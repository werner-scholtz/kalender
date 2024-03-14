import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:timezone/standalone.dart';

import 'utils.dart';

void main() {
  timezoneTest(
    (zone, now) {
      group(zone.name, () {
        final calendarStart = TZDateTime(zone, now.year);
        final calendarEnd = TZDateTime(zone, now.year + 1);

        for (var i = 1; i < 15; i++) {
          testCustomMultiDayV2(
            start: calendarStart,
            end: calendarEnd,
            numberOfDays: 1,
          );
        }
      });
    },
  );
}

void testCustomMultiDayV2({
  required TZDateTime start,
  required TZDateTime end,
  required int numberOfDays,
}) {
  final multiDayViewConfig = CustomMultiDayConfiguration(
    name: 'test',
    numberOfDays: numberOfDays,
  );

  final adjustedRange = multiDayViewConfig.calculateAdjustedDateTimeRange(
    dateTimeRange: DateTimeRange(start: start, end: end),
    visibleStart: start,
  );
  final remainder = adjustedRange.dayDifference % numberOfDays;

  test('calculateAdjustedDateTimeRange', () {
    expect(remainder, 0);
  });

  final numberOfPages = multiDayViewConfig.calculateNumberOfPages(
    adjustedRange,
  );
  final expectedNumberOfPages = adjustedRange.dayDifference ~/ numberOfDays;

  test('calculateNumberOfPages', () {
    expect(numberOfPages, expectedNumberOfPages);
  });
}

void testCustomMultiDay({
  required DateTimeRange calendarRange,
  required int numberOfDays,
}) {
  final calendarStart = calendarRange.start;

  group('CustomMultiDayConfiguration $numberOfDays', () {
    final multiDayViewConfig = CustomMultiDayConfiguration(
      name: 'test',
      numberOfDays: numberOfDays,
    );

    final adjustedRange = multiDayViewConfig.calculateAdjustedDateTimeRange(
      dateTimeRange: calendarRange,
      visibleStart: calendarStart,
    );
    final remainder = adjustedRange.dayDifference % numberOfDays;

    test('calculateAdjustedDateTimeRange', () {
      expect(remainder, 0);
    });

    final numberOfPages = multiDayViewConfig.calculateNumberOfPages(
      adjustedRange,
    );
    final expectedNumberOfPages = adjustedRange.dayDifference ~/ numberOfDays;

    test('calculateNumberOfPages', () {
      expect(numberOfPages, expectedNumberOfPages);
    });

    final datesToTest = adjustedRange.datesSpanned;

    final indexedDateMap = <int, Iterable<DateTime>>{};
    for (var i = 0; i < numberOfPages; i++) {
      final dates = datesToTest.skip(i * numberOfDays).take(numberOfDays);
      indexedDateMap.putIfAbsent(i, () => dates);
    }

    final indexedDateRangeMap = <int, DateTimeRange>{};
    for (var i = 0; i < numberOfPages; i++) {
      final dates = indexedDateMap[i]!;
      final dateRange = DateTimeRange(
        start: dates.first,
        end: dates.first.add(Duration(days: numberOfDays)),
      );
      indexedDateRangeMap.putIfAbsent(i, () => dateRange);
    }

    for (final date in datesToTest) {
      final pageIndex = multiDayViewConfig.calculateDateIndex(
        date,
        adjustedRange.start,
      );

      final present = indexedDateMap[pageIndex]?.contains(date) ?? false;

      test('calculateDateIndex', () {
        expect(present, true);
      });
    }

    for (var i = 0; i < numberOfPages; i++) {
      final visibleDateRange =
          multiDayViewConfig.calculateVisibleDateRangeForIndex(
        index: i,
        calendarStart: calendarStart,
      );

      final expectedVisibleDateRange = indexedDateRangeMap[i];

      test('calculateVisibleDateRangeForIndex', () {
        expect(visibleDateRange, expectedVisibleDateRange);
      });
    }

    for (final date in datesToTest) {
      final visibleDateTimeRange =
          multiDayViewConfig.calculateVisibleDateTimeRange(date);

      final expectedVisibleDateTimeRange =
          date.multiDayDateTimeRange(numberOfDays);

      test('calculateVisibleDateTimeRange', () {
        expect(visibleDateTimeRange, expectedVisibleDateTimeRange);
      });
    }
  });
}
