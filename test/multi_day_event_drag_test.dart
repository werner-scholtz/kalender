import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/drag_targets/vertical_drag_target.dart';

import 'utilities.dart';

/// Tests for multi-day event drag behavior in the VerticalDragTarget.
///
/// These tests verify that multi-day/all-day events are rejected when dragged
/// into the body area of a multi-day view, as they belong in the header.
void main() {
  group('Multi-Day Event Drag in VerticalDragTarget', () {
    testWidgets('multi-day event should be rejected when dragged in body', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController();
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add an all-day event (midnight to midnight = 24 hours)
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 0, 0), // Midnight
            end: DateTime(2025, 1, 3, 0, 0), // Next day midnight
          ),
        ),
      );

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: displayRange,
            initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
          ),
          body: const CalendarBody(),
        ),
      );

      // Find the VerticalDragTarget
      final dragTargetFinder = find.byType(VerticalDragTarget);
      expect(dragTargetFinder, findsOneWidget);

      final state = tester.state<State>(dragTargetFinder);
      final stateWithMixin = state as dynamic;

      // Get the event
      final events = eventsController.events.toList();
      expect(events.length, equals(1));
      final originalEvent = events.first;

      // Verify it's a multi-day event
      expect(originalEvent.isMultiDayEvent, isTrue);
      expect(originalEvent.datesSpanned().length, equals(1)); // Just Jan 2

      // Simulate rescheduling - cursor at 2:30 PM on Jan 5
      final cursorDateTime = DateTime.utc(2025, 1, 5, 14, 30);
      final rescheduledEvent = stateWithMixin.rescheduleEvent(originalEvent, cursorDateTime);

      // Multi-day events should be rejected (return null) by VerticalDragTarget
      expect(rescheduledEvent, isNull);
    });

    testWidgets('single-day event should use cursor time when dragged in body', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController();
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add a single-day event (2 hours)
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 10, 0), // 10:00 AM
            end: DateTime(2025, 1, 2, 12, 0), // 12:00 PM
          ),
        ),
      );

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: displayRange,
            initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
          ),
          body: const CalendarBody(),
        ),
      );

      final dragTargetFinder = find.byType(VerticalDragTarget);
      final state = tester.state<State>(dragTargetFinder);
      final stateWithMixin = state as dynamic;

      final events = eventsController.events.toList();
      final originalEvent = events.first;

      // Verify it's NOT a multi-day event
      expect(originalEvent.isMultiDayEvent, isFalse);

      // Simulate rescheduling - cursor at 2:30 PM on Jan 5
      final cursorDateTime = DateTime.utc(2025, 1, 5, 14, 30);
      final rescheduledEvent = stateWithMixin.rescheduleEvent(originalEvent, cursorDateTime);

      expect(rescheduledEvent, isNotNull);
      final rescheduled = rescheduledEvent as CalendarEvent;

      // Single-day events should use the cursor time (snapped)
      expect(rescheduled.internalStart().day, equals(5));
      // The exact time depends on snapping, but should be around 14:30
      expect(rescheduled.internalStart().hour, greaterThanOrEqualTo(14));

      // Duration should be preserved (2 hours)
      expect(rescheduled.duration.inHours, equals(2));
    });

    testWidgets('multi-day event spanning 3 days should be rejected when dragged in body', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController();
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add a 3-day event
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 0, 0), // Jan 2 midnight
            end: DateTime(2025, 1, 5, 0, 0), // Jan 5 midnight (spans Jan 2, 3, 4)
          ),
        ),
      );

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: displayRange,
            initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
          ),
          body: const CalendarBody(),
        ),
      );

      final dragTargetFinder = find.byType(VerticalDragTarget);
      final state = tester.state<State>(dragTargetFinder);
      final stateWithMixin = state as dynamic;

      final events = eventsController.events.toList();
      final originalEvent = events.first;

      // Verify original spans 3 dates
      expect(originalEvent.isMultiDayEvent, isTrue);
      expect(originalEvent.datesSpanned().length, equals(3)); // Jan 2, 3, 4

      // Simulate rescheduling - cursor at 3:45 PM on Jan 10
      final cursorDateTime = DateTime.utc(2025, 1, 10, 15, 45);
      final rescheduledEvent = stateWithMixin.rescheduleEvent(originalEvent, cursorDateTime);

      // Multi-day events should be rejected (return null) by VerticalDragTarget
      expect(rescheduledEvent, isNull);
    });

    testWidgets('multi-day event starting at non-midnight should be rejected when dragged in body', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController();
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add a multi-day event that starts at 8:00 AM (not midnight)
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 8, 0), // Jan 2 8:00 AM
            end: DateTime(2025, 1, 4, 8, 0), // Jan 4 8:00 AM (48 hours)
          ),
        ),
      );

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: displayRange,
            initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
          ),
          body: const CalendarBody(),
        ),
      );

      final dragTargetFinder = find.byType(VerticalDragTarget);
      final state = tester.state<State>(dragTargetFinder);
      final stateWithMixin = state as dynamic;

      final events = eventsController.events.toList();
      final originalEvent = events.first;

      expect(originalEvent.isMultiDayEvent, isTrue);

      // Simulate rescheduling - cursor at 5:30 PM on Jan 15
      final cursorDateTime = DateTime.utc(2025, 1, 15, 17, 30);
      final rescheduledEvent = stateWithMixin.rescheduleEvent(originalEvent, cursorDateTime);

      // Multi-day events should be rejected (return null) by VerticalDragTarget
      expect(rescheduledEvent, isNull);
    });
  });

  group('CalendarEvent.isMultiDayEvent', () {
    test('24-hour event should be multi-day', () {
      final event = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(2025, 1, 1, 0, 0),
          end: DateTime(2025, 1, 2, 0, 0), // Exactly 24 hours
        ),
      );
      expect(event.isMultiDayEvent, isTrue);
      expect(event.duration.inDays, equals(1));
    });

    test('23-hour event should not be multi-day', () {
      final event = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(2025, 1, 1, 0, 0),
          end: DateTime(2025, 1, 1, 23, 0), // 23 hours
        ),
      );
      expect(event.isMultiDayEvent, isFalse);
      expect(event.duration.inDays, equals(0));
    });

    test('25-hour event should be multi-day', () {
      final event = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(2025, 1, 1, 0, 0),
          end: DateTime(2025, 1, 2, 1, 0), // 25 hours
        ),
      );
      expect(event.isMultiDayEvent, isTrue);
      expect(event.duration.inDays, equals(1));
    });
  });

  group('CalendarEvent.datesSpanned', () {
    test('all-day event should span 1 date', () {
      final event = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(2025, 1, 5, 0, 0),
          end: DateTime(2025, 1, 6, 0, 0),
        ),
      );
      expect(event.datesSpanned().length, equals(1));
      expect(event.datesSpanned().first.day, equals(5));
    });

    test('48-hour event starting at midnight should span 2 dates', () {
      final event = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(2025, 1, 5, 0, 0),
          end: DateTime(2025, 1, 7, 0, 0),
        ),
      );
      expect(event.datesSpanned().length, equals(2));
    });

    test('event from 2pm to 2pm next day should span 2 dates', () {
      final event = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(2025, 1, 5, 14, 0), // 2 PM
          end: DateTime(2025, 1, 6, 14, 0), // 2 PM next day
        ),
      );
      // This spans Jan 5 and Jan 6
      expect(event.datesSpanned().length, equals(2));
    });
  });

  group('Drag Rejection Behavior', () {
    group('VerticalDragTarget rejects multi-day events', () {
      testWidgets('should reject multi-day event in onWillAcceptWithDetails', (tester) async {
        final eventsController = DefaultEventsController();
        final calendarController = CalendarController();
        final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: MultiDayViewConfiguration.week(
              displayRange: displayRange,
            ),
            body: const CalendarBody(),
          ),
        );

        // Create a multi-day event (24+ hours)
        final multiDayEvent = CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 0, 0),
            end: DateTime(2025, 1, 3, 0, 0), // 24 hours
          ),
        );

        final reschedule = Reschedule(event: multiDayEvent);
        final details = DragTargetDetails(
          data: reschedule,
          offset: Offset.zero,
        );

        const configuration = MultiDayBodyConfiguration();

        // Should return false for multi-day events
        final result = VerticalDragTarget.onWillAcceptWithDetails(
          details,
          calendarController,
          configuration,
        );

        expect(result, isFalse);
      });

      testWidgets('should accept single-day event in onWillAcceptWithDetails', (tester) async {
        final eventsController = DefaultEventsController();
        final calendarController = CalendarController();
        final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: MultiDayViewConfiguration.week(
              displayRange: displayRange,
            ),
            body: const CalendarBody(),
          ),
        );

        // Create a single-day event (less than 24 hours)
        final singleDayEvent = CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 10, 0),
            end: DateTime(2025, 1, 2, 12, 0), // 2 hours
          ),
        );

        final reschedule = Reschedule(event: singleDayEvent);
        final details = DragTargetDetails(
          data: reschedule,
          offset: Offset.zero,
        );

        const configuration = MultiDayBodyConfiguration();

        // Should return true for single-day events
        final result = VerticalDragTarget.onWillAcceptWithDetails(
          details,
          calendarController,
          configuration,
        );

        expect(result, isTrue);
      });
    });

    group('HorizontalDragTarget rejects single-day events in header', () {
      test('should reject single-day event in header configuration', () {
        final controller = CalendarController();

        // Create a single-day event
        final singleDayEvent = CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 10, 0),
            end: DateTime(2025, 1, 2, 12, 0), // 2 hours
          ),
        );

        final reschedule = Reschedule(event: singleDayEvent);
        final details = DragTargetDetails(
          data: reschedule,
          offset: Offset.zero,
        );

        // MultiDayHeaderConfiguration has allowSingleDayEvents: false
        const configuration = MultiDayHeaderConfiguration();

        // Should return false for single-day events in header
        final result = HorizontalDragTarget.onWillAcceptWithDetails(
          details,
          controller,
          configuration,
        );

        expect(result, isFalse);
      });

      test('should accept multi-day event in header configuration', () {
        final controller = CalendarController();

        // Create a multi-day event
        final multiDayEvent = CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 0, 0),
            end: DateTime(2025, 1, 3, 0, 0), // 24 hours
          ),
        );

        final reschedule = Reschedule(event: multiDayEvent);
        final details = DragTargetDetails(
          data: reschedule,
          offset: Offset.zero,
        );

        const configuration = MultiDayHeaderConfiguration();

        // Should return true for multi-day events in header
        final result = HorizontalDragTarget.onWillAcceptWithDetails(
          details,
          controller,
          configuration,
        );

        expect(result, isTrue);
      });

      test('should accept single-day event in month body configuration', () {
        final controller = CalendarController();

        // Create a single-day event
        final singleDayEvent = CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 10, 0),
            end: DateTime(2025, 1, 2, 12, 0), // 2 hours
          ),
        );

        final reschedule = Reschedule(event: singleDayEvent);
        final details = DragTargetDetails(
          data: reschedule,
          offset: Offset.zero,
        );

        // MonthBodyConfiguration has allowSingleDayEvents: true
        final configuration = MonthBodyConfiguration();

        // Should return true for single-day events in month body
        final result = HorizontalDragTarget.onWillAcceptWithDetails(
          details,
          controller,
          configuration,
        );

        expect(result, isTrue);
      });
    });
  });

  group('rescheduleEvent returns null for invalid event types', () {
    testWidgets('VerticalDragTarget.rescheduleEvent returns null for multi-day events', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController();
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add a multi-day event
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 0, 0),
            end: DateTime(2025, 1, 3, 0, 0), // 24 hours - multi-day
          ),
        ),
      );

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: displayRange,
          ),
          body: const CalendarBody(),
        ),
      );

      final dragTargetFinder = find.byType(VerticalDragTarget);
      final state = tester.state<State>(dragTargetFinder);
      final stateWithMixin = state as dynamic;

      final events = eventsController.events.toList();
      final multiDayEvent = events.first;

      // Verify it's a multi-day event
      expect(multiDayEvent.isMultiDayEvent, isTrue);

      // rescheduleEvent should return null for multi-day events
      // This prevents the event selection from being updated during onMove
      final cursorDateTime = DateTime.utc(2025, 1, 5, 14, 30);
      final result = stateWithMixin.rescheduleEvent(multiDayEvent, cursorDateTime);

      expect(result, isNull);
    });

    testWidgets('VerticalDragTarget.rescheduleEvent returns event for single-day events', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController();
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add a single-day event
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 10, 0),
            end: DateTime(2025, 1, 2, 12, 0), // 2 hours - single-day
          ),
        ),
      );

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: displayRange,
          ),
          body: const CalendarBody(),
        ),
      );

      final dragTargetFinder = find.byType(VerticalDragTarget);
      final state = tester.state<State>(dragTargetFinder);
      final stateWithMixin = state as dynamic;

      final events = eventsController.events.toList();
      final singleDayEvent = events.first;

      // Verify it's NOT a multi-day event
      expect(singleDayEvent.isMultiDayEvent, isFalse);

      // rescheduleEvent should return an updated event for single-day events
      final cursorDateTime = DateTime.utc(2025, 1, 5, 14, 30);
      final result = stateWithMixin.rescheduleEvent(singleDayEvent, cursorDateTime);

      expect(result, isNotNull);
      expect(result.isMultiDayEvent, isFalse);
    });

    testWidgets('HorizontalDragTarget.rescheduleEvent returns null for single-day events in header', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController();
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add a single-day event
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 10, 0),
            end: DateTime(2025, 1, 2, 12, 0), // 2 hours - single-day
          ),
        ),
      );

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: displayRange,
          ),
          header: const CalendarHeader(), // Include header
          body: const CalendarBody(),
        ),
      );

      // Find the HorizontalDragTarget in the header (MultiDayHeaderConfiguration)
      final dragTargetFinder = find.byType(HorizontalDragTarget);
      expect(dragTargetFinder, findsWidgets); // Header has HorizontalDragTarget

      // Get the first one (header)
      final state = tester.state<State>(dragTargetFinder.first);
      final stateWithMixin = state as dynamic;

      final events = eventsController.events.toList();
      final singleDayEvent = events.first;

      // Verify it's NOT a multi-day event
      expect(singleDayEvent.isMultiDayEvent, isFalse);

      // rescheduleEvent should return null for single-day events in header
      // because the header doesn't allow single-day events
      final cursorDateTime = DateTime.utc(2025, 1, 5);
      final result = stateWithMixin.rescheduleEvent(singleDayEvent, cursorDateTime);

      expect(result, isNull);
    });

    testWidgets('HorizontalDragTarget.rescheduleEvent returns event for multi-day events in header', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController();
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add a multi-day event
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 0, 0),
            end: DateTime(2025, 1, 3, 0, 0), // 24 hours - multi-day
          ),
        ),
      );

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: displayRange,
          ),
          header: const CalendarHeader(),
          body: const CalendarBody(),
        ),
      );

      final dragTargetFinder = find.byType(HorizontalDragTarget);
      final state = tester.state<State>(dragTargetFinder.first);
      final stateWithMixin = state as dynamic;

      final events = eventsController.events.toList();
      final multiDayEvent = events.first;

      // Verify it's a multi-day event
      expect(multiDayEvent.isMultiDayEvent, isTrue);

      // rescheduleEvent should return an updated event for multi-day events in header
      final cursorDateTime = DateTime.utc(2025, 1, 5);
      final result = stateWithMixin.rescheduleEvent(multiDayEvent, cursorDateTime);

      expect(result, isNotNull);
      expect(result.isMultiDayEvent, isTrue);
    });
  });

  group('Timeline tooltip behavior', () {
    test('isMultiDayEvent correctly identifies events for timeline filtering', () {
      // Events less than 24 hours should NOT be multi-day
      final shortEvent = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(2025, 1, 1, 10, 0),
          end: DateTime(2025, 1, 1, 23, 59),
        ),
      );
      expect(shortEvent.isMultiDayEvent, isFalse);

      // Events exactly 24 hours should be multi-day
      final exactDayEvent = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(2025, 1, 1, 0, 0),
          end: DateTime(2025, 1, 2, 0, 0),
        ),
      );
      expect(exactDayEvent.isMultiDayEvent, isTrue);

      // Events more than 24 hours should be multi-day
      final longEvent = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(2025, 1, 1, 0, 0),
          end: DateTime(2025, 1, 3, 0, 0),
        ),
      );
      expect(longEvent.isMultiDayEvent, isTrue);

      // Events spanning midnight but less than 24 hours should NOT be multi-day
      final overnightEvent = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(2025, 1, 1, 22, 0),
          end: DateTime(2025, 1, 2, 6, 0), // 8 hours
        ),
      );
      expect(overnightEvent.isMultiDayEvent, isFalse);
    });
  });
}
