import 'package:flutter/material.dart';
import 'package:kalender/src/models/view_configurations/month_view_configuration.dart';
import 'package:kalender/src/models/view_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

// TODO: these will also need to be refactored to work with TZDateTime and Locations.

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
  /// The start of the range this calculator operates within.
  ///
  /// This is provided by the user and defines the bounds for navigation and display.
  /// Note these bounds are not hard limits; the calendar may adjust them in certain circumstances.
  /// - The week view may extend the range to ensure full weeks are displayed.
  /// - The month view may adjust to show complete months.
  ///
  /// see [internalRange] for the adjusted range used in calculations.
  final DateTime start;

  /// The end of the range this calculator operates within.
  final DateTime end;

  /// Creates a [PageIndexCalculator] covering [start] to [end].
  const PageIndexCalculator({required this.start, required this.end});

  /// [start] and [end] resolved into [location], before a view adjusts them to
  /// its own page boundaries.
  @protected
  InternalDateTimeRange rawRange(Location? location) {
    return InternalDateTimeRange(
      start: InternalDateTime.fromExternal(start, location: location),
      end: InternalDateTime.fromExternal(end, location: location),
    );
  }

  /// Creates a [PageIndexCalculator] for a single day [MultiDayViewConfiguration.singleDay].
  factory PageIndexCalculator.singleDay(KalenderDateTimeRange dateTimeRange) {
    return DayIndexCalculator(start: dateTimeRange.start, end: dateTimeRange.end);
  }

  /// Creates a [PageIndexCalculator] for a week [MultiDayViewConfiguration.week].
  ///
  /// [daysToDisplay] shortens the page without changing the weekly pagination,
  /// so 6 shows Monday to Saturday on a week that still turns every 7 days.
  factory PageIndexCalculator.week(
    KalenderDateTimeRange dateTimeRange,
    int firstDayOfWeek, {
    int daysToDisplay = DateTime.daysPerWeek,
  }) {
    return WeekIndexCalculator(
      start: dateTimeRange.start,
      end: dateTimeRange.end,
      firstDayOfWeek: firstDayOfWeek,
      daysToDisplay: daysToDisplay,
    );
  }

  /// Creates a [PageIndexCalculator] for a work week [MultiDayViewConfiguration.workWeek].
  ///
  /// [daysToDisplay] shortens the page without changing the weekly pagination.
  factory PageIndexCalculator.workWeek(KalenderDateTimeRange dateTimeRange, {int daysToDisplay = 5}) {
    return WeekIndexCalculator(
      start: dateTimeRange.start,
      end: dateTimeRange.end,
      firstDayOfWeek: DateTime.monday,
      daysToDisplay: daysToDisplay,
    );
  }

  /// Creates a [PageIndexCalculator] for a month [MonthViewConfiguration.singleMonth].
  factory PageIndexCalculator.month(KalenderDateTimeRange dateTimeRange, int firstDayOfWeek) {
    return MonthIndexCalculator.fromRange(dateTimeRange, firstDayOfWeek);
  }

  /// Creates a [PageIndexCalculator] for a custom [MultiDayViewConfiguration.custom].
  factory PageIndexCalculator.custom(KalenderDateTimeRange dateTimeRange, int numberOfDays) {
    return CustomIndexCalculator(start: dateTimeRange.start, end: dateTimeRange.end, numberOfDays: numberOfDays);
  }

  /// Creates a [PageIndexCalculator] for a free scrolling [MultiDayViewConfiguration.freeScroll].
  ///
  /// The band scrolls continuously rather than paging, so an index is a day offset from the start of
  /// the range.
  factory PageIndexCalculator.freeScroll(KalenderDateTimeRange dateTimeRange) {
    return DayIndexCalculator(start: dateTimeRange.start, end: dateTimeRange.end);
  }

  /// Creates a [PageIndexCalculator] for a schedule [ContinuousScheduleIndexCalculator].
  factory PageIndexCalculator.scheduleContinuous(KalenderDateTimeRange dateTimeRange) {
    return ContinuousScheduleIndexCalculator(start: dateTimeRange.start, end: dateTimeRange.end);
  }

  /// Creates a [PageIndexCalculator] for a schedule [PaginatedScheduleIndexCalculator].
  factory PageIndexCalculator.schedulePaginated(KalenderDateTimeRange dateTimeRange) {
    return PaginatedScheduleIndexCalculator(start: dateTimeRange.start, end: dateTimeRange.end);
  }

  /// Calculates the VisibleDateRange from the [index].
  ///
  /// [index] is the page index.
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location);

  /// Calculates the page index of the [date].
  ///
  /// The returned index should be clamped between 0 and [numberOfPages] minus one.
  /// [numberOfPages] is a count, while page indices are zero-based, so the last
  /// valid index is `numberOfPages - 1`.
  int indexFromDate(DateTime date, Location? location);

  /// The number of pages that can be displayed.
  ///
  /// This is a count (starting at 1), not an index. The last valid page index is
  /// therefore `numberOfPages - 1`.
  int numberOfPages(Location? location);

  /// The adjusted range for a specific location.
  ///
  /// This range is intended to be used for calculations only.
  InternalDateTimeRange internalRange(Location? location);

  /// Returns the range that is displayed for the given [date].
  InternalDateTimeRange dateTimeRangeFromDate(InternalDateTime date, Location? location) {
    final index = indexFromDate(date, location);
    final range = dateTimeRangeFromIndex(index, location);
    return range;
  }
}

/// Calculates page indices and date ranges for a single day view.
class DayIndexCalculator extends PageIndexCalculator {
  /// Creates a [DayIndexCalculator] covering [start] to [end].
  DayIndexCalculator({required super.start, required super.end});

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
    final startOfDate = InternalDateTime.fromExternal(date, location: location);
    final startOfRange = internalRange(location).start;
    // Calculate the difference in days between the two dates.
    final days = startOfDate.difference(startOfRange).inDays;
    // Guard against an empty range (numberOfPages == 0), where numberOfPages - 1
    // would be a negative upper bound and make clamp throw.
    final pageCount = numberOfPages(location);
    return pageCount == 0 ? 0 : days.clamp(0, pageCount - 1);
  }

  @override
  int numberOfPages(Location? location) {
    final range = internalRange(location);
    return range.end.difference(range.start).inDays;
  }

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final internalRange = rawRange(location);
    final start = internalRange.start.startOfDay;
    final end = internalRange.end.isStartOfDay ? internalRange.end : internalRange.end.endOfDay;
    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DayIndexCalculator && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(DayIndexCalculator, start, end);
}

/// Calculates page indices and date ranges for a week view.
class WeekIndexCalculator extends PageIndexCalculator {
  /// The value to shift the start of week by to get the first day of the week.
  final int firstDayOfWeek;

  /// The number of days to display in a week view. Usually 7.
  ///
  /// Fewer than 7 shortens the page and leaves the pagination alone, so the page
  /// still turns every 7 days from [firstDayOfWeek]. More than 7 would make
  /// consecutive pages overlap.
  final int daysToDisplay;

  /// Creates a [WeekIndexCalculator] covering [start] to [end], [firstDayOfWeek], and [daysToDisplay].
  WeekIndexCalculator({
    required super.start,
    required super.end,
    required this.firstDayOfWeek,
    required this.daysToDisplay,
  }) : assert(
          daysToDisplay >= 1 && daysToDisplay <= DateTime.daysPerWeek,
          'daysToDisplay must be between 1 and 7, because a week view pages by whole weeks.\n'
          'Use CustomIndexCalculator for a page that is longer than a week.',
        );

  /// Creates a [WeekIndexCalculator] for a standard week view.
  WeekIndexCalculator.week({
    required super.start,
    required super.end,
    required this.firstDayOfWeek,
  }) : daysToDisplay = DateTime.daysPerWeek;

  /// Creates a [WeekIndexCalculator] for a work week view.
  WeekIndexCalculator.workWeek({required super.start, required super.end})
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
    final internalDate = InternalDateTime.fromExternal(date, location: location).startOfDay;
    // print('Date for index calculation: $date');
    final internalStartOfWeek = internalDate.startOfWeek(firstDayOfWeek: firstDayOfWeek);
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

    return index.round().clamp(0, numberOfPages(location) - 1);
  }

  @override
  int numberOfPages(Location? location) {
    final internalRange = this.internalRange(location);
    final numberOfPages = internalRange.end.difference(internalRange.start).inDays / DateTime.daysPerWeek;
    if (numberOfPages.round() != numberOfPages) {
      debugPrint('Warning: numberOfPages is not an integer: $numberOfPages');
    }
    return numberOfPages.round();
  }

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final internalRange = rawRange(location);
    final start = internalRange.start.startOfWeek(firstDayOfWeek: firstDayOfWeek);
    final end = internalRange.end.endOfWeek(firstDayOfWeek: firstDayOfWeek);
    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekIndexCalculator &&
          other.start == start &&
          other.end == end &&
          other.firstDayOfWeek == firstDayOfWeek &&
          other.daysToDisplay == daysToDisplay;

  @override
  int get hashCode => Object.hash(WeekIndexCalculator, start, end, firstDayOfWeek, daysToDisplay);
}

/// Calculates page indices and date ranges for a custom multi-day view.
class CustomIndexCalculator extends PageIndexCalculator {
  /// The number of days in each page.
  final int numberOfDays;

  /// Creates a [CustomIndexCalculator] covering [start] to [end] and [numberOfDays].
  CustomIndexCalculator({required super.start, required super.end, required this.numberOfDays});

  @override
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final internalRange = this.internalRange(location);
    final start = internalRange.start.add(Duration(days: index * numberOfDays));
    final end = start.add(Duration(days: numberOfDays));
    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    final startOfDate = InternalDateTime.fromExternal(date, location: location);
    final startOfDateUtc = startOfDate.startOfDay;
    final internalRange = this.internalRange(location);
    final index = startOfDateUtc.difference(internalRange.start).inDays ~/ numberOfDays;
    return index.clamp(0, numberOfPages(location) - 1);
  }

  @override
  int numberOfPages(Location? location) {
    final internalRange = this.internalRange(location);
    final numberOfDays = internalRange.end.difference(internalRange.start).inDays;
    return numberOfDays ~/ this.numberOfDays;
  }

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final internalRange = rawRange(location);

    final start = internalRange.start.startOfDay;
    final end =
        internalRange.end.startOfDay == internalRange.end ? internalRange.end.startOfDay : internalRange.end.endOfDay;
    final numberOfDaysInRange = end.difference(start).inDays;
    final extraDays = numberOfDaysInRange % numberOfDays;
    if (extraDays == 0) {
      return InternalDateTimeRange(start: start, end: end);
    } else {
      final adjustedEnd = end.add(Duration(days: numberOfDays - extraDays));
      return InternalDateTimeRange(start: start, end: adjustedEnd);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomIndexCalculator && other.start == start && other.end == end && other.numberOfDays == numberOfDays;

  @override
  int get hashCode => Object.hash(CustomIndexCalculator, start, end, numberOfDays);
}

/// Calculates page indices and date ranges for a month view.
class MonthIndexCalculator extends PageIndexCalculator {
  /// The default number of rows to display in a month view.
  static const numberOfRows = 5;

  /// The value to shift the start of week by to get the first day of the week.
  final int firstDayOfWeek;

  /// Creates a [MonthIndexCalculator] covering [start] to [end] and [firstDayOfWeek].
  MonthIndexCalculator({required super.start, required super.end, required this.firstDayOfWeek});

  /// Creates a [MonthIndexCalculator] covering [dateTimeRange] and [firstDayOfWeek].
  MonthIndexCalculator.fromRange(KalenderDateTimeRange dateTimeRange, this.firstDayOfWeek)
      : super(start: dateTimeRange.start, end: dateTimeRange.end);

  /// The first day of the focused month shown on the page at [index].
  ///
  /// This is the month the page represents; the grid also renders leading and
  /// trailing days from the adjacent months around it.
  InternalDateTime monthStartFromIndex(int index, Location? location) {
    final internalStart = internalRange(location).start;
    return InternalDateTime.fromDateTime(internalStart.copyWith(month: internalStart.month + index));
  }

  @override
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final startOfMonth = monthStartFromIndex(index, location);

    var start = startOfMonth.startOfWeek(firstDayOfWeek: firstDayOfWeek);
    if (start.isAfter(startOfMonth)) start = InternalDateTime.fromDateTime(start.subtract(const Duration(days: 7)));

    var end = start.add(const Duration(days: DateTime.daysPerWeek * numberOfRows));
    if (end.isBefore(startOfMonth.endOfMonth)) {
      end = start.add(const Duration(days: DateTime.daysPerWeek * (numberOfRows + 1)));
    }

    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    date = InternalDateTime.fromExternal(date, location: location).startOfDay;
    final internalRange = this.internalRange(location);
    final dateTimeRange = InternalDateTimeRange(start: internalRange.start, end: date);
    return dateTimeRange.monthDifference.clamp(0, numberOfPages(location) - 1);
  }

  /// Returns the number of rows that need to be displayed for the given [range].
  int numberOfRowsForRange(InternalDateTimeRange range) {
    return range.dates().length ~/ DateTime.daysPerWeek;
  }

  @override
  int numberOfPages(Location? location) {
    final internalRange = this.internalRange(location);
    return internalRange.monthDifference;
  }

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final internalRange = rawRange(location);
    final start = internalRange.start.startOfMonth;
    final end = internalRange.end.startOfMonth == internalRange.end
        ? internalRange.end.startOfMonth
        : internalRange.end.endOfMonth;
    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthIndexCalculator &&
          other.start == start &&
          other.end == end &&
          other.firstDayOfWeek == firstDayOfWeek;

  @override
  int get hashCode => Object.hash(MonthIndexCalculator, start, end, firstDayOfWeek);
}

/// Calculates page indices and date ranges for a continuous schedule view.
class ContinuousScheduleIndexCalculator extends PageIndexCalculator {
  /// Creates a [ContinuousScheduleIndexCalculator] covering [start] to [end].
  ContinuousScheduleIndexCalculator({required super.start, required super.end});

  @override
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location) => internalRange(location);

  @override
  int indexFromDate(DateTime date, Location? location) => 0;

  @override
  int numberOfPages(Location? location) => 1;

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final internalRange = rawRange(location);

    final start = internalRange.start.startOfDay;
    final end =
        internalRange.end.startOfDay == internalRange.end ? internalRange.end.startOfDay : internalRange.end.endOfDay;
    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ContinuousScheduleIndexCalculator && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(ContinuousScheduleIndexCalculator, start, end);
}

class PaginatedScheduleIndexCalculator extends PageIndexCalculator {
  PaginatedScheduleIndexCalculator({
    required super.start,
    required super.end,
  });

  @override
  InternalDateTimeRange dateTimeRangeFromIndex(int index, Location? location) {
    final internalRange = this.internalRange(location);
    final start = InternalDateTime(internalRange.start.year, internalRange.start.month + index, 1);
    final end = start.endOfMonth;
    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    date = InternalDateTime.fromExternal(date, location: location).startOfDay;
    final internalRange = this.internalRange(location);
    final dateTimeRange = InternalDateTimeRange(start: internalRange.start, end: date);
    return dateTimeRange.monthDifference.clamp(0, numberOfPages(location) - 1);
  }

  @override
  int numberOfPages(Location? location) {
    final internalRange = this.internalRange(location);
    return internalRange.monthDifference;
  }

  @override
  InternalDateTimeRange internalRange(Location? location) {
    final internalRange = rawRange(location);
    final start = internalRange.start.startOfMonth;
    final end = internalRange.end.startOfMonth == internalRange.end
        ? internalRange.end.startOfMonth
        : internalRange.end.endOfMonth;
    return InternalDateTimeRange(start: start, end: end);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PaginatedScheduleIndexCalculator && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(PaginatedScheduleIndexCalculator, start, end);
}
