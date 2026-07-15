import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_overlay_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';

import '../utilities.dart';

void main() {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();
  final viewConfiguration = MultiDayViewConfiguration.week();
  final preciseInteraction = CalendarInteraction(
    inputMode: InputMode.precise,
    createEventGesture: CreateEventGesture.tap,
    modifyEventGesture: CreateEventGesture.tap,
  );
  const headerConfiguration = MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1);

  setUpAll(() {
    final now = InternalDateTime.fromDateTime(DateTime.now()).startOfWeek();
    final startOfWeek = DateTime(now.year, now.month, now.day);

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
              interaction: preciseInteraction,
            ),
            body: CalendarBody(interaction: preciseInteraction),
          ),
        );

        expect(find.byType(MultiDayEventTile), findsOne);
        expect(find.byType(MultiDayOverlayPortal), findsNWidgets(2));
        expect(find.byType(MultiDayPortalOverlayButton), findsNWidgets(2));

        // Check that the overlay always renders within the calendar view bounds.
        final visibleDates = calendarController.internalDateTimeRange.value!.dates();
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

        final event = find.byType(MultiDayEventOverlayTile).first;
        expect(event, findsOne);

        // Simulate a drag gesture on the event tile to dismiss the overlay.
        final gesture = await tester.startGesture(
          tester.getCenter(event),
          pointer: 1,
          kind: PointerDeviceKind.mouse,
        );
        await gesture.moveBy(const Offset(20, 0));
        await tester.pumpAndSettle();

        expect(overlay, findsNothing);
        await gesture.up();
        await tester.pumpAndSettle();
        expect(overlay, findsNothing);
      });
    }
  });

  // The group above anchors the overlay off the week header, which sits at the
  // top of the view, so the card is never near the bottom edge. The overlay
  // card used to be positioned without being measured, and only its top and
  // sides were clamped, so a card anchored low in the view ran off the bottom
  // and was clipped by the enclosing Stack.
  group('Month overlay bounds', () {
    /// Opens the overlay for [day] in a month view of the given [size], with
    /// [eventCount] events on that day, and returns the card's rect and the
    /// view's rect.
    Future<({Rect card, Rect view})> openOverlay(
      WidgetTester tester, {
      required DateTime day,
      required int eventCount,
      Size size = const Size(800, 600),
    }) async {
      final dpi = tester.view.devicePixelRatio;
      tester.view.physicalSize = Size(size.width * dpi, size.height * dpi);
      addTearDown(tester.view.resetPhysicalSize);

      final eventsController = DefaultEventsController();
      for (var i = 0; i < eventCount; i++) {
        eventsController.addEvent(
          CalendarEvent(dateTimeRange: DateTimeRange(start: day, end: day.add(const Duration(days: 1)))),
        );
      }

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: CalendarController(),
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: year2025DisplayRange,
            initialDateTime: DateTime(2025, 1, 15),
          ),
          body: const CalendarBody(),
        ),
      );

      final button = find.byKey(MultiDayPortalOverlayButton.getKey(day));
      expect(button, findsOne, reason: 'the day should overflow and show a "+N more" button');

      await tester.tap(button);
      await tester.pumpAndSettle();

      final card = find.byKey(MultiDayOverlay.getOverlayCardKey(day));
      expect(card, findsOne);

      return (card: tester.getRect(card), view: tester.getRect(find.byType(CalendarView)));
    }

    // January 2025 lays out as 5 rows (Mon 30 Dec - Sun 2 Feb), so the 29th
    // sits in the last row, closest to the bottom edge.
    final lastRowDay = DateTime.utc(2025, 1, 29);
    final firstRowDay = DateTime.utc(2025, 1, 2);

    testWidgets('a day in the last week row stays inside the view', (tester) async {
      final rects = await openOverlay(tester, day: lastRowDay, eventCount: 8);

      expect(
        rects.card.bottom,
        lessThanOrEqualTo(rects.view.bottom),
        reason: 'card bottom ${rects.card.bottom} overflows view bottom ${rects.view.bottom}',
      );
      expect(
        rects.card.top,
        greaterThanOrEqualTo(rects.view.top),
        reason: 'card top ${rects.card.top} is above view top ${rects.view.top}',
      );
    });

    testWidgets('a day in the first week row stays inside the view', (tester) async {
      final rects = await openOverlay(tester, day: firstRowDay, eventCount: 8);

      expect(rects.card.top, greaterThanOrEqualTo(rects.view.top), reason: 'card top ${rects.card.top}');
      expect(rects.card.bottom, lessThanOrEqualTo(rects.view.bottom), reason: 'card bottom ${rects.card.bottom}');
    });

    testWidgets('a card taller than the view is capped and scrolls', (tester) async {
      final rects = await openOverlay(tester, day: lastRowDay, eventCount: 40);

      expect(
        rects.card.height,
        lessThanOrEqualTo(rects.view.height),
        reason: 'card height ${rects.card.height} exceeds view height ${rects.view.height}',
      );
      expect(rects.card.top, greaterThanOrEqualTo(rects.view.top));
      expect(rects.card.bottom, lessThanOrEqualTo(rects.view.bottom));

      final scrollable = find.descendant(
        of: find.byKey(MultiDayOverlay.getOverlayCardKey(lastRowDay)),
        matching: find.byType(Scrollable),
      );
      expect(scrollable, findsOne, reason: 'the event list should be scrollable');

      final position = tester.state<ScrollableState>(scrollable).position;
      expect(position.maxScrollExtent, greaterThan(0), reason: 'the events should overflow the capped card');

      await tester.drag(scrollable, const Offset(0, -80));
      await tester.pumpAndSettle();
      expect(position.pixels, greaterThan(0), reason: 'the event list should scroll');
    });

    testWidgets('a card shorter than the view is not scrollable', (tester) async {
      await openOverlay(tester, day: lastRowDay, eventCount: 8);

      final position = tester
          .state<ScrollableState>(
            find.descendant(
              of: find.byKey(MultiDayOverlay.getOverlayCardKey(lastRowDay)),
              matching: find.byType(Scrollable),
            ),
          )
          .position;

      expect(position.maxScrollExtent, 0, reason: 'a card that fits should have nothing to scroll');
    });
  });
}
