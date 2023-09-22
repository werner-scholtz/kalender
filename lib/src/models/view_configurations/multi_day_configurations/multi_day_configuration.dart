import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';

class MultiDayConfiguration extends MultiDayViewConfiguration {
  const MultiDayConfiguration({
    required this.name,
    this.numberOfDays = 3,
    this.timelineWidth = 56,
    this.hourLineTimelineOverlap = 8,
    this.multiDayTileHeight = 24,
    this.newEventDuration = const Duration(minutes: 15),
    this.paintWeekNumber = true,
    this.eventSnapping = false,
    this.timeIndicatorSnapping = false,
    this.createNewEvents = true,
    this.verticalStepDuration = const Duration(minutes: 15),
    this.verticalSnapRange = const Duration(minutes: 15),
  });

  @override
  final int numberOfDays;

  @override
  final double timelineWidth;

  @override
  final double hourLineTimelineOverlap;

  // TODO: Remove this
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
  final String name;

  @override
  final bool createNewEvents;

  @override
  int get firstDayOfWeek => 1;

  @override
  final Duration horizontalStepDuration = const Duration(days: 1);

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    return getMultiDayRange(date);
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
    int? firstDayOfWeek,
  }) {
    return DateTimeRange(
      start: visibleStart.startOfDay.subtract(
        Duration(
          days: (visibleStart.difference(dateTimeRange.start).inDays ~/
                      numberOfDays)
                  .ceil() *
              numberOfDays,
        ),
      ),
      end: visibleStart.startOfDay.add(
        Duration(
          days: (dateTimeRange.end.difference(visibleStart).inDays ~/
                      numberOfDays)
                  .ceil() *
              numberOfDays,
        ),
      ),
    );
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    return date.difference(startDate).inDays ~/ numberOfDays;
  }

  @override
  int calculateIndex(DateTime calendarStart, DateTime visibleStart) {
    return visibleStart.difference(calendarStart).inDays ~/ numberOfDays;
  }

  @override
  int calculateNumberOfPages(DateTimeRange calendarDateTimeRange) {
    return calendarDateTimeRange.dayDifference ~/ numberOfDays;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
    int? firstDayOfWeek,
  }) {
    return getMultiDayRange(
      DateTime(
        calendarStart.year,
        calendarStart.month,
        calendarStart.day + (index * numberOfDays),
      ),
    );
  }

  @override
  DateTimeRange regulateVisibleDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTimeRange visibleDateTimeRange,
  ) {
    if (visibleDateTimeRange.start.isBefore(dateTimeRange.start)) {
      return getMultiDayRange(dateTimeRange.start);
    } else if (visibleDateTimeRange.end.isAfter(dateTimeRange.end)) {
      return getMultiDayRange(dateTimeRange.end);
    }
    return visibleDateTimeRange;
  }

  /// Gets the four day range with the [DateTime] as the first day.
  DateTimeRange getMultiDayRange(DateTime date) {
    return DateTimeRange(
      start: date.startOfDay,
      end: date.endOfDay.add(
        Duration(days: numberOfDays - 1),
      ),
    );
  }

  MultiDayConfiguration copyWith({
    int? numberOfDays,
    double? timelineWidth,
    double? hourLineTimelineOverlap,
    double? multiDayTileHeight,
    Duration? newEventDuration,
    bool? paintWeekNumber,
    bool? eventSnapping,
    bool? timeIndicatorSnapping,
    bool? createNewEvents,
    Duration? verticalStepDuration,
    Duration? verticalSnapRange,
  }) {
    return MultiDayConfiguration(
      numberOfDays: numberOfDays ?? this.numberOfDays,
      timelineWidth: timelineWidth ?? this.timelineWidth,
      hourLineTimelineOverlap:
          hourLineTimelineOverlap ?? this.hourLineTimelineOverlap,
      multiDayTileHeight: multiDayTileHeight ?? this.multiDayTileHeight,
      newEventDuration: newEventDuration ?? this.newEventDuration,
      paintWeekNumber: paintWeekNumber ?? this.paintWeekNumber,
      eventSnapping: eventSnapping ?? this.eventSnapping,
      timeIndicatorSnapping:
          timeIndicatorSnapping ?? this.timeIndicatorSnapping,
      createNewEvents: createNewEvents ?? this.createNewEvents,
      verticalStepDuration: verticalStepDuration ?? this.verticalStepDuration,
      verticalSnapRange: verticalSnapRange ?? this.verticalSnapRange,
      name: name,
    );
  }
}
