import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extentions.dart';

class MonthConfiguration extends MonthViewConfiguration {
  const MonthConfiguration();
  
  @override
  String get name => 'Month';

  @override
  DateTimeRange calcualteVisibleDateTimeRange(DateTime date, int firstDayOfWeek) {
    DateTimeRange monthRange = date.monthRange;
    return DateTimeRange(
      start: monthRange.start.startOfWeekWithOffset(firstDayOfWeek),
      end: monthRange.end.endOfWeekWithOffset(firstDayOfWeek),
    );
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTime visibleStart,
    int firstDayOfWeek,
  ) {
    return DateTimeRange(
      start: dateTimeRange.start.startOfMonth.startOfWeekWithOffset(firstDayOfWeek),
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
  DateTimeRange calculateVisibleDateRangeForIndex(
    int index,
    DateTime calendarStart,
    int firstDayOfWeek,
  ) {
    DateTimeRange monthRange = DateTime(
      calendarStart.year,
      calendarStart.month + index,
      calendarStart.day,
    ).monthRange;

    return DateTimeRange(
      start: monthRange.start.startOfWeekWithOffset(firstDayOfWeek),
      end: monthRange.end.endOfWeekWithOffset(firstDayOfWeek),
    );
  }

  @override
  DateTime getHighlighedDate(DateTimeRange visibleDateRange) {
    return visibleDateRange.centerDateTime.startOfMonth;
  }

  @override
  DateTimeRange regulateVisibleDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTimeRange visibleDateTimeRange,
    int firstDayOfWeek,
  ) {
    if (visibleDateTimeRange.start.isBefore(dateTimeRange.start)) {
      return dateTimeRange.start.monthRange.start.weekRangeWithOffset(firstDayOfWeek);
    } else if (visibleDateTimeRange.end.isAfter(dateTimeRange.end)) {
      return dateTimeRange.end.monthRange.end.weekRangeWithOffset(firstDayOfWeek);
    }
    return visibleDateTimeRange;
  }
}
