import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/slot_size.dart';
import 'package:kalender/src/models/view_configurations/single_day_configurations/single_day_view_configuration.dart';

/// The [DayConfiguration] class contains the configuration for the [SingleDayView].
///
/// This class contains the functions required to calculate the [DateTimeRange]s and indexes of a [SingleDayView].
/// It also contains some configuration values that are used to calculate the layout of the [SingleDayView].
class DayConfiguration extends SingleDayViewConfiguration {
  const DayConfiguration({
    this.timelineWidth = 56,
    this.hourLineTimelineOverlap = 8,
    this.multidayTileHeight = 24,
    this.slotSize = const SlotSize(minutes: 15),
    this.eventSnapping = false,
    this.timeIndicatorSnapping = false,
    this.createNewEvents = true,
    this.verticalStepDuration = const Duration(minutes: 15),
    this.verticalSnapRange = const Duration(minutes: 15),
  });

  @override
  final double timelineWidth;

  @override
  final double hourLineTimelineOverlap;

  @override
  final double multidayTileHeight;

  @override
  final SlotSize slotSize;

  @override
  final Duration verticalStepDuration;

  @override
  final Duration verticalSnapRange;

  @override
  final bool eventSnapping;

  @override
  final bool timeIndicatorSnapping;

  @override
  final bool createNewEvents;

  @override
  DateTimeRange calculateVisibleDateTimeRange(
    DateTime date,
  ) {
    return date.dayRange;
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
    int? firstDayOfWeek,
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
    return date.difference(startDate).inDays;
  }

  @override
  int calculateIndex(
    DateTime calendarStart,
    DateTime visibleStart,
  ) {
    return visibleStart.difference(calendarStart).inDays;
  }

  @override
  int calculateNumberOfPages(
    DateTimeRange calendarDateTimeRange,
  ) {
    return calendarDateTimeRange.dayDifference;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
    int? firstDayOfWeek,
  }) {
    return calendarStart.add(Duration(days: index)).dayRange;
  }

  @override
  DateTime getHighlightedDate(DateTimeRange visibleDateRange) {
    return visibleDateRange.start;
  }

  @override
  String get name => 'Day';

  @override
  DateTimeRange regulateVisibleDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTimeRange visibleDateTimeRange,
  ) {
    if (visibleDateTimeRange.start.isBefore(dateTimeRange.start)) {
      return dateTimeRange.start.dayRange;
    } else if (visibleDateTimeRange.end.isAfter(dateTimeRange.end)) {
      return dateTimeRange.end.dayRange;
    }
    return visibleDateTimeRange;
  }

  DayConfiguration copyWith({
    double? timelineWidth,
    double? hourlineTimelineOverlap,
    double? multidayTileHeight,
    SlotSize? slotSize,
    bool? eventSnapping,
    bool? timeIndicatorSnapping,
    bool? createNewEvents,
    Duration? verticalStepDuration,
    Duration? verticalSnapRange,
  }) {
    return DayConfiguration(
      timelineWidth: timelineWidth ?? this.timelineWidth,
      hourLineTimelineOverlap:
          hourlineTimelineOverlap ?? this.hourLineTimelineOverlap,
      multidayTileHeight: multidayTileHeight ?? this.multidayTileHeight,
      slotSize: slotSize ?? this.slotSize,
      eventSnapping: eventSnapping ?? this.eventSnapping,
      timeIndicatorSnapping:
          timeIndicatorSnapping ?? this.timeIndicatorSnapping,
      createNewEvents: createNewEvents ?? this.createNewEvents,
      verticalStepDuration: verticalStepDuration ?? this.verticalStepDuration,
      verticalSnapRange: verticalSnapRange ?? this.verticalSnapRange,
    );
  }
}
