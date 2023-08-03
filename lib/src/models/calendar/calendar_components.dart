import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/day_header.dart';
import 'package:kalender/src/components/general/day_seperator.dart';
import 'package:kalender/src/components/general/hour_line.dart';
// import 'package:kalender/src/components/general/schedule_date.dart';
import 'package:kalender/src/components/general/time_line.dart';
import 'package:kalender/src/components/general/week_number.dart';
import 'package:kalender/src/typedefs.dart';

/// This class is used to provide the tile components for the calendar.
class CalendarTileComponents<T> {
  const CalendarTileComponents({
    this.tileBuilder,
    this.monthTileBuilder,
    this.scheduleTileBuilder,
    this.multiDayTileBuilder,
  });

  /// The [TileBuilder] is used to build event tiles that are displayed on [SingleDayView] and [MultiDayView] days.
  final TileBuilder<T>? tileBuilder;

  /// The [MultiDayTileBuilder] is used to build event tiles that are displayed on multiple days.
  final MultiDayTileBuilder<T>? multiDayTileBuilder;

  /// The [MonthEventBuilder] is used to build event tiles that are displayed on [MonthView] days.
  final MonthEventBuilder<T>? monthTileBuilder;

  /// The [ScheduleEventTileBuilder] is used to build event tiles that are displayed on [ScheduleView] days.
  final ScheduleEventTileBuilder<T>? scheduleTileBuilder;
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
    // ScheduleDateBuilder? scheduleDateBuilder,
  }) {
    this.dayHeaderBuilder = dayHeaderBuilder ?? _defaultDayHeaderBuilder;
    this.weekNumberBuilder = weekNumberBuilder ?? _defaultWeekNumberBuilder;
    this.hourlineBuilder = hourlineBuilder ?? _defaultHourLineBuilder;
    this.timelineBuilder = timelineBuilder ?? _defaultTimelineBuilder;
    this.daySepratorBuilder = daySepratorBuilder ?? _defaultDaySeperatorBuilder;
    // this.scheduleDateBuilder = scheduleDateBuilder ?? _defaultScheduleDateBuilder;
  }

  /// This builder is used to build the widget displayed in the calendar's header.
  late CalendarHeaderBuilder? calendarHeaderBuilder;

  /// This builder is used to build the header displayed above a day.
  late DayHeaderBuilder dayHeaderBuilder;

  /// This builder is used to build the week number displayed on the left side of the calendar above the timeline.
  late WeekNumberBuilder weekNumberBuilder;

  /// This builder is used to build the hourlines displayed on calendar.
  late HourlineBuilder hourlineBuilder;

  /// This builder is used to build the timeline displayed on the left side of the calendar.
  late TimelineBuilder timelineBuilder;

  /// This builder is used to build the seperators between days.
  late DaySepratorBuilder daySepratorBuilder;

  ///
  // late ScheduleDateBuilder scheduleDateBuilder;

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

  // Widget _defaultScheduleDateBuilder(
  //   DateTime date,
  //   void Function(DateTime date) onDateTapped,
  // ) {
  //   return ScheduleDate(
  //     date: date,
  //     onDateTapped: onDateTapped,
  //   );
  // }

  @override
  bool operator ==(Object other) {
    return other is CalendarComponents &&
        other.calendarHeaderBuilder == calendarHeaderBuilder &&
        other.dayHeaderBuilder == dayHeaderBuilder &&
        other.weekNumberBuilder == weekNumberBuilder &&
        other.hourlineBuilder == hourlineBuilder &&
        other.timelineBuilder == timelineBuilder &&
        other.daySepratorBuilder == daySepratorBuilder; //&&
    // other.scheduleDateBuilder == scheduleDateBuilder;
  }

  @override
  int get hashCode => Object.hash(
        calendarHeaderBuilder,
        dayHeaderBuilder,
        weekNumberBuilder,
        hourlineBuilder,
        timelineBuilder,
        daySepratorBuilder,
        // scheduleDateBuilder,
      );
}
