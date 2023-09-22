import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/schedule_configurations/schedule_view_configuration.dart';

class ScheduleConfiguration extends ScheduleViewConfiguration {
  const ScheduleConfiguration();

  @override
  String get name => 'Schedule';

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
  }) {
    return DateTimeRange(
      start: dateTimeRange.start.startOfMonth,
      end: dateTimeRange.end.endOfMonth,
    );
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    return DateTimeRange(start: startDate, end: date).monthDifference;
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
    return DateTime(
      calendarStart.year,
      calendarStart.month + index,
    ).monthRange;
  }

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    final monthRange = date.monthRange;
    return DateTimeRange(
      start: monthRange.start,
      end: monthRange.end,
    );
  }

  @override
  DateTimeRange regulateVisibleDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTimeRange visibleDateTimeRange,
  ) {
    if (visibleDateTimeRange.start.isBefore(dateTimeRange.start)) {
      return dateTimeRange.start.monthRange;
    } else if (visibleDateTimeRange.end.isAfter(dateTimeRange.end)) {
      return dateTimeRange.end.monthRange;
    }
    return visibleDateTimeRange;
  }
}
