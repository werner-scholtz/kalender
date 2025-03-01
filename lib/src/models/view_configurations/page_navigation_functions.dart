import 'package:flutter/material.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/models/view_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/models/view_configurations/month_view_configuration.dart';

/// A class that contains functions to navigate between pages in a view.
///
/// **Note:** Any functions that return a [DateTime] will return a date in UTC timezone.
///           To convert this to the local timezone, use the [DateTimeExtensions.asLocal] getter.
///           This is because the calculations are done in UTC.
///
abstract class PageNavigationFunctions {
  PageNavigationFunctions() {
    assert(numberOfPages > 0);
    assert(adjustedRange.isUtc);
  }

  /// Creates a [PageNavigationFunctions] for a single day [MultiDayViewConfiguration.singleDay].
  factory PageNavigationFunctions.singleDay(DateTimeRange dateTimeRange) {
    return DayPageFunctions(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageNavigationFunctions] for a week [MultiDayViewConfiguration.week].
  factory PageNavigationFunctions.week(DateTimeRange dateTimeRange, int firstDayOfWeek) {
    return WeekPageFunctions(dateTimeRange: dateTimeRange, shift: firstDayOfWeek - 1);
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
    return MonthPageFunctions(dateTimeRange: dateTimeRange, shift: firstDayOfWeek - 1);
  }

  /// Calculates the VisibleDateRange from the [index].
  ///
  /// [index] is the page index.
  ///
  /// The returned [DateTimeRange] will be constructed in UTC, as that is how the calculations are done.
  /// To convert this to the local timezone, use the [DateTimeRangeExtensions.asLocal] getter.
  DateTimeRange dateTimeRangeFromIndex(int index);

  /// Calculates the page index of the [date].
  ///
  /// The returned index should be clamped between 0 and the number of pages.
  int indexFromDate(DateTime date);

  /// The number of pages that can be displayed.
  int get numberOfPages;

  /// A callback that adjusts the range to allow for an even number of pages.
  ///
  /// This should return a new [DateTimeRange] (utc) that is adjusted to allow
  /// the range to be split into an even number of pages.
  DateTimeRange get adjustedRange;

  /// Returns the [DateTimeRange] that is displayed for the given [date].
  DateTimeRange dateTimeRangeFromDate(DateTime date) {
    final index = indexFromDate(date);
    return dateTimeRangeFromIndex(index);
  }
}

class DayPageFunctions extends PageNavigationFunctions {
  DayPageFunctions({
    required DateTimeRange dateTimeRange,
  }) : adjustedRange = dateTimeRange.asUtc;

  @override
  DateTimeRange dateTimeRangeFromIndex(int index) {
    // Add the index to the start date to get the date to display.
    return adjustedRange.start.addDays(index).dayRange;
  }

  @override
  int indexFromDate(DateTime date) {
    // Create a new date with the same year, month, and day, but in UTC.
    final dateAsUtc = date.asUtc.startOfDay;

    // Calculate the difference in days between the start date and the given date.
    return dateAsUtc.difference(adjustedRange.start).inDays.clamp(0, numberOfPages);
  }

  @override
  late final int numberOfPages = adjustedRange.dates().length;

  @override
  final DateTimeRange adjustedRange;
}

class WeekPageFunctions extends PageNavigationFunctions {
  /// The value to shift the start of week by to get the first day of the week.
  final int shift;

  WeekPageFunctions({
    required DateTimeRange dateTimeRange,
    required this.shift,
  }) : adjustedRange = DateTimeRange(
          start: dateTimeRange.start.asUtc.startOfWeek.addDays(shift),
          end: dateTimeRange.end.asUtc.endOfWeek.addDays(shift),
        );

  @override
  DateTimeRange dateTimeRangeFromIndex(int index) {
    return DateTime.utc(
      adjustedRange.start.year,
      adjustedRange.start.month,
      adjustedRange.start.day + (index * DateTime.daysPerWeek),
    ).weekRange.shiftByDays(shift);
  }

  @override
  int indexFromDate(DateTime date) {
    final startOfWeek = date.asUtc.startOfWeek.addDays(shift);
    if (startOfWeek == adjustedRange.start) return 0;

    final range = DateTimeRange(start: adjustedRange.start, end: startOfWeek);
    final index = range.dates().length / DateTime.daysPerWeek;

    assert(index == index.round());
    return index.round().clamp(0, numberOfPages);
  }

  @override
  late final int numberOfPages = ((adjustedRange.dates().length / DateTime.daysPerWeek) - 1).round();

  @override
  final DateTimeRange adjustedRange;
}

class WorkWeekPageFunctions extends PageNavigationFunctions {
  WorkWeekPageFunctions({
    required DateTimeRange dateTimeRange,
  }) : adjustedRange = DateTimeRange(
          start: dateTimeRange.start.asUtc.startOfWeek,
          end: dateTimeRange.end.asUtc.endOfWeek,
        );

  @override
  DateTimeRange dateTimeRangeFromIndex(int index) {
    final date = DateTime.utc(
      adjustedRange.start.year,
      adjustedRange.start.month,
      adjustedRange.start.day + (index * DateTime.daysPerWeek),
    );

    return date.workWeekRange;
  }

  @override
  int indexFromDate(DateTime date) {
    final startOfWeek = date.asUtc.startOfWeek;
    if (startOfWeek == adjustedRange.start) return 0;

    final range = DateTimeRange(start: adjustedRange.start, end: startOfWeek);
    final index = range.dates().length / DateTime.daysPerWeek;

    assert(index == index.round());
    return index.round().clamp(0, numberOfPages);
  }

  @override
  late final int numberOfPages = ((adjustedRange.dates().length / DateTime.daysPerWeek) - 1).round();

  @override
  late final DateTimeRange adjustedRange;
}

class CustomPageFunctions extends PageNavigationFunctions {
  /// The number of days in each page.
  late final int numberOfDays;

  CustomPageFunctions({
    required DateTimeRange dateTimeRange,
    required this.numberOfDays,
  }) : adjustedRange = dateTimeRange.asUtc;

  @override
  DateTimeRange dateTimeRangeFromIndex(int index) {
    return DateTime.utc(
      adjustedRange.start.year,
      adjustedRange.start.month,
      adjustedRange.start.day + (index * numberOfDays),
    ).customDateTimeRange(numberOfDays);
  }

  @override
  int indexFromDate(DateTime date) {
    final dateUtc = date.startOfDay.asUtc;
    final index = (dateUtc.difference(adjustedRange.start).inDays ~/ numberOfDays);
    return index.clamp(0, numberOfPages);
  }

  @override
  late final int numberOfPages = (adjustedRange.dates().length ~/ numberOfDays);

  @override
  late final DateTimeRange adjustedRange;
}

class FreeScrollFunctions extends PageNavigationFunctions {
  FreeScrollFunctions({
    required DateTimeRange dateTimeRange,
  }) : adjustedRange = dateTimeRange.asUtc;

  @override
  DateTimeRange dateTimeRangeFromIndex(int index) => adjustedRange.start.addDays(index).dayRange;

  @override
  int indexFromDate(DateTime date) {
    final dateAsUtc = date.asUtc.startOfDay;
    return dateAsUtc.difference(adjustedRange.start).inDays;
  }

  @override
  late final int numberOfPages = adjustedRange.dates().length;

  @override
  late final DateTimeRange adjustedRange;
}

class MonthPageFunctions extends PageNavigationFunctions {
  static const numberOfRows = 5;
  final int shift;

  MonthPageFunctions({
    required DateTimeRange dateTimeRange,
    required this.shift,
  }) : adjustedRange = dateTimeRange.asUtc;

  @override
  DateTimeRange dateTimeRangeFromIndex(int index) {
    final range = DateTime.utc(adjustedRange.start.year, adjustedRange.start.month + index, 1).monthRange;
    var rangeStart = range.start.startOfWeek.addDays(shift);
    if (rangeStart.isAfter(range.start)) rangeStart = rangeStart.subtractDays(7);
    final rangeEnd = rangeStart.addDays(DateTime.daysPerWeek * numberOfRows);
    return DateTimeRange(start: rangeStart, end: rangeEnd);
  }

  @override
  int indexFromDate(DateTime date) {
    final dateTimeRange = DateTimeRange(start: adjustedRange.start, end: date.asUtc);
    return dateTimeRange.monthDifference;
  }

  @override
  late final int numberOfPages = adjustedRange.monthDifference;

  @override
  late final DateTimeRange adjustedRange;
}
