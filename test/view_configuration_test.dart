import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  final start = DateTime(2024);
  final end = DateTime(2025);
  final ranges = <DateTimeRange>[
    DateTimeRange(start: start, end: end),
    DateTimeRange(start: start.addDays(1), end: end),
    DateTimeRange(start: start.addDays(2), end: end),
    DateTimeRange(start: start.addDays(3), end: end),
    DateTimeRange(start: start.addDays(4), end: end),
    DateTimeRange(start: start.addDays(5), end: end),
    DateTimeRange(start: start.addDays(6), end: end),
    DateTimeRange(start: start.addDays(7), end: end),
    DateTimeRange(start: start.addDays(1), end: end.subtractDays(1)),
    DateTimeRange(start: start.addDays(2), end: end.subtractDays(2)),
    DateTimeRange(start: start.addDays(3), end: end.subtractDays(3)),
    DateTimeRange(start: start.addDays(4), end: end.subtractDays(4)),
    DateTimeRange(start: start.addDays(5), end: end.subtractDays(5)),
    DateTimeRange(start: start.addDays(6), end: end.subtractDays(6)),
    DateTimeRange(start: start.addDays(7), end: end.subtractDays(7)),
  ];

  group('ViewConfiguration Tests', () {
    testDayConfiguration(ranges);
    testWeekConfiguration(ranges);
  });
}

void testDayConfiguration(List<DateTimeRange> calendarRanges) {
  test('DayConfiguration tests', () {
    for (final range in calendarRanges) {
      final start = range.start;
      final end = range.end;
      final dayConfiguration = MultiDayViewConfiguration.singleDay(
        displayRange: range,
      );

      final functions = dayConfiguration.pageNavigationFunctions;

      // The index of the start date should be 0.
      final startIndex = functions.indexFromDate(start);
      expect(startIndex, 0);

      // The index of the end date should be the difference between the start and end date.
      final endIndex = functions.indexFromDate(end);
      expect(endIndex, range.dayDifference);

      // The number of pages should be the difference between the start and end date.
      final numberOfPages = functions.numberOfPages;
      expect(numberOfPages, range.dayDifference);

      for (var i = 0; i < range.dayDifference; i++) {
        final dateTimeRange = functions.dateTimeRangeFromIndex(i);

        expect(dateTimeRange.start, start.addDays(i).asUtc);
        expect(dateTimeRange.end, start.addDays(i).endOfDay.asUtc);
      }
    }
  });
}

void testWeekConfiguration(List<DateTimeRange> calendarRanges) {
  test('WeekConfiguration test', () {
    for (final range in calendarRanges) {
      final start = range.start;
      for (var i = 1; i <= 7; i++) {
        final weekConfiguration = MultiDayViewConfiguration.week(
          firstDayOfWeek: i,
          displayRange: range,
        );
        final functions = weekConfiguration.pageNavigationFunctions;

        // The index of the start date should be 0.
        final startIndex = functions.indexFromDate(start);
        expect(startIndex, 0);

        //TODO: check how to better test this.
      }
    }
  });
}
