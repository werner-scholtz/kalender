// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  late EventsController eventsController;
  late KalenderController kalenderController;
  var hasController = false;
  final calendarRange = KalenderDateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2026, 12, 31));

  setUp(() {
    eventsController = DefaultEventsController();
    hasController = false;
  });

  /// Mounts a view on [config], or switches the mounted view to it.
  Future<void> pumpCalendarView(
    WidgetTester tester, {
    required ViewConfiguration config,
    bool withBody = false,
    KalenderCallbacks? callbacks,
  }) async {
    if (!hasController) {
      kalenderController = KalenderController(viewConfiguration: config);
      addTearDown(kalenderController.dispose);
      hasController = true;
    } else {
      kalenderController.viewConfiguration = config;
    }
    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        callbacks: callbacks,
        body: withBody ? const KalenderBody() : null,
      ),
    );
  }

  group('View configuration changes with initialDateTime', () {
    testWidgets('ignores initialDateTime on a config change', (tester) async {
      Future<FloatingDateTime> switchToDay({DateTime? initialDateTime}) async {
        await tester.pumpWidget(const SizedBox());
        hasController = false;
        await pumpCalendarView(
          tester,
          config: MonthViewConfiguration.singleMonth(
            displayRange: calendarRange,
            initialDateTime: DateTime(2024, 6, 15),
          ),
        );
        await pumpCalendarView(
          tester,
          config: MultiDayViewConfiguration.singleDay(initialDateTime: initialDateTime, displayRange: calendarRange),
        );
        return kalenderController.floatingVisibleRange.value!.start.startOfDay;
      }

      final withInitialDateTime = await switchToDay(initialDateTime: DateTime(2024, 8, 20));
      final withoutInitialDateTime = await switchToDay();

      expect(withInitialDateTime, isNot(FloatingDateTime(2024, 8, 20)));
      expect(withInitialDateTime, withoutInitialDateTime);
    });

    testWidgets('dateResolver decides the date on a config change even when initialDateTime is set', (tester) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month View', displayRange: calendarRange),
      );

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(
          name: 'Day View',
          initialDateTime: DateTime(2024, 12, 25),
          dateResolver: _alwaysReturnJanuaryResolver,
          displayRange: calendarRange,
        ),
      );

      final visibleRange = kalenderController.floatingVisibleRange.value;
      expect(visibleRange!.start.startOfDay, equals(_fixedDate));
    });
  });

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

      final visibleRangeBefore = kalenderController.floatingVisibleRange.value;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day View', displayRange: calendarRange),
      );

      // Default monthly→daily strategy uses dominantMonthDate.
      final visibleRangeAfter = kalenderController.floatingVisibleRange.value;
      final expectedDate = visibleRangeBefore!.dominantMonthDate;
      expect(visibleRangeAfter!.start.startOfDay, equals(FloatingDateTime.fromDateTime(expectedDate)));
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

      final visibleRange = kalenderController.floatingVisibleRange.value;
      expect(visibleRange!.start.startOfDay, equals(_fixedDate));
    });

    testWidgets('custom strategy receives correct old view controller', (tester) async {
      ViewController? capturedOldController;
      ViewConfiguration? capturedNewConfig;

      FloatingDateTime capturingResolver(ViewTransitionContext transition) {
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

  group('Real-world transition scenarios', () {
    final startDateTransitions =
        <({String name, ViewConfiguration from, Type body, DateTime date, ViewConfiguration to})>[
          (
            name: 'month → week',
            from: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
            body: MonthBody,
            date: DateTime(2024, 6, 1),
            to: MultiDayViewConfiguration.week(name: 'Week', displayRange: calendarRange),
          ),
          (
            name: 'week → day',
            from: MultiDayViewConfiguration.week(name: 'Week', displayRange: calendarRange),
            body: MultiDayBody,
            date: DateTime(2024, 6, 10),
            to: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
          ),
          (
            name: 'schedule → day',
            from: ScheduleViewConfiguration.continuous(name: 'Schedule', displayRange: calendarRange),
            body: ScheduleBody,
            date: DateTime(2024, 7, 20),
            to: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
          ),
          (
            name: 'paginated schedule → day',
            from: ScheduleViewConfiguration.paginated(name: 'Paginated Schedule', displayRange: calendarRange),
            body: ScheduleBody,
            date: DateTime(2024, 9, 1),
            to: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
          ),
        ];

    for (final transition in startDateTransitions) {
      testWidgets('${transition.name} keeps the start date', (tester) async {
        await pumpCalendarView(tester, config: transition.from, withBody: true);
        expect(find.byType(transition.body), findsOneWidget);

        kalenderController.jumpToDate(transition.date);
        await tester.pumpAndSettle();
        final before = kalenderController.floatingVisibleRange.value!.start.startOfDay;

        await pumpCalendarView(tester, config: transition.to);

        expect(kalenderController.floatingVisibleRange.value!.start.startOfDay, before);
      });
    }

    testWidgets('month → week opens on a week of the month when the first days of the week differ', (tester) async {
      // September 2026 starts on a Tuesday, so a grid starting on Sunday begins on 30 August, which falls in the
      // Monday week of 24 August.
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(
          name: 'Month',
          displayRange: calendarRange,
          firstDayOfWeek: DateTime.sunday,
          initialDateTime: DateTime(2026, 9, 15),
        ),
        withBody: true,
      );
      expect(kalenderController.floatingVisibleRange.value!.start, FloatingDateTime(2026, 8, 30));

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.week(
          name: 'Week',
          displayRange: calendarRange,
          firstDayOfWeek: DateTime.monday,
        ),
      );

      expect(kalenderController.floatingVisibleRange.value!.start, FloatingDateTime(2026, 8, 31));
    });

    testWidgets('month → paginated schedule opens on the month', (tester) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(
          name: 'Month',
          displayRange: calendarRange,
          firstDayOfWeek: DateTime.sunday,
          initialDateTime: DateTime(2026, 9, 15),
        ),
        withBody: true,
      );

      await pumpCalendarView(
        tester,
        config: ScheduleViewConfiguration.paginated(name: 'Schedule', displayRange: calendarRange),
      );

      expect(kalenderController.floatingVisibleRange.value!.start, FloatingDateTime(2026, 9, 1));
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

      final monthRange = kalenderController.floatingVisibleRange.value;
      expect(monthRange!.dominantMonthDate.year, equals(specificDay.year));
      expect(monthRange.dominantMonthDate.month, equals(specificDay.month));
      expect(monthRange.dominantMonthDate.day, equals(1));
    });

    testWidgets('day → week → month → schedule → custom number of days (chained transitions)', (tester) async {
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
        withBody: true,
      );
      kalenderController.jumpToDate(DateTime(2024, 6, 15));
      await tester.pumpAndSettle();

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.week(name: 'Week', displayRange: calendarRange),
      );
      expect(kalenderController.floatingVisibleRange.value, isNotNull);

      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );
      expect(kalenderController.floatingVisibleRange.value!.dominantMonthDate.month, equals(6));

      await pumpCalendarView(
        tester,
        config: ScheduleViewConfiguration.continuous(name: 'Schedule', displayRange: calendarRange),
        withBody: true,
      );
      expect(find.byType(ScheduleBody), findsOneWidget);
      expect(kalenderController.floatingVisibleRange.value, isNotNull);

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.custom(name: '3-Day', numberOfDays: 3, displayRange: calendarRange),
        withBody: true,
      );
      expect(find.byType(MultiDayBody), findsOneWidget);
      expect(kalenderController.floatingVisibleRange.value, isNotNull);
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

      final workWeekRange = kalenderController.floatingVisibleRange.value;
      expect(workWeekRange, isNotNull);
      expect(workWeekRange!.end.difference(workWeekRange.start).inDays, equals(5));
    });
  });

  group('View controller lifecycle', () {
    testWidgets('each config change creates a new view controller, also between objects of the same type', (
      tester,
    ) async {
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );
      final monthController = kalenderController.viewController;

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day 1', displayRange: calendarRange),
      );
      final dayController = kalenderController.viewController;
      expect(dayController, isNot(same(monthController)));

      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day 2', displayRange: calendarRange),
      );
      expect(kalenderController.viewController, isNot(same(dayController)));
    });
  });

  group('Edge cases', () {
    testWidgets('month → week → month when the range starts after the first day of its first week', (tester) async {
      // January 2025 starts on a Wednesday, so its first week starts on 30 December, before the range.
      final range = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 6));
      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(
          name: 'Month',
          displayRange: range,
          initialDateTime: DateTime(2025, 1, 15),
        ),
        withBody: true,
      );
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.week(name: 'Week', displayRange: range),
      );
      expect(kalenderController.floatingVisibleRange.value!.start, FloatingDateTime(2024, 12, 30));

      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: range),
      );

      expect(tester.takeException(), isNull);
      expect(kalenderController.floatingVisibleRange.value!.dominantMonthDate, DateTime.utc(2025));
    });

    testWidgets('week → paginated schedule when the week starts before the range', (tester) async {
      final range = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 6));
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.week(name: 'Week', displayRange: range, initialDateTime: DateTime(2025)),
        withBody: true,
      );
      expect(kalenderController.floatingVisibleRange.value!.start, FloatingDateTime(2024, 12, 30));

      await pumpCalendarView(
        tester,
        config: ScheduleViewConfiguration.paginated(name: 'Schedule', displayRange: range),
      );

      expect(tester.takeException(), isNull);
      expect(kalenderController.floatingVisibleRange.value!.start, FloatingDateTime(2025));
    });

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

      expect(kalenderController.viewController.viewConfiguration, same(configs.last));
    });

    testWidgets('round-trip transition preserves date context', (tester) async {
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

      final initialRange = kalenderController.floatingVisibleRange.value;

      await pumpCalendarView(
        tester,
        config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
      );
      await pumpCalendarView(
        tester,
        config: MultiDayViewConfiguration.singleDay(name: 'Day', displayRange: calendarRange),
      );

      final finalRange = kalenderController.floatingVisibleRange.value;
      expect(finalRange!.start.month, equals(initialRange!.start.month));
    });

    for (final (boundary, initialDateTime) in [('start', calendarRange.start), ('end', DateTime(2026, 12, 30))]) {
      testWidgets('day → month at the $boundary of the display range', (tester) async {
        await pumpCalendarView(
          tester,
          config: MultiDayViewConfiguration.singleDay(
            name: 'Day',
            initialDateTime: initialDateTime,
            displayRange: calendarRange,
          ),
        );

        await pumpCalendarView(
          tester,
          config: MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange),
        );

        expect(kalenderController.floatingVisibleRange.value, isNotNull);
      });
    }
  });

  group('View-transition policy (#249)', () {
    MultiDayViewController multiDay() => kalenderController.viewController as MultiDayViewController;
    MonthViewConfiguration month() => MonthViewConfiguration.singleMonth(name: 'Month', displayRange: calendarRange);
    FloatingDateTime? visibleStart() => kalenderController.floatingVisibleRange.value?.start.startOfDay;

    MultiDayViewConfiguration week({
      ScrollTransition scroll = ScrollTransition.preserve,
      ZoomTransition zoom = ZoomTransition.preserve,
      DateTransition date = DateTransition.carryFocus,
      ScrollResolver? scrollResolver,
      ZoomResolver? zoomResolver,
      DateResolver? dateResolver,
    }) => MultiDayViewConfiguration.week(
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

      expect(visibleStart(), equals(FloatingDateTime(2024, 6, 15)));
    });

    testWidgets('ScrollTransition.restorePerView restores the view\'s own last time-of-day', (tester) async {
      final day = MultiDayViewConfiguration.singleDay(
        name: 'Day',
        displayRange: calendarRange,
        scrollTransition: ScrollTransition.restorePerView,
      );
      final wk = week(scroll: ScrollTransition.restorePerView);

      await pumpCalendarView(tester, config: day, withBody: true);
      multiDay().scrollController.jumpTo(180 * 0.7);
      await tester.pump();

      await pumpCalendarView(tester, config: wk, withBody: true);
      multiDay().scrollController.jumpTo(300 * 0.7);
      await tester.pump();

      await pumpCalendarView(tester, config: day, withBody: true);
      expect(kalenderController.visibleTimeOfDay.value, equals(const KalenderTime(hour: 3, minute: 0)));
    });

    testWidgets('ZoomTransition.reset returns to initialHeightPerMinute on switch', (tester) async {
      final wk = week(zoom: ZoomTransition.reset);
      await pumpCalendarView(tester, config: wk, withBody: true);
      multiDay().heightPerMinute.value = 1.5;
      await tester.pump();

      await pumpCalendarView(tester, config: month(), withBody: true);
      await pumpCalendarView(tester, config: wk, withBody: true);

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

    testWidgets('visibleTimeOfDay is non-null in multi-day and null in month; onScrollPositionChanged fires', (
      tester,
    ) async {
      final reported = <KalenderTime>[];
      await pumpCalendarView(
        tester,
        config: week(),
        withBody: true,
        callbacks: KalenderCallbacks(onScrollPositionChanged: reported.add),
      );
      expect(kalenderController.visibleTimeOfDay.value, isNotNull);

      multiDay().scrollController.jumpTo(120 * 0.7); // 02:00
      await tester.pump();
      expect(reported.last, equals(const KalenderTime(hour: 2, minute: 0)));

      await pumpCalendarView(tester, config: month(), withBody: true);
      expect(kalenderController.visibleTimeOfDay.value, isNull);
    });
  });
}

FloatingDateTime _alwaysReturnJanuaryResolver(ViewTransitionContext transition) {
  return _fixedDate;
}

final _fixedDate = FloatingDateTime(2024, 1, 1);
