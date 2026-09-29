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
  final key = UniqueKey();
  final now = FloatingDateTime.fromDateTime(DateTime.now()).startOfWeek();
  final range = FloatingDateTimeRange(start: now, end: now.endOfWeek());

  Future<void> pumpPositioner(
    WidgetTester tester,
    MultiDayViewConfiguration viewConfiguration, {
    DateTime? dateOverride,
    FloatingDateTime? initialDate,
  }) {
    return pumpAndSettleWithMaterialApp(
      tester,
      timeIndicatorPositioner(
        viewConfiguration: viewConfiguration,
        indicatorKey: key,
        initialDate: initialDate,
        dateOverride: dateOverride,
      ),
    );
  }

  group('TimeIndicatorPositioner', () {
    final viewConfiguration = MultiDayViewConfiguration.week(displayRange: range.forLocation());

    for (final (index, date) in range.dates().map(FloatingDateTime.fromDateTime).indexed) {
      testWidgets('for date index: ($index)', (tester) async {
        await pumpPositioner(tester, viewConfiguration, dateOverride: date);
        final finder = find.byKey(key);
        expect(finder, findsOneWidget);
        expect(tester.getTopLeft(finder).dx, index * 100.0);
      });
    }
  });

  group('nowCallback', () {
    group('TimeIndicatorPositioner', () {
      group('positions indicator using callback wall-clock values', () {
        for (final (index, date) in range.dates().map(FloatingDateTime.fromDateTime).indexed) {
          testWidgets('day index $index', (tester) async {
            await pumpPositioner(
              tester,
              MultiDayViewConfiguration.week(displayRange: range.forLocation(), nowCallback: () => date),
            );
            expect(tester.getTopLeft(find.byKey(key)).dx, index * 100.0);
          });
        }
      });

      testWidgets('dateOverride takes precedence over nowCallback', (tester) async {
        final thursday = FloatingDateTime.fromDateTime(range.dates()[3]);
        final monday = FloatingDateTime.fromDateTime(range.dates()[0]);

        await pumpPositioner(
          tester,
          MultiDayViewConfiguration.week(displayRange: range.forLocation(), nowCallback: () => thursday),
          dateOverride: monday,
        );
        expect(tester.getTopLeft(find.byKey(key)).dx, 0.0);
      });

      testWidgets('null callback preserves location-based behavior', (tester) async {
        final today = FloatingDateTime.fromDateTime(DateTime.now());
        final todayWeekStart = today.startOfWeek();
        final todayRange = FloatingDateTimeRange(start: todayWeekStart, end: todayWeekStart.endOfWeek());
        final todayIndex = todayRange
            .dates()
            .map(FloatingDateTime.fromDateTime)
            .toList()
            .indexWhere((d) => d.isSameDay(today.startOfDay));

        await pumpPositioner(tester, MultiDayViewConfiguration.week(displayRange: todayRange.forLocation()));
        expect(tester.getTopLeft(find.byKey(key)).dx, todayIndex * 100.0);
      });

      testWidgets('singleDay config with callback', (tester) async {
        final monday = FloatingDateTime.fromDateTime(range.dates()[0]);

        await pumpPositioner(
          tester,
          MultiDayViewConfiguration.singleDay(displayRange: range.forLocation(), nowCallback: () => monday),
          initialDate: monday,
        );
        expect(tester.getTopLeft(find.byKey(key)).dx, 0.0);
      });
    });

    group('ViewConfiguration copyWith preserves nowCallback', () {
      final constructors = [
        (name: 'week', build: (NowCallback callback) => MultiDayViewConfiguration.week(nowCallback: callback)),
        (
          name: 'singleDay',
          build: (NowCallback callback) => MultiDayViewConfiguration.singleDay(nowCallback: callback),
        ),
        (name: 'workWeek', build: (NowCallback callback) => MultiDayViewConfiguration.workWeek(nowCallback: callback)),
        (
          name: 'custom',
          build: (NowCallback callback) => MultiDayViewConfiguration.custom(numberOfDays: 3, nowCallback: callback),
        ),
        (
          name: 'freeScroll',
          build: (NowCallback callback) => MultiDayViewConfiguration.freeScroll(numberOfDays: 3, nowCallback: callback),
        ),
      ];

      for (final constructor in constructors) {
        test('MultiDayViewConfiguration.${constructor.name} copyWith', () {
          DateTime callback() => DateTime(2026, 4, 13, 14, 0);
          final copy = constructor.build(callback).copyWith(name: 'Modified');
          expect(copy.nowCallback, same(callback));
        });
      }

      test('copyWith can override nowCallback', () {
        DateTime original() => DateTime(2026, 4, 13, 14, 0);
        DateTime replacement() => DateTime(2026, 4, 13, 9, 0);
        final config = MultiDayViewConfiguration.week(nowCallback: original);
        final copy = config.copyWith(nowCallback: replacement);
        expect(copy.nowCallback, same(replacement));
      });

      test('null by default', () {
        final config = MultiDayViewConfiguration.week();
        expect(config.nowCallback, isNull);
      });
    });
  });
}
