import 'package:flutter/material.dart';

class DateTimeTestObject {
  DateTimeTestObject({
    required this.date,
    required this.weekNumber,
    required this.startOfDay,
    required this.endOfDay,
    required this.startOfWeekSundayOffset,
    required this.startOfWeek,
    required this.endOfWeek,
    required this.startOfMonth,
    required this.endOfMonth,
    required this.startOfYear,
    required this.endOfYear,
    required this.dayRange,
    required this.threeDayRange,
    required this.fourDayRange,
    required this.weekRangeWithMondayOffset,
    required this.weekRange,
    required this.monthRange,
    required this.yearRange,
  });

  final DateTime date;
  final int weekNumber;
  final DateTime startOfDay;
  final DateTime endOfDay;
  final DateTime startOfWeek;
  final DateTime endOfWeek;
  final DateTime startOfWeekSundayOffset;
  final DateTime startOfMonth;
  final DateTime endOfMonth;
  final DateTime startOfYear;
  final DateTime endOfYear;
  final DateTimeRange dayRange;
  final DateTimeRange threeDayRange;
  final DateTimeRange fourDayRange;
  final DateTimeRange weekRangeWithMondayOffset;
  final DateTimeRange weekRange;
  final DateTimeRange monthRange;
  final DateTimeRange yearRange;
}

List<DateTimeTestObject> dateTimeTestObjects = <DateTimeTestObject>[
  DateTimeTestObject(
    date: DateTime(2020, 1, 1),
    weekNumber: 1,
    startOfDay: DateTime(2020, 1, 1),
    endOfDay: DateTime(2020, 1, 2),
    startOfWeekSundayOffset: DateTime(2020, 1, 5),
    startOfWeek: DateTime(2019, 12, 30),
    endOfWeek: DateTime(2020, 1, 5),
    startOfMonth: DateTime(2020, 1, 1),
    endOfMonth: DateTime(2020, 2, 1),
    startOfYear: DateTime(2020, 1, 1),
    endOfYear: DateTime(2021, 1, 1),
    dayRange: DateTimeRange(
      start: DateTime(2020, 1, 1),
      end: DateTime(2020, 1, 2),
    ),
    threeDayRange: DateTimeRange(
      start: DateTime(2020, 1, 1),
      end: DateTime(2020, 1, 4),
    ),
    fourDayRange: DateTimeRange(
      start: DateTime(2020, 1, 1),
      end: DateTime(2020, 1, 5),
    ),
    weekRangeWithMondayOffset: DateTimeRange(
      start: DateTime(2019, 12, 30),
      end: DateTime(2020, 1, 6),
    ),
    weekRange: DateTimeRange(
      start: DateTime(2019, 12, 30),
      end: DateTime(2020, 1, 6),
    ),
    monthRange: DateTimeRange(
      start: DateTime(2020, 1, 1),
      end: DateTime(2020, 2, 1),
    ),
    yearRange: DateTimeRange(
      start: DateTime(2020, 1, 1),
      end: DateTime(2021, 1, 1),
    ),
  ),
  DateTimeTestObject(
    date: DateTime(2020, 2, 29),
    weekNumber: 9,
    startOfDay: DateTime(2020, 2, 29),
    endOfDay: DateTime(2020, 3, 1),
    startOfWeekSundayOffset: DateTime(2020, 3, 1),
    startOfWeek: DateTime(2020, 2, 24),
    endOfWeek: DateTime(2020, 3, 1),
    startOfMonth: DateTime(2020, 2, 1),
    endOfMonth: DateTime(2020, 3, 1),
    startOfYear: DateTime(2020, 1, 1),
    endOfYear: DateTime(2021, 1, 1),
    dayRange: DateTimeRange(
      start: DateTime(2020, 2, 29),
      end: DateTime(2020, 3, 1),
    ),
    threeDayRange: DateTimeRange(
      start: DateTime(2020, 2, 29),
      end: DateTime(2020, 3, 3),
    ),
    fourDayRange: DateTimeRange(
      start: DateTime(2020, 2, 29),
      end: DateTime(2020, 3, 4),
    ),
    weekRangeWithMondayOffset: DateTimeRange(
      start: DateTime(2020, 2, 24),
      end: DateTime(2020, 3, 2),
    ),
    weekRange: DateTimeRange(
      start: DateTime(2020, 2, 24),
      end: DateTime(2020, 3, 2),
    ),
    monthRange: DateTimeRange(
      start: DateTime(2020, 2, 1),
      end: DateTime(2020, 3, 1),
    ),
    yearRange: DateTimeRange(
      start: DateTime(2020, 2, 1),
      end: DateTime(2021, 2, 1),
    ),
  ),
];
