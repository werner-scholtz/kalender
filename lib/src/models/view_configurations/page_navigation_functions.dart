import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/type_definitions.dart';

abstract class PageNavigationFunctions {
  PageNavigationFunctions();

  factory PageNavigationFunctions.singleDay(DateTimeRange dateTimeRange) {
    return DayPageFunctions(
      dateTimeRange: dateTimeRange,
    );
  }

  factory PageNavigationFunctions.week(DateTimeRange dateTimeRange, int firstDayOfWeek) {
    return WeekPageFunctions(
      dateTimeRange: dateTimeRange,
      firstDayOfWeek: firstDayOfWeek,
    );
  }

  factory PageNavigationFunctions.workWeek(
    DateTimeRange dateTimeRange,
  ) {
    return WorkWeekPageFunctions(dateTimeRange: dateTimeRange);
  }

  factory PageNavigationFunctions.custom(DateTimeRange dateTimeRange, int numberOfDays) {
    return CustomPageFunctions(
      dateTimeRange: dateTimeRange,
      numberOfDays: numberOfDays,
    );
  }

  factory PageNavigationFunctions.month(
    DateTimeRange dateTimeRange,
    int firstDayOfWeek,
  ) {
    return MonthPageFunctions(
      dateTimeRange: dateTimeRange,
      firstDayOfWeek: firstDayOfWeek,
    );
  }

  DateTimeRangeFromIndex get dateTimeRangeFromIndex;
  IndexFromDate get indexFromDate;
  int get numberOfPages;

  /// Returns the [DateTimeRange] that is displayed for the given [date].
  DateTimeRange dateTimeRangeFromDate(DateTime date) {
    final index = indexFromDate(date);
    return dateTimeRangeFromIndex(index);
  }
}

class DayPageFunctions extends PageNavigationFunctions {
  DayPageFunctions({
    required DateTimeRange dateTimeRange,
  }) {
    final start = dateTimeRange.start.asUtc().startOfDay;
    dateTimeRangeFromIndex = (index) => start.addDays(index).dayRange;
    indexFromDate = (date) {
      final dateAsUtc = date.asUtc().startOfDay;
      return dateAsUtc.difference(start).inDays;
    };
    numberOfPages = dateTimeRange.dayDifference;
  }

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}

class WeekPageFunctions extends PageNavigationFunctions {
  WeekPageFunctions({
    required DateTimeRange dateTimeRange,
    required int firstDayOfWeek,
  }) {
    final start = dateTimeRange.start.asUtc();
    final end = dateTimeRange.end.asUtc();
    final shiftedStart = start.startOfWeekWithOffset(firstDayOfWeek).startOfDay;
    final shiftedEnd = end.endOfWeekWithOffset(firstDayOfWeek).startOfDay;
    final shiftedRange = DateTimeRange(start: shiftedStart, end: shiftedEnd);
    final weekDifference = (shiftedRange.dayDifference / DateTime.daysPerWeek);
    if (weekDifference != weekDifference.round()) {
      debugPrint('Week difference is not a whole number, this should not happen and is a bug');
    }
    numberOfPages = weekDifference.round();
    dateTimeRangeFromIndex = (index) {
      return DateTime(
        start.year,
        start.month,
        start.day + (index * DateTime.daysPerWeek),
      ).weekRangeWithOffset(firstDayOfWeek);
    };
    indexFromDate = (date) {
      final dateAsUtc = date.asUtc();
      final shiftedDate = dateAsUtc.startOfWeekWithOffset(firstDayOfWeek);
      final range = DateTimeRange(start: shiftedStart, end: shiftedDate);
      final index = range.dayDifference / DateTime.daysPerWeek;
      assert(index == index.round());
      return index.round().clamp(0, numberOfPages - 1);
    };
  }

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}

class WorkWeekPageFunctions extends PageNavigationFunctions {
  WorkWeekPageFunctions({
    required DateTimeRange dateTimeRange,
  }) {
    final start = dateTimeRange.start.asUtc();
    final end = dateTimeRange.end.asUtc();
    final shiftedStart = start.startOfWeekWithOffset(1).startOfDay;
    final shiftedEnd = end.endOfWeekWithOffset(1).startOfDay;
    final shiftedRange = DateTimeRange(start: shiftedStart, end: shiftedEnd);
    final weekDifference = (shiftedRange.dayDifference / DateTime.daysPerWeek);
    if (weekDifference != weekDifference.round()) {
      debugPrint('Week difference is not a whole number, this should not happen and is a bug');
    }
    numberOfPages = weekDifference.round();
    dateTimeRangeFromIndex = (index) {
      final weekRange = DateTime(
        start.year,
        start.month,
        start.day + (index * DateTime.daysPerWeek),
      ).weekRangeWithOffset(1);

      return DateTimeRange(
        start: weekRange.start,
        end: weekRange.end.subtractDays(2),
      );
    };
    indexFromDate = (date) {
      final dateAsUtc = date.asUtc();
      final shiftedDate = dateAsUtc.startOfWeekWithOffset(1);
      final range = DateTimeRange(start: shiftedStart, end: shiftedDate);
      final index = range.dayDifference / DateTime.daysPerWeek;
      assert(index == index.round());
      return index.round().clamp(0, numberOfPages - 1);
    };
  }

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}

class CustomPageFunctions extends PageNavigationFunctions {
  CustomPageFunctions({
    required DateTimeRange dateTimeRange,
    required int numberOfDays,
  }) {
    final start = dateTimeRange.start;
    numberOfPages = dateTimeRange.dayDifference ~/ numberOfDays;
    dateTimeRangeFromIndex = (index) {
      final startDateUtc = start.startOfDay;
      return DateTime(
        startDateUtc.year,
        startDateUtc.month,
        startDateUtc.day + (index * numberOfDays),
      ).multiDayDateTimeRange(numberOfDays);
    };
    indexFromDate = (date) {
      final dateUtc = date.startOfDay.toUtc();
      final startDateUtc = dateTimeRange.start.startOfDay.toUtc();
      final index = dateUtc.difference(startDateUtc).inDays ~/ numberOfDays;
      return index.clamp(0, numberOfPages - 1);
    };
  }

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}

class MonthPageFunctions extends PageNavigationFunctions {
  MonthPageFunctions({
    required DateTimeRange dateTimeRange,
    required int firstDayOfWeek,
  }) {
    final start = dateTimeRange.start;
    dateTimeRangeFromIndex = (index) {
      final range = DateTime(start.year, start.month + index, 1).monthRange;
      var rangeStart = range.start.startOfWeekWithOffset(firstDayOfWeek);
      if (rangeStart.isAfter(range.start)) {
        rangeStart = rangeStart.subtractDays(7);
      }
      final rangeEnd = rangeStart.addDays(7 * 5);
      return DateTimeRange(start: rangeStart, end: rangeEnd);
    };
    indexFromDate = (date) {
      final dateTimeRange = DateTimeRange(start: start, end: date);
      return dateTimeRange.monthDifference;
    };
    numberOfPages = dateTimeRange.monthDifference;
  }

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}
