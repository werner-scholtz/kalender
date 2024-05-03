import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';

void main() {
  group('ViewConfiguration Tests', () {
    final start = DateTime(2024, 1, 1);
    final end = DateTime(2025, 1, 1);

    _testMonthConfigurations(start: start, end: end);

    _testMultiDayConfigurations(start: start, end: end);

    _testScheduleConfigurations(start: start, end: end);
  });
}

/// Tests for [MonthViewConfiguration].
///
///   - [MonthConfiguration]
void _testMonthConfigurations({
  required DateTime start,
  required DateTime end,
}) {
  final calendarRange = DateTimeRange(start: start, end: end);

  final datesToTest = <DateTime, int>{
    DateTime(start.year, 1, 1): 0,
    DateTime(start.year, 2, 1): 1,
    DateTime(start.year, 3, 1): 2,
    DateTime(start.year, 4, 1): 3,
    DateTime(start.year, 5, 1): 4,
    DateTime(start.year, 6, 1): 5,
    DateTime(start.year, 7, 1): 6,
    DateTime(start.year, 8, 1): 7,
    DateTime(start.year, 9, 1): 8,
    DateTime(start.year, 10, 1): 9,
    DateTime(start.year, 11, 1): 10,
    DateTime(start.year, 12, 1): 11,
    DateTime(start.year, 12, 31): 11,
  };

  test('MonthConfiguration Tests', () {
    final config = MonthConfiguration();

    final adjustedDateTimeRange = config.calculateAdjustedDateTimeRange(
      dateTimeRange: calendarRange,
    );

    final numberOfMonths = adjustedDateTimeRange.monthDifference;
    expect(
      numberOfMonths,
      12,
    );

    final numberOfPages = config.calculateNumberOfPages(
      adjustedDateTimeRange,
    );

    expect(
      numberOfPages,
      12,
      reason: 'The number of pages must be 13 in this test',
    );

    for (final entry in datesToTest.entries) {
      final date = entry.key;
      final index = config.calculateDateIndex(date, start);

      expect(
        index,
        entry.value,
        reason: 'The index must be ${entry.value} for $date',
      );
    }
  });
}

/// Tests for [MultiDayViewConfiguration].
///
/// - [CustomMultiDayConfiguration]
/// - [DayConfiguration]
/// - [MultiWeekConfiguration]
/// - [WeekConfiguration]
/// - [WorkWeekConfiguration]
void _testMultiDayConfigurations({
  required DateTime start,
  required DateTime end,
}) {
  final calendarRange = DateTimeRange(start: start, end: end);

  final datesToTest = [
    DateTime(start.year, 1, 1),
    DateTime(start.year, 2, 1),
    DateTime(start.year, 3, 1),
    DateTime(start.year, 4, 1),
    DateTime(start.year, 5, 1),
    DateTime(start.year, 6, 1),
    DateTime(start.year, 7, 1),
    DateTime(start.year, 8, 1),
    DateTime(start.year, 9, 1),
    DateTime(start.year, 10, 1),
    DateTime(start.year, 11, 1),
    DateTime(start.year, 12, 1),
  ];

  // For now use the precalculated indexes. for the year 2024-2025
  final dayIndexes = {
    1: [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335],
    2: [0, 15, 30, 45, 60, 76, 91, 106, 122, 137, 152, 167],
    3: [0, 10, 20, 30, 40, 50, 60, 71, 81, 91, 101, 111],
    4: [0, 7, 15, 22, 30, 38, 45, 53, 61, 68, 76, 83],
    5: [0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 61, 67],
    6: [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55],
    7: [0, 4, 8, 13, 17, 21, 26, 30, 34, 39, 43, 47],
    14: [0, 2, 4, 6, 8, 10, 13, 15, 17, 19, 21, 23],
  };

  test('CustomMultiDayConfiguration Tests', () {
    for (var i = 1; i <= 7; i++) {
      final config = CustomMultiDayConfiguration(
        name: '$i',
        numberOfDays: i,
      );

      final adjustedDateTimeRange = config.calculateAdjustedDateTimeRange(
        dateTimeRange: calendarRange,
      );

      final numberOfDaysRemainder = adjustedDateTimeRange.duration.inDays % i;

      expect(
        numberOfDaysRemainder,
        0,
        reason: 'The number of days must be a multiple of $i',
      );

      final numberOfPages = config.calculateNumberOfPages(
        adjustedDateTimeRange,
      );

      final expectedNumberOfPages = adjustedDateTimeRange.duration.inDays ~/ i;

      expect(
        numberOfPages,
        expectedNumberOfPages,
        reason: 'The number of pages must be $expectedNumberOfPages',
      );

      for (final date in datesToTest) {
        final index = config.calculateDateIndex(date, start);
        expect(
          index,
          dayIndexes[i]![datesToTest.indexOf(date)],
        );
      }
    }
  });

  test('DayConfiguration Tests', () {
    final config = DayConfiguration();

    final adjustedDateTimeRange = config.calculateAdjustedDateTimeRange(
      dateTimeRange: calendarRange,
    );

    final numberOfDaysRemainder = adjustedDateTimeRange.duration.inDays % 1;

    expect(
      numberOfDaysRemainder,
      0,
      reason: 'The number of days must be a multiple of 1',
    );

    final numberOfPages = config.calculateNumberOfPages(
      adjustedDateTimeRange,
    );

    final expectedNumberOfPages = adjustedDateTimeRange.duration.inDays ~/ 1;

    expect(
      numberOfPages,
      expectedNumberOfPages,
      reason: 'The number of pages must be $expectedNumberOfPages',
    );

    for (final date in datesToTest) {
      final index = config.calculateDateIndex(date, start);
      expect(
        index,
        dayIndexes[1]![datesToTest.indexOf(date)],
      );
    }
  });

  test('MultiWeekConfiguration Tests', () {
    final config = MultiWeekConfiguration();

    final adjustedDateTimeRange = config.calculateAdjustedDateTimeRange(
      dateTimeRange: calendarRange,
    );

    final numberOfDaysRemainder = adjustedDateTimeRange.duration.inDays % 14;

    expect(
      numberOfDaysRemainder,
      0,
      reason: 'The number of days must be a multiple of 7',
    );

    final numberOfPages = config.calculateNumberOfPages(
      adjustedDateTimeRange,
    );

    final expectedNumberOfPages = adjustedDateTimeRange.duration.inDays ~/ 14;

    expect(
      numberOfPages,
      expectedNumberOfPages,
      reason: 'The number of pages must be $expectedNumberOfPages',
    );

    for (final date in datesToTest) {
      final index = config.calculateDateIndex(date, start);
      expect(
        index,
        dayIndexes[14]![datesToTest.indexOf(date)],
      );
    }
  });

  test('WeekConfiguration Tests', () {
    final config = WeekConfiguration();

    final adjustedDateTimeRange = config.calculateAdjustedDateTimeRange(
      dateTimeRange: calendarRange,
    );

    final numberOfDaysRemainder = adjustedDateTimeRange.duration.inDays % 7;

    expect(
      numberOfDaysRemainder,
      0,
      reason: 'The number of days must be a multiple of 7',
    );

    final numberOfPages = config.calculateNumberOfPages(
      adjustedDateTimeRange,
    );

    final expectedNumberOfPages = adjustedDateTimeRange.duration.inDays ~/ 7;

    expect(
      numberOfPages,
      expectedNumberOfPages,
      reason: 'The number of pages must be $expectedNumberOfPages',
    );

    for (final date in datesToTest) {
      final index = config.calculateDateIndex(date, start);
      expect(
        index,
        dayIndexes[7]![datesToTest.indexOf(date)],
      );
    }
  });

  test('WorkWeekConfiguration Tests', () {
    final config = WorkWeekConfiguration();

    final adjustedDateTimeRange = config.calculateAdjustedDateTimeRange(
      dateTimeRange: calendarRange,
    );

    final numberOfDaysRemainder = adjustedDateTimeRange.duration.inDays % 7;

    expect(
      numberOfDaysRemainder,
      0,
      reason: 'The number of days must be a multiple of 5',
    );

    final numberOfPages = config.calculateNumberOfPages(
      adjustedDateTimeRange,
    );

    final expectedNumberOfPages = adjustedDateTimeRange.duration.inDays ~/ 7;

    expect(
      numberOfPages,
      expectedNumberOfPages,
      reason: 'The number of pages must be $expectedNumberOfPages',
    );

    for (final date in datesToTest) {
      final index = config.calculateDateIndex(date, start);
      expect(
        index,
        dayIndexes[7]![datesToTest.indexOf(date)],
      );
    }
  });
}

/// Tests for [ScheduleViewConfiguration].
///
/// - [ScheduleConfiguration]
void _testScheduleConfigurations({
  required DateTime start,
  required DateTime end,
}) {
  final calendarRange = DateTimeRange(start: start, end: end);

  test('ScheduleConfiguration Tests', () {
    final config = ScheduleConfiguration();

    final adjustedDateTimeRange = config.calculateAdjustedDateTimeRange(
      dateTimeRange: calendarRange,
    );

    final numberOfDaysRemainder = adjustedDateTimeRange.duration.inDays % 1;

    expect(
      numberOfDaysRemainder,
      0,
      reason: 'The number of days must be a multiple of 1',
    );
  });
}
