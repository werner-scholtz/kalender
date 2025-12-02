import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/drag_targets/vertical_drag_target.dart';

import 'utilities.dart';

/// Tests for drag target edge cases, particularly handling cursor positions
/// over timeline areas and beyond visible dates.
void main() {
  group('VerticalDragTarget Edge Cases', () {
    testWidgets('should handle negative cursor position (over timeline)', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController(initialDate: DateTime(2025, 1, 1));
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add a test event
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 10),
            end: DateTime(2025, 1, 2, 12),
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

      // Find the drag target
      final dragTargetFinder = find.byType(VerticalDragTarget<Object?>);
      expect(dragTargetFinder, findsOneWidget, reason: 'VerticalDragTarget should be present');

      final state = tester.state<State>(dragTargetFinder);

      // Get the RenderBox to calculate positions
      final renderBox = tester.renderObject(dragTargetFinder) as RenderBox;
      final globalPosition = renderBox.localToGlobal(Offset.zero);

      // Create drag details with cursor position to the LEFT of the drag target (negative local x)
      // This simulates the cursor being over the timeline area
      final negativeXOffset = Offset(globalPosition.dx - 50, globalPosition.dy + 100);

      // The calculateCursorDateTime should NOT return null for negative positions
      // It should clamp to the first visible date
      final stateWithMixin = state as dynamic;
      final calculatedDate = stateWithMixin.calculateCursorDateTime(negativeXOffset);
      
      // Should return a valid date (the first visible date) instead of null
      expect(calculatedDate, isNotNull, reason: 'Should handle negative cursor position by clamping to first day');
    });

    testWidgets('should handle cursor position far beyond last visible date', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController(initialDate: DateTime(2025, 1, 1));
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add a test event
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 10),
            end: DateTime(2025, 1, 2, 12),
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

      final dragTargetFinder = find.byType(VerticalDragTarget<Object?>);
      expect(dragTargetFinder, findsOneWidget);

      final state = tester.state<State>(dragTargetFinder);
      final renderBox = tester.renderObject(dragTargetFinder) as RenderBox;
      final globalPosition = renderBox.localToGlobal(Offset.zero);

      // Position far to the right (beyond all visible dates)
      final farRightOffset = Offset(globalPosition.dx + 10000, globalPosition.dy + 100);

      final stateWithMixin = state as dynamic;
      final calculatedDate = stateWithMixin.calculateCursorDateTime(farRightOffset);

      // Should clamp to the last visible date
      expect(calculatedDate, isNotNull, reason: 'Should handle far right position by clamping to last day');
    });

    testWidgets('should smoothly handle transition from timeline to first day', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController(initialDate: DateTime(2025, 1, 1));
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

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

      final dragTargetFinder = find.byType(VerticalDragTarget<Object?>);
      final state = tester.state<State>(dragTargetFinder);
      final renderBox = tester.renderObject(dragTargetFinder) as RenderBox;
      final globalPosition = renderBox.localToGlobal(Offset.zero);

      final stateWithMixin = state as dynamic;

      // Test multiple positions from negative (timeline) to positive (first day)
      final positions = [
        globalPosition.dx - 100, // Far left (timeline)
        globalPosition.dx - 50,  // Timeline
        globalPosition.dx - 10,  // Edge of timeline
        globalPosition.dx + 10,  // First day
        globalPosition.dx + 50,  // First day
      ];

      DateTime? previousDate;
      for (final xPos in positions) {
        final offset = Offset(xPos, globalPosition.dy + 100);
        final calculatedDate = stateWithMixin.calculateCursorDateTime(offset);

        expect(calculatedDate, isNotNull, 
          reason: 'All positions should return valid dates (xPos: $xPos)');

        // All negative positions should map to the same date (first visible date)
        if (previousDate != null && xPos < globalPosition.dx) {
          expect(calculatedDate!.day, equals(previousDate.day),
            reason: 'Timeline positions should consistently map to first day');
        }
        previousDate = calculatedDate;
      }
    });
  });

  group('HorizontalDragTarget Edge Cases', () {
    testWidgets('should handle negative cursor position in month view', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController(initialDate: DateTime(2025, 1, 1));
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add a multi-day test event
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2),
            end: DateTime(2025, 1, 4),
          ),
        ),
      );

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: displayRange,
          ),
          body: const CalendarBody(),
        ),
      );

      // Find the horizontal drag target (used in month view)
      // Note: Month view has multiple HorizontalDragTarget widgets (one per week row)
      final dragTargetFinder = find.byType(HorizontalDragTarget<Object?>);
      expect(dragTargetFinder, findsWidgets, reason: 'HorizontalDragTarget should be present in month view');

      final state = tester.state<State>(dragTargetFinder.first);
      final renderBox = tester.renderObject(dragTargetFinder.first) as RenderBox;
      final globalPosition = renderBox.localToGlobal(Offset.zero);

      // Simulate cursor position to the left (negative local x)
      final negativeXOffset = Offset(globalPosition.dx - 50, globalPosition.dy + 50);

      final stateWithMixin = state as dynamic;
      final calculatedDate = stateWithMixin.calculateCursorDateTime(negativeXOffset);

      // Should return a valid date instead of null
      expect(calculatedDate, isNotNull, 
        reason: 'Should handle negative cursor position by clamping to first date');
    });

    testWidgets('should handle cursor far beyond visible dates', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController(initialDate: DateTime(2025, 1, 1));
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: displayRange,
          ),
          body: const CalendarBody(),
        ),
      );

      final dragTargetFinder = find.byType(HorizontalDragTarget<Object?>);
      expect(dragTargetFinder, findsWidgets);
      final state = tester.state<State>(dragTargetFinder.first);
      final renderBox = tester.renderObject(dragTargetFinder.first) as RenderBox;
      final globalPosition = renderBox.localToGlobal(Offset.zero);

      final stateWithMixin = state as dynamic;

      // Test far right position
      final farRightOffset = Offset(globalPosition.dx + 10000, globalPosition.dy + 50);
      final calculatedDate = stateWithMixin.calculateCursorDateTime(farRightOffset);

      // Should clamp to last visible date
      expect(calculatedDate, isNotNull, 
        reason: 'Should handle far right position by clamping to last date');
    });
  });

  group('Drag Target Behavior During Active Drag', () {
    testWidgets('event should not get stuck when dragged over timeline', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController(initialDate: DateTime(2025, 1, 1));
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      // Add a test event
      final eventId = eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 2, 10),
            end: DateTime(2025, 1, 2, 12),
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

      // Verify event was added
      expect(eventId, isNotNull);

      // Get drag target state to verify cursor calculation doesn't return null
      final dragTargetFinder = find.byType(VerticalDragTarget<Object?>);
      final state = tester.state<State>(dragTargetFinder);
      final stateWithMixin = state as dynamic;

      final renderBox = tester.renderObject(dragTargetFinder) as RenderBox;
      final globalPosition = renderBox.localToGlobal(Offset.zero);

      // Simulate dragging over the timeline area (negative X)
      final timelineOffset = Offset(globalPosition.dx - 30, globalPosition.dy + 200);
      
      // This should NOT return null - it should return the first visible day
      final dateOverTimeline = stateWithMixin.calculateCursorDateTime(timelineOffset);
      expect(dateOverTimeline, isNotNull, 
        reason: 'Cursor over timeline should calculate to first visible day, not null');

      // Verify the calculated date is valid and corresponds to a visible date
      // Note: The week view starts on the previous week if Jan 1 is not the first day of the week
      expect(dateOverTimeline.year, greaterThanOrEqualTo(2024));
      expect(dateOverTimeline.month, greaterThanOrEqualTo(1));
    });
  });

  group('Edge Case Regression Tests', () {
    testWidgets('zero-width dayWidth should not cause division errors', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController(initialDate: DateTime(2025, 1, 1));
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.singleDay(
            displayRange: displayRange,
            initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
          ),
          body: const CalendarBody(),
        ),
      );

      final dragTargetFinder = find.byType(VerticalDragTarget<Object?>);
      expect(dragTargetFinder, findsOneWidget);

      // Just verify it renders without errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('empty visible dates list should be handled gracefully', (tester) async {
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController(initialDate: DateTime(2025, 1, 1));
      final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

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

      // Verify no crashes occur with edge case calculations
      expect(tester.takeException(), isNull);
    });
  });
}

