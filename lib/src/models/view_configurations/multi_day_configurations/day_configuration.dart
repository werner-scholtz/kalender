import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';

/// The [DayConfiguration] class contains the configuration for the [MultiDayView].
///
/// This class contains the functions required to calculate the [DateTimeRange]s and indexes of a [MultiDayView].
/// It also contains some configuration values that are used to layout of the [MultiDayView].
class DayConfiguration extends MultiDayViewConfiguration
    implements ViewConfiguration {
  DayConfiguration({
    this.name = 'Day',
    super.timelineWidth = 56,
    super.hourLineLeftMargin = 56,
    super.daySeparatorLeftOffset = 8,
    super.eventSnapping = false,
    super.timeIndicatorSnapping = false,
    super.createEvents = true,
    super.createMultiDayEvents = true,
    super.multiDayTileHeight = 24,
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
    super.numberOfDays = 1;
    super.firstDayOfWeek = 1;
    super.showWeekNumber = false;
  }

  @override
  final String name;

  @override
  int get numberOfDays => 1;

  @override
  int get firstDayOfWeek => 1;

  @override
  bool get showWeekNumber => false;

  @override
  DateTimeRange calculateVisibleDateTimeRange(
    DateTime date,
  ) {
    return date.dayRange;
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
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

    return dateUtc.difference(startDateUTC).inDays;
  }

  @override
  int calculateNumberOfPages(
    DateTimeRange adjustedDateTimeRange,
  ) {
    return adjustedDateTimeRange.dayDifference;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
    int? firstDayOfWeek,
  }) {
    return calendarStart.addDays(index).dayRange;
  }
}
