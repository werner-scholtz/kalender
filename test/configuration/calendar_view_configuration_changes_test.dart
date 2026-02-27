import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  late EventsController eventsController;
  late CalendarController calendarController;
  final calendarRange = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2026, 12, 31));

  /// Shared key so didUpdateWidget fires instead of full rebuild.
  late GlobalKey calendarViewKey;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    calendarViewKey = GlobalKey();
  });

  /// Helper to pump a CalendarView with the given config and optional body.
  Future<void> pumpCalendarView(
    WidgetTester tester, {
    required ViewConfiguration config,
    bool withBody = false,
  }) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        key: calendarViewKey,
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: config,
        body: withBody ? const CalendarBody() : null,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // selectedDate tests
  // ---------------------------------------------------------------------------
  group('View configuration changes with selectedDate', () {
    testWidgets('uses initialDateTime when provided during config change', (tester) async {
      await pumpCalendarView(tester, config: MonthViewConfiguration.singleMonth(displayRange: calendarRange));

      final selectedDate = DateTime(2024, 8, 20);
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(
          initialDateTime: selectedDate,
          displayRange: calendarRange,
        ),
      );

      final visibleRange = calendarController.internalDateTimeRange.value;
      expect(visibleRange!.start.startOfDay, equals(InternalDateTime.fromDateTime(selectedDate)));
    });

    testWidgets('prioritizes initialDateTime over strategy', (tester) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month View', displayRange: calendarRange),
      );

      final selectedDate = DateTime(2024, 12, 25);
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(
          name: 'Day View',
          initialDateTime: selectedDate,
          initialDateSelectionStrategy: _alwaysReturnJanuaryStrategy,
          displayRange: calendarRange,
        ),
      );

      final visibleRange = calendarController.internalDateTimeRange.value;
      expect(visibleRange!.start.startOfDay, equals(InternalDateTime.fromDateTime(selectedDate)));
    });
  });

  // ---------------------------------------------------------------------------
  // Strategy tests
  // ---------------------------------------------------------------------------
  group('View configuration changes with strategy', () {
    testWidgets('uses default strategy when no initialDateTime', (tester) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month View', displayRange: calendarRange),
        withBody: true,
      );
      expect(find.byType(MonthBody), findsOneWidget);

      calendarController.jumpToDate(DateTime(2024, 6, 1));
      await tester.pumpAndSettle();

      final visibleRangeBefore = calendarController.internalDateTimeRange.value;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day View', displayRange: calendarRange),
      );

      // Default monthly→daily strategy uses dominantMonthDate.
      final visibleRangeAfter = calendarController.internalDateTimeRange.value;
      final expectedDate = visibleRangeBefore!.dominantMonthDate;
      expect(visibleRangeAfter!.start.startOfDay, equals(InternalDateTime.fromDateTime(expectedDate)));
    });

    testWidgets('uses custom strategy', (tester) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month View', displayRange: calendarRange),
      );

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(
          name: 'Day View',
          initialDateSelectionStrategy: _alwaysReturnJanuaryStrategy,
          displayRange: calendarRange,
        ),
      );

      final visibleRange = calendarController.internalDateTimeRange.value;
      expect(visibleRange!.start.startOfDay, equals(_fixedDate));
    });

    testWidgets('custom strategy receives correct old view controller', (tester) async {
      ViewController? capturedOldController;
      ViewConfiguration? capturedNewConfig;

      InternalDateTime capturingStrategy({
        required ViewController oldViewController,
        required ViewConfiguration newViewConfiguration,
      }) {
        capturedOldController = oldViewController;
        capturedNewConfig = newViewConfiguration;
        return _fixedDate;
      }

      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );

      final originalController = calendarController.viewController;

      final dailyConfig = MultiDayViewConfiguration.singleDay(
        name: 'Day',
        initialDateSelectionStrategy: capturingStrategy,
        displayRange: calendarRange,
      );
      await pumpCalendarView(tester, config: dailyConfig);

      expect(capturedOldController, same(originalController));
      expect(capturedNewConfig, same(dailyConfig));
    });
  });

  // ---------------------------------------------------------------------------
  // Real-world transition scenarios
  // ---------------------------------------------------------------------------
  group('Real-world transition scenarios', () {
    testWidgets('month → week', (tester) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
        withBody: true,
      );
      expect(find.byType(MonthBody), findsOneWidget);

      calendarController.jumpToDate(DateTime(2024, 6, 1));
      await tester.pumpAndSettle();
      final monthRange = calendarController.visibleDateTimeRange.value;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.week(name: 'Week', displayRange: calendarRange),
      );

      final weekRange = calendarController.internalDateTimeRange.value;
      expect(weekRange!.start.startOfDay, equals(InternalDateTime.fromDateTime(monthRange!.start)));
    });

    testWidgets('week → day', (tester) async {
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.week(name: 'Week', displayRange: calendarRange),
        withBody: true,
      );
      expect(find.byType(MultiDayBody), findsOneWidget);

      calendarController.jumpToDate(DateTime(2024, 6, 10));
      await tester.pumpAndSettle();
      final weekRange = calendarController.visibleDateTimeRange.value;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      final dayRange = calendarController.internalDateTimeRange.value;
      expect(dayRange!.start.startOfDay, equals(InternalDateTime.fromDateTime(weekRange!.start)));
    });

    testWidgets('day → month', (tester) async {
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
        withBody: true,
      );
      expect(find.byType(MultiDayBody), findsOneWidget);

      final specificDay = DateTime(2024, 6, 15);
      calendarController.jumpToDate(specificDay);
      await tester.pumpAndSettle();

      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );
      await tester.pumpAndSettle();

      final monthRange = calendarController.internalDateTimeRange.value;
      expect(monthRange!.dominantMonthDate.year, equals(specificDay.year));
      expect(monthRange.dominantMonthDate.month, equals(specificDay.month));
      expect(monthRange.dominantMonthDate.day, equals(1));
    });

    testWidgets('schedule → day', (tester) async {
      await pumpCalendarView(
        tester,
        config: ScheduleViewConfiguration.continuous(name: 'Schedule', displayRange: calendarRange),
        withBody: true,
      );
      await tester.pumpAndSettle();
      expect(find.byType(ScheduleBody), findsOneWidget);

      final specificDate = DateTime(2024, 7, 20);
      calendarController.jumpToDate(specificDate);
      await tester.pumpAndSettle();
      final scheduleRange = calendarController.internalDateTimeRange.value;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      final dayRange = calendarController.internalDateTimeRange.value;
      expect(dayRange!.start.startOfDay, equals(scheduleRange!.start.startOfDay));
    });

    testWidgets('day → week → month (chained transitions)', (tester) async {
      // Start with day view on June 15
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
        withBody: true,
      );
      calendarController.jumpToDate(DateTime(2024, 6, 15));
      await tester.pumpAndSettle();

      // Day → Week
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.week(name: 'Week', displayRange: calendarRange),
      );
      final weekRange = calendarController.internalDateTimeRange.value;
      expect(weekRange, isNotNull);

      // Week → Month
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );
      final monthRange = calendarController.internalDateTimeRange.value;
      expect(monthRange!.dominantMonthDate.month, equals(6));
    });

    testWidgets('day → work week', (tester) async {
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
        withBody: true,
      );
      calendarController.jumpToDate(DateTime(2024, 6, 12)); // Wednesday
      await tester.pumpAndSettle();

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.workWeek(name: 'Work Week', displayRange: calendarRange),
      );

      final workWeekRange = calendarController.internalDateTimeRange.value;
      expect(workWeekRange, isNotNull);
      // Work week should have 5 days
      expect(workWeekRange!.end.difference(workWeekRange.start).inDays, equals(5));
    });

    testWidgets('month → schedule', (tester) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
        withBody: true,
      );
      calendarController.jumpToDate(DateTime(2024, 6, 1));
      await tester.pumpAndSettle();

      await pumpCalendarView(
        tester,
        config: ScheduleViewConfiguration.continuous(name: 'Schedule', displayRange: calendarRange),
        withBody: true,
      );
      await tester.pumpAndSettle();

      expect(find.byType(ScheduleBody), findsOneWidget);
      expect(calendarController.internalDateTimeRange.value, isNotNull);
    });

    testWidgets('paginated schedule → day', (tester) async {
      await pumpCalendarView(
        tester,
        config: ScheduleViewConfiguration.paginated(name: 'Paginated Schedule', displayRange: calendarRange),
        withBody: true,
      );
      await tester.pumpAndSettle();

      calendarController.jumpToDate(DateTime(2024, 9, 1));
      await tester.pumpAndSettle();
      final scheduleRange = calendarController.internalDateTimeRange.value;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      final dayRange = calendarController.internalDateTimeRange.value;
      expect(dayRange!.start.startOfDay, equals(scheduleRange!.start.startOfDay));
    });
  });

  // ---------------------------------------------------------------------------
  // View controller lifecycle
  // ---------------------------------------------------------------------------
  group('View controller lifecycle', () {
    testWidgets('creates new controller on config change', (tester) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );

      final original = calendarController.viewController;
      expect(original, isNotNull);

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      final updated = calendarController.viewController;
      expect(updated, isNotNull);
      expect(updated, isNot(same(original)));
    });

    testWidgets('creates new controller for different objects of same type', (tester) async {
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day 1', displayRange: calendarRange),
      );
      final original = calendarController.viewController;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day 2', displayRange: calendarRange),
      );

      // Different config objects → new view controller.
      expect(calendarController.viewController, isNot(same(original)));
    });

    testWidgets('controller is attached after config change', (tester) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );

      expect(calendarController.isAttached, isTrue);

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      expect(calendarController.isAttached, isTrue);
      expect(calendarController.viewController, isNotNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Edge cases
  // ---------------------------------------------------------------------------
  group('Edge cases', () {
    testWidgets('rapid configuration changes do not crash', (tester) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );

      final configs = [
        MultiDayViewConfiguration.singleDay(name: 'Day 1', displayRange: calendarRange),
        MultiDayViewConfiguration.week(name: 'Week 1', displayRange: calendarRange),
        MonthViewConfiguration.singleMonth(name: 'Month 1', displayRange: calendarRange),
        MultiDayViewConfiguration.workWeek(name: 'Work Week', displayRange: calendarRange),
        ScheduleViewConfiguration.continuous(name: 'Schedule', displayRange: calendarRange),
        MultiDayViewConfiguration.singleDay(name: 'Day 2', displayRange: calendarRange),
      ];

      for (final config in configs) {
        await pumpCalendarView(tester, config: config);
      }

      expect(calendarController.viewController, isNotNull);
      expect(calendarController.isAttached, isTrue);
    });

    testWidgets('round-trip transition preserves date context', (tester) async {
      // Start daily on June 15
      final startDate = DateTime(2024, 6, 15);
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(
          name: 'Day',
          initialDateTime: startDate,
          displayRange: calendarRange,
        ),
        withBody: true,
      );

      final initialRange = calendarController.internalDateTimeRange.value;

      // Go to month and back
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      final finalRange = calendarController.internalDateTimeRange.value;
      // After round-trip, should still be in June.
      expect(finalRange!.start.month, equals(initialRange!.start.month));
    });

    testWidgets('config change at display range boundary', (tester) async {
      final start = calendarRange.start;
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(
          name: 'Day',
          initialDateTime: start,
          displayRange: calendarRange,
        ),
      );

      // Switch to month - should not crash at the boundary.
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );

      expect(calendarController.internalDateTimeRange.value, isNotNull);
    });

    testWidgets('config change at end of display range', (tester) async {
      // Jump close to the end of the visible range.
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(
          name: 'Day',
          initialDateTime: DateTime(2026, 12, 30),
          displayRange: calendarRange,
        ),
      );

      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );

      expect(calendarController.internalDateTimeRange.value, isNotNull);
    });

    testWidgets('custom number of days', (tester) async {
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
        withBody: true,
      );
      calendarController.jumpToDate(DateTime(2024, 6, 15));
      await tester.pumpAndSettle();

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.custom(
          name: '3-Day',
          numberOfDays: 3,
          displayRange: calendarRange,
        ),
        withBody: true,
      );

      expect(find.byType(MultiDayBody), findsOneWidget);
      expect(calendarController.internalDateTimeRange.value, isNotNull);
    });
  });
}

InternalDateTime _alwaysReturnJanuaryStrategy({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
}) {
  return _fixedDate;
}

final _fixedDate = InternalDateTime(2024, 1, 1);
