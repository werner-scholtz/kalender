// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/view_switch_area.dart';

import '../utilities.dart';

/// [ColumnMorph]: where the day columns of two multi-day pages sit while one turns into the other.
void main() {
  final week = MultiDayViewConfiguration.week(displayRange: year2025DisplayRange);
  final threeDays = MultiDayViewConfiguration.custom(displayRange: year2025DisplayRange, numberOfDays: 3);
  final freeScroll = MultiDayViewConfiguration.freeScroll(displayRange: year2025DisplayRange, numberOfDays: 3);
  final month = MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange);

  FloatingDateTimeRange days(int startDay, int count) =>
      FloatingDateTimeRange(start: DateTime.utc(2025, 3, startDay), end: DateTime.utc(2025, 3, startDay + count));

  /// The left edge of the column of [day], as a fraction of the width, on a page of [count] days from [startDay].
  double edge(ColumnTransform transform, int day, int startDay, int count) {
    return (day - startDay) / count * transform.scale + transform.shift;
  }

  final cases = [
    (name: 'a week to three days inside it', from: (3, 7), to: (5, 3)),
    (name: 'three days to the week around them', from: (5, 3), to: (3, 7)),
    (name: 'a week to three days overlapping its end', from: (3, 7), to: (8, 3)),
    (name: 'three days to a week starting after them', from: (1, 3), to: (3, 7)),
  ];
  for (final c in cases) {
    test('${c.name} keeps every date in the same place in both pages', () {
      final (fromStart, fromCount) = c.from;
      final (toStart, toCount) = c.to;
      final from = fromCount == 7 ? week : threeDays;
      final to = toCount == 7 ? week : threeDays;
      final morph = ColumnMorph.between(from, days(fromStart, fromCount), to, days(toStart, toCount))!;

      final misplaced = <String>[];
      for (final t in [0.0, 0.25, 0.5, 1.0]) {
        for (var day = 1; day <= 14; day++) {
          final outgoing = edge(morph.outgoingAt(t), day, fromStart, fromCount);
          final incoming = edge(morph.incomingAt(t), day, toStart, toCount);
          if ((outgoing - incoming).abs() > 1e-9) misplaced.add('t $t, day $day');
        }
      }

      expect(
        (misplaced.join(', '), morph.outgoingAt(0), morph.incomingAt(1)),
        ('', ColumnTransform.identity, ColumnTransform.identity),
      );
    });
  }

  test('pages that share no day, or a free-scrolling or month view, have no morph', () {
    expect(
      [
        ColumnMorph.between(week, days(3, 7), threeDays, days(10, 3)),
        ColumnMorph.between(week, days(3, 7), threeDays, days(0, 3)),
        ColumnMorph.between(week, days(3, 7), freeScroll, days(5, 3)),
        ColumnMorph.between(week, days(3, 7), month, days(1, 31)),
      ],
      [null, null, null, null],
    );
  });
}
