import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class WorkWeekConfiguration extends MultiDayViewConfiguration {
  WorkWeekConfiguration({
    this.name = 'Work Week',
    super.timelineWidth = 56,
    super.daySeparatorLeftOffset = 8,
    super.hourLineLeftMargin = 56,
    super.multiDayTileHeight = 24,
    super.showWeekNumber = true,
    super.eventSnapping = false,
    super.timeIndicatorSnapping = false,
    super.createEvents = true,
    super.createMultiDayEvents = true,
    super.verticalStepDuration = const Duration(minutes: 15),
    super.verticalSnapRange = const Duration(minutes: 15),
    super.horizontalStepDuration = const Duration(days: 1),
    super.newEventDuration = const Duration(minutes: 15),
    super.enableRescheduling = true,
    super.enableResizing = true,
    super.startHour = 0,
    super.endHour = 24,
    super.initialHeightPerMinute,
    super.createEventTrigger,
    super.showDayHeader,
    super.showMultiDayHeader,
  }) {
    super.numberOfDays = 5;
  }

  @override
  final String name;

  @override
  int get numberOfDays => 5;

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
  }) {
    return DateTimeRange(
      start: dateTimeRange.start.startOfWeekWithOffset(firstDayOfWeek),
      end: dateTimeRange.end.endOfWeekWithOffset(firstDayOfWeek),
    );
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    final dateUtc = DateTime.utc(
      date.year,
      date.month,
      date.day,
    );
    final startDateUTC = DateTime.utc(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    return dateUtc.difference(startDateUTC).inDays ~/ DateTime.daysPerWeek;
  }

  @override
  int calculateNumberOfPages(DateTimeRange adjustedDateTimeRange) {
    return adjustedDateTimeRange.dayDifference ~/ DateTime.daysPerWeek;
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
