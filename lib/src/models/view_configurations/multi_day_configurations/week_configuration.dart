import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class WeekConfiguration extends MultiDayViewConfiguration {
  const WeekConfiguration({
    this.timelineWidth = 56,
    this.hourLineTimelineOverlap = 8,
    this.multiDayTileHeight = 24,
    this.newEventDuration = const Duration(minutes: 15),
    this.paintWeekNumber = true,
    this.eventSnapping = false,
    this.timeIndicatorSnapping = false,
    this.firstDayOfWeek = 1,
    this.createNewEvents = true,
    this.verticalStepDuration = const Duration(minutes: 15),
    this.verticalSnapRange = const Duration(minutes: 15),
  });

  @override
  final int numberOfDays = 7;

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
  final int firstDayOfWeek;

  @override
  final String name = 'Week';

  @override
  final bool createNewEvents;

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    return date.weekRangeWithOffset(firstDayOfWeek);
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
  double calculateDayWidth(double pageWidth) {
    return (pageWidth / DateTime.daysPerWeek);
  }

  @override
  int calculateIndex(DateTime calendarStart, DateTime visibleStart) {
    return (visibleStart.difference(calendarStart).inDays /
            DateTime.daysPerWeek)
        .floor();
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
    return DateTime(
      calendarStart.year,
      calendarStart.month,
      calendarStart.day + (index * DateTime.daysPerWeek),
    ).weekRangeWithOffset(firstDayOfWeek);
  }

  @override
  DateTime getHighlightedDate(DateTimeRange visibleDateRange) {
    return visibleDateRange.start;
  }

  @override
  DateTimeRange regulateVisibleDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTimeRange visibleDateTimeRange,
  ) {
    if (visibleDateTimeRange.start.isBefore(dateTimeRange.start)) {
      return dateTimeRange.start.weekRangeWithOffset(firstDayOfWeek);
    } else if (visibleDateTimeRange.end.isAfter(dateTimeRange.end)) {
      return dateTimeRange.end.weekRangeWithOffset(firstDayOfWeek);
    }
    return visibleDateTimeRange;
  }

  WeekConfiguration copyWith({
    double? timelineWidth,
    double? hourlineTimelineOverlap,
    double? multidayTileHeight,
    Duration? slotSize,
    bool? paintWeekNumber,
    bool? eventSnapping,
    bool? timeIndicatorSnapping,
    int? firstDayOfWeek,
    bool? createNewEvents,
    Duration? verticalStepDuration,
    Duration? verticalSnapRange,
  }) {
    return WeekConfiguration(
      timelineWidth: timelineWidth ?? this.timelineWidth,
      hourLineTimelineOverlap:
          hourlineTimelineOverlap ?? this.hourLineTimelineOverlap,
      multiDayTileHeight: multidayTileHeight ?? this.multiDayTileHeight,
      newEventDuration: slotSize ?? this.newEventDuration,
      paintWeekNumber: paintWeekNumber ?? this.paintWeekNumber,
      eventSnapping: eventSnapping ?? this.eventSnapping,
      timeIndicatorSnapping:
          timeIndicatorSnapping ?? this.timeIndicatorSnapping,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      createNewEvents: createNewEvents ?? this.createNewEvents,
      verticalStepDuration: verticalStepDuration ?? this.verticalStepDuration,
      verticalSnapRange: verticalSnapRange ?? this.verticalSnapRange,
    );
  }
}
