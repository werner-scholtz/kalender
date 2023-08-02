import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/day_header.dart';
import 'package:kalender/src/components/general/day_seperator.dart';
import 'package:kalender/src/components/general/hour_line.dart';
import 'package:kalender/src/components/general/schedule_date.dart';
import 'package:kalender/src/components/general/time_line.dart';
import 'package:kalender/src/components/general/week_number.dart';
import 'package:kalender/src/typedefs.dart';

/// This class is used to provide the tile components for the calendar.
class CalendarTileComponents<T extends Object?> {
  const CalendarTileComponents({
    this.eventTileBuilder,
    this.monthEventTileBuilder,
    this.scheduleEventTileBuilder,
    this.multiDayEventTileBuilder,
  });

  ///
  final EventTileBuilder<T>? eventTileBuilder;

  ///
  final MonthEventTileBuilder<T>? monthEventTileBuilder;

  ///
  final ScheduleEventTileBuilder<T>? scheduleEventTileBuilder;

  ///
  final MultiDayEventTileBuilder<T>? multiDayEventTileBuilder;
}

/// This class is used to provide the components for the calendar.
///
/// Custom component builders can be provided to the [CalendarComponents].
class CalendarComponents {
  CalendarComponents({
    this.calendarHeaderBuilder,
    DayHeaderBuilder? dayHeaderBuilder,
    WeekNumberBuilder? weekNumberBuilder,
    HourlineBuilder? hourlineBuilder,
    TimelineBuilder? timelineBuilder,
    DaySepratorBuilder? daySepratorBuilder,
    ScheduleDateBuilder? scheduleDateBuilder,
  }) {
    this.dayHeaderBuilder = dayHeaderBuilder ?? _defaultDayHeaderBuilder;
    this.weekNumberBuilder = weekNumberBuilder ?? _defaultWeekNumberBuilder;
    this.hourlineBuilder = hourlineBuilder ?? _defaultHourLineBuilder;
    this.timelineBuilder = timelineBuilder ?? _defaultTimelineBuilder;
    this.daySepratorBuilder = daySepratorBuilder ?? _defaultDaySeperatorBuilder;
    this.scheduleDateBuilder = scheduleDateBuilder ?? _defaultScheduleDateBuilder;
  }

  ///
  late CalendarHeaderBuilder? calendarHeaderBuilder;

  ///
  late DayHeaderBuilder dayHeaderBuilder;

  ///
  late WeekNumberBuilder weekNumberBuilder;

  ///
  late HourlineBuilder hourlineBuilder;

  ///
  late TimelineBuilder timelineBuilder;

  ///
  late DaySepratorBuilder daySepratorBuilder;

  ///
  late ScheduleDateBuilder scheduleDateBuilder;

  Widget _defaultTimelineBuilder(
    double timelineWidth,
    double height,
    double hourHeight,
  ) {
    return Timeline(
      timelineWidth: timelineWidth,
      height: height,
      hourHeight: hourHeight,
    );
  }

  Widget _defaultHourLineBuilder(
    double pageWidth,
    double hourHeight,
  ) {
    return HourLine(
      hourlineWidth: pageWidth,
      hourHeight: hourHeight,
    );
  }

  Widget _defaultDaySeperatorBuilder(
    double pageHeight,
    double dayWidth,
    int numberOfDays,
  ) {
    return DaySeperator(
      dayWidth: dayWidth,
      pageHeight: pageHeight,
      numberOfDays: numberOfDays,
    );
  }

  Widget _defaultDayHeaderBuilder(
    DateTime date,
    Function(DateTime date)? onTapped,
  ) {
    return DayHeader(
      date: date,
      onTapped: onTapped,
    );
  }

  Widget _defaultWeekNumberBuilder(
    DateTimeRange visibleDateRange,
  ) {
    return WeekNumber(
      visibleDateRange: visibleDateRange,
    );
  }

  Widget _defaultScheduleDateBuilder(
    DateTime date,
    void Function(DateTime date) onDateTapped,
  ) {
    return ScheduleDate(
      date: date,
      onDateTapped: onDateTapped,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarComponents &&
        other.calendarHeaderBuilder == calendarHeaderBuilder &&
        other.dayHeaderBuilder == dayHeaderBuilder &&
        other.weekNumberBuilder == weekNumberBuilder &&
        other.hourlineBuilder == hourlineBuilder &&
        other.timelineBuilder == timelineBuilder &&
        other.daySepratorBuilder == daySepratorBuilder &&
        other.scheduleDateBuilder == scheduleDateBuilder;
  }

  @override
  int get hashCode => Object.hash(
        calendarHeaderBuilder,
        dayHeaderBuilder,
        weekNumberBuilder,
        hourlineBuilder,
        timelineBuilder,
        daySepratorBuilder,
        scheduleDateBuilder,
      );
}
