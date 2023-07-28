import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class ThreeDayConfiguration extends MultiDayViewConfiguration {
  const ThreeDayConfiguration({
    this.timelineWidth = 56,
    this.hourlineTimelineOverlap = 8,
    this.multidayTileHeight = 24,
    this.minuteSlotSize = SlotSize.minute15,
    this.verticalDurationStep = const Duration(minutes: 15),
    this.horizontalDurationStep = const Duration(days: 1),
    this.paintWeekNumber = true,
        this.eventSnapping = false,
    this.timeIndicatorSnapping = false,
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
  final String name = 'Three Day';

  @override
  DateTimeRange calcualteVisibleDateTimeRange(DateTime date, int firstDayOfWeek) {
    return date.threeDayRange;
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTime visibleStart,
    int firstDayOfWeek,
  ) {
    return DateTimeRange(
      start: visibleStart.startOfDay.subtract(
        Duration(days: (visibleStart.difference(dateTimeRange.start).inDays ~/ 3).ceil() * 3),
      ),
      end: visibleStart.startOfDay.add(
        Duration(days: (dateTimeRange.end.difference(visibleStart).inDays ~/ 3).ceil() * 3),
      ),
    );
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    return date.difference(startDate).inDays ~/ 3;
  }

  @override
  double calculateDayWidth(double pageWidth) {
    return (pageWidth / 3);
  }

  @override
  int calculateIndex(DateTime calendarStart, DateTime visibleStart) {
    return visibleStart.difference(calendarStart).inDays ~/ 3;
  }

  @override
  int calculateNumberOfPages(DateTimeRange calendarDateTimeRange) {
    return calendarDateTimeRange.dayDifference ~/ 3;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex(
    int index,
    DateTime calendarStart,
    int firstDayOfWeek,
  ) {
    return DateTime(
      calendarStart.year,
      calendarStart.month,
      calendarStart.day + (index * 3),
    ).threeDayRange;
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
      return dateTimeRange.start.threeDayRange;
    } else if (visibleDateTimeRange.end.isAfter(dateTimeRange.end)) {
      return dateTimeRange.end.threeDayRange;
    }
    return visibleDateTimeRange;
  }
}
