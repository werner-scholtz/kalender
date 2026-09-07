import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  late EventsController eventsController;
  late KalenderController kalenderController;
  final calendarRange = KalenderDateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2026, 12, 31));

  /// Shared key so didUpdateWidget fires instead of full rebuild.
  late GlobalKey calendarViewKey;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
    calendarViewKey = GlobalKey();
  });

  /// Helper to pump a KalenderView with the given config and optional body.
  Future<void> pumpCalendarView(
    WidgetTester tester, {
    required ViewConfiguration config,
    bool withBody = false,
  }) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        key: calendarViewKey,
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: config,
        body: withBody ? const KalenderBody() : null,
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

      final visibleRange = kalenderController.internalDateTimeRange.value;
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
          dateResolver: _alwaysReturnJanuaryResolver,
          displayRange: calendarRange,
        ),
      );

      final visibleRange = kalenderController.internalDateTimeRange.value;
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

      kalenderController.jumpToDate(DateTime(2024, 6, 1));
      await tester.pumpAndSettle();

      final visibleRangeBefore = kalenderController.internalDateTimeRange.value;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day View', displayRange: calendarRange),
      );

      // Default monthly→daily strategy uses dominantMonthDate.
      final visibleRangeAfter = kalenderController.internalDateTimeRange.value;
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
          dateResolver: _alwaysReturnJanuaryResolver,
          displayRange: calendarRange,
        ),
      );

      final visibleRange = kalenderController.internalDateTimeRange.value;
      expect(visibleRange!.start.startOfDay, equals(_fixedDate));
    });

    testWidgets('custom strategy receives correct old view controller', (tester) async {
      ViewController? capturedOldController;
      ViewConfiguration? capturedNewConfig;

      InternalDateTime capturingResolver(ViewTransitionContext transition) {
        capturedOldController = transition.oldViewController;
        capturedNewConfig = transition.newViewConfiguration;
        return _fixedDate;
      }

      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );

      final originalController = kalenderController.viewController;

      final dailyConfig = MultiDayViewConfiguration.singleDay(
        name: 'Day',
        dateResolver: capturingResolver,
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

      kalenderController.jumpToDate(DateTime(2024, 6, 1));
      await tester.pumpAndSettle();
      final monthRange = kalenderController.visibleDateTimeRange.value;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.week(name: 'Week', displayRange: calendarRange),
      );

      final weekRange = kalenderController.internalDateTimeRange.value;
      expect(weekRange!.start.startOfDay, equals(InternalDateTime.fromDateTime(monthRange!.start)));
    });

    testWidgets('week → day', (tester) async {
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.week(name: 'Week', displayRange: calendarRange),
        withBody: true,
      );
      expect(find.byType(MultiDayBody), findsOneWidget);

      kalenderController.jumpToDate(DateTime(2024, 6, 10));
      await tester.pumpAndSettle();
      final weekRange = kalenderController.visibleDateTimeRange.value;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      final dayRange = kalenderController.internalDateTimeRange.value;
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
      kalenderController.jumpToDate(specificDay);
      await tester.pumpAndSettle();

      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );
      await tester.pumpAndSettle();

      final monthRange = kalenderController.internalDateTimeRange.value;
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
      kalenderController.jumpToDate(specificDate);
      await tester.pumpAndSettle();
      final scheduleRange = kalenderController.internalDateTimeRange.value;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      final dayRange = kalenderController.internalDateTimeRange.value;
      expect(dayRange!.start.startOfDay, equals(scheduleRange!.start.startOfDay));
    });

    testWidgets('day → week → month (chained transitions)', (tester) async {
      // Start with day view on June 15
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
        withBody: true,
      );
      kalenderController.jumpToDate(DateTime(2024, 6, 15));
      await tester.pumpAndSettle();

      // Day → Week
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.week(name: 'Week', displayRange: calendarRange),
      );
      final weekRange = kalenderController.internalDateTimeRange.value;
      expect(weekRange, isNotNull);

      // Week → Month
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );
      final monthRange = kalenderController.internalDateTimeRange.value;
      expect(monthRange!.dominantMonthDate.month, equals(6));
    });

    testWidgets('day → work week', (tester) async {
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
        withBody: true,
      );
      kalenderController.jumpToDate(DateTime(2024, 6, 12)); // Wednesday
      await tester.pumpAndSettle();

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.workWeek(name: 'Work Week', displayRange: calendarRange),
      );

      final workWeekRange = kalenderController.internalDateTimeRange.value;
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
      kalenderController.jumpToDate(DateTime(2024, 6, 1));
      await tester.pumpAndSettle();

      await pumpCalendarView(
        tester,
        config: ScheduleViewConfiguration.continuous(name: 'Schedule', displayRange: calendarRange),
        withBody: true,
      );
      await tester.pumpAndSettle();

      expect(find.byType(ScheduleBody), findsOneWidget);
      expect(kalenderController.internalDateTimeRange.value, isNotNull);
    });

    testWidgets('paginated schedule → day', (tester) async {
      await pumpCalendarView(
        tester,
        config: ScheduleViewConfiguration.paginated(name: 'Paginated Schedule', displayRange: calendarRange),
        withBody: true,
      );
      await tester.pumpAndSettle();

      kalenderController.jumpToDate(DateTime(2024, 9, 1));
      await tester.pumpAndSettle();
      final scheduleRange = kalenderController.internalDateTimeRange.value;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      final dayRange = kalenderController.internalDateTimeRange.value;
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

      final original = kalenderController.viewController;
      expect(original, isNotNull);

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      final updated = kalenderController.viewController;
      expect(updated, isNotNull);
      expect(updated, isNot(same(original)));
    });

    testWidgets('creates new controller for different objects of same type', (tester) async {
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day 1', displayRange: calendarRange),
      );
      final original = kalenderController.viewController;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day 2', displayRange: calendarRange),
      );

      // Different config objects → new view controller.
      expect(kalenderController.viewController, isNot(same(original)));
    });

    testWidgets('controller is attached after config change', (tester) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );

      expect(kalenderController.isAttached, isTrue);

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      expect(kalenderController.isAttached, isTrue);
      expect(kalenderController.viewController, isNotNull);
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

      expect(kalenderController.viewController, isNotNull);
      expect(kalenderController.isAttached, isTrue);
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

      final initialRange = kalenderController.internalDateTimeRange.value;

      // Go to month and back
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      final finalRange = kalenderController.internalDateTimeRange.value;
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

      expect(kalenderController.internalDateTimeRange.value, isNotNull);
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

      expect(kalenderController.internalDateTimeRange.value, isNotNull);
    });

    testWidgets('custom number of days', (tester) async {
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
        withBody: true,
      );
      kalenderController.jumpToDate(DateTime(2024, 6, 15));
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
      expect(kalenderController.internalDateTimeRange.value, isNotNull);
    });
  });

  // ---------------------------------------------------------------------------
  // View-transition policy: scroll / zoom / date across switches (#249)
  // ---------------------------------------------------------------------------
  group('View-transition policy (#249)', () {
    MultiDayViewController multiDay() => kalenderController.viewController as MultiDayViewController;
    MonthViewConfiguration month() => MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange);
    InternalDateTime? visibleStart() => kalenderController.internalDateTimeRange.value?.start.startOfDay;

    MultiDayViewConfiguration week({
      ScrollTransition scroll = ScrollTransition.preserve,
      ZoomTransition zoom = ZoomTransition.preserve,
      DateTransition date = DateTransition.carryFocus,
      ScrollResolver? scrollResolver,
      ZoomResolver? zoomResolver,
      DateResolver? dateResolver,
    }) =>
        MultiDayViewConfiguration.week(
          name: 'Week',
          displayRange: calendarRange,
          scrollTransition: scroll,
          zoomTransition: zoom,
          dateTransition: date,
          scrollResolver: scrollResolver,
          zoomResolver: zoomResolver,
          dateResolver: dateResolver,
        );

    testWidgets('defaults preserve scroll + zoom across Week → Month → Week', (tester) async {
      await pumpCalendarView(tester, config: week(), withBody: true);
      multiDay().scrollController.jumpTo(120 * 0.7); // 02:00 at default heightPerMinute.
      multiDay().heightPerMinute.value = 1.2;
      await tester.pump();
      final todBefore = kalenderController.visibleTimeOfDay.value;
      expect(todBefore, isNotNull);

      await pumpCalendarView(tester, config: month(), withBody: true);
      await pumpCalendarView(tester, config: week(), withBody: true);

      expect(kalenderController.visibleTimeOfDay.value, equals(todBefore));
      expect(multiDay().heightPerMinute.value, equals(1.2));
    });

    testWidgets('ScrollTransition.reset returns to initialTimeOfDay on switch', (tester) async {
      await pumpCalendarView(tester, config: week(scroll: ScrollTransition.reset), withBody: true);
      multiDay().scrollController.jumpTo(120 * 0.7);
      await tester.pump();

      await pumpCalendarView(tester, config: month(), withBody: true);
      await pumpCalendarView(tester, config: week(scroll: ScrollTransition.reset), withBody: true);

      // initialTimeOfDay is midnight → offset 0.
      expect(multiDay().scrollController.offset, closeTo(0, 1.0));
    });

    testWidgets('DateTransition.restorePerView reopens the view\'s own last date', (tester) async {
      final day = MultiDayViewConfiguration.singleDay(
        name: 'Day',
        displayRange: calendarRange,
        dateTransition: DateTransition.restorePerView,
      );
      await pumpCalendarView(tester, config: day, withBody: true);
      kalenderController.jumpToDate(DateTime(2024, 6, 15));
      await tester.pumpAndSettle();

      await pumpCalendarView(tester, config: month(), withBody: true);
      kalenderController.jumpToDate(DateTime(2024, 9, 10)); // navigate month elsewhere
      await tester.pumpAndSettle();
      await pumpCalendarView(tester, config: day, withBody: true);

      expect(visibleStart(), equals(InternalDateTime(2024, 6, 15)));
    });

    testWidgets('ScrollTransition.restorePerView restores the view\'s own last time-of-day', (tester) async {
      final day = MultiDayViewConfiguration.singleDay(
        name: 'Day',
        displayRange: calendarRange,
        scrollTransition: ScrollTransition.restorePerView,
      );
      final wk = week(scroll: ScrollTransition.restorePerView);

      // Day scrolled to 03:00.
      await pumpCalendarView(tester, config: day, withBody: true);
      multiDay().scrollController.jumpTo(180 * 0.7);
      await tester.pump();

      // Week scrolled somewhere else (05:00) — a different per-view position.
      await pumpCalendarView(tester, config: wk, withBody: true);
      multiDay().scrollController.jumpTo(300 * 0.7);
      await tester.pump();

      // Returning to Day restores Day's own 03:00, not Week's 05:00.
      await pumpCalendarView(tester, config: day, withBody: true);
      expect(kalenderController.visibleTimeOfDay.value, equals(const KalenderTime(hour: 3, minute: 0)));
    });

    testWidgets('ZoomTransition.reset returns to initialHeightPerMinute on switch', (tester) async {
      final wk = week(zoom: ZoomTransition.reset);
      await pumpCalendarView(tester, config: wk, withBody: true);
      multiDay().heightPerMinute.value = 1.5; // zoom in
      await tester.pump();

      await pumpCalendarView(tester, config: month(), withBody: true);
      await pumpCalendarView(tester, config: wk, withBody: true);

      // Back to the configured default (0.7), not the 1.5 we set.
      expect(multiDay().heightPerMinute.value, equals(kDefaultHeightPerMinute));
    });

    testWidgets('ZoomTransition.restorePerView restores the view\'s own last zoom', (tester) async {
      final day = MultiDayViewConfiguration.singleDay(
        name: 'Day',
        displayRange: calendarRange,
        zoomTransition: ZoomTransition.restorePerView,
      );
      final wk = week(zoom: ZoomTransition.restorePerView);

      await pumpCalendarView(tester, config: day, withBody: true);
      multiDay().heightPerMinute.value = 2.0;
      await tester.pump();

      await pumpCalendarView(tester, config: wk, withBody: true);
      multiDay().heightPerMinute.value = 0.9;
      await tester.pump();

      await pumpCalendarView(tester, config: day, withBody: true);
      expect(multiDay().heightPerMinute.value, equals(2.0));
    });

    testWidgets('zoomResolver overrides the zoom transition', (tester) async {
      double fixedZoom(ViewTransitionContext transition) => 1.7;
      final wk = week(zoomResolver: fixedZoom);
      await pumpCalendarView(tester, config: wk, withBody: true);

      await pumpCalendarView(tester, config: month(), withBody: true);
      await pumpCalendarView(tester, config: wk, withBody: true);

      expect(multiDay().heightPerMinute.value, equals(1.7));
    });

    testWidgets('scrollResolver overrides the scroll transition', (tester) async {
      KalenderTime fixedNine(ViewTransitionContext transition) => const KalenderTime(hour: 9, minute: 0);
      await pumpCalendarView(tester, config: week(scrollResolver: fixedNine), withBody: true);

      await pumpCalendarView(tester, config: month(), withBody: true);
      await pumpCalendarView(tester, config: week(scrollResolver: fixedNine), withBody: true);

      // 09:00 * kDefaultHeightPerMinute (0.7) = 540 * 0.7 = 378px.
      expect(multiDay().scrollController.offset, closeTo(540 * 0.7, 1.0));
      expect(kalenderController.visibleTimeOfDay.value, equals(const KalenderTime(hour: 9, minute: 0)));
    });

    testWidgets('visibleTimeOfDay is non-null in multi-day and null in month; onScrollPositionChanged fires',
        (tester) async {
      final reported = <KalenderTime>[];
      await pumpAndSettleWithMaterialApp(
        tester,
        KalenderView(
          key: calendarViewKey,
          eventsController: eventsController,
          kalenderController: kalenderController,
          viewConfiguration: week(),
          callbacks: KalenderCallbacks(onScrollPositionChanged: reported.add),
          body: const KalenderBody(),
        ),
      );
      expect(kalenderController.visibleTimeOfDay.value, isNotNull);

      multiDay().scrollController.jumpTo(120 * 0.7); // 02:00
      await tester.pump();
      expect(reported.last, equals(const KalenderTime(hour: 2, minute: 0)));

      await pumpAndSettleWithMaterialApp(
        tester,
        KalenderView(
          key: calendarViewKey,
          eventsController: eventsController,
          kalenderController: kalenderController,
          viewConfiguration: month(),
          body: const KalenderBody(),
        ),
      );
      expect(kalenderController.visibleTimeOfDay.value, isNull);
    });
  });
}

InternalDateTime _alwaysReturnJanuaryResolver(ViewTransitionContext transition) {
  return _fixedDate;
}

final _fixedDate = InternalDateTime(2024, 1, 1);
