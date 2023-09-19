import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';

class MonthConfiguration extends MonthViewConfiguration {
  const MonthConfiguration({
    this.firstDayOfWeek = 1,
    this.enableRezising = false,
    this.createNewEvents = true,
  });

  @override
  String get name => 'Month';

  @override
  final Duration horizontalDurationStep = const Duration(days: 1);

  @override
  final Duration verticalDurationStep = const Duration(days: 7);

  @override
  final int firstDayOfWeek;

  @override
  final bool enableRezising;

  @override
  final bool createNewEvents;

  MonthConfiguration copyWith({
    int? firstDayOfWeek,
    bool? enableRezising,
    bool? createNewEvents,
  }) {
    return MonthConfiguration(
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      enableRezising: enableRezising ?? this.enableRezising,
      createNewEvents: createNewEvents ?? this.createNewEvents,
    );
  }

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    final monthRange = date.monthRange;
    return DateTimeRange(
      start: monthRange.start.startOfWeekWithOffset(firstDayOfWeek),
      end: monthRange.end.endOfWeekWithOffset(firstDayOfWeek),
    );
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
  }) {
    return DateTimeRange(
      start: dateTimeRange.start.startOfMonth
          .startOfWeekWithOffset(firstDayOfWeek),
      end: dateTimeRange.end.endOfMonth.endOfWeekWithOffset(firstDayOfWeek),
    );
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    return DateTimeRange(start: startDate, end: date).monthDifference;
  }

  @override
  double calculateDayWidth(double pageWidth) {
    return (pageWidth / DateTime.daysPerWeek);
  }

  @override
  int calculateIndex(DateTime calendarStart, DateTime visibleStart) {
    return DateTimeRange(
      start: calendarStart,
      end: visibleStart,
    ).monthDifference;
  }

  @override
  int calculateNumberOfPages(DateTimeRange calendarDateTimeRange) {
    return calendarDateTimeRange.monthDifference;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
  }) {
    final monthRange = DateTime(
      calendarStart.year,
      calendarStart.month + index,
    ).monthRange;

    return DateTimeRange(
      start: monthRange.start.startOfWeekWithOffset(firstDayOfWeek),
      end: monthRange.end.endOfWeekWithOffset(firstDayOfWeek),
    );
  }

  @override
  DateTime getHighlightedDate(DateTimeRange visibleDateRange) {
    return visibleDateRange.centerDateTime.startOfMonth;
  }

  @override
  DateTimeRange regulateVisibleDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTimeRange visibleDateTimeRange,
  ) {
    if (visibleDateTimeRange.start.isBefore(dateTimeRange.start)) {
      return dateTimeRange.start.monthRange.start
          .weekRangeWithOffset(firstDayOfWeek);
    } else if (visibleDateTimeRange.end.isAfter(dateTimeRange.end)) {
      return dateTimeRange.end.monthRange.end
          .weekRangeWithOffset(firstDayOfWeek);
    }
    return visibleDateTimeRange;
  }
}
