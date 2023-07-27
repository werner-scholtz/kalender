import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/calendar_header.dart';
import 'package:kalender/src/components/general/day_header.dart';
import 'package:kalender/src/components/general/day_seperator.dart';
import 'package:kalender/src/components/general/hour_line.dart';
import 'package:kalender/src/components/general/schedule_date.dart';
import 'package:kalender/src/components/general/time_line.dart';
import 'package:kalender/src/components/general/week_number.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/typedefs.dart';

class CalendarComponents<T extends Object?> {
  CalendarComponents({
    required this.eventTileBuilder,
    required this.monthEventTileBuilder,
    required this.scheduleEventTileBuilder,
    required this.multiDayEventTileBuilder,
    CalendarHeaderBuilder? calendarHeaderBuilder,
    DayHeaderBuilder? dayHeaderBuilder,
    WeekNumberBuilder? weekNumberBuilder,
    HourlineBuilder? hourlineBuilder,
    TimelineBuilder? timelineBuilder,
    DaySepratorBuilder? daySepratorBuilder,
    ScheduleDateBuilder? scheduleDateBuilder,
  }) {
    this.calendarHeaderBuilder = calendarHeaderBuilder ?? _defualtCalendarHeaderBuilder;
    this.dayHeaderBuilder = dayHeaderBuilder ?? _defaultDayHeaderBuilder;
    this.weekNumberBuilder = weekNumberBuilder ?? _defaultWeekNumberBuilder;
    this.hourlineBuilder = hourlineBuilder ?? _defaultHourLineBuilder;
    this.timelineBuilder = timelineBuilder ?? _defaultTimelineBuilder;
    this.daySepratorBuilder = daySepratorBuilder ?? _defaultDaySeperatorBuilder;
    this.scheduleDateBuilder = scheduleDateBuilder ?? _defaultScheduleDateBuilder;
  }

  ///
  late CalendarHeaderBuilder<T> calendarHeaderBuilder;

  ///
  late DayHeaderBuilder<T> dayHeaderBuilder;

  ///
  late WeekNumberBuilder<T> weekNumberBuilder;

  ///
  late HourlineBuilder<T> hourlineBuilder;

  ///
  late TimelineBuilder<T> timelineBuilder;

  ///
  late DaySepratorBuilder<T> daySepratorBuilder;

  ///
  late EventTileBuilder<T> eventTileBuilder;

  ///
  late MonthEventTileBuilder<T> monthEventTileBuilder;

  ///
  late ScheduleEventTileBuilder<T> scheduleEventTileBuilder;

  ///
  late ScheduleDateBuilder<T> scheduleDateBuilder;

  ///
  late MultiDayEventTileBuilder<T> multiDayEventTileBuilder;

  Widget _defualtCalendarHeaderBuilder(
    DateTimeRange dateTimeRange,
    ViewConfiguration currentPageConfiguration,
    List<ViewConfiguration> pageConfigurations,
    Function(ViewConfiguration pageView) onContentChanged,
    VoidCallback onDateSelectorPressed,
    VoidCallback onLeftArrowPressed,
    VoidCallback onRightArrowPressed,
  ) {
    return CalendarViewHeader<T>(
      visibleDateTimeRange: dateTimeRange,
      currentPageConfiguration: currentPageConfiguration,
      pageConfigurations: pageConfigurations,
      onContentChanged: onContentChanged,
      onDateSelectorPressed: onDateSelectorPressed,
      onLeftArrowPressed: onLeftArrowPressed,
      onRightArrowPressed: onRightArrowPressed,
    );
  }

  Widget _defaultTimelineBuilder(
    double timelineWidth,
    double height,
    double hourHeight,
  ) {
    return Timeline<T>(
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

  // @override
  // bool operator ==(Object other) {
  //   return other is CalendarComponents<T> &&
  //       other.calendarHeaderBuilder == calendarHeaderBuilder &&
  //       other.dayHeaderBuilder == dayHeaderBuilder &&
  //       other.weekNumberBuilder == weekNumberBuilder &&
  //       other.hourlineBuilder == hourlineBuilder &&
  //       other.timelineBuilder == timelineBuilder &&
  //       other.daySepratorBuilder == daySepratorBuilder &&
  //       other.scheduleDateBuilder == scheduleDateBuilder &&
  //       other.monthEventTileBuilder == monthEventTileBuilder &&
  //       other.scheduleEventTileBuilder == scheduleEventTileBuilder &&
  //       other.eventTileBuilder == eventTileBuilder &&
  //       other.multiDayEventTileBuilder == multiDayEventTileBuilder;
  // }

  // @override
  // int get hashCode => Object.hash(
  //       calendarHeaderBuilder,
  //       dayHeaderBuilder,
  //       weekNumberBuilder,
  //       hourlineBuilder,
  //       timelineBuilder,
  //       daySepratorBuilder,
  //       scheduleDateBuilder,
  //       monthEventTileBuilder,
  //       scheduleEventTileBuilder,
  //       eventTileBuilder,
  //       multiDayEventTileBuilder,
  //     );
}
