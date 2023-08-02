import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/day_header.dart';
import 'package:kalender/src/components/general/day_seperator.dart';
import 'package:kalender/src/components/general/hour_line.dart';
import 'package:kalender/src/components/general/material_header.dart';
import 'package:kalender/src/components/general/month_cell_header.dart';
import 'package:kalender/src/components/general/month_header.dart';
import 'package:kalender/src/components/general/schedule_date.dart';
import 'package:kalender/src/components/general/time_indicator.dart';
import 'package:kalender/src/components/general/time_line.dart';
import 'package:kalender/src/components/general/week_number.dart';
import 'package:kalender/src/models/calendar/calendar_components.dart';

/// The [CalendarStyle] class is used to store custom style's for the [CalendarComponents].
class CalendarStyle {
  const CalendarStyle({
    this.backgroundColor,
    this.calendarHeaderBackgroundStyle = const CalendarHeaderBackgroundStyle(),
    this.daySeperatorStyle = const DaySeperatorStyle(),
    this.hourLineStyle = const HourLineStyle(),
    this.scheduleDateStyle = const ScheduleDateStyle(),
    this.dayHeaderStyle = const DayHeaderStyle(),
    this.monthHeaderStyle = const MonthHeaderStyle(),
    this.timeIndicatorStyle = const TimeIndicatorStyle(),
    this.timelineStyle = const TimelineStyle(),
    this.weekNumberStyle = const WeekNumberStyle(),
    this.monthCellHeaderStyle = const MonthCellHeaderStyle(),
  });

  /// The background color of the [CalendarView].
  final Color? backgroundColor;

  /// The background color of the [CalendarHeaderBackground] header.
  final CalendarHeaderBackgroundStyle? calendarHeaderBackgroundStyle;

  /// The [DaySeperatorStyle] used by the [DaySeperator].
  final DaySeperatorStyle? daySeperatorStyle;

  /// The [HourLineStyle] used by the [HourLine].
  final HourLineStyle? hourLineStyle;

  /// The [ScheduleDateStyle] used by the [ScheduleDate].
  final ScheduleDateStyle? scheduleDateStyle;

  /// The [DayHeaderStyle] used by the [DayHeader].
  final DayHeaderStyle? dayHeaderStyle;

  /// The [MonthHeaderStyle] used by the [MonthHeader].
  final MonthHeaderStyle? monthHeaderStyle;

  /// The [MonthCellHeaderStyle] used by the [MonthCellHeader]
  final MonthCellHeaderStyle? monthCellHeaderStyle;

  /// The [TimeIndicatorStyle] used by the [TimeIndicator].
  final TimeIndicatorStyle? timeIndicatorStyle;

  /// The [TimelineStyle] used by the [Timeline].
  final TimelineStyle? timelineStyle;

  /// The [WeekNumberStyle] used by the [WeekNumber].
  final WeekNumberStyle? weekNumberStyle;

  @override
  operator ==(Object other) {
    return other is CalendarStyle &&
        other.backgroundColor == backgroundColor &&
        other.calendarHeaderBackgroundStyle == calendarHeaderBackgroundStyle &&
        other.daySeperatorStyle == daySeperatorStyle &&
        other.hourLineStyle == hourLineStyle &&
        other.scheduleDateStyle == scheduleDateStyle &&
        other.dayHeaderStyle == dayHeaderStyle &&
        other.monthHeaderStyle == monthHeaderStyle &&
        other.timeIndicatorStyle == timeIndicatorStyle &&
        other.timelineStyle == timelineStyle &&
        other.weekNumberStyle == weekNumberStyle &&
        other.monthCellHeaderStyle == monthCellHeaderStyle;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        calendarHeaderBackgroundStyle,
        daySeperatorStyle,
        hourLineStyle,
        scheduleDateStyle,
        dayHeaderStyle,
        monthHeaderStyle,
        timeIndicatorStyle,
        timelineStyle,
        weekNumberStyle,
        monthCellHeaderStyle,
      );
}
