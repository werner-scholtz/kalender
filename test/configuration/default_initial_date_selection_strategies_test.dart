// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart';

import '../utilities.dart';

void main() {
  initializeTimeZones();
  final locations = locationsToTest.map(getLocation).toList();

  for (final location in locations) {
    final range = KalenderDateTimeRange(start: TZDateTime(location, 2025), end: TZDateTime(location, 2026));
    final visibleEvents = ValueNotifier(<KalenderEvent>{});

    // The constructors overwrite the initial visible range.
    ViewController build(ViewConfiguration config) {
      final floatingVisibleRange = ValueNotifier(
        FloatingDateTimeRange(start: FloatingDateTime(2025), end: FloatingDateTime(2025, 2)),
      );
      final initial = ViewSnapshot(date: FloatingDateTime(2025, 1, 1));
      return switch (config) {
        final MonthViewConfiguration config => MonthViewController(
          viewConfiguration: config,
          floatingVisibleRange: floatingVisibleRange,
          visibleEvents: visibleEvents,
          initial: initial,
        ),
        final MultiDayViewConfiguration config => MultiDayViewController(
          viewConfiguration: config,
          floatingVisibleRange: floatingVisibleRange,
          visibleEvents: visibleEvents,
          initial: initial,
        ),
        final ScheduleViewConfiguration config => ContinuousScheduleViewController(
          viewConfiguration: config,
          floatingVisibleRange: floatingVisibleRange,
          visibleEvents: visibleEvents,
          initial: initial,
        ),
        _ => throw ArgumentError.value(config),
      };
    }

    FloatingDateTime visibleStart(ViewConfiguration config) => build(config).floatingVisibleRange.value!.start;

    // Month, week and work week start on the Monday of the week containing 1 January in every location. Custom(3)
    // and schedule anchor page 0 to the display-range start, which moves with the UTC offset, so their starts come
    // from the controllers.
    final monthOrWeekStart = FloatingDateTime(2024, 12, 30);
    final dayStart = FloatingDateTime(2025, 1, 1);
    final dominantJanuary = FloatingDateTime(2025, 1, 1);

    final week = MultiDayViewConfiguration.week(displayRange: range);
    final custom3 = MultiDayViewConfiguration.custom(numberOfDays: 3, displayRange: range);
    final schedule = ScheduleViewConfiguration.continuous(displayRange: range);

    final views = [
      (name: 'Month', config: MonthViewConfiguration.singleMonth(displayRange: range), expected: dominantJanuary),
      (name: 'Week', config: week, expected: monthOrWeekStart),
      (name: 'WorkWeek', config: MultiDayViewConfiguration.workWeek(displayRange: range), expected: monthOrWeekStart),
      (name: 'Day', config: MultiDayViewConfiguration.singleDay(displayRange: range), expected: dayStart),
      (name: 'Custom(3)', config: custom3, expected: visibleStart(custom3)),
      (
        name: 'Custom(1)',
        config: MultiDayViewConfiguration.custom(numberOfDays: 1, displayRange: range),
        expected: dayStart,
      ),
      (name: 'Schedule', config: schedule, expected: visibleStart(schedule)),
    ];

    test('[$location] the deprecated functions return the carried date', () {
      final old = build(week);
      // ignore: deprecated_member_use_from_same_package
      final deprecated = [kDefaultToMonthly, kDefaultToWeekly, kDefaultToDaily, kDefaultToSchedule];
      expect(deprecated.map((function) => function(old)), everyElement(monthOrWeekStart));
    });

    group('[$location] kCarryFocusDate', () {
      for (final view in views) {
        test('from ${view.name}', () {
          expect(kCarryFocusDate(_ctx(build(view.config), week)), view.expected);
        });
      }
    });
  }
}

ViewTransitionContext _ctx(ViewController old, ViewConfiguration next) =>
    ViewTransitionContext(oldViewController: old, newViewConfiguration: next, byView: const {}, lastMultiDay: null);
