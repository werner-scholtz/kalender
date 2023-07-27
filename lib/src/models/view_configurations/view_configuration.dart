import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';

/// This is the base class for all [ViewConfiguration]s.
///
///
abstract class ViewConfiguration {
  const ViewConfiguration();

  /// The [ViewType] of this [ViewConfiguration].
  /// This determines which [CalendarView] is used.
  ///
  /// [ViewType.singleDay]
  /// [ViewType.multiDay]
  /// [ViewType.month]
  /// [ViewType.schedule]
  ViewType get viewType;

  /// The name of the [ViewConfiguration].
  String get name;

  /// Calculates the width of each day.
  double calculateDayWidth(
    double pageWidth,
  );

  /// Returns the visible[DateTimeRange] for the [index].
  ///
  /// [calendarStart] is the start of the calendar.
  /// [firstDayOfWeek] is the first day of the week.
  DateTimeRange calculateVisibleDateRangeForIndex(
    int index,
    DateTime calendarStart,
    int firstDayOfWeek,
  );

  /// Calculates the index of the [visibleStart]
  ///
  /// [calendarStart] is the start of the calendar.
  int calculateIndex(
    DateTime calendarStart,
    DateTime visibleStart,
  );

  /// Regulates the [visibleDateTimeRange] to be within the [dateTimeRange].
  ///
  /// [dateTimeRange] is the range of the calendar.
  /// [visibleDateTimeRange] is the visible range of the calendar.
  /// [firstDayOfWeek] is the first day of the week.
  DateTimeRange regulateVisibleDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTimeRange visibleDateTimeRange,
    int firstDayOfWeek,
  );

  /// Calculates the number of pages for the [calendarDateTimeRange].
  int calculateNumberOfPages(
    DateTimeRange calendarDateTimeRange,
  );

  /// Calculates the visible [DateTimeRange] form the [date].
  ///
  /// [firstDayOfWeek] is the first day of the week.
  DateTimeRange calcualteVisibleDateTimeRange(
    DateTime date,
    int firstDayOfWeek,
  );

  /// Calculates the adjusted [dateTimeRange].
  /// This adjusts the [dateTimeRange] so it aligns with the visible dateTimeRange.
  ///
  /// [dateTimeRange] is the range of the calendar.
  /// [visibleStart] is the date that is highlighted.
  /// [firstDayOfWeek] is the first day of the week.
  DateTimeRange calculateAdjustedDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTime visibleStart,
    int firstDayOfWeek,
  );

  /// Calculates the index of the given [date].
  ///
  /// [startDate] is the start date of the calendar.
  int calculateDateIndex(
    DateTime date,
    DateTime startDate,
  );

  /// Returns the new highlighted date.
  ///
  /// [visibleDateRange] is the visible date range.
  DateTime getHighlighedDate(
    DateTimeRange visibleDateRange,
  );
}


/// This is the base class for all [ViewType.month]
abstract class MonthViewConfiguration implements ViewConfiguration {
  const MonthViewConfiguration();

  @override
  final ViewType viewType = ViewType.month;
}

/// This is the base class for all [ViewType.schedule]
abstract class ScheduleViewConfiguration implements ViewConfiguration {
  const ScheduleViewConfiguration();

  @override
  final ViewType viewType = ViewType.schedule;
}
