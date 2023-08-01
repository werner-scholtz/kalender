import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extentions.dart';

class DayConfiguration extends SingleDayViewConfiguration {
  const DayConfiguration({
    this.timelineWidth = 56,
    this.hourlineTimelineOverlap = 8,
    this.multidayTileHeight = 24,
    this.verticalDurationStep = const Duration(minutes: 15),
    this.minuteSlotSize = SlotSize.minute15,
    this.eventSnapping = false,
    this.timeIndicatorSnapping = false,
  });

  @override
  final double timelineWidth;

  @override
  final double hourlineTimelineOverlap;

  @override
  final Duration verticalDurationStep;

  @override
  final double multidayTileHeight;

  @override
  final SlotSize minuteSlotSize;

  @override
  final bool eventSnapping;

  @override
  final bool timeIndicatorSnapping;

  @override
  DateTimeRange calcualteVisibleDateTimeRange(
    DateTime date,
    int firstDayOfWeek,
  ) {
    return date.dayRange;
  }

  // @override
  // DateTimeRange calculateAdjustedDateTimeRange({
  //   required DateTimeRange dateTimeRange,
  //   required DateTime visibleStart,
  //   required int firstDayOfWeek,
  // }) {
  // return DateTimeRange(
  //   start: dateTimeRange.start.startOfDay,
  //   end: dateTimeRange.end.endOfDay,
  // );
  // }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
    int? firstDayOfWeek,
  }) {
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
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
    int? firstDayOfWeek,
  }) {
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
}
