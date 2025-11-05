import 'package:flutter/material.dart';
import 'package:kalender/src/extensions/internal_extensions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:timezone/timezone.dart';

/// TODO: THIS CAN BE SIMPLIFIED A LOT ONCE ONLY UTC DATES ARE USED INTERNALLY!!!
/// TODO: we should probably calculate the adjusted range with location in mind.

/// A class that contains functions to navigate between pages in a view, where applicable.
///
/// **Note:** Any functions that return a [DateTime] will return a date in UTC timezone.
///           To convert this to the local timezone, use the [DateTimeExtensions.asLocal] getter.
///           This is because the calculations are done in UTC.
///
abstract class PageNavigationFunctions {
  /// The range provided by the user in UTC.
  final DateTimeRange dateTimeRange;

  PageNavigationFunctions({required DateTimeRange dateTimeRange}) : dateTimeRange = dateTimeRange.toUtc();

  /// Creates a [PageNavigationFunctions] for a single day [MultiDayViewConfiguration.singleDay].
  factory PageNavigationFunctions.singleDay(DateTimeRange dateTimeRange) {
    return DayPageFunctions(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageNavigationFunctions] for a week [MultiDayViewConfiguration.week].
  factory PageNavigationFunctions.week(DateTimeRange dateTimeRange, int firstDayOfWeek) {
    return WeekPageFunctions.week(dateTimeRange: dateTimeRange, firstDayOfWeek: firstDayOfWeek);
  }

  /// Creates a [PageNavigationFunctions] for a work week [MultiDayViewConfiguration.workWeek].
  factory PageNavigationFunctions.workWeek(DateTimeRange dateTimeRange) {
    return WeekPageFunctions.workWeek(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageNavigationFunctions] for a custom [MultiDayViewConfiguration.custom].
  factory PageNavigationFunctions.custom(DateTimeRange dateTimeRange, int numberOfDays) {
    return CustomPageFunctions(dateTimeRange: dateTimeRange, numberOfDays: numberOfDays);
  }

  /// Creates a [PageNavigationFunctions] for a single day [MultiDayViewConfiguration.freeScroll].
  factory PageNavigationFunctions.freeScroll(DateTimeRange dateTimeRange) {
    return FreeScrollFunctions(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageNavigationFunctions] for a schedule [ContinuousSchedulePageFunctions].
  factory PageNavigationFunctions.scheduleContinuous(DateTimeRange dateTimeRange) {
    return ContinuousSchedulePageFunctions(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageNavigationFunctions] for a schedule [PaginatedSchedulePageFunctions].
  factory PageNavigationFunctions.schedulePaginated(DateTimeRange dateTimeRange) {
    return PaginatedSchedulePageFunctions(dateTimeRange: dateTimeRange);
  }

  /// Calculates the VisibleDateRange from the [index].
  ///
  /// [index] is the page index.
  ///
  /// The returned [DateTimeRange] will be constructed in UTC, as that is how the calculations are done.
  /// To convert this to the local timezone, use the [DateTimeRangeExtensions.asLocal] getter.
  DateTimeRange dateTimeRangeFromIndex(int index, Location? location);

  /// Calculates the page index of the [date].
  ///
  /// The returned index should be clamped between 0 and the number of pages.
  int indexFromDate(DateTime date, Location? location);

  /// The number of pages that can be displayed.
  int numberOfPages(Location? location);

  /// The adjusted [DateTimeRange] for a specific location.
  ///
  /// This range is intended to be used for calculations only.
  DateTimeRange adjustedRangeAsUtc(Location? location);

  /// Returns the [DateTimeRange] that is displayed for the given [date].
  DateTimeRange dateTimeRangeFromDate(DateTime date, Location? location) {
    final index = indexFromDate(date, location);
    final range = dateTimeRangeFromIndex(index, location);
    assert(range.isUtc);
    return range;
  }
}

class DayPageFunctions extends PageNavigationFunctions {
  DayPageFunctions({required super.dateTimeRange});

  @override
  DateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final adjustedRangeUtc = adjustedRangeAsUtc(location).toUtc();

    // Add the index to the start date to get the date to display.
    final start = adjustedRangeUtc.start.add(Duration(days: index));
    final end = start.add(const Duration(days: 1));

    return DateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    final startOfDate = date.startOfDay.toUtc();
    final startOfRange = adjustedRangeAsUtc(location).start.toUtc();

    // Calculate the difference in days between the two dates.
    final days = startOfDate.difference(startOfRange).inDays;

    return days.clamp(0, numberOfPages(location));
  }

  @override
  int numberOfPages(Location? location) {
    final adjustedRangeUtc = adjustedRangeAsUtc(location).toUtc();
    return adjustedRangeUtc.end.difference(adjustedRangeUtc.start).inDays;
  }

  @override
  DateTimeRange adjustedRangeAsUtc(Location? location) => dateTimeRange.forLocation(location).asUtc;
}

class WeekPageFunctions extends PageNavigationFunctions {
  /// The value to shift the start of week by to get the first day of the week.
  final int firstDayOfWeek;

  /// The number of days to display in a week view. Usually 7.
  final int daysToDisplay;

  WeekPageFunctions({
    required super.dateTimeRange,
    required this.firstDayOfWeek,
    required this.daysToDisplay,
  });

  WeekPageFunctions.week({
    required super.dateTimeRange,
    required this.firstDayOfWeek,
  }) : daysToDisplay = DateTime.daysPerWeek;

  WeekPageFunctions.workWeek({required super.dateTimeRange})
      : firstDayOfWeek = DateTime.monday,
        daysToDisplay = 5;

  @override
  DateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final adjustedRangeUtc = adjustedRangeAsUtc(location).toUtc();

    final start = adjustedRangeUtc.start.copyWith(
      day: adjustedRangeUtc.start.day + (index * DateTime.daysPerWeek),
    );
    final end = start.add(Duration(days: daysToDisplay));

    return DateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    date = date.forLocation(location).asUtc;
    final startOfWeekUtc = date.startOfWeek(firstDayOfWeek: firstDayOfWeek);
    final adjustedRangeUtc = adjustedRangeAsUtc(location);

    // If the date provided start of week is before or equal to the adjusted range start, return 0.
    if (startOfWeekUtc.isBefore(adjustedRangeUtc.start) || startOfWeekUtc == adjustedRangeUtc.start) return 0;
    final range = DateTimeRange(start: adjustedRangeUtc.start, end: startOfWeekUtc);
    final index = range.dates().length / DateTime.daysPerWeek;

    if (index.round() != index) {
      debugPrint('Warning: index is not an integer: $index');
    }

    return index.round().clamp(0, numberOfPages(location));
  }

  @override
  int numberOfPages(Location? location) {
    final adjustedRangeUtc = adjustedRangeAsUtc(location);
    final numberOfPages = adjustedRangeUtc.end.difference(adjustedRangeUtc.start).inDays / DateTime.daysPerWeek;
    if (numberOfPages.round() != numberOfPages) {
      debugPrint('Warning: numberOfPages is not an integer: $numberOfPages');
    }
    return (numberOfPages - 1).round();
  }

  @override
  DateTimeRange adjustedRangeAsUtc(Location? location) {
    final localRange = dateTimeRange.forLocation(location);
    final start = localRange.start.startOfWeek(firstDayOfWeek: firstDayOfWeek).asUtc;
    final end = localRange.end.endOfWeek(firstDayOfWeek: firstDayOfWeek).asUtc;
    return DateTimeRange(start: start, end: end);
  }
}

class CustomPageFunctions extends PageNavigationFunctions {
  /// The number of days in each page.
  late final int numberOfDays;

  CustomPageFunctions({required this.numberOfDays, required super.dateTimeRange});

  @override
  DateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final adjustedRangeUtc = adjustedRangeAsUtc(location);
    final start = adjustedRangeUtc.start.add(Duration(days: index * numberOfDays));
    final end = start.add(Duration(days: numberOfDays));
    return DateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    final startOfDateUtc = date.startOfDay;
    final adjustedRangeUtc = adjustedRangeAsUtc(location);
    final index = startOfDateUtc.difference(adjustedRangeUtc.start).inDays ~/ numberOfDays;
    return index.clamp(0, numberOfPages(location));
  }

  @override
  int numberOfPages(Location? location) {
    // TODO: Check this logic
    final adjustedRangeUtc = adjustedRangeAsUtc(location);
    return (adjustedRangeUtc.end.difference(adjustedRangeUtc.start).inDays ~/ numberOfDays);
  }

  // TODO: Test this.
  @override
  DateTimeRange adjustedRangeAsUtc(Location? location) {
    final range = dateTimeRange.forLocation(location).asUtc;
    final numberOfDaysInRange = range.end.difference(range.start).inDays;
    final extraDays = numberOfDaysInRange % numberOfDays;
    if (extraDays == 0) {
      return range;
    } else {
      final adjustedEnd = range.end.add(Duration(days: numberOfDays - extraDays));
      return DateTimeRange(start: range.start, end: adjustedEnd);
    }
  }
}

class FreeScrollFunctions extends PageNavigationFunctions {
  FreeScrollFunctions({required super.dateTimeRange});

  @override
  DateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final adjustedRange = adjustedRangeAsUtc(location);

    // Add the index to the start date to get the date to display.
    final start = adjustedRange.start.add(Duration(days: index));
    final end = start.add(const Duration(days: 1));

    return DateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    final startOfDate = date.startOfDay.toUtc();
    final startOfRange = adjustedRangeAsUtc(location).start.toUtc();

    // Calculate the difference in days between the two dates.
    final days = startOfDate.difference(startOfRange).inDays;

    return days.clamp(0, numberOfPages(location));
  }

  @override
  int numberOfPages(Location? location) {
    final adjustedRangeUtc = adjustedRangeAsUtc(location).toUtc();
    return adjustedRangeUtc.end.difference(adjustedRangeUtc.start).inDays;
  }

  @override
  DateTimeRange<DateTime> adjustedRangeAsUtc(Location? location) => dateTimeRange.forLocation(location).asUtc;
}

class MonthPageFunctions extends PageNavigationFunctions {
  static const numberOfRows = 5;

  /// The first day of the week.
  final int firstDayOfWeek;

  MonthPageFunctions({required super.dateTimeRange, required this.firstDayOfWeek});

  @override
  DateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final adjustRangeStart = adjustedRangeAsUtc(location).start;
    final startOfMonth = adjustRangeStart.copyWith(month: adjustRangeStart.month + index);

    var start = startOfMonth.startOfWeek(firstDayOfWeek: firstDayOfWeek);
    if (start.isAfter(startOfMonth)) start = start.subtractDays(7);

    var end = start.addDays(DateTime.daysPerWeek * numberOfRows);
    if (end.isBefore(startOfMonth.endOfMonth)) end = start.addDays(DateTime.daysPerWeek * (numberOfRows + 1));

    return DateTimeRange(start: start, end: end).toUtc();
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    date = date.forLocation(location).startOfDay;
    final adjustedRange = adjustedRangeAsUtc(location);

    // TODO: Check if this is needed.
    // final dateAsUtc = date.startOfDay;
    // if (dateAsUtc.isBefore(adjustedRange.start) || dateAsUtc == adjustedRange.start) return 0;

    final dateTimeRange = DateTimeRange(start: adjustedRange.start, end: date);
    return dateTimeRange.monthDifference.clamp(0, numberOfPages(location));
  }

  /// Returns the number of rows that need to be displayed for the given [range].
  int numberOfRowsForRange(DateTimeRange range) {
    return range.dates().length ~/ DateTime.daysPerWeek;
  }

  @override
  int numberOfPages(Location? location) {
    final adjustedRange = adjustedRangeAsUtc(location);
    return adjustedRange.monthDifference;
  }

  @override
  DateTimeRange adjustedRangeAsUtc(Location? location) {
    final localRange = dateTimeRange.forLocation(location).asUtc;
    return DateTimeRange(start: localRange.start.startOfMonth, end: localRange.end.endOfMonth);
  }
}

class ContinuousSchedulePageFunctions extends PageNavigationFunctions {
  ContinuousSchedulePageFunctions({required super.dateTimeRange});

  @override
  DateTimeRange dateTimeRangeFromIndex(int index, Location? location) => adjustedRangeAsUtc(location);

  @override
  int indexFromDate(DateTime date, Location? location) => 0;

  @override
  int numberOfPages(Location? location) => 1;

  @override
  DateTimeRange adjustedRangeAsUtc(Location? location) {
    final localRange = dateTimeRange.forLocation(location).asUtc;
    return DateTimeRange(start: localRange.start.startOfDay, end: localRange.end.endOfDay);
  }
}

class PaginatedSchedulePageFunctions extends PageNavigationFunctions {
  PaginatedSchedulePageFunctions({required super.dateTimeRange});

  @override
  DateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final adjustedRange = adjustedRangeAsUtc(location);
    final start = DateTime(adjustedRange.start.year, adjustedRange.start.month + index, 1).endOfMonth;
    final end = start.endOfMonth;
    return DateTimeRange(start: start, end: end).toUtc();
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    final adjustedRange = adjustedRangeAsUtc(location);
    date = date.forLocation(location);
    final dateTimeRange = DateTimeRange(start: adjustedRange.start, end: date);
    return dateTimeRange.monthDifference.clamp(0, numberOfPages(location));
  }

  @override
  int numberOfPages(Location? location) {
    final adjustedRange = adjustedRangeAsUtc(location);
    return adjustedRange.monthDifference;
  }

  @override
  DateTimeRange adjustedRangeAsUtc(Location? location) {
    final localRange = dateTimeRange.forLocation(location).asUtc;
    return DateTimeRange(start: localRange.start.startOfMonth, end: localRange.end.endOfMonth);
  }
}

