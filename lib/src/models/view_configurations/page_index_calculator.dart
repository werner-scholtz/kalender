// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/view_configurations/month_view_configuration.dart';
import 'package:kalender/src/models/view_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// Calculates page indices and date ranges for paginated calendar views.
///
/// Each view type has its own implementation that maps dates to pages. Calculations are performed in UTC. Use
/// [FloatingDateTime.forLocation] to convert results to a location.
///
/// {@category Views}
abstract class PageIndexCalculator {
  /// The start of the range, before a view aligns it to its page boundaries. See [floatingRange].
  final DateTime start;

  /// The end of the range this calculator operates within.
  final DateTime end;

  const PageIndexCalculator({required this.start, required this.end});

  /// [start] and [end] resolved into [location], before a view adjusts them to
  /// its own page boundaries.
  @protected
  FloatingDateTimeRange rawRange(Location? location) {
    return FloatingDateTimeRange(
      start: FloatingDateTime.fromExternal(start, location: location),
      end: FloatingDateTime.fromExternal(end, location: location),
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
  FloatingDateTimeRange rangeFromIndex(int index, Location? location);

  /// Calculates the page index of the [date].
  ///
  /// The returned index should be clamped between 0 and [numberOfPages] minus one.
  int indexFromDate(DateTime date, Location? location);

  /// The number of pages that can be displayed.
  ///
  /// Page indices are zero-based, so the last valid index is `numberOfPages - 1`.
  int numberOfPages(Location? location);

  /// The adjusted range for a specific location.
  ///
  /// This range is intended to be used for calculations only.
  FloatingDateTimeRange floatingRange(Location? location);

  /// Returns the range that is displayed for the given [date].
  FloatingDateTimeRange rangeFromDate(FloatingDateTime date, Location? location) {
    final index = indexFromDate(date, location);
    final range = rangeFromIndex(index, location);
    return range;
  }
}

/// Calculates page indices and date ranges for a single day view.
///
/// {@category Views}
class DayIndexCalculator extends PageIndexCalculator {
  DayIndexCalculator({required super.start, required super.end});

  @override
  FloatingDateTimeRange rangeFromIndex(int index, Location? location) {
    final floatingRange = this.floatingRange(location);
    final start = floatingRange.start.add(Duration(days: index));
    final end = start.add(const Duration(days: 1));
    return FloatingDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    final startOfDate = FloatingDateTime.fromExternal(date, location: location);
    final startOfRange = floatingRange(location).start;
    final days = startOfDate.difference(startOfRange).inDays;
    // Guard against an empty range (numberOfPages == 0), where numberOfPages - 1
    // would be a negative upper bound and make clamp throw.
    final pageCount = numberOfPages(location);
    return pageCount == 0 ? 0 : days.clamp(0, pageCount - 1);
  }

  @override
  int numberOfPages(Location? location) {
    final range = floatingRange(location);
    return range.end.difference(range.start).inDays;
  }

  @override
  FloatingDateTimeRange floatingRange(Location? location) => _wholeDays(rawRange(location));

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DayIndexCalculator && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(DayIndexCalculator, start, end);
}

/// Calculates page indices and date ranges for a week view.
///
/// {@category Views}
class WeekIndexCalculator extends PageIndexCalculator {
  /// The value to shift the start of week by to get the first day of the week.
  final int firstDayOfWeek;

  /// The number of days to display in a week view. Usually 7.
  ///
  /// Fewer than 7 shortens the page and leaves the pagination alone, so the page
  /// still turns every 7 days from [firstDayOfWeek]. More than 7 would make
  /// consecutive pages overlap.
  final int daysToDisplay;

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
  WeekIndexCalculator.week({required super.start, required super.end, required this.firstDayOfWeek})
    : daysToDisplay = DateTime.daysPerWeek;

  /// Creates a [WeekIndexCalculator] for a work week view.
  WeekIndexCalculator.workWeek({required super.start, required super.end})
    : firstDayOfWeek = DateTime.monday,
      daysToDisplay = 5;

  @override
  FloatingDateTimeRange rangeFromIndex(int index, Location? location) {
    final floatingRange = this.floatingRange(location);
    final start = floatingRange.start.copyWith(day: floatingRange.start.day + (index * DateTime.daysPerWeek));
    final end = start.add(Duration(days: daysToDisplay));

    return FloatingDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    final floatingDate = FloatingDateTime.fromExternal(date, location: location).startOfDay;
    final floatingStartOfWeek = floatingDate.startOfWeek(firstDayOfWeek: firstDayOfWeek);
    final floatingRange = this.floatingRange(location);

    if (!floatingStartOfWeek.isAfter(floatingRange.start)) return 0;
    final range = FloatingDateTimeRange(start: floatingRange.start, end: floatingStartOfWeek);
    final index = range.dates().length ~/ DateTime.daysPerWeek;
    return index.clamp(0, numberOfPages(location) - 1);
  }

  @override
  int numberOfPages(Location? location) {
    final floatingRange = this.floatingRange(location);
    return floatingRange.end.difference(floatingRange.start).inDays ~/ DateTime.daysPerWeek;
  }

  @override
  FloatingDateTimeRange floatingRange(Location? location) {
    final floatingRange = rawRange(location);
    final start = floatingRange.start.startOfWeek(firstDayOfWeek: firstDayOfWeek);
    final end = floatingRange.end.endOfWeek(firstDayOfWeek: firstDayOfWeek);
    return FloatingDateTimeRange(start: start, end: end);
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
///
/// {@category Views}
class CustomIndexCalculator extends PageIndexCalculator {
  /// The number of days in each page.
  final int numberOfDays;

  CustomIndexCalculator({required super.start, required super.end, required this.numberOfDays});

  @override
  FloatingDateTimeRange rangeFromIndex(int index, Location? location) {
    final floatingRange = this.floatingRange(location);
    final start = floatingRange.start.add(Duration(days: index * numberOfDays));
    final end = start.add(Duration(days: numberOfDays));
    return FloatingDateTimeRange(start: start, end: end);
  }

  @override
  int indexFromDate(DateTime date, Location? location) {
    final startOfDate = FloatingDateTime.fromExternal(date, location: location);
    final startOfDateUtc = startOfDate.startOfDay;
    final floatingRange = this.floatingRange(location);
    final index = startOfDateUtc.difference(floatingRange.start).inDays ~/ numberOfDays;
    return index.clamp(0, numberOfPages(location) - 1);
  }

  @override
  int numberOfPages(Location? location) {
    final floatingRange = this.floatingRange(location);
    final numberOfDays = floatingRange.end.difference(floatingRange.start).inDays;
    return numberOfDays ~/ this.numberOfDays;
  }

  @override
  FloatingDateTimeRange floatingRange(Location? location) {
    final range = _wholeDays(rawRange(location));
    final extraDays = range.end.difference(range.start).inDays % numberOfDays;
    if (extraDays == 0) return range;
    return FloatingDateTimeRange(
      start: range.start,
      end: range.end.add(Duration(days: numberOfDays - extraDays)),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomIndexCalculator && other.start == start && other.end == end && other.numberOfDays == numberOfDays;

  @override
  int get hashCode => Object.hash(CustomIndexCalculator, start, end, numberOfDays);
}

/// Calculates page indices and date ranges for a month view.
///
/// {@category Views}
class MonthIndexCalculator extends PageIndexCalculator with _MonthPages {
  /// The default number of rows to display in a month view.
  static const numberOfRows = 5;

  /// The value to shift the start of week by to get the first day of the week.
  final int firstDayOfWeek;

  MonthIndexCalculator({required super.start, required super.end, required this.firstDayOfWeek});

  MonthIndexCalculator.fromRange(KalenderDateTimeRange dateTimeRange, this.firstDayOfWeek)
    : super(start: dateTimeRange.start, end: dateTimeRange.end);

  /// The first day of the focused month shown on the page at [index].
  ///
  /// This is the month the page represents; the grid also renders leading and
  /// trailing days from the adjacent months around it.
  FloatingDateTime monthStartFromIndex(int index, Location? location) {
    final floatingStart = floatingRange(location).start;
    return FloatingDateTime.fromDateTime(floatingStart.copyWith(month: floatingStart.month + index));
  }

  @override
  FloatingDateTimeRange rangeFromIndex(int index, Location? location) {
    final startOfMonth = monthStartFromIndex(index, location);

    var start = startOfMonth.startOfWeek(firstDayOfWeek: firstDayOfWeek);
    if (start.isAfter(startOfMonth)) start = FloatingDateTime.fromDateTime(start.subtract(const Duration(days: 7)));

    var end = start.add(const Duration(days: DateTime.daysPerWeek * numberOfRows));
    if (end.isBefore(startOfMonth.endOfMonth)) {
      end = start.add(const Duration(days: DateTime.daysPerWeek * (numberOfRows + 1)));
    }

    return FloatingDateTimeRange(start: start, end: end);
  }

  /// Returns the number of rows that need to be displayed for the given [range].
  int numberOfRowsForRange(FloatingDateTimeRange range) {
    return range.dates().length ~/ DateTime.daysPerWeek;
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
///
/// {@category Views}
class ContinuousScheduleIndexCalculator extends PageIndexCalculator {
  ContinuousScheduleIndexCalculator({required super.start, required super.end});

  @override
  FloatingDateTimeRange rangeFromIndex(int index, Location? location) => floatingRange(location);

  @override
  int indexFromDate(DateTime date, Location? location) => 0;

  @override
  int numberOfPages(Location? location) => 1;

  @override
  FloatingDateTimeRange floatingRange(Location? location) => _wholeDays(rawRange(location));

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ContinuousScheduleIndexCalculator && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(ContinuousScheduleIndexCalculator, start, end);
}

/// Calculates page indices and date ranges for a paginated schedule view.
///
/// {@category Views}
class PaginatedScheduleIndexCalculator extends PageIndexCalculator with _MonthPages {
  PaginatedScheduleIndexCalculator({required super.start, required super.end});

  @override
  FloatingDateTimeRange rangeFromIndex(int index, Location? location) {
    final floatingRange = this.floatingRange(location);
    final start = FloatingDateTime(floatingRange.start.year, floatingRange.start.month + index, 1);
    final end = start.endOfMonth;
    return FloatingDateTimeRange(start: start, end: end);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PaginatedScheduleIndexCalculator && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(PaginatedScheduleIndexCalculator, start, end);
}

/// One page per month, from the first month of the range to the last.
mixin _MonthPages on PageIndexCalculator {
  @override
  int indexFromDate(DateTime date, Location? location) {
    final day = FloatingDateTime.fromExternal(date, location: location);
    final start = floatingRange(location).start;
    final lastPage = numberOfPages(location) - 1;
    if (lastPage < 0) return 0;
    final months = (day.year - start.year) * DateTime.monthsPerYear + day.month - start.month;
    return months.clamp(0, lastPage);
  }

  @override
  int numberOfPages(Location? location) => floatingRange(location).monthDifference;

  @override
  FloatingDateTimeRange floatingRange(Location? location) {
    final range = rawRange(location);
    final end = range.end.startOfMonth == range.end ? range.end : range.end.endOfMonth;
    return FloatingDateTimeRange(start: range.start.startOfMonth, end: end);
  }
}

FloatingDateTimeRange _wholeDays(FloatingDateTimeRange range) {
  final end = range.end.isStartOfDay ? range.end : range.end.endOfDay;
  return FloatingDateTimeRange(start: range.start.startOfDay, end: end);
}
