// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/view_configurations/page_index_calculator.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart';

import '../utilities.dart';

void main() {
  initializeTimeZones();
  final locations = locationsToTest.map(getLocation).toList();

  void testRangeFromIndex(PageIndexCalculator calculator, Location location, Map<int, FloatingDateTimeRange> ranges) {
    for (final MapEntry(key: index, value: range) in ranges.entries) {
      test('rangeFromIndex($index)', () {
        expect(calculator.rangeFromIndex(index, location), range);
      });
    }
  }

  void testIndexFromDate(PageIndexCalculator calculator, Location location, Map<DateTime, int> indices) {
    for (final MapEntry(key: date, value: index) in indices.entries) {
      test('indexFromDate($date)', () {
        expect(calculator.indexFromDate(date, location), index);
      });
    }
  }

  void testPages(PageIndexCalculator calculator, Location location, Map<int, FloatingDateTimeRange> pages) {
    testRangeFromIndex(calculator, location, pages);
    testIndexFromDate(calculator, location, {
      for (final MapEntry(key: index, value: page) in pages.entries) page.start.forLocation(location: location): index,
    });
  }

  for (final location in locations) {
    final range = KalenderDateTimeRange(start: TZDateTime(location, 2020), end: TZDateTime(location, 2021));
    group('DayIndexCalculator for $location', () {
      final calculator = DayIndexCalculator(start: range.start, end: range.end);

      testPages(calculator, location, {
        0: FloatingDateTimeRange(start: FloatingDateTime(2020), end: FloatingDateTime(2020, 1, 2)),
        1: FloatingDateTimeRange(start: FloatingDateTime(2020, 1, 2), end: FloatingDateTime(2020, 1, 3)),
        166: FloatingDateTimeRange(start: FloatingDateTime(2020, 6, 15), end: FloatingDateTime(2020, 6, 16)),
        365: FloatingDateTimeRange(start: FloatingDateTime(2020, 12, 31), end: FloatingDateTime(2021, 1, 1)),
      });
      testRangeFromIndex(calculator, location, {
        366: FloatingDateTimeRange(start: FloatingDateTime(2021), end: FloatingDateTime(2021, 1, 2)),
      });
      // range.end is the exclusive end of the range, so it clamps to the last page index.
      testIndexFromDate(calculator, location, {range.end: 365});

      test('numberOfPages', () {
        expect(calculator.numberOfPages(location), 366);
      });

      test('floatingRange', () {
        final floatingRange = calculator.floatingRange(location);
        expect(floatingRange, FloatingDateTimeRange.fromDateTimeRange(range));
      });

      // An empty range (start == end) has 0 pages; indexFromDate must not throw
      // on the negative clamp bound, and should fall back to index 0.
      test('indexFromDate for an empty range', () {
        final emptyRange = KalenderDateTimeRange(start: TZDateTime(location, 2020), end: TZDateTime(location, 2020));
        final emptyCalculator = DayIndexCalculator(start: emptyRange.start, end: emptyRange.end);
        expect(emptyCalculator.numberOfPages(location), 0);
        expect(() => emptyCalculator.indexFromDate(TZDateTime(location, 2020), location), returnsNormally);
        expect(emptyCalculator.indexFromDate(TZDateTime(location, 2020), location), 0);
      });
    });

    group('freeScroll for $location', () {
      test('the band maps a day per index, the same as a single day view', () {
        expect(PageIndexCalculator.freeScroll(range), isA<DayIndexCalculator>());
      });

      test('a range ending at midnight is not extended by a day', () {
        final calculator = PageIndexCalculator.freeScroll(range);
        expect(calculator.numberOfPages(location), 366);

        final last = calculator.rangeFromIndex(calculator.numberOfPages(location) - 1, location);
        expect(last.start, FloatingDateTime(2020, 12, 31));
        expect(last.end, FloatingDateTime(2021));
      });

      test('a range ending mid-day still covers the part day', () {
        final partDay = KalenderDateTimeRange(
          start: TZDateTime(location, 2020),
          end: TZDateTime(location, 2020, 1, 8, 13, 30),
        );
        final calculator = PageIndexCalculator.freeScroll(partDay);
        expect(calculator.numberOfPages(location), 8);
      });
    });

    group('WeekIndexCalculator for $location', () {
      final calculator = WeekIndexCalculator.week(start: range.start, end: range.end, firstDayOfWeek: DateTime.monday);

      testPages(calculator, location, {
        0: FloatingDateTimeRange(start: FloatingDateTime(2019, 12, 30), end: FloatingDateTime(2020, 1, 6)),
        1: FloatingDateTimeRange(start: FloatingDateTime(2020, 1, 6), end: FloatingDateTime(2020, 1, 13)),
        9: FloatingDateTimeRange(start: FloatingDateTime(2020, 3, 2), end: FloatingDateTime(2020, 3, 9)),
        51: FloatingDateTimeRange(start: FloatingDateTime(2020, 12, 21), end: FloatingDateTime(2020, 12, 28)),
        52: FloatingDateTimeRange(start: FloatingDateTime(2020, 12, 28), end: FloatingDateTime(2021, 1, 4)),
      });

      test('numberOfPages', () {
        expect(calculator.numberOfPages(location), 53);
      });

      test('floatingRange', () {
        final floatingRange = calculator.floatingRange(location);
        expect(
          floatingRange,
          FloatingDateTimeRange(start: FloatingDateTime(2019, 12, 30), end: FloatingDateTime(2021, 1, 4)),
        );
      });
    });

    group('WeekIndexCalculator with six days for $location', () {
      final calculator = WeekIndexCalculator(
        start: range.start,
        end: range.end,
        firstDayOfWeek: DateTime.monday,
        daysToDisplay: 6,
      );

      test('a page ends after six days', () {
        expect(
          calculator.rangeFromIndex(0, location),
          FloatingDateTimeRange(start: FloatingDateTime(2019, 12, 30), end: FloatingDateTime(2020, 1, 5)),
        );
        expect(
          calculator.rangeFromIndex(1, location),
          FloatingDateTimeRange(start: FloatingDateTime(2020, 1, 6), end: FloatingDateTime(2020, 1, 12)),
        );
      });

      test('pagination is unchanged', () {
        expect(calculator.indexFromDate(TZDateTime(location, 2020, 1, 6), location), 1);
        expect(calculator.indexFromDate(TZDateTime(location, 2020, 3, 2), location), 9);
        expect(calculator.numberOfPages(location), 53);
        expect(
          calculator.floatingRange(location),
          FloatingDateTimeRange(start: FloatingDateTime(2019, 12, 30), end: FloatingDateTime(2021, 1, 4)),
        );
      });

      test('the day the page drops is still reachable', () {
        // Sunday 5 January 2020 is not displayed, but asking for it must land on
        // the page that starts the week it belongs to.
        expect(calculator.indexFromDate(TZDateTime(location, 2020, 1, 5), location), 0);
      });
    });

    group('CustomIndexCalculator for $location', () {
      final calculator = CustomIndexCalculator(start: range.start, end: range.end, numberOfDays: 3);

      testPages(calculator, location, {
        0: FloatingDateTimeRange(start: FloatingDateTime(2020), end: FloatingDateTime(2020, 1, 4)),
        1: FloatingDateTimeRange(start: FloatingDateTime(2020, 1, 4), end: FloatingDateTime(2020, 1, 7)),
        9: FloatingDateTimeRange(start: FloatingDateTime(2020, 1, 28), end: FloatingDateTime(2020, 1, 31)),
        120: FloatingDateTimeRange(start: FloatingDateTime(2020, 12, 26), end: FloatingDateTime(2020, 12, 29)),
        121: FloatingDateTimeRange(start: FloatingDateTime(2020, 12, 29), end: FloatingDateTime(2021)),
      });

      test('numberOfPages', () {
        expect(calculator.numberOfPages(location), 122);
      });

      test('floatingRange', () {
        final floatingRange = calculator.floatingRange(location);
        expect(floatingRange, FloatingDateTimeRange(start: FloatingDateTime(2020), end: FloatingDateTime(2021)));
      });
    });

    group('MonthIndexCalculator for $location', () {
      final calculator = MonthIndexCalculator.fromRange(range, DateTime.monday);

      testRangeFromIndex(calculator, location, {
        0: FloatingDateTimeRange(start: FloatingDateTime(2019, 12, 30), end: FloatingDateTime(2020, 2, 3)),
        1: FloatingDateTimeRange(start: FloatingDateTime(2020, 1, 27), end: FloatingDateTime(2020, 3, 2)),
        9: FloatingDateTimeRange(start: FloatingDateTime(2020, 9, 28), end: FloatingDateTime(2020, 11, 2)),
        10: FloatingDateTimeRange(start: FloatingDateTime(2020, 10, 26), end: FloatingDateTime(2020, 12, 07)),
        11: FloatingDateTimeRange(start: FloatingDateTime(2020, 11, 30), end: FloatingDateTime(2021, 1, 4)),
      });
      testIndexFromDate(calculator, location, {
        TZDateTime(location, 2020): 0,
        TZDateTime(location, 2020, 2, 3): 1,
        TZDateTime(location, 2020, 6, 2): 5,
        TZDateTime(location, 2020, 11, 26): 10,
        TZDateTime(location, 2020, 12, 31): 11,
      });

      test('indexFromDate outside the range', () {
        expect(calculator.indexFromDate(TZDateTime(location, 2019, 12, 30), location), 0);
        expect(calculator.indexFromDate(TZDateTime(location, 2018, 6, 15), location), 0);
        expect(calculator.indexFromDate(TZDateTime(location, 2021, 3, 1), location), 11);
      });

      test('an empty range has one index', () {
        final empty = MonthIndexCalculator(
          start: TZDateTime(location, 2020, 3),
          end: TZDateTime(location, 2020, 3),
          firstDayOfWeek: 1,
        );
        expect(empty.numberOfPages(location), 0);
        expect(empty.indexFromDate(TZDateTime(location, 2020, 3), location), 0);
      });

      test('numberOfPages', () {
        expect(calculator.numberOfPages(location), 12);
      });

      test('floatingRange', () {
        final floatingRange = calculator.floatingRange(location);
        expect(floatingRange, FloatingDateTimeRange(start: FloatingDateTime(2020), end: FloatingDateTime(2021)));
      });

      // Regression test for #266.
      test('numberOfPages for a single-month range', () {
        final singleMonth = MonthIndexCalculator(
          start: TZDateTime(location, 2020, 5),
          end: TZDateTime(location, 2020, 5, 31),
          firstDayOfWeek: DateTime.monday,
        );
        expect(singleMonth.numberOfPages(location), 1);
        expect(singleMonth.indexFromDate(TZDateTime(location, 2020, 5, 15), location), 0);
      });
    });

    group('ContinuousScheduleIndexCalculator for $location', () {
      final calculator = ContinuousScheduleIndexCalculator(start: range.start, end: range.end);

      test('rangeFromIndex and floatingRange are the whole range', () {
        final wholeRange = FloatingDateTimeRange(start: FloatingDateTime(2020), end: FloatingDateTime(2021));
        expect(calculator.rangeFromIndex(0, location), wholeRange);
        expect(calculator.floatingRange(location), wholeRange);
      });

      test('indexFromDate', () {
        final index = calculator.indexFromDate(TZDateTime(location, 2020), location);
        expect(index, 0);
      });

      test('numberOfPages', () {
        expect(calculator.numberOfPages(location), 1);
      });
    });

    group('PaginatedScheduleIndexCalculator for $location', () {
      final calculator = PaginatedScheduleIndexCalculator(start: range.start, end: range.end);

      testRangeFromIndex(calculator, location, {
        0: FloatingDateTimeRange(start: FloatingDateTime(2020), end: FloatingDateTime(2020, 2)),
        1: FloatingDateTimeRange(start: FloatingDateTime(2020, 2), end: FloatingDateTime(2020, 3)),
        9: FloatingDateTimeRange(start: FloatingDateTime(2020, 10), end: FloatingDateTime(2020, 11)),
        10: FloatingDateTimeRange(start: FloatingDateTime(2020, 11), end: FloatingDateTime(2020, 12)),
        11: FloatingDateTimeRange(start: FloatingDateTime(2020, 12), end: FloatingDateTime(2021)),
      });
      testIndexFromDate(calculator, location, {
        TZDateTime(location, 2020): 0,
        TZDateTime(location, 2020, 2, 3): 1,
        TZDateTime(location, 2020, 6, 2): 5,
        TZDateTime(location, 2020, 11, 26): 10,
        TZDateTime(location, 2020, 12, 31): 11,
      });

      test('indexFromDate outside the range', () {
        expect(calculator.indexFromDate(TZDateTime(location, 2019, 12, 30), location), 0);
        expect(calculator.indexFromDate(TZDateTime(location, 2018, 6, 15), location), 0);
        expect(calculator.indexFromDate(TZDateTime(location, 2021, 3, 1), location), 11);
      });

      test('an empty range has one index', () {
        final empty = PaginatedScheduleIndexCalculator(
          start: TZDateTime(location, 2020, 3),
          end: TZDateTime(location, 2020, 3),
        );
        expect(empty.numberOfPages(location), 0);
        expect(empty.indexFromDate(TZDateTime(location, 2020, 3), location), 0);
      });

      test('numberOfPages', () {
        expect(calculator.numberOfPages(location), 12);
      });

      test('floatingRange', () {
        final floatingRange = calculator.floatingRange(location);
        expect(floatingRange, FloatingDateTimeRange(start: FloatingDateTime(2020), end: FloatingDateTime(2021)));
      });
    });
  }
}
