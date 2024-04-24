import 'package:flutter/material.dart';

/// This is the base class for all [ViewConfiguration]s.
///
/// It contains all the methods that are used to calculate:
/// * The visible date range and indices.
abstract class ViewConfiguration with ChangeNotifier {
  ViewConfiguration();

  /// The name of the [ViewConfiguration].
  String get name;

  /// Returns the visible[DateTimeRange] for the [index].
  ///
  /// [calendarStart] is the start of the calendar.
  /// [firstDayOfWeek] is the first day of the week.
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
  });

  /// Calculates the number of pages for the [adjustedDateTimeRange].
  int calculateNumberOfPages(
    DateTimeRange adjustedDateTimeRange,
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
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
  });

  /// Calculates the index of the given [date].
  ///
  /// [startDate] is the start date of the calendar.
  int calculateDateIndex(
    DateTime date,
    DateTime startDate,
  );
}
