import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class WorkWeekConfiguration extends MultiDayViewConfiguration {
  WorkWeekConfiguration({
    // this.timelineWidth = 56,
    // this.daySeparatorLeftOffset = 8,
    // this.multiDayTileHeight = 24,
    // this.newEventDuration = const Duration(minutes: 15),
    // this.paintWeekNumber = true,
    // this.eventSnapping = true,
    // this.timeIndicatorSnapping = true,
    // this.createEvents = true,
    // this.createMultiDayEvents = true,
    // this.verticalStepDuration = const Duration(minutes: 15),
    // this.verticalSnapRange = const Duration(minutes: 15),
    this.name = 'Work Week',
    super.timelineWidth = 56,
    super.daySeparatorLeftOffset = 8,
    super.multiDayTileHeight = 24,
    super.paintWeekNumber = true,
    super.eventSnapping = false,
    super.timeIndicatorSnapping = false,
    super.createEvents = true,
    super.createMultiDayEvents = true,
    super.verticalStepDuration = const Duration(minutes: 15),
    super.verticalSnapRange = const Duration(minutes: 15),
    super.horizontalStepDuration = const Duration(days: 1),
    super.newEventDuration = const Duration(minutes: 15),
  }) {
    super.numberOfDays = 5;
  }

  @override
  final String name;

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    final weekRange = date.weekRangeWithOffset(firstDayOfWeek);
    return DateTimeRange(
      start: weekRange.start,
      end: weekRange.end.subtract(
        const Duration(days: 2),
      ),
    );
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
  }) {
    return DateTimeRange(
      start: dateTimeRange.start.startOfWeekWithOffset(firstDayOfWeek),
      end: dateTimeRange.end.endOfWeekWithOffset(firstDayOfWeek),
    );
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    return date.difference(startDate).inDays ~/ DateTime.daysPerWeek;
  }

  @override
  int calculateNumberOfPages(DateTimeRange calendarDateTimeRange) {
    return calendarDateTimeRange.dayDifference ~/ DateTime.daysPerWeek;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
  }) {
    final weekRange = DateTime(
      calendarStart.year,
      calendarStart.month,
      calendarStart.day + (index * DateTime.daysPerWeek),
    ).weekRangeWithOffset(firstDayOfWeek);

    return DateTimeRange(
      start: weekRange.start,
      end: weekRange.end.subtract(
        const Duration(days: 2),
      ),
    );
  }
}
