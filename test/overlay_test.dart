import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_overlay_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';

import 'utilities.dart';

void main() {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();
  final viewConfiguration = MultiDayViewConfiguration.week();
  const headerConfiguration = MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1);

  setUpAll(() {
    final startOfWeek = DateTime.now().startOfWeek();
    eventsController.addEvents([
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: startOfWeek,
          end: startOfWeek.copyWith(day: startOfWeek.day + 2),
        ),
      ),
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: startOfWeek,
          end: startOfWeek.copyWith(day: startOfWeek.day + 2),
        ),
      ),
    ]);
  });

  final sizesToTest = [
    const Size(300, 500),
    const Size(400, 600),
    const Size(800, 600),
    const Size(1200, 600),
  ];

  group('Overlay', () {
    for (final size in sizesToTest) {
      testWidgets('Overlay $size test', (tester) async {
        final dpi = tester.view.devicePixelRatio;
        tester.view.physicalSize = Size(size.width * dpi, size.height * dpi);

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: viewConfiguration,
            header: const CalendarHeader(
              multiDayHeaderConfiguration: headerConfiguration,
            ),
            body: const CalendarBody(),
          ),
        );

        expect(find.byType(MultiDayEventTile), findsOne);
        expect(find.byType(MultiDayOverlayPortal), findsNWidgets(2));
        expect(find.byType(MultiDayPortalOverlayButton), findsNWidgets(2));

        // Check that the overlay always renders within the calendar view bounds.
        final visibleDates = calendarController.visibleDateTimeRangeUtc.value.dates();
        final datesToTest = [visibleDates[0], visibleDates[1]];
        for (final date in datesToTest) {
          final button = find.byKey(MultiDayPortalOverlayButton.getKey(date));
          expect(button, findsOne);

          await tester.tap(button);
          await tester.pumpAndSettle();

          final overlay = find.byType(MultiDayOverlay);
          expect(overlay, findsOne);

          final overlayCard = find.byKey(MultiDayOverlay.getOverlayCardKey(date));
          expect(overlayCard, findsOne);

          final topLeft = tester.getTopLeft(overlayCard);
          final bottomRight = tester.getBottomRight(overlayCard);
          final calendarRect = tester.getRect(find.byType(CalendarView));

          expect(topLeft.dx >= calendarRect.left && topLeft.dy >= calendarRect.top, isTrue);
          expect(bottomRight.dx <= calendarRect.right && bottomRight.dy <= calendarRect.bottom, isTrue);

          await tester.tap(find.byKey(MultiDayOverlay.getCloseButtonKey(date)));
          await tester.pumpAndSettle();
        }

        // Check that the overlay dismisses correctly when dragging an event.
        final overlay = find.byType(MultiDayOverlay);
        expect(overlay, findsNothing);
        final button = find.byKey(MultiDayPortalOverlayButton.getKey(datesToTest.first));
        expect(button, findsOne);
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(overlay, findsOne);

        final event = find.byType(MultiDayOverlayEventTile).first;
        expect(event, findsOne);

        // Simulate a drag gesture on the event tile to dismiss the overlay.
        final gesture = await tester.startGesture(tester.getCenter(event), pointer: 1);
        await gesture.moveBy(const Offset(10, 0));
        await tester.pumpAndSettle();

        expect(overlay, findsNothing);
        await gesture.up();
        await tester.pumpAndSettle();
        expect(overlay, findsNothing);
      });
    }
  });
}
