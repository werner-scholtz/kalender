import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

class DayConfiguration extends SingleDayViewConfiguration {
  const DayConfiguration({
    this.timelineWidth = 56,
    this.hourlineTimelineOverlap = 8,
  });

  @override
  DateTimeRange calcualteVisibleDateTimeRange(
    DateTime date,
    int firstDayOfWeek,
  ) {
    return date.dayRange;
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTime visibleStart,
    int firstDayOfWeek,
  ) {
    return DateTimeRange(
      start: dateTimeRange.start.startOfDay,
      end: dateTimeRange.end.endOfDay,
    );
  }

  @override
  int calculateDateIndex(
    DateTime date,
    DateTime startDate,
  ) {
    return date.difference(startDate).inDays;
  }

  @override
  int calculateIndex(
    DateTime calendarStart,
    DateTime visibleStart,
  ) {
    return visibleStart.difference(calendarStart).inDays;
  }

  @override
  int calculateNumberOfPages(
    DateTimeRange calendarDateTimeRange,
  ) {
    return calendarDateTimeRange.dayDifference;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex(
    int index,
    DateTime calendarStart,
    int firstDayOfWeek,
  ) {
    return calendarStart.add(Duration(days: index)).dayRange;
  }

  @override
  DateTime getHighlighedDate(DateTimeRange visibleDateRange) {
    return visibleDateRange.start;
  }

  @override
  String get name => 'Day';

  @override
  DateTimeRange regulateVisibleDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTimeRange visibleDateTimeRange,
    int firstDayOfWeek,
  ) {
    if (visibleDateTimeRange.start.isBefore(dateTimeRange.start)) {
      return dateTimeRange.start.dayRange;
    } else if (visibleDateTimeRange.end.isAfter(dateTimeRange.end)) {
      return dateTimeRange.end.dayRange;
    }
    return visibleDateTimeRange;
  }

  @override
  final double timelineWidth;

  @override
  final double hourlineTimelineOverlap;
}
