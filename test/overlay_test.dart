import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_event_tile.dart';

import 'utilities.dart';

void main() {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();
  final viewConfiguration = MultiDayViewConfiguration.week();
  final headerConfiguration = MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1);

  setUpAll(() {
    final startOfWeek = DateTime.now().asUtc.startOfWeek();
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
            header: CalendarHeader(
              multiDayHeaderConfiguration: headerConfiguration,
            ),
            body: const CalendarBody(),
          ),
        );

        expect(find.byType(MultiDayEventTile), findsOne);
        expect(find.byType(MultiDayOverlayPortal), findsNWidgets(3));
        expect(find.byType(MultiDayPortalOverlayButton), findsNWidgets(3));

        final visibleDates = calendarController.visibleDateTimeRangeUtc.value.dates();

        final datesToTest = [visibleDates[0], visibleDates[1], visibleDates[2]];

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
      });
    }
  });
}
