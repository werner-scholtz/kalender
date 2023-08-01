import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class WeekConfiguration extends MultiDayViewConfiguration {
  const WeekConfiguration({
    this.timelineWidth = 56,
    this.hourlineTimelineOverlap = 8,
    this.multidayTileHeight = 24,
    this.minuteSlotSize = SlotSize.minute15,
    this.verticalDurationStep = const Duration(minutes: 15),
    this.horizontalDurationStep = const Duration(days: 1),
    this.paintWeekNumber = true,
    this.eventSnapping = false,
    this.timeIndicatorSnapping = false,
    this.firstDayOfWeek = 1,
  });
  @override
  final double timelineWidth;

  @override
  final Duration verticalDurationStep;

  @override
  final Duration horizontalDurationStep;

  @override
  final double hourlineTimelineOverlap;

  @override
  final SlotSize minuteSlotSize;

  @override
  final double multidayTileHeight;

  @override
  final bool paintWeekNumber;

  @override
  final bool eventSnapping;

  @override
  final bool timeIndicatorSnapping;

  @override
  final int firstDayOfWeek;

  @override
  final String name = 'Week';

  @override
  DateTimeRange calcualteVisibleDateTimeRange(DateTime date, int firstDayOfWeek) {
    return date.weekRangeWithOffset(firstDayOfWeek);
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
    int? firstDayOfWeek,
  }) {
    return DateTimeRange(
      start: dateTimeRange.start.startOfWeekWithOffset(firstDayOfWeek ?? 1),
      end: dateTimeRange.end.endOfWeekWithOffset(firstDayOfWeek ?? 1),
    );
  }

  // @override
  // DateTimeRange calculateAdjustedDateTimeRange(
  //   DateTimeRange dateTimeRange,
  //   DateTime visibleStart,
  //   int firstDayOfWeek,
  // ) {
  //   return DateTimeRange(
  //     start: dateTimeRange.start.startOfWeekWithOffset(firstDayOfWeek),
  //     end: dateTimeRange.end.endOfWeekWithOffset(firstDayOfWeek),
  //   );
  // }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    return date.difference(startDate).inDays ~/ DateTime.daysPerWeek;
  }

  @override
  double calculateDayWidth(double pageWidth) {
    return (pageWidth / DateTime.daysPerWeek);
  }

  @override
  int calculateIndex(DateTime calendarStart, DateTime visibleStart) {
    return (visibleStart.difference(calendarStart).inDays / DateTime.daysPerWeek).floor();
  }

  @override
  int calculateNumberOfPages(DateTimeRange calendarDateTimeRange) {
    return calendarDateTimeRange.dayDifference ~/ DateTime.daysPerWeek;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
    int? firstDayOfWeek,
  }) {
    return DateTime(
      calendarStart.year,
      calendarStart.month,
      calendarStart.day + (index * DateTime.daysPerWeek),
    ).weekRangeWithOffset(firstDayOfWeek ?? 1);
  }

  @override
  DateTime getHighlighedDate(DateTimeRange visibleDateRange) {
    return visibleDateRange.start;
  }

  @override
  DateTimeRange regulateVisibleDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTimeRange visibleDateTimeRange,
    int firstDayOfWeek,
  ) {
    if (visibleDateTimeRange.start.isBefore(dateTimeRange.start)) {
      return dateTimeRange.start.weekRangeWithOffset(firstDayOfWeek);
    } else if (visibleDateTimeRange.end.isAfter(dateTimeRange.end)) {
      return dateTimeRange.end.weekRangeWithOffset(firstDayOfWeek);
    }
    return visibleDateTimeRange;
  }
}
