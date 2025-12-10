import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions/internal.dart';

import 'utilities.dart';

void main() {
  group('CalendarView Configuration Changes', () {
    late EventsController eventsController;
    late CalendarController calendarController;
    late DateTimeRange calendarRange;

    setUp(() {
      eventsController = DefaultEventsController();
      calendarController = CalendarController();
      calendarRange = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2026, 12, 31));
    });

    group('View configuration changes with selectedDate', () {
      testWidgets('should use selectedDate when provided during view configuration change', (tester) async {
        final calendarViewKey = GlobalKey();
        final monthConfig = MonthViewConfiguration.singleMonth(displayRange: calendarRange);

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: monthConfig,
          ),
        );

        // Change to daily view with specific selectedDate
        final selectedDate = DateTime(2024, 8, 20);
        final dailyConfig = MultiDayViewConfiguration.singleDay(
          selectedDate: selectedDate,
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: dailyConfig,
          ),
        );

        // Verify that the selectedDate was used
        final visibleRange = calendarController.visibleDateTimeRange.value;
        expect(visibleRange!.start.startOfDay, equals(selectedDate.startOfDay));
      });

      testWidgets('should prioritize selectedDate over initial date selection strategy', (tester) async {
        final calendarViewKey = GlobalKey();

        final monthConfig = MonthViewConfiguration.singleMonth(
          name: 'Month View',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: monthConfig,
          ),
        );

        // Change to daily view with both selectedDate and custom strategy
        final selectedDate = DateTime(2024, 12, 25);
        final dailyConfig = MultiDayViewConfiguration.singleDay(
          name: 'Day View',
          selectedDate: selectedDate,
          initialDateSelectionStrategy: _alwaysReturnJanuaryStrategy,
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: dailyConfig,
          ),
        );

        // Verify that selectedDate was used, not the strategy result
        final visibleRange = calendarController.visibleDateTimeRange.value;
        expect(visibleRange!.start.startOfDay, equals(selectedDate.startOfDay));
      });
    });

    group('View configuration changes with strategy', () {
      testWidgets('should use initial date selection strategy when no selectedDate', (tester) async {
        final calendarViewKey = GlobalKey();
        final monthConfig = MonthViewConfiguration.singleMonth(
          name: 'Month View',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: monthConfig,
            body: const CalendarBody(),
          ),
        );
        expect(find.byType(MonthBody), findsOneWidget);

        calendarController.jumpToDate(DateTime(2024, 6, 1));
        await tester.pumpAndSettle();

        // Get the current visible range after the month view is initialized
        final visibleRangeBeforeChange = calendarController.visibleDateTimeRange.value;

        // Change to daily view without selectedDate (should use strategy)
        final dailyConfig = MultiDayViewConfiguration.singleDay(
          name: 'Day View',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: dailyConfig,
          ),
        );

        // Verify that the strategy was used (monthly to daily transition)
        final visibleRangeAfterChange = calendarController.visibleDateTimeRange.value;
        final expectedDate = visibleRangeBeforeChange!.dominantMonthDate;
        expect(visibleRangeAfterChange!.start.startOfDay, equals(expectedDate.startOfDay));
      });

      testWidgets('should use custom initial date selection strategy', (tester) async {
        final calendarViewKey = GlobalKey();

        final monthConfig = MonthViewConfiguration.singleMonth(
          displayRange: calendarRange,
          name: 'Month View',
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: monthConfig,
          ),
        );

        // Change to daily view with custom strategy
        final dailyConfig = MultiDayViewConfiguration.singleDay(
          name: 'Day View',
          initialDateSelectionStrategy: _alwaysReturnJanuaryStrategy,
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: dailyConfig,
          ),
        );

        // Verify that the custom strategy was used
        final visibleRange = calendarController.internalDateTimeRange.value;
        expect(visibleRange!.start.startOfDay, equals(_fixedDate));
      });
    });

    group('Real-world transition scenarios', () {
      testWidgets('should handle month to week transition correctly', (tester) async {
        final calendarViewKey = GlobalKey();
        final monthConfig = MonthViewConfiguration.singleMonth(
          name: 'Month View',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: monthConfig,
            body: const CalendarBody(),
          ),
        );

        expect(find.byType(MonthBody), findsOneWidget);

        // Set up a specific month view
        calendarController.jumpToDate(DateTime(2024, 6, 1));
        await tester.pumpAndSettle();

        final monthVisibleRange = calendarController.visibleDateTimeRange.value;

        // Transition to week view
        final weekConfig = MultiDayViewConfiguration.week(
          name: 'Week View',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: weekConfig,
          ),
        );

        // Verify that the week view starts at the beginning of the month range
        final weekVisibleRange = calendarController.visibleDateTimeRange.value;
        expect(weekVisibleRange!.start.startOfDay, equals(monthVisibleRange!.start.startOfDay));
      });

      testWidgets('should handle week to daily transition correctly', (tester) async {
        final calendarViewKey = GlobalKey();
        final weekConfig = MultiDayViewConfiguration.week(
          name: 'Week View',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: weekConfig,
            body: const CalendarBody(),
          ),
        );

        expect(find.byType(MultiDayBody), findsOneWidget);

        // Set up a specific week
        calendarController.jumpToDate(DateTime(2024, 6, 10)); // Monday
        await tester.pumpAndSettle();

        final weekVisibleRange = calendarController.visibleDateTimeRange.value;

        // Transition to daily view
        final dailyConfig = MultiDayViewConfiguration.singleDay(
          name: 'Day View',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: dailyConfig,
          ),
        );

        // Verify that the daily view starts at the beginning of the week
        final dailyVisibleRange = calendarController.visibleDateTimeRange.value;
        expect(dailyVisibleRange!.start.startOfDay, equals(weekVisibleRange!.start.startOfDay));
      });

      testWidgets('should handle daily to month transition correctly', (tester) async {
        final calendarViewKey = GlobalKey();
        final dailyConfig = MultiDayViewConfiguration.singleDay(
          name: 'Day View',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: dailyConfig,
            body: const CalendarBody(),
          ),
        );

        expect(find.byType(MultiDayBody), findsOneWidget);

        // Set up a specific day
        final specificDay = DateTime(2024, 6, 15);
        calendarController.jumpToDate(specificDay);
        await tester.pumpAndSettle();

        // Transition to month view
        final monthConfig = MonthViewConfiguration.singleMonth(
          name: 'Month View',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: monthConfig,
          ),
        );

        await tester.pumpAndSettle();

        // Verify that the month view shows the correct month
        final monthVisibleRange = calendarController.internalDateTimeRange.value;
        expect(monthVisibleRange!.dominantMonthDate.year, equals(specificDay.year));
        expect(monthVisibleRange.dominantMonthDate.month, equals(specificDay.month));
        expect(monthVisibleRange.dominantMonthDate.day, equals(1));
      });

      testWidgets('should handle schedule to daily transition correctly', (tester) async {
        final calendarViewKey = GlobalKey();
        final scheduleConfig = ScheduleViewConfiguration.continuous(name: 'Schedule View', displayRange: calendarRange);
        final calendarView = CalendarView(
          key: calendarViewKey,
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: scheduleConfig,
          body: const CalendarBody(),
        );

        await pumpAndSettleWithMaterialApp(tester, calendarView);
        await tester.pumpAndSettle();

        expect(find.byType(ScheduleBody), findsOneWidget);

        // Set up a specific date in schedule view
        final specificDate = DateTime(2024, 7, 20);
        calendarController.jumpToDate(specificDate);
        await tester.pumpAndSettle();

        final scheduleVisibleRange = calendarController.internalDateTimeRange.value;

        // Transition to daily view
        final dailyConfig = MultiDayViewConfiguration.singleDay(
          name: 'Day View',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: dailyConfig,
          ),
        );

        // Verify that the daily view starts at the schedule start date
        final dailyVisibleRange = calendarController.internalDateTimeRange.value;
        expect(dailyVisibleRange!.start.startOfDay, equals(scheduleVisibleRange!.start.startOfDay));
      });
    });

    group('View controller disposal', () {
      testWidgets('should dispose old view controller when configuration changes', (tester) async {
        final calendarViewKey = GlobalKey();
        final monthConfig = MonthViewConfiguration.singleMonth(
          name: 'Month View',
          displayRange: calendarRange,
        );

        final calendarView = CalendarView(
          key: calendarViewKey,
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: monthConfig,
        );

        await pumpAndSettleWithMaterialApp(tester, calendarView);

        final originalViewController = calendarController.viewController;
        expect(originalViewController, isNotNull);

        // Change configuration
        final dailyConfig = MultiDayViewConfiguration.singleDay(
          name: 'Day View',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: dailyConfig,
          ),
        );

        // Verify that a new view controller was created
        final newViewController = calendarController.viewController;
        expect(newViewController, isNotNull);
        expect(newViewController, isNot(same(originalViewController)));
      });
    });

    group('Edge cases and error scenarios', () {
      testWidgets('should handle rapid configuration changes', (tester) async {
        final calendarViewKey = GlobalKey();
        final monthConfig = MonthViewConfiguration.singleMonth(
          name: 'Month View',
          displayRange: calendarRange,
        );

        final calendarView = CalendarView(
          key: calendarViewKey,
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: monthConfig,
        );

        await pumpAndSettleWithMaterialApp(tester, calendarView);

        // Rapidly change configurations
        final configs = [
          MultiDayViewConfiguration.singleDay(name: 'Day 1', displayRange: calendarRange),
          MultiDayViewConfiguration.week(name: 'Week 1', displayRange: calendarRange),
          MonthViewConfiguration.singleMonth(name: 'Month 1', displayRange: calendarRange),
          MultiDayViewConfiguration.workWeek(name: 'Work Week', displayRange: calendarRange),
          MultiDayViewConfiguration.singleDay(name: 'Day 2', displayRange: calendarRange),
        ];

        for (final config in configs) {
          await pumpAndSettleWithMaterialApp(
            tester,
            CalendarView(
              key: calendarViewKey,
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: config,
            ),
          );
        }

        // Should not crash and should have a valid view controller
        expect(calendarController.viewController, isNotNull);
      });

      testWidgets('should handle same view configuration type without recreation', (tester) async {
        final calendarViewKey = GlobalKey();
        final dailyConfig1 = MultiDayViewConfiguration.singleDay(
          name: 'Day View 1',
          displayRange: calendarRange,
        );

        final calendarView = CalendarView(
          key: calendarViewKey,
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: dailyConfig1,
        );

        await pumpAndSettleWithMaterialApp(tester, calendarView);

        final originalViewController = calendarController.viewController;

        // Change to identical configuration (same runtime type)
        final dailyConfig2 = MultiDayViewConfiguration.singleDay(
          name: 'Day View 2',
          displayRange: calendarRange,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            key: calendarViewKey,
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: dailyConfig2,
          ),
        );

        // Should create new view controller because configurations are different objects
        final newViewController = calendarController.viewController;
        expect(newViewController, isNot(same(originalViewController)));
      });
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
