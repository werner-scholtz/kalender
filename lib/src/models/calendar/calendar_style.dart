import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/styles_export.dart';

/// The [CalendarStyle] class is used to store custom style's for the [CalendarComponents].
class CalendarStyle {
  const CalendarStyle({
    this.backgroundColor,
    this.calendarHeaderBackgroundStyle = const CalendarHeaderBackgroundStyle(),
    this.daySeparatorStyle = const DaySeparatorStyle(),
    this.hourLineStyle = const HourLineStyle(),
    this.dayHeaderStyle = const DayHeaderStyle(),
    this.monthHeaderStyle = const MonthHeaderStyle(),
    this.timeIndicatorStyle = const TimeIndicatorStyle(),
    this.timelineStyle = const TimelineStyle(),
    this.weekNumberStyle = const WeekNumberStyle(),
    this.monthCellHeaderStyle = const MonthCellHeaderStyle(),
    this.monthGridStyle = const MonthGridStyle(),
    this.scheduleMonthHeaderStyle = const ScheduleMonthHeaderStyle(),
    this.scheduleDateTileStyle = const ScheduleDateTileStyle(),
    this.tileHandleStyle = const TileHandleStyle(),
  });

  /// The background color of the [CalendarView].
  final Color? backgroundColor;

  /// The background color of the [CalendarHeaderBackground] header.
  final CalendarHeaderBackgroundStyle calendarHeaderBackgroundStyle;

  /// The [DaySeparatorStyle] used by the [DaySeparator].
  final DaySeparatorStyle daySeparatorStyle;

  /// The [HourLineStyle] used by the [HourLines].
  final HourLineStyle hourLineStyle;

  /// The [DayHeaderStyle] used by the [DayHeader].
  final DayHeaderStyle dayHeaderStyle;

  /// The [TimeIndicatorStyle] used by the [TimeIndicator].
  final TimeIndicatorStyle timeIndicatorStyle;

  /// The [TimelineStyle] used by the [Timeline].
  final TimelineStyle timelineStyle;

  /// The [WeekNumberStyle] used by the [WeekNumber].
  final WeekNumberStyle weekNumberStyle;

  /// The [MonthGridStyle] used by the [MonthGrid].
  final MonthGridStyle monthGridStyle;

  /// The [MonthHeaderStyle] used by the [MonthHeader].
  final MonthHeaderStyle monthHeaderStyle;

  /// The [MonthCellHeaderStyle] used by the [MonthCellHeader]
  final MonthCellHeaderStyle monthCellHeaderStyle;

  /// The [ScheduleMonthHeaderStyle] used by the [ScheduleMonthHeader]
  final ScheduleMonthHeaderStyle scheduleMonthHeaderStyle;

  /// The [ScheduleDateTileStyle] used by the [ScheduleDateTile]
  final ScheduleDateTileStyle scheduleDateTileStyle;

  /// The [TileHandleStyle] used by the [TileHandle]
  final TileHandleStyle tileHandleStyle;

  @override
  operator ==(Object other) {
    return other is CalendarStyle &&
        other.backgroundColor == backgroundColor &&
        other.calendarHeaderBackgroundStyle == calendarHeaderBackgroundStyle &&
        other.daySeparatorStyle == daySeparatorStyle &&
        other.hourLineStyle == hourLineStyle &&
        other.dayHeaderStyle == dayHeaderStyle &&
        other.monthHeaderStyle == monthHeaderStyle &&
        other.timeIndicatorStyle == timeIndicatorStyle &&
        other.timelineStyle == timelineStyle &&
        other.weekNumberStyle == weekNumberStyle &&
        other.monthCellHeaderStyle == monthCellHeaderStyle &&
        other.monthGridStyle == monthGridStyle;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        calendarHeaderBackgroundStyle,
        daySeparatorStyle,
        hourLineStyle,
        dayHeaderStyle,
        monthHeaderStyle,
        timeIndicatorStyle,
        timelineStyle,
        weekNumberStyle,
        monthCellHeaderStyle,
        monthGridStyle,
      );

  CalendarStyle copyWith({
    CalendarHeaderBackgroundStyle? calendarHeaderBackgroundStyle,
    DaySeparatorStyle? daySeparatorStyle,
    HourLineStyle? hourLineStyle,
    DayHeaderStyle? dayHeaderStyle,
    MonthHeaderStyle? monthHeaderStyle,
    TimeIndicatorStyle? timeIndicatorStyle,
    TimelineStyle? timelineStyle,
    WeekNumberStyle? weekNumberStyle,
    MonthCellHeaderStyle? monthCellHeaderStyle,
    MonthGridStyle? monthGridStyle,
    ScheduleMonthHeaderStyle? scheduleMonthHeaderStyle,
    ScheduleDateTileStyle? scheduleDateTileStyle,
    TileHandleStyle? tileHandleStyle,
  }) {
    return CalendarStyle(
      calendarHeaderBackgroundStyle:
          calendarHeaderBackgroundStyle ?? this.calendarHeaderBackgroundStyle,
      daySeparatorStyle: daySeparatorStyle ?? this.daySeparatorStyle,
      hourLineStyle: hourLineStyle ?? this.hourLineStyle,
      dayHeaderStyle: dayHeaderStyle ?? this.dayHeaderStyle,
      monthHeaderStyle: monthHeaderStyle ?? this.monthHeaderStyle,
      timeIndicatorStyle: timeIndicatorStyle ?? this.timeIndicatorStyle,
      timelineStyle: timelineStyle ?? this.timelineStyle,
      weekNumberStyle: weekNumberStyle ?? this.weekNumberStyle,
      monthCellHeaderStyle: monthCellHeaderStyle ?? this.monthCellHeaderStyle,
      monthGridStyle: monthGridStyle ?? this.monthGridStyle,
      scheduleMonthHeaderStyle:
          scheduleMonthHeaderStyle ?? this.scheduleMonthHeaderStyle,
      scheduleDateTileStyle:
          scheduleDateTileStyle ?? this.scheduleDateTileStyle,
      tileHandleStyle: tileHandleStyle ?? this.tileHandleStyle,
    );
  }
}
