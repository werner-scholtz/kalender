import 'package:flutter/material.dart';

/// This is the base class for all [ViewConfiguration]s.
///
/// It contains all the methods that are used to calculate:
/// * The layout of the calendar.
/// * The visible date range and indices.
abstract class ViewConfiguration {
  const ViewConfiguration();

  /// The name of the [ViewConfiguration].
  String get name;

  /// Can create new events.
  bool get createNewEvents;

  /// Calculates the width of each day.
  double calculateDayWidth(
    double pageWidth,
  );

  /// Returns the visible[DateTimeRange] for the [index].
  ///
  /// [calendarStart] is the start of the calendar.
  /// [firstDayOfWeek] is the first day of the week.
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
  });

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
  );

  /// Calculates the number of pages for the [calendarDateTimeRange].
  int calculateNumberOfPages(
    DateTimeRange calendarDateTimeRange,
  );

  /// Calculates the visible [DateTimeRange] form the [date].
  ///
  /// [firstDayOfWeek] is the first day of the week.
  DateTimeRange calculateVisibleDateTimeRange(
    DateTime date,
  );

  /// Calculates the adjusted [dateTimeRange].
  /// This adjusts the [dateTimeRange] so it aligns with the visible dateTimeRange.
  ///
  /// [dateTimeRange] is the range of the calendar.
  /// [visibleStart] is the date that is highlighted.
  /// [firstDayOfWeek] is the first day of the week.
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
  });

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
  DateTime getHighlightedDate(
    DateTimeRange visibleDateRange,
  );
}
