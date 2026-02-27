import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';

import 'utilities.dart';

// ---------------------------------------------------------------------------
// Helpers shared across all MultiDayEventLayoutWidget tests
// ---------------------------------------------------------------------------

/// Asserts that no two [Rect]s in [rects] overlap each other.
void expectNoOverlaps(List<Rect> rects) {
  for (var i = 0; i < rects.length; i++) {
    for (var j = i + 1; j < rects.length; j++) {
      expect(
        rects[i].overlaps(rects[j]),
        isFalse,
        reason: 'Rect ${i + 1} overlaps with Rect ${j + 1}',
      );
    }
  }
}

void main() {
  group('MultiDayEventLayoutWidget', () {
    // -----------------------------------------------------------------------
    // Per-test state – recreated in setUp so tests are fully isolated.
    // -----------------------------------------------------------------------
    late DefaultEventsController eventsController;
    late CalendarController controller;

    final tileComponents = TileComponents(
      tileBuilder: (event, tileRange) => Container(
        key: ValueKey(event.id),
        child: Text(event.id.toString()),
      ),
    );

    final start = InternalDateTime(2025, 3, 24);
    final end = InternalDateTime(2025, 3, 31);
    final visibleRange = InternalDateTimeRange(start: start, end: end);

    setUp(() {
      eventsController = DefaultEventsController();
      controller = CalendarController();
    });

    // -----------------------------------------------------------------------
    // Widget-building helper – avoids repeating the full provider/widget tree.
    // -----------------------------------------------------------------------
    Widget buildLayoutWidget({
      required MultiDayHeaderConfiguration configuration,
      Widget? sizedBoxWrapper,
    }) {
      final inner = MultiDayEventLayoutWidget(
        events: eventsController.events.toList(),
        internalDateTimeRange: visibleRange,
        textDirection: TextDirection.ltr,
        multiDayOverlayBuilders: null,
        multiDayOverlayStyles: null,
        configuration: configuration,
        maxNumberOfVerticalEvents: null,
        multiDayCache: null,
        location: null,
      );

      return wrapWithMaterialApp(
        TestProvider(
          calendarController: controller,
          eventsController: eventsController,
          tileComponents: tileComponents,
          child: sizedBoxWrapper != null ? sizedBoxWrapper : inner,
        ),
      );
    }

    // Convenience overload that wraps the layout widget inside a SizedBox.
    Widget buildLayoutWidgetSized({
      required MultiDayHeaderConfiguration configuration,
      required double width,
      required double height,
    }) {
      return wrapWithMaterialApp(
        TestProvider(
          calendarController: controller,
          eventsController: eventsController,
          tileComponents: tileComponents,
          child: SizedBox(
            width: width,
            height: height,
            child: MultiDayEventLayoutWidget(
              events: eventsController.events.toList(),
              internalDateTimeRange: visibleRange,
              textDirection: TextDirection.ltr,
              multiDayOverlayBuilders: null,
              multiDayOverlayStyles: null,
              configuration: configuration,
              maxNumberOfVerticalEvents: null,
              multiDayCache: null,
              location: null,
            ),
          ),
        ),
      );
    }

    // -----------------------------------------------------------------------
    // Regression tests
    // -----------------------------------------------------------------------

    // Regression: totalNumberOfRows was always at least 1 (= maxRow + 1),
    // so an empty event list produced totalNumberOfRows=1 instead of 0.
    // With maxNumberOfVerticalEvents=0 that caused a spurious "+1" button.
    testWidgets('No overflow buttons when there are no events', (tester) async {
      // eventsController is empty – do not add any events.
      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: const MultiDayHeaderConfiguration(tileHeight: 50.0, maximumNumberOfVerticalEvents: 2),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MultiDayPortalOverlayButton), findsNothing);
    });

    // Regression: when the available height per week row was less than tileHeight,
    // MonthBody computed a negative maxNumberOfVerticalEvents (e.g. -1), turning
    // "numberOfHiddenRows = (row+1) - (-1)" into 2 even for a single event.
    // A second part of the same bug: columnRowMap was initialised to 0 for every
    // column, so days that had NO event also showed overflow buttons whenever
    // maxNumberOfRows dropped to 0.
    testWidgets('Overflow button count is correct when maxNumberOfVerticalEvents is 0', (tester) async {
      // Two events spanning days 24-25 only (end = midnight of the 26th = startOfDay,
      // so the 26th is not included → 2 of the 7 visible columns).
      final events = [
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 2)),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 2)),
        ),
      ];
      eventsController.addEvents(events);

      await tester.pumpWidget(
        buildLayoutWidget(
          // max=0 means no events fit → both are hidden behind overflow buttons.
          configuration: const MultiDayHeaderConfiguration(tileHeight: 50.0, maximumNumberOfVerticalEvents: 0),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey(events[0].id)), findsNothing);
      expect(find.byKey(ValueKey(events[1].id)), findsNothing);

      // Only the 2 columns the events span (24, 25) should show a button.
      // The remaining 5 columns have no events and must stay empty.
      expect(find.byType(MultiDayPortalOverlayButton), findsNWidgets(2));

      // Every button that does appear must show a positive hidden-row count.
      for (final button in tester.widgetList(find.byType(MultiDayPortalOverlayButton))) {
        expect((button as MultiDayPortalOverlayButton).numberOfHiddenRows, greaterThan(0));
      }
    });

    testWidgets('Basic', (tester) async {
      final events = [
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.add(const Duration(hours: 6))),
        ),
      ];
      eventsController.addEvents(events);

      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: const MultiDayHeaderConfiguration(tileHeight: 50.0, maximumNumberOfVerticalEvents: 2),
        ),
      );
      await tester.pumpAndSettle();

      // Events within the max-vertical-events limit should be visible.
      expect(find.byKey(ValueKey(events[0].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[1].id)), findsOneWidget);
      // Exceeds maximum – hidden behind the overflow button.
      expect(find.byKey(ValueKey(events[2].id)), findsNothing);

      // One overflow button should appear.
      expect(find.byType(MultiDayPortalOverlayButton), findsOneWidget);

      // The button must show '1 more' (one hidden event).
      final buttonText = (find.byKey(MultiDayPortalOverlayButton.textKey).evaluate().single.widget as Text).data!;
      expect(buttonText, equals('1 more'));
    });

    testWidgets('Multiple events', (tester) async {
      ///   24   25   26   27   28   29  30
      ///   |------1------||-----2----|
      ///   |--3--||---4---||---5-----|
      ///                  |-----6----|

      final events = [
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 24),
            end: DateTime(2025, 3, 27),
          ),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 24),
            end: DateTime(2025, 3, 25),
          ),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 25),
            end: DateTime(2025, 3, 28),
          ),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 28),
            end: DateTime(2025, 3, 30),
          ),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),
        ),
      ];
      eventsController.addEvents(events);

      const tileHeight = 50.0;
      const dayWidth = 50.0;

      await tester.pumpWidget(
        buildLayoutWidgetSized(
          configuration: const MultiDayHeaderConfiguration(tileHeight: tileHeight, maximumNumberOfVerticalEvents: 3),
          width: dayWidth * 7,
          height: tileHeight * 3,
        ),
      );
      await tester.pumpAndSettle();

      // All six events should be visible (none overflow with max = 3).
      for (final event in events) {
        expect(find.byKey(ValueKey(event.id)), findsOneWidget, reason: 'Event ${event.id} should be visible');
      }

      // No event should overlap another event.
      expectNoOverlaps([for (final event in events) tester.getRect(find.byKey(ValueKey(event.id)))]);
    });

    testWidgets('Button values', (tester) async {
      ///   24   25   26   27   28   29  30
      ///   |-----1-------||-----2----|
      ///        |----3---|
      ///                  | +1 || +1 |
      /// _______________________________
      ///                 |------4----|
      final events = [
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 24),
            end: DateTime(2025, 3, 27),
          ),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 25),
            end: DateTime(2025, 3, 28),
          ),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),
        ),
      ];
      eventsController.addEvents(events);

      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: const MultiDayHeaderConfiguration(tileHeight: 50.0, maximumNumberOfVerticalEvents: 2),
        ),
      );
      await tester.pumpAndSettle();

      // Events 1-3 should be visible; event 4 overflows.
      expect(find.byKey(ValueKey(events[0].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[1].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[2].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[3].id)), findsNothing);

      // Three overflow buttons expected (one per overflowing column).
      expect(find.byType(MultiDayPortalOverlayButton), findsNWidgets(3));

      // Each button must display exactly '1 more'.
      for (final element in find.byKey(MultiDayPortalOverlayButton.textKey).evaluate()) {
        final text = (element.widget as Text).data;
        expect(text, isNotNull, reason: 'Button text should not be null');
        expect(text, equals('1 more'), reason: 'Expected "1 more" but found "$text"');
      }
    });

    testWidgets('Sorting by start time', (tester) async {
      ///   24   25   26   27   28   29  30
      ///   |-----2-------|
      ///   |-3-|
      ///   |----1--------|
      ///   | +1 |
      /// _______________________________
      ///   |-4-|
      final events = [
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start.copyWith(hour: 6), end: start.copyWith(day: start.day + 3)),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start.copyWith(hour: 3), end: start.copyWith(hour: 6)),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start.copyWith(hour: 7), end: start.copyWith(hour: 10)),
        ),
      ];
      eventsController.addEvents(events);

      int startTimeComparator(CalendarEvent a, CalendarEvent b) => a.start.compareTo(b.start);

      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: MultiDayHeaderConfiguration(
            maximumNumberOfVerticalEvents: 3,
            tileHeight: 50.0,
            generateMultiDayLayoutFrame: ({
              required events,
              required textDirection,
              required visibleDateTimeRange,
              required location,
              cache,
            }) =>
                defaultMultiDayFrameGenerator(
              visibleDateTimeRange: visibleDateTimeRange,
              events: events,
              textDirection: textDirection,
              cache: cache,
              location: location,
              eventComparator: startTimeComparator,
            ),
            eventPadding: const EdgeInsets.all(0),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // events[0] (start 06:00, multi-day) and events[1] (start 00:00, multi-day) are visible.
      // events[2] (start 03:00, same-day) is visible.
      // events[3] (start 07:00) overflows.
      expect(find.byKey(ValueKey(events[0].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[1].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[2].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[3].id)), findsNothing);

      expect(find.byType(MultiDayPortalOverlayButton), findsOneWidget);

      final buttonText = (find.byKey(MultiDayPortalOverlayButton.textKey).evaluate().single.widget as Text).data!;
      expect(buttonText, equals('1 more'));

      // Verify vertical ordering: events[1] (earliest start) is topmost,
      // then events[2], then events[0].
      final pos0 = tester.getTopLeft(find.byKey(ValueKey(events[0].id)));
      final pos1 = tester.getTopLeft(find.byKey(ValueKey(events[1].id)));
      final pos2 = tester.getTopLeft(find.byKey(ValueKey(events[2].id)));

      expect(pos1.dy, lessThan(pos2.dy));
      expect(pos2.dy, lessThan(pos0.dy));

      expectNoOverlaps([
        tester.getRect(find.byKey(ValueKey(events[0].id))),
        tester.getRect(find.byKey(ValueKey(events[1].id))),
        tester.getRect(find.byKey(ValueKey(events[2].id))),
      ]);
    });

    testWidgets('Sorting by end time', (tester) async {
      ///   24   25   26   27   28   29  30
      ///   |-3-|
      ///   |-2-|
      ///   |-1-|
      ///   | +1 |
      /// _______________________________
      ///   |-4-|
      final events = [
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(hour: 12)),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(hour: 8)),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start.copyWith(hour: 3), end: start.copyWith(hour: 4)),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start.copyWith(hour: 3), end: start.copyWith(hour: 16)),
        ),
      ];
      eventsController.addEvents(events);

      int endTimeComparator(CalendarEvent a, CalendarEvent b) => a.end.compareTo(b.end);

      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: MultiDayHeaderConfiguration(
            tileHeight: 50.0,
            maximumNumberOfVerticalEvents: 3,
            generateMultiDayLayoutFrame: ({
              required events,
              required textDirection,
              required visibleDateTimeRange,
              required location,
              cache,
            }) =>
                defaultMultiDayFrameGenerator(
              visibleDateTimeRange: visibleDateTimeRange,
              events: events,
              textDirection: textDirection,
              eventComparator: endTimeComparator,
              cache: cache,
              location: location,
            ),
            eventPadding: const EdgeInsets.all(0),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // events[0-2] are within the limit; events[3] overflows.
      expect(find.byKey(ValueKey(events[0].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[1].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[2].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[3].id)), findsNothing);

      expect(find.byType(MultiDayPortalOverlayButton), findsOneWidget);

      final buttonText = (find.byKey(MultiDayPortalOverlayButton.textKey).evaluate().single.widget as Text).data!;
      expect(buttonText, equals('1 more'));

      // Verify vertical ordering by end time (earliest end = topmost row):
      // events[2] ends at 04:00, events[1] at 08:00, events[0] at 12:00.
      final pos0 = tester.getTopLeft(find.byKey(ValueKey(events[0].id)));
      final pos1 = tester.getTopLeft(find.byKey(ValueKey(events[1].id)));
      final pos2 = tester.getTopLeft(find.byKey(ValueKey(events[2].id)));

      expect(pos2.dy, lessThan(pos1.dy));
      expect(pos1.dy, lessThan(pos0.dy));

      expectNoOverlaps([
        tester.getRect(find.byKey(ValueKey(events[0].id))),
        tester.getRect(find.byKey(ValueKey(events[1].id))),
        tester.getRect(find.byKey(ValueKey(events[2].id))),
      ]);
    });
  });
}
