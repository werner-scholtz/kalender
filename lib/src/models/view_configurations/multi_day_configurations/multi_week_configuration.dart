import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class MultiWeekConfiguration extends MultiDayViewConfiguration {
  const MultiWeekConfiguration({
    this.timelineWidth = 56,
    this.daySeparatorLeftOffset = 8,
    this.multiDayTileHeight = 24,
    this.newEventDuration = const Duration(minutes: 15),
    this.paintWeekNumber = true,
    this.eventSnapping = true,
    this.timeIndicatorSnapping = true,
    this.firstDayOfWeek = 1,
    this.createEvents = true,
    this.createMultiDayEvents = true,
    this.enableResizing = true,
    this.enableRescheduling = true,
    this.verticalStepDuration = const Duration(minutes: 15),
    this.verticalSnapRange = const Duration(minutes: 15),
    this.name = 'Multi Week',
    this.numberOfWeeks = 2,
  });

  final int numberOfWeeks;

  @override
  int get numberOfDays => numberOfWeeks * 7;

  @override
  final double timelineWidth;

  @override
  final Duration horizontalStepDuration = const Duration(days: 1);

  @override
  final double daySeparatorLeftOffset;

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
  final String name;

  @override
  final bool createEvents;

  @override
  final bool createMultiDayEvents;

  @override
  final bool enableRescheduling;

  @override
  final bool enableResizing;

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    final start = date.startOfWeekWithOffset(firstDayOfWeek);
    final end = start.add(Duration(days: numberOfDays));

    final dateTimeRange = DateTimeRange(
      start: start,
      end: end,
    );

    return dateTimeRange;
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
  }) {
    final normalizedDateTimeRange = DateTimeRange(
      start: dateTimeRange.start.startOfWeekWithOffset(firstDayOfWeek),
      end: dateTimeRange.end.endOfWeekWithOffset(firstDayOfWeek),
    );

    final numberOfFullPages =
        (normalizedDateTimeRange.duration.inDays / numberOfDays).ceil();

    final start = normalizedDateTimeRange.start;
    final end = start.add(Duration(days: numberOfFullPages * numberOfDays));

    final adjustedDateTimeRange = DateTimeRange(
      start: start,
      end: end,
    );

    return adjustedDateTimeRange;
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    final index = date.difference(startDate).inDays ~/ numberOfDays;
    return index;
  }

  @override
  int calculateNumberOfPages(DateTimeRange calendarDateTimeRange) {
    final numberOfPages = calendarDateTimeRange.dayDifference ~/ numberOfDays;

    return numberOfPages;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
  }) {
    final start = DateTime(
      calendarStart.year,
      calendarStart.month,
      calendarStart.day + (index * numberOfDays),
    );

    final end = start.add(Duration(days: numberOfDays));

    return DateTimeRange(
      start: start,
      end: end,
    );
  }

  @override
  MultiWeekConfiguration copyWith({
    String? name,
    int? numberOfWeeks,
    int? numberOfDays = 7,
    double? timelineWidth,
    double? daySeparatorLeftOffset,
    double? multiDayTileHeight,
    Duration? verticalStepDuration,
    Duration? verticalSnapRange,
    Duration? newEventDuration,
    bool? paintWeekNumber,
    bool? eventSnapping,
    bool? timeIndicatorSnapping,
    int? firstDayOfWeek,
    bool? createEvents,
    bool? createMultiDayEvents,
    bool? enableRescheduling,
    bool? enableResizing,
  }) {
    return MultiWeekConfiguration(
      timelineWidth: timelineWidth ?? this.timelineWidth,
      daySeparatorLeftOffset:
          daySeparatorLeftOffset ?? this.daySeparatorLeftOffset,
      multiDayTileHeight: multiDayTileHeight ?? this.multiDayTileHeight,
      newEventDuration: newEventDuration ?? this.newEventDuration,
      paintWeekNumber: paintWeekNumber ?? this.paintWeekNumber,
      eventSnapping: eventSnapping ?? this.eventSnapping,
      timeIndicatorSnapping:
          timeIndicatorSnapping ?? this.timeIndicatorSnapping,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      createEvents: createEvents ?? this.createEvents,
      createMultiDayEvents: createMultiDayEvents ?? this.createMultiDayEvents,
      verticalStepDuration: verticalStepDuration ?? this.verticalStepDuration,
      verticalSnapRange: verticalSnapRange ?? this.verticalSnapRange,
      name: name ?? this.name,
      enableRescheduling: enableRescheduling ?? this.enableRescheduling,
      enableResizing: enableResizing ?? this.enableResizing,
    );
  }
}
