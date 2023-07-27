import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

class DayConfiguration extends SingleDayViewConfiguration {
  const DayConfiguration();

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
  double calculateDayWidth(
    double pageWidth,
  ) {
    return pageWidth;
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
    // TODO: implement calculateVisibleDateRangeForIndex
    throw UnimplementedError();
  }

  @override
  DateTime getHighlighedDate(DateTimeRange visibleDateRange) {
    // TODO: implement getHighlighedDate
    throw UnimplementedError();
  }

  @override
  String get name => 'Day';

  @override
  DateTimeRange regulateVisibleDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTimeRange visibleDateTimeRange,
    int firstDayOfWeek,
  ) {
    // TODO: implement regulateVisibleDateTimeRange
    throw UnimplementedError();
  }
}
