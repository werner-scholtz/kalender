import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';

class CustomMultiDayConfiguration extends MultiDayViewConfiguration {
  const CustomMultiDayConfiguration({
    required this.name,
    this.numberOfDays = 3,
    this.timelineWidth = 56,
    this.daySeparatorLeftOffset = 8,
    this.multiDayTileHeight = 24,
    this.newEventDuration = const Duration(minutes: 15),
    this.paintWeekNumber = true,
    this.eventSnapping = true,
    this.timeIndicatorSnapping = true,
    this.createMultiDayEvents = true,
    this.createEvents = true,
    this.enableResizing = true,
    this.enableRescheduling = true,
    this.verticalStepDuration = const Duration(minutes: 15),
    this.verticalSnapRange = const Duration(minutes: 15),
  });

  @override
  final int numberOfDays;

  @override
  final double timelineWidth;

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
  final String name;

  @override
  final bool createMultiDayEvents;

  @override
  final bool createEvents;

  @override
  final bool enableRescheduling;

  @override
  final bool enableResizing;

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

  /// Gets the four day range with the [DateTime] as the first day.
  DateTimeRange getMultiDayRange(DateTime date) {
    return DateTimeRange(
      start: date.startOfDay,
      end: date.endOfDay.add(
        Duration(days: numberOfDays - 1),
      ),
    );
  }

  @override
  CustomMultiDayConfiguration copyWith({
    String? name,
    int? numberOfDays,
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
    return CustomMultiDayConfiguration(
      numberOfDays: numberOfDays ?? this.numberOfDays,
      timelineWidth: timelineWidth ?? this.timelineWidth,
      daySeparatorLeftOffset:
          daySeparatorLeftOffset ?? this.daySeparatorLeftOffset,
      multiDayTileHeight: multiDayTileHeight ?? this.multiDayTileHeight,
      newEventDuration: newEventDuration ?? this.newEventDuration,
      paintWeekNumber: paintWeekNumber ?? this.paintWeekNumber,
      eventSnapping: eventSnapping ?? this.eventSnapping,
      timeIndicatorSnapping:
          timeIndicatorSnapping ?? this.timeIndicatorSnapping,
      createMultiDayEvents: createMultiDayEvents ?? this.createMultiDayEvents,
      createEvents: createEvents ?? this.createEvents,
      verticalStepDuration: verticalStepDuration ?? this.verticalStepDuration,
      verticalSnapRange: verticalSnapRange ?? this.verticalSnapRange,
      name: name ?? this.name,
      enableRescheduling: enableRescheduling ?? this.enableRescheduling,
      enableResizing: enableResizing ?? this.enableResizing,
    );
  }
}
