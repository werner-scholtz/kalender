import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class WeekConfiguration extends MultiDayViewConfiguration {
  WeekConfiguration({
    this.name = 'Week',
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
    super.firstDayOfWeek,
  }) {
    super.numberOfDays = 7;
  }

  @override
  final String name;

  @override
  int get numberOfDays => 7;

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    return date.weekRangeWithOffset(firstDayOfWeek);
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
  }) {
    final start = dateTimeRange.start;

    final closetsStart = firstDayOfWeek >= 4
        ? start.subtractDays(start.weekday + (7 - firstDayOfWeek))
        : start.subtractDays(start.weekday - firstDayOfWeek);

    final dayDifference = dateTimeRange.dayDifference;
    final remained = dayDifference % numberOfDays;
    final end = start.addDays((dayDifference - remained));

    final adjustDateTimeRange = DateTimeRange(
      start: closetsStart,
      end: end,
    );

    return adjustDateTimeRange;
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
    final dateTime = DateTime(
      calendarStart.year,
      calendarStart.month,
      calendarStart.day + (index * DateTime.daysPerWeek),
    );

    return dateTime.weekRangeWithOffset(firstDayOfWeek);
  }
}
