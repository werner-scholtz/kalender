import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/day_header/day_header_style.dart';
import 'package:kalender/src/components/general/day_seperator/day_seperator_style.dart';
import 'package:kalender/src/components/general/hour_line/hour_line_style.dart';
import 'package:kalender/src/components/general/material_header/material_header_style.dart';
import 'package:kalender/src/components/general/month_cell_header/month_cell_header_style.dart';
import 'package:kalender/src/components/general/month_cells/month_cells_style.dart';
import 'package:kalender/src/components/general/month_grid/month_grid_style.dart';
import 'package:kalender/src/components/general/month_header/month_header_style.dart';
import 'package:kalender/src/components/general/time_indicator/time_indicator_style.dart';
import 'package:kalender/src/components/general/time_line/timeline_style.dart';
import 'package:kalender/src/components/general/week_number/week_number_style.dart';

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
    this.monthCellsStyle = const MonthCellsStyle(),
  });

  /// The background color of the [CalendarView].
  final Color? backgroundColor;

  /// The background color of the [CalendarHeaderBackground] header.
  final CalendarHeaderBackgroundStyle? calendarHeaderBackgroundStyle;

  /// The [DaySeparatorStyle] used by the [DaySeperator].
  final DaySeparatorStyle? daySeparatorStyle;

  /// The [HourLineStyle] used by the [HourLines].
  final HourLineStyle? hourLineStyle;

  /// The [DayHeaderStyle] used by the [DayHeader].
  final DayHeaderStyle? dayHeaderStyle;

  /// The [TimeIndicatorStyle] used by the [TimeIndicator].
  final TimeIndicatorStyle? timeIndicatorStyle;

  /// The [TimelineStyle] used by the [Timeline].
  final TimelineStyle? timelineStyle;

  /// The [WeekNumberStyle] used by the [WeekNumber].
  final WeekNumberStyle? weekNumberStyle;

  /// The [MonthGridStyle] used by the [MonthGrid].
  final MonthGridStyle? monthGridStyle;

  /// The [MonthCellsStyle] used by the [MonthCells].
  final MonthCellsStyle? monthCellsStyle;

  /// The [MonthHeaderStyle] used by the [MonthHeader].
  final MonthHeaderStyle? monthHeaderStyle;

  /// The [MonthCellHeaderStyle] used by the [MonthCellHeader]
  final MonthCellHeaderStyle? monthCellHeaderStyle;

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
    MonthCellsStyle? monthCellsStyle,
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
      monthCellsStyle: monthCellsStyle ?? this.monthCellsStyle,
    );
  }
}
