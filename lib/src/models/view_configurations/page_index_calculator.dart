import 'package:flutter/material.dart';
import 'package:kalender/src/models/view_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// TODO: these will also need to be refactored to work with TZDateTime and Locations.

/// Calculates page indices and date ranges for paginated calendar views.
///
/// This class provides the logic to translate between dates and page indices
/// for different view types (day, week, month, schedule). It handles:
/// - Converting dates to page indices for navigation
/// - Calculating the date range displayed on a specific page
/// - Determining the total number of pages available
/// - Managing timezone-adjusted date ranges for calculations
///
/// Each view type (single day, week, month, etc.) has its own implementation
/// that defines how dates map to pages based on the view's structure.
///
/// **Note:** Internal calculations are performed in UTC. Use [InternalDateTime.forLocation]
/// to convert results to the appropriate timezone.
abstract class PageIndexCalculator {
  /// The overall date range that this calculator operates within.
  ///
  /// This is provided by the user and defines the bounds for navigation and display.
  /// Note these bounds are not hard limits; the calendar may adjust them in certain circumstances.
  /// - The week view may extend the range to ensure full weeks are displayed.
  /// - The month view may adjust to show complete months.
  ///
  /// see [internalRange] for the adjusted range used in calculations.
  final DateTimeRange dateTimeRange;

  /// Creates a [PageIndexCalculator] with the given [dateTimeRange].
  const PageIndexCalculator({required this.dateTimeRange});

  /// Creates a [PageIndexCalculator] for a single day [MultiDayViewConfiguration.singleDay].
  factory PageIndexCalculator.singleDay(DateTimeRange dateTimeRange) {
    return DayIndexCalculator(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageIndexCalculator] for a week [MultiDayViewConfiguration.week].
  factory PageIndexCalculator.week(DateTimeRange dateTimeRange, int firstDayOfWeek) {
    return WeekIndexCalculator.week(dateTimeRange: dateTimeRange, firstDayOfWeek: firstDayOfWeek);
  }

  /// Creates a [PageIndexCalculator] for a work week [MultiDayViewConfiguration.workWeek].
  factory PageIndexCalculator.workWeek(DateTimeRange dateTimeRange) {
    return WeekIndexCalculator.workWeek(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageIndexCalculator] for a custom [MultiDayViewConfiguration.custom].
  factory PageIndexCalculator.custom(DateTimeRange dateTimeRange, int numberOfDays) {
    return CustomIndexCalculator(dateTimeRange: dateTimeRange, numberOfDays: numberOfDays);
  }

  /// Creates a [PageIndexCalculator] for a single day [MultiDayViewConfiguration.freeScroll].
  factory PageIndexCalculator.freeScroll(DateTimeRange dateTimeRange) {
    return FreeScrollFunctions(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageIndexCalculator] for a schedule [ContinuousScheduleIndexCalculator].
  factory PageIndexCalculator.scheduleContinuous(DateTimeRange dateTimeRange) {
    return ContinuousScheduleIndexCalculator(dateTimeRange: dateTimeRange);
  }

  /// Creates a [PageIndexCalculator] for a schedule [PaginatedScheduleIndexCalculator].
  factory PageIndexCalculator.schedulePaginated(DateTimeRange dateTimeRange) {
    return PaginatedScheduleIndexCalculator(dateTimeRange: dateTimeRange);
  }

  /// Calculates the VisibleDateRange from the [index].
  ///
  /// [index] is the page index.
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location);

  /// Calculates the page index of the [date].
  ///
  /// The returned index should be clamped between 0 and the number of pages.
  int indexFromDate(DateTime date, Location? location);

  /// The number of pages that can be displayed.
  int numberOfPages(Location? location);

  /// The adjusted [DateTimeRange] for a specific location.
  ///
  /// This range is intended to be used for calculations only.
  InternalDateTimeRange internalRange(Location? location);

  /// Returns the [DateTimeRange] that is displayed for the given [date].
  InternalDateTimeRange dateTimeRangeFromDate(InternalDateTime date, Location? location) {
    final index = indexFromDate(date, location);
    final range = dateTimeRangeFromIndex(index, location);
    assert(range.isUtc);
    return range;
  }

  /// Returns the [DateTimeRange] that the calendar can display for the given [location].
  DateTimeRange displayRangeForLocation(Location? location) {
    final internalRange = this.internalRange(location);

    // TODO: This logic needs to be checked.
    return DateTimeRange(
      start: internalRange.start.forLocation(location),
      end: internalRange.end.forLocation(location),
    );
  }
}

/// Calculates page indices and date ranges for a single day view.
class DayIndexCalculator extends PageIndexCalculator {
  /// Creates a [DayIndexCalculator] with the given [dateTimeRange].
  DayIndexCalculator({required super.dateTimeRange});

  @override
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final internalRange = this.internalRange(location);
    // Add the index to the start date to get the date to display.
    final start = internalRange.start.add(Duration(days: index));
    final end = start.add(const Duration(days: 1));
    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    final startOfDate = date.forLocation(location: location).asUtc;
    final startOfRange = internalRange(location).start;
    // Calculate the difference in days between the two dates.
    final days = startOfDate.difference(startOfRange).inDays;
    return days.clamp(0, numberOfPages(location));
  }

  @override
  int numberOfPages(Location? location) {
    final range = internalRange(location);
    return range.end.difference(range.start).inDays;
  }

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final localRange = dateTimeRange.forLocation(location);
    final start = localRange.start.startOfDay;
    // final end = localRange.end.startOfDay == localRange.end ? localRange.end.startOfDay : localRange.end.endOfDay;
    final end = localRange.end.isStartOfDay ? localRange.end : localRange.end.endOfDay;
    return InternalDateTimeRange(start: start, end: end);
  }
}

/// Calculates page indices and date ranges for a week view.
class WeekIndexCalculator extends PageIndexCalculator {
  /// The value to shift the start of week by to get the first day of the week.
  final int firstDayOfWeek;

  /// The number of days to display in a week view. Usually 7.
  final int daysToDisplay;

  /// Creates a [WeekIndexCalculator] with the given [dateTimeRange], [firstDayOfWeek], and [daysToDisplay].
  WeekIndexCalculator({required super.dateTimeRange, required this.firstDayOfWeek, required this.daysToDisplay});

  /// Creates a [WeekIndexCalculator] for a standard week view.
  WeekIndexCalculator.week({
    required super.dateTimeRange,
    required this.firstDayOfWeek,
  }) : daysToDisplay = DateTime.daysPerWeek;

  /// Creates a [WeekIndexCalculator] for a work week view.
  WeekIndexCalculator.workWeek({required super.dateTimeRange})
      : firstDayOfWeek = DateTime.monday,
        daysToDisplay = 5;

  @override
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final internalRange = this.internalRange(location);
    final start = internalRange.start.copyWith(
      day: internalRange.start.day + (index * DateTime.daysPerWeek),
    );
    final end = start.add(Duration(days: daysToDisplay));

    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    // print('Date for index calculation: $date');
    final internalStartOfWeek = date.startOfWeek(firstDayOfWeek: firstDayOfWeek);
    final internalRange = this.internalRange(location);
    // print('Internal start of range: $internalStartOfWeek');

    // If the date provided start of week is before or equal to the adjusted range start, return 0.
    if (internalStartOfWeek.isBefore(internalRange.start) || internalStartOfWeek == internalRange.start) return 0;
    final range = InternalDateTimeRange(start: internalRange.start, end: internalStartOfWeek);
    // print(range.end.difference(range.start));
    // print(range.dates().length);
    final index = range.dates().length / DateTime.daysPerWeek;

    if (index.round() != index) {
      debugPrint('Warning: index is not an integer: $index');
    }

    return index.round().clamp(0, numberOfPages(location));
  }

  @override
  int numberOfPages(Location? location) {
    final internalRange = this.internalRange(location);
    final numberOfPages = internalRange.end.difference(internalRange.start).inDays / DateTime.daysPerWeek;
    if (numberOfPages.round() != numberOfPages) {
      debugPrint('Warning: numberOfPages is not an integer: $numberOfPages');
    }
    return (numberOfPages - 1).round();
  }

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final localRange = dateTimeRange.forLocation(location);
    final start = localRange.start.startOfWeek(firstDayOfWeek: firstDayOfWeek);
    final end = localRange.end.endOfWeek(firstDayOfWeek: firstDayOfWeek);
    return InternalDateTimeRange(start: start, end: end);
  }
}

/// Calculates page indices and date ranges for a custom multi-day view.
class CustomIndexCalculator extends PageIndexCalculator {
  /// The number of days in each page.
  final int numberOfDays;

  /// Creates a [CustomIndexCalculator] with the given [dateTimeRange] and [numberOfDays].
  CustomIndexCalculator({required super.dateTimeRange, required this.numberOfDays});

  @override
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final internalRange = this.internalRange(location);
    final start = internalRange.start.add(Duration(days: index * numberOfDays));
    final end = start.add(Duration(days: numberOfDays));
    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    final startOfDate = date.forLocation(location: location).asUtc;
    final startOfDateUtc = startOfDate.startOfDay;
    final internalRange = this.internalRange(location);
    final index = startOfDateUtc.difference(internalRange.start).inDays ~/ numberOfDays;
    return index.clamp(0, numberOfPages(location));
  }

  @override
  int numberOfPages(Location? location) {
    final internalRange = this.internalRange(location);
    final numberOfDays = internalRange.end.difference(internalRange.start).inDays;
    return (numberOfDays ~/ this.numberOfDays) - 1;
  }

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final localRange = dateTimeRange.forLocation(location).asUtc;
    final start = localRange.start.startOfDay;
    final end = localRange.end.startOfDay == localRange.end ? localRange.end.startOfDay : localRange.end.endOfDay;
    final numberOfDaysInRange = end.difference(start).inDays;
    final extraDays = numberOfDaysInRange % numberOfDays;
    if (extraDays == 0) {
      return InternalDateTimeRange(start: start, end: end);
    } else {
      final adjustedEnd = end.add(Duration(days: numberOfDays - extraDays));
      return InternalDateTimeRange(start: start, end: adjustedEnd);
    }
  }
}

/// TODO: see if this can be removed and replaced with [DayIndexCalculator].
class FreeScrollFunctions extends PageIndexCalculator {
  FreeScrollFunctions({required super.dateTimeRange});

  @override
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final internalRange = this.internalRange(location);
    // Add the index to the start date to get the date to display.
    final start = internalRange.start.add(Duration(days: index));
    final end = start.add(const Duration(days: 1));
    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    final startOfDate = date.forLocation(location: location).asUtc;
    final startOfRange = internalRange(location).start;
    // Calculate the difference in days between the two dates.
    final days = startOfDate.difference(startOfRange).inDays;
    return days.clamp(0, numberOfPages(location));
  }

  @override
  int numberOfPages(Location? location) {
    final range = internalRange(location);
    return range.end.difference(range.start).inDays;
  }

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final localRange = dateTimeRange.forLocation(location);
    final start = localRange.start.startOfDay;
    final end = localRange.end.endOfDay;
    return InternalDateTimeRange(start: start, end: end);
  }
}

/// Calculates page indices and date ranges for a month view.
class MonthIndexCalculator extends PageIndexCalculator {
  /// The default number of rows to display in a month view.
  static const numberOfRows = 5;

  /// The value to shift the start of week by to get the first day of the week.
  final int firstDayOfWeek;

  /// Creates a [MonthIndexCalculator] with the given [dateTimeRange] and [firstDayOfWeek].
  MonthIndexCalculator({required super.dateTimeRange, required this.firstDayOfWeek});

  @override
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final internalRange = this.internalRange(location);
    final internalStart = internalRange.start;
    final startOfMonth = internalStart.copyWith(month: internalStart.month + index);

    var start = startOfMonth.startOfWeek(firstDayOfWeek: firstDayOfWeek);
    if (start.isAfter(startOfMonth)) start = start.subtractDays(7);

    var end = start.addDays(DateTime.daysPerWeek * numberOfRows);
    if (end.isBefore(startOfMonth.endOfMonth)) end = start.addDays(DateTime.daysPerWeek * (numberOfRows + 1));

    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    date = date.forLocation(location: location).startOfDay.asUtc;
    final internalRange = this.internalRange(location);
    final dateTimeRange = DateTimeRange(start: internalRange.start, end: date);
    return dateTimeRange.monthDifference.clamp(0, numberOfPages(location));
  }

  /// Returns the number of rows that need to be displayed for the given [range].
  int numberOfRowsForRange(DateTimeRange range) {
    return range.dates().length ~/ DateTime.daysPerWeek;
  }

  @override
  int numberOfPages(Location? location) {
    final internalRange = this.internalRange(location);
    return internalRange.monthDifference - 1;
  }

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final localRange = dateTimeRange.forLocation(location).asUtc;
    final start = localRange.start.startOfMonth;
    final end = localRange.end.startOfMonth == localRange.end ? localRange.end.startOfMonth : localRange.end.endOfMonth;
    return InternalDateTimeRange(start: start, end: end);
  }
}

/// Calculates page indices and date ranges for a continuous schedule view.
class ContinuousScheduleIndexCalculator extends PageIndexCalculator {
  /// Creates a [ContinuousScheduleIndexCalculator] with the given [dateTimeRange].
  ContinuousScheduleIndexCalculator({required super.dateTimeRange});

  @override
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location) => internalRange(location);

  @override
  int indexFromDate(DateTime date, Location? location) => 0;

  @override
  int numberOfPages(Location? location) => 1;

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final localRange = dateTimeRange.forLocation(location).asUtc;
    final start = localRange.start.startOfDay;
    final end = localRange.end.startOfDay == localRange.end ? localRange.end.startOfDay : localRange.end.endOfDay;
    return InternalDateTimeRange(start: start, end: end);
  }
}

class PaginatedScheduleIndexCalculator extends PageIndexCalculator {
  PaginatedScheduleIndexCalculator({
    required super.dateTimeRange,
  });

  @override
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final internalRange = this.internalRange(location);
    final start = DateTime(internalRange.start.year, internalRange.start.month + index, 1);
    final end = start.endOfMonth;
    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    date = date.forLocation(location: location).asUtc;
    final internalRange = this.internalRange(location);
    final dateTimeRange = DateTimeRange(start: internalRange.start, end: date);
    return dateTimeRange.monthDifference.clamp(0, numberOfPages(location));
  }

  @override
  int numberOfPages(Location? location) {
    final internalRange = this.internalRange(location);
    return internalRange.monthDifference - 1;
  }

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final localRange = dateTimeRange.forLocation(location).asUtc;
    final start = localRange.start.startOfMonth;
    final end = localRange.end.startOfMonth == localRange.end ? localRange.end.startOfMonth : localRange.end.endOfMonth;
    return InternalDateTimeRange(start: start, end: end);
  }
}
