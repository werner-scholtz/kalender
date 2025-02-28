import 'package:flutter/material.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/models/view_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/models/view_configurations/month_view_configuration.dart';

/// Calculates the VisibleDateRange from the [index].
///
/// [index] is the page index.
///
/// The returned [DateTimeRange] will be constructed in UTC, as that is how the calculations are done.
/// To convert this to the local timezone, use the [DateTimeRangeExtensions.asLocal] getter.
typedef DateTimeRangeFromIndex = DateTimeRange Function(int index);

/// Calculates the page index of the [date].
typedef IndexFromDate = int Function(DateTime date);

/// The number of pages for the [DateTimeRange] of the calendar.
typedef NumberOfPages = int Function();

abstract class PageNavigationFunctions {
  PageNavigationFunctions();

  /// Creates a [PageNavigationFunctions] for a single day [MultiDayViewConfiguration.singleDay].
  factory PageNavigationFunctions.singleDay(DateTimeRange dateTimeRange) {
    return DayPageFunctions(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageNavigationFunctions] for a week [MultiDayViewConfiguration.week].
  factory PageNavigationFunctions.week(DateTimeRange dateTimeRange, int firstDayOfWeek) {
    return WeekPageFunctions(dateTimeRange: dateTimeRange, firstDayOfWeek: firstDayOfWeek);
  }

  /// Creates a [PageNavigationFunctions] for a work week [MultiDayViewConfiguration.workWeek].
  factory PageNavigationFunctions.workWeek(DateTimeRange dateTimeRange) {
    return WorkWeekPageFunctions(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageNavigationFunctions] for a custom [MultiDayViewConfiguration.custom].
  factory PageNavigationFunctions.custom(DateTimeRange dateTimeRange, int numberOfDays) {
    return CustomPageFunctions(dateTimeRange: dateTimeRange, numberOfDays: numberOfDays);
  }

  /// Creates a [PageNavigationFunctions] for a single day [MultiDayViewConfiguration.freeScroll].
  factory PageNavigationFunctions.freeScroll(DateTimeRange dateTimeRange) {
    return FreeScrollFunctions(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageNavigationFunctions] for a month [MonthViewConfiguration.singleMonth].
  factory PageNavigationFunctions.month(DateTimeRange dateTimeRange, int firstDayOfWeek) {
    return MonthPageFunctions(dateTimeRange: dateTimeRange, firstDayOfWeek: firstDayOfWeek);
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
    // Construct a new date with the same year, month, and day, but in UTC.
    final start = dateTimeRange.start.asUtc.startOfDay;

    dateTimeRangeFromIndex = (index) {
      // Add the index to the start date to get the date to display.
      return start.addDays(index).dayRange;
    };

    indexFromDate = (date) {
      // Create a new date with the same year, month, and day, but in UTC.
      final dateAsUtc = date.asUtc.startOfDay;

      // Calculate the difference in days between the start date and the given date.
      return dateAsUtc.difference(start).inDays.clamp(0, numberOfPages);
    };

    numberOfPages = dateTimeRange.dates().length;
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
    // The value to shift the start of week by to get the first day of the week.
    final shift = firstDayOfWeek - 1;

    final start = dateTimeRange.start.asUtc;
    final end = dateTimeRange.end.asUtc;

    final shiftedStart = start.startOfWeek.addDays(shift);
    final shiftedEnd = end.endOfWeek.addDays(shift);
    final shiftedRange = DateTimeRange(start: shiftedStart, end: shiftedEnd);

    final weekDifference = (shiftedRange.dates().length / DateTime.daysPerWeek) - 1;
    if (weekDifference != weekDifference.round()) {
      debugPrint('Week difference is not a whole number, this should not happen and is a bug');
    }

    numberOfPages = weekDifference.round();

    dateTimeRangeFromIndex = (index) {
      return DateTime.utc(
        start.year,
        start.month,
        start.day + (index * DateTime.daysPerWeek),
      ).weekRange.shiftByDays(firstDayOfWeek - 1);
    };

    indexFromDate = (date) {
      final startOfWeek = date.asUtc.startOfWeek.addDays(shift);
      if (startOfWeek == shiftedStart) return 0;

      final range = DateTimeRange(start: shiftedStart, end: startOfWeek);
      final index = range.dates().length / DateTime.daysPerWeek;

      assert(index == index.round());
      return index.round().clamp(0, numberOfPages);
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
    final start = dateTimeRange.start.asUtc;
    final end = dateTimeRange.end.asUtc;

    final shiftedStart = start.startOfWeek;
    final shiftedEnd = end.endOfWeek;
    final shiftedRange = DateTimeRange(start: shiftedStart, end: shiftedEnd);

    final weekDifference = (shiftedRange.dates().length / DateTime.daysPerWeek) - 1;
    if (weekDifference != weekDifference.round()) {
      debugPrint('Week difference is not a whole number, this should not happen and is a bug');
    }

    numberOfPages = weekDifference.round();

    dateTimeRangeFromIndex = (index) {
      final date = DateTime.utc(
        start.year,
        start.month,
        start.day + (index * DateTime.daysPerWeek),
      );

      return date.workWeekRange;
    };
    indexFromDate = (date) {
      final startOfWeek = date.asUtc.startOfWeek;
      if (startOfWeek == shiftedStart) return 0;

      final range = DateTimeRange(start: shiftedStart, end: startOfWeek);
      final index = range.dates().length / DateTime.daysPerWeek;

      assert(index == index.round());
      return index.round().clamp(0, numberOfPages);
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
    final start = dateTimeRange.start.asUtc;

    numberOfPages = (dateTimeRange.dates().length ~/ numberOfDays);

    dateTimeRangeFromIndex = (index) {
      return DateTime.utc(
        start.year,
        start.month,
        start.day + (index * numberOfDays),
      ).customDateTimeRange(numberOfDays);
    };

    indexFromDate = (date) {
      final dateUtc = date.startOfDay.asUtc;
      final index = (dateUtc.difference(start).inDays ~/ numberOfDays);
      return index.clamp(0, numberOfPages);
    };
  }

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}

class FreeScrollFunctions extends PageNavigationFunctions {
  FreeScrollFunctions({
    required DateTimeRange dateTimeRange,
  }) {
    final start = dateTimeRange.start.asUtc.startOfDay;
    numberOfPages = dateTimeRange.dates().length;

    dateTimeRangeFromIndex = (index) => start.addDays(index).dayRange;

    indexFromDate = (date) {
      final dateAsUtc = date.asUtc.startOfDay;
      return dateAsUtc.difference(start).inDays;
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
  static const numberOfRows = 5;

  MonthPageFunctions({
    required DateTimeRange dateTimeRange,
    required int firstDayOfWeek,
  }) {
    final shift = firstDayOfWeek - 1;
    final start = dateTimeRange.start.asUtc;

    numberOfPages = dateTimeRange.monthDifference;

    dateTimeRangeFromIndex = (index) {
      final range = DateTime.utc(start.year, start.month + index, 1).monthRange;
      var rangeStart = range.start.startOfWeek.addDays(shift);
      if (rangeStart.isAfter(range.start)) rangeStart = rangeStart.subtractDays(7);
      final rangeEnd = rangeStart.addDays(DateTime.daysPerWeek * numberOfRows);
      return DateTimeRange(start: rangeStart, end: rangeEnd);
    };

    indexFromDate = (date) {
      final dateTimeRange = DateTimeRange(start: start, end: date.asUtc);
      return dateTimeRange.monthDifference;
    };
  }

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}
