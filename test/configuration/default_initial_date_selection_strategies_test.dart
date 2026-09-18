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

  final strategies = {
    'kDefaultToMonthly': kDefaultToMonthly,
    'kDefaultToWeekly': kDefaultToWeekly,
    'kDefaultToDaily': kDefaultToDaily,
    'kDefaultToSchedule': kDefaultToSchedule,
  };

  for (final location in locations) {
    final range = KalenderDateTimeRange(start: TZDateTime(location, 2025), end: TZDateTime(location, 2026));
    final visibleEvents = ValueNotifier(<KalenderEvent>{});

    // The constructors overwrite the initial visible range.
    ViewController build(ViewConfiguration config) {
      final floatingVisibleRange = ValueNotifier(
        FloatingDateTimeRange(start: FloatingDateTime(2025), end: FloatingDateTime(2025, 2)),
      );
      final initialDate = FloatingDateTime(2025, 1, 1);
      return switch (config) {
        final MonthViewConfiguration config => MonthViewController(
          viewConfiguration: config,
          floatingVisibleRange: floatingVisibleRange,
          visibleEvents: visibleEvents,
          initialDate: initialDate,
        ),
        final MultiDayViewConfiguration config => MultiDayViewController(
          viewConfiguration: config,
          floatingVisibleRange: floatingVisibleRange,
          visibleEvents: visibleEvents,
          initialDate: initialDate,
        ),
        final ScheduleViewConfiguration config => ContinuousScheduleViewController(
          viewConfiguration: config,
          floatingVisibleRange: floatingVisibleRange,
          visibleEvents: visibleEvents,
          initialDate: initialDate,
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
      (
        name: 'Month',
        config: MonthViewConfiguration.singleMonth(displayRange: range),
        expected: dominantJanuary,
        routesTo: 'kDefaultToMonthly',
      ),
      (name: 'Week', config: week, expected: monthOrWeekStart, routesTo: 'kDefaultToWeekly'),
      (
        name: 'WorkWeek',
        config: MultiDayViewConfiguration.workWeek(displayRange: range),
        expected: monthOrWeekStart,
        routesTo: 'kDefaultToWeekly',
      ),
      (
        name: 'Day',
        config: MultiDayViewConfiguration.singleDay(displayRange: range),
        expected: dayStart,
        routesTo: 'kDefaultToDaily',
      ),
      (name: 'Custom(3)', config: custom3, expected: visibleStart(custom3), routesTo: 'kDefaultToWeekly'),
      (
        name: 'Custom(1)',
        config: MultiDayViewConfiguration.custom(numberOfDays: 1, displayRange: range),
        expected: dayStart,
        routesTo: 'kDefaultToDaily',
      ),
      (name: 'Schedule', config: schedule, expected: visibleStart(schedule), routesTo: 'kDefaultToSchedule'),
    ];

    for (final MapEntry(key: name, value: strategy) in strategies.entries) {
      group('[$location] $name', () {
        for (final view in views) {
          test('from ${view.name}', () {
            expect(strategy(build(view.config)), view.expected);
          });
        }
      });
    }

    group('[$location] kCarryFocusDate routing', () {
      for (final view in views) {
        test('to ${view.name} routes to ${view.routesTo}', () {
          expect(kCarryFocusDate(_ctx(build(week), view.config)), strategies[view.routesTo]!(build(week)));
        });
      }
    });
  }
}

ViewTransitionContext _ctx(ViewController old, ViewConfiguration next) =>
    ViewTransitionContext(oldViewController: old, newViewConfiguration: next, byView: const {}, lastMultiDay: null);
