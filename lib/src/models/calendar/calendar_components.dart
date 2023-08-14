import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/day_header/day_header.dart';
import 'package:kalender/src/components/general/day_seperator/day_seperator.dart';
import 'package:kalender/src/components/general/hour_line/hour_line.dart';
import 'package:kalender/src/components/general/month_cell_header/month_cell_header.dart';
import 'package:kalender/src/components/general/month_grid/month_grid.dart';
import 'package:kalender/src/components/general/month_header/month_header.dart';
import 'package:kalender/src/components/general/time_indicator/time_indicator.dart';
import 'package:kalender/src/components/general/time_line/time_line.dart';
import 'package:kalender/src/components/general/week_number/week_number.dart';
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

  /// The [MonthTileBuilder] is used to build event tiles that are displayed on [MonthView] days.
  final MonthTileBuilder<T>? monthTileBuilder;

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
    HourlinesBuilder? hourlineBuilder,
    TimelineBuilder? timelineBuilder,
    TimeIndicatorBuilder? timeIndicatorBuilder,
    DaySepratorBuilder? daySepratorBuilder,
    MonthGridBuilder? monthGridBuilder,
    MonthCellHeaderBuilder? monthCellHeaderBuilder,
    MonthHeaderBuilder? monthHeaderBuilder,
  }) {
    this.dayHeaderBuilder = dayHeaderBuilder ?? _defaultDayHeaderBuilder;
    this.weekNumberBuilder = weekNumberBuilder ?? _defaultWeekNumberBuilder;
    this.hourlineBuilder = hourlineBuilder ?? _defaultHourLineBuilder;
    this.timelineBuilder = timelineBuilder ?? _defaultTimelineBuilder;
    this.daySepratorBuilder = daySepratorBuilder ?? _defaultDaySeperatorBuilder;
    this.timeIndicatorBuilder =
        timeIndicatorBuilder ?? _defaultTimeIndicatorBuilder;
    this.monthGridBuilder = monthGridBuilder ?? _defaultMonthGridBuilder;
    this.monthCellHeaderBuilder =
        monthCellHeaderBuilder ?? _defaultMonthCellHeaderBuilder;
    this.monthHeaderBuilder = monthHeaderBuilder ?? _defaultMonthHeaderBuilder;
  }

  /// This builder is used to build the widget displayed in the calendar's header.
  late CalendarHeaderBuilder? calendarHeaderBuilder;

  /// This builder is used to build the header displayed above a day.
  late DayHeaderBuilder dayHeaderBuilder;

  /// This builder is used to build the week number displayed on the left side of the calendar above the timeline.
  late WeekNumberBuilder weekNumberBuilder;

  /// This builder is used to build the hourlines displayed on calendar.
  late HourlinesBuilder hourlineBuilder;

  /// This builder is used to build the timeline displayed on the left side of the calendar.
  late TimelineBuilder timelineBuilder;

  /// This builder is used to build the seperators between days.
  late DaySepratorBuilder daySepratorBuilder;

  /// This builder is used to build the time indicator displayed on the calendar.
  late TimeIndicatorBuilder timeIndicatorBuilder;

  /// This builder is used to build the month grid displayed on the calendar.
  late MonthGridBuilder monthGridBuilder;

  /// This builder is used to build the month cell header displayed on the calendar.
  late MonthCellHeaderBuilder monthCellHeaderBuilder;

  late MonthHeaderBuilder monthHeaderBuilder;

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
    return HourLines(
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

  Widget _defaultTimeIndicatorBuilder(
    double timeIndicatorWidth,
    double areaHeight,
    DateTimeRange visibleDateRange,
    double heightPerMinute,
    double timelineWidth,
  ) {
    return TimeIndicator(
      width: timeIndicatorWidth,
      height: areaHeight,
      visibleDateRange: visibleDateRange,
      heightPerMinute: heightPerMinute,
      timelineWidth: timelineWidth,
    );
  }

  Widget _defaultMonthGridBuilder(
    double pageHeight,
    double cellHeight,
    double cellWidth,
  ) {
    return MonthGrid(
      pageHeight: pageHeight,
      cellHeight: cellHeight,
      cellWidth: cellWidth,
    );
  }

  Widget _defaultMonthCellHeaderBuilder(
    DateTime date,
    void Function(DateTime date)? onTapped,
  ) {
    return MonthCellHeader(
      date: date,
      onTapped: onTapped,
    );
  }

  Widget _defaultMonthHeaderBuilder(
    double dayWidth,
    DateTime date,
  ) {
    return MonthHeader(
      date: date,
      dayWidth: dayWidth,
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
        other.daySepratorBuilder == daySepratorBuilder;
  }

  @override
  int get hashCode => Object.hash(
        calendarHeaderBuilder,
        dayHeaderBuilder,
        weekNumberBuilder,
        hourlineBuilder,
        timelineBuilder,
        daySepratorBuilder,
      );
}
