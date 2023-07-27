import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class FourDayConfiguration extends MultiDayViewConfiguration {
  const FourDayConfiguration({
    this.timelineWidth = 56,
    this.hourlineTimelineOverlap = 8,
    this.multidayTileHeight = 24,
    this.minuteSlotSize = SlotSize.minute15,
    this.verticalDurationStep = const Duration(minutes: 15),
    this.horizontalDurationStep = const Duration(days: 1),
    this.paintWeekNumber = true,
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
  final String name = 'Four Day';

  @override
  DateTimeRange calcualteVisibleDateTimeRange(DateTime date, int firstDayOfWeek) {
    return date.fourDayRange;
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTime visibleStart,
    int firstDayOfWeek,
  ) {
    return DateTimeRange(
      start: visibleStart.startOfDay.subtract(
        Duration(days: (visibleStart.difference(dateTimeRange.start).inDays ~/ 4).ceil() * 4),
      ),
      end: visibleStart.startOfDay.add(
        Duration(days: (dateTimeRange.end.difference(visibleStart).inDays ~/ 4).ceil() * 4),
      ),
    );
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    return date.difference(startDate).inDays ~/ 4;
  }

  @override
  double calculateDayWidth(double pageWidth) {
    return (pageWidth / 4);
  }

  @override
  int calculateIndex(DateTime calendarStart, DateTime visibleStart) {
    return visibleStart.difference(calendarStart).inDays ~/ 4;
  }

  @override
  int calculateNumberOfPages(DateTimeRange calendarDateTimeRange) {
    return calendarDateTimeRange.dayDifference ~/ 4;
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
      calendarStart.day + (index * 4),
    ).fourDayRange;
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
      return dateTimeRange.start.fourDayRange;
    } else if (visibleDateTimeRange.end.isAfter(dateTimeRange.end)) {
      return dateTimeRange.end.fourDayRange;
    }
    return visibleDateTimeRange;
  }
}
