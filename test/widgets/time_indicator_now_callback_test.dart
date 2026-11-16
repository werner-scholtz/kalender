// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  final key = UniqueKey();
  final monday = FloatingDateTime(2031, 3, 3);
  final range = FloatingDateTimeRange(start: monday, end: monday.endOfWeek());

  Future<void> pumpPositioner(
    WidgetTester tester,
    MultiDayViewConfiguration viewConfiguration, {
    FloatingDateTime? initialDate,
  }) {
    return pumpAndSettleWithMaterialApp(
      tester,
      timeIndicatorPositioner(viewConfiguration: viewConfiguration, indicatorKey: key, initialDate: initialDate),
    );
  }

  group('TimeIndicatorPositioner without a callback reads the clock', () {
    for (var index = 0; index < 7; index++) {
      testWidgets('day index $index', (tester) async {
        await withClock(Clock.fixed(DateTime(2031, 3, 3 + index, 12)), () async {
          await pumpPositioner(tester, MultiDayViewConfiguration.week(displayRange: range.forLocation()));
          expect(tester.getTopLeft(find.byKey(key)).dx, index * 100.0);
        });
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

      testWidgets('singleDay config with callback', (tester) async {
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
