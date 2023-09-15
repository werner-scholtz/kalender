import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/slot_size.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class WorkWeekConfiguration extends MultiDayViewConfiguration {
  const WorkWeekConfiguration({
    this.timelineWidth = 56,
    this.hourlineTimelineOverlap = 8,
    this.multidayTileHeight = 24,
    this.slotSize = const SlotSize(minutes: 15),
    this.paintWeekNumber = true,
    this.eventSnapping = false,
    this.timeIndicatorSnapping = false,
    this.createNewEvents = true,
    this.verticalStepDuration = const Duration(minutes: 15),
    this.verticalSnapRange = const Duration(minutes: 15),
  });

  @override
  final double timelineWidth;

  @override
  final Duration horizontalDurationStep = const Duration(days: 1);

  @override
  final double hourlineTimelineOverlap;

  @override
  final SlotSize slotSize;

  @override
  final Duration verticalStepDuration;

  @override
  final Duration verticalSnapRange;

  @override
  final double multidayTileHeight;

  @override
  final bool paintWeekNumber;

  @override
  final bool eventSnapping;

  @override
  final bool timeIndicatorSnapping;

  @override
  final int firstDayOfWeek = 1;

  @override
  final String name = 'Work Week';

  @override
  final bool createNewEvents;

  @override
  DateTimeRange calcualteVisibleDateTimeRange(DateTime date) {
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
  double calculateDayWidth(double pageWidth) {
    return (pageWidth / 5);
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
  DateTime getHighlighedDate(DateTimeRange visibleDateRange) {
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

  WorkWeekConfiguration copyWith({
    double? timelineWidth,
    double? hourlineTimelineOverlap,
    double? multidayTileHeight,
    SlotSize? slotSize,
    bool? paintWeekNumber,
    bool? eventSnapping,
    bool? timeIndicatorSnapping,
    bool? createNewEvents,
    Duration? verticalStepDuration,
    Duration? verticalSnapRange,
  }) {
    return WorkWeekConfiguration(
      timelineWidth: timelineWidth ?? this.timelineWidth,
      hourlineTimelineOverlap:
          hourlineTimelineOverlap ?? this.hourlineTimelineOverlap,
      multidayTileHeight: multidayTileHeight ?? this.multidayTileHeight,
      slotSize: slotSize ?? this.slotSize,
      paintWeekNumber: paintWeekNumber ?? this.paintWeekNumber,
      eventSnapping: eventSnapping ?? this.eventSnapping,
      timeIndicatorSnapping:
          timeIndicatorSnapping ?? this.timeIndicatorSnapping,
      createNewEvents: createNewEvents ?? this.createNewEvents,
      verticalStepDuration: verticalStepDuration ?? this.verticalStepDuration,
      verticalSnapRange: verticalSnapRange ?? this.verticalSnapRange,
    );
  }
}
