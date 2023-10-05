import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class WorkWeekConfiguration extends MultiDayViewConfiguration {
  const WorkWeekConfiguration({
    this.timelineWidth = 56,
    this.hourLineTimelineOverlap = 8,
    this.multiDayTileHeight = 24,
    this.newEventDuration = const Duration(minutes: 15),
    this.paintWeekNumber = true,
    this.eventSnapping = true,
    this.timeIndicatorSnapping = true,
    this.createEvents = true,
    this.createMultiDayEvents = true,
    this.verticalStepDuration = const Duration(minutes: 15),
    this.verticalSnapRange = const Duration(minutes: 15),
    this.name = 'Work Week',
  });

  @override
  final int numberOfDays = 5;

  @override
  final double timelineWidth;

  @override
  final Duration horizontalStepDuration = const Duration(days: 1);

  @override
  final double hourLineTimelineOverlap;

  @override
  final Duration newEventDuration;

  @override
  final Duration verticalStepDuration;

  @override
  final Duration verticalSnapRange;

  @override
  final double multiDayTileHeight;

  @override
  final bool paintWeekNumber;

  @override
  final bool eventSnapping;

  @override
  final bool timeIndicatorSnapping;

  @override
  final int firstDayOfWeek = 1;

  @override
  final String name;

  @override
  final bool createEvents;

  @override
  final bool createMultiDayEvents;

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

  @override
  WorkWeekConfiguration copyWith({
    String? name,
    int? numberOfDays = 5,
    double? timelineWidth,
    double? hourLineTimelineOverlap,
    double? multiDayTileHeight,
    Duration? verticalStepDuration,
    Duration? verticalSnapRange,
    Duration? newEventDuration,
    bool? paintWeekNumber,
    bool? eventSnapping,
    bool? timeIndicatorSnapping,
    bool? createEvents,
    bool? createMultiDayEvents,
    // ignore: avoid_init_to_null
    int? firstDayOfWeek = null,
  }) {
    return WorkWeekConfiguration(
      timelineWidth: timelineWidth ?? this.timelineWidth,
      hourLineTimelineOverlap:
          hourLineTimelineOverlap ?? this.hourLineTimelineOverlap,
      multiDayTileHeight: multiDayTileHeight ?? this.multiDayTileHeight,
      newEventDuration: newEventDuration ?? this.newEventDuration,
      paintWeekNumber: paintWeekNumber ?? this.paintWeekNumber,
      eventSnapping: eventSnapping ?? this.eventSnapping,
      timeIndicatorSnapping:
          timeIndicatorSnapping ?? this.timeIndicatorSnapping,
      createEvents: createEvents ?? this.createEvents,
      verticalStepDuration: verticalStepDuration ?? this.verticalStepDuration,
      verticalSnapRange: verticalSnapRange ?? this.verticalSnapRange,
      name: name ?? this.name,
    );
  }
}
