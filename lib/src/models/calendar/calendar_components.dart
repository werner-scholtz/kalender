import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/general/day_header/day_header.dart';
import 'package:kalender/src/components/general/day_separator/day_separator.dart';
import 'package:kalender/src/components/general/hour_line/hour_lines.dart';
import 'package:kalender/src/components/general/month_cell_header/month_cell_header.dart';
import 'package:kalender/src/components/general/month_grid/month_grid.dart';
import 'package:kalender/src/components/general/month_header/month_header.dart';
import 'package:kalender/src/components/general/schedule_month_header/schedule_month_header.dart';
import 'package:kalender/src/components/general/tile_handle/tile_handle.dart';
import 'package:kalender/src/components/general/time_indicator/time_indicator.dart';
import 'package:kalender/src/components/general/time_line/timeline.dart';
import 'package:kalender/src/components/general/week_number/week_number.dart';
import 'package:kalender/src/type_definitions.dart';

/// This class is used to provide the tile components for the calendar.
class CalendarTileComponents<T> {
  const CalendarTileComponents({
    this.tileBuilder,
    this.scheduleTileBuilder,
    this.multiDayTileBuilder,
    this.eventTileBuilder,
    this.multiDayEventTileBuilder,
  });

  /// The [TileBuilder] is used to build event tiles that are displayed on [SingleDayView] and [MultiDayView] days.
  final TileBuilder<T>? tileBuilder;

  /// The [MultiDayTileBuilder] is used to build event tiles that are displayed on multiple days.
  final MultiDayTileBuilder<T>? multiDayTileBuilder;

  /// The [ScheduleTileBuilder] is used to build event tiles that are displayed on [ScheduleView] days.
  final ScheduleTileBuilder<T>? scheduleTileBuilder;

  final EventTileBuilder<T>? eventTileBuilder;

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
    HourLinesBuilder? hourLineBuilder,
    TimelineBuilder? timelineBuilder,
    TimelineTextBuilder? timelineTextBuilder,
    TimeIndicatorBuilder? timeIndicatorBuilder,
    DaySeparatorBuilder? daySeparatorBuilder,
    MonthGridBuilder? monthGridBuilder,
    MonthCellHeaderBuilder? monthCellHeaderBuilder,
    MonthHeaderBuilder? monthHeaderBuilder,
    TileHandleBuilder? tileHandleBuilder,
    ScheduleMonthHeaderBuilder? scheduleMonthHeaderBuilder,
    CalendarZoomDetector? calendarZoomDetector,
  }) {
    this.dayHeaderBuilder = dayHeaderBuilder ?? _defaultDayHeaderBuilder;
    this.weekNumberBuilder = weekNumberBuilder ?? _defaultWeekNumberBuilder;
    this.hourLineBuilder = hourLineBuilder ?? _defaultHourLineBuilder;
    this.timelineBuilder = timelineBuilder ?? _defaultTimelineBuilder;
    this.daySeparatorBuilder =
        daySeparatorBuilder ?? _defaultDaySeparatorBuilder;
    this.timeIndicatorBuilder =
        timeIndicatorBuilder ?? _defaultTimeIndicatorBuilder;
    this.monthGridBuilder = monthGridBuilder ?? _defaultMonthGridBuilder;
    this.monthCellHeaderBuilder =
        monthCellHeaderBuilder ?? _defaultMonthCellHeaderBuilder;
    this.monthHeaderBuilder = monthHeaderBuilder ?? _defaultMonthHeaderBuilder;
    this.tileHandleBuilder = tileHandleBuilder ?? _defaultTileHandleBuilder;
    this.scheduleMonthHeaderBuilder =
        scheduleMonthHeaderBuilder ?? _defaultScheduleMonthHeaderBuilder;
    this.calendarZoomDetector =
        calendarZoomDetector ?? _defaultCalendarZoomDetector;
    this.timelineTextBuilder =
        timelineTextBuilder ?? _defaultTimelineTextBuilder;
  }

  /// This builder is used to build the widget displayed in the calendar's header.
  late CalendarHeaderBuilder? calendarHeaderBuilder;

  /// This builder is used to build the header displayed above a day.
  late DayHeaderBuilder dayHeaderBuilder;

  /// This builder is used to build the week number displayed on the left side of the calendar above the timeline.
  late WeekNumberBuilder weekNumberBuilder;

  /// This builder is used to build the hourLines displayed on calendar.
  late HourLinesBuilder hourLineBuilder;

  /// This builder is used to build the timeline displayed on the left side of the calendar.
  ///
  /// If you override this builder, the [TimelineTextBuilder] will be ignored.
  late TimelineBuilder timelineBuilder;

  /// This builder is used to build the text displayed on the timeline.
  late TimelineTextBuilder timelineTextBuilder;

  /// This builder is used to build the separators between days.
  late DaySeparatorBuilder daySeparatorBuilder;

  /// This builder is used to build the time indicator displayed on the calendar.
  late TimeIndicatorBuilder timeIndicatorBuilder;

  /// This builder is used to build the month grid displayed on the calendar.
  late MonthGridBuilder monthGridBuilder;

  /// This builder is used to build the month cell header displayed on the calendar.
  late MonthCellHeaderBuilder monthCellHeaderBuilder;

  /// This builder is used to build the month header displayed on the calendar.
  late MonthHeaderBuilder monthHeaderBuilder;

  /// This builder is used to build the month header displayed on the schedule view.
  late ScheduleMonthHeaderBuilder scheduleMonthHeaderBuilder;

  /// This builder is used to build the handle displayed on the event tiles. (Mobile only)
  late TileHandleBuilder tileHandleBuilder;

  /// This builder is used to detect zoom gestures on the multi day calendar area.
  late CalendarZoomDetector calendarZoomDetector;

  Widget _defaultTimelineBuilder(
    double hourHeight,
    int startHour,
    int endHour,
  ) {
    return Timeline(
      hourHeight: hourHeight,
      startHour: startHour,
      endHour: endHour,
    );
  }

  Widget _defaultTimelineTextBuilder(
    TimeOfDay timeOfDay,
  ) {
    return TimelineText(
      timeOfDay: timeOfDay,
    );
  }

  Widget _defaultHourLineBuilder(
    double hourHeight,
    double leftOffset,
  ) {
    return HourLines(
      hourHeight: hourHeight,
      leftOffset: leftOffset,
    );
  }

  Widget _defaultDaySeparatorBuilder(
    int numberOfDays,
    double dayWidth,
  ) {
    return DaySeparator(
      numberOfDays: numberOfDays,
      dayWidth: dayWidth,
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
    double heightPerMinute,
    double dayWidth,
  ) {
    return TimeIndicator(
      dayWidth: dayWidth,
      heightPerMinute: heightPerMinute,
    );
  }

  Widget _defaultMonthGridBuilder() {
    return const MonthGrid();
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
    DateTime date,
  ) {
    return MonthHeader(
      date: date,
    );
  }

  Widget _defaultScheduleMonthHeaderBuilder(
    DateTime date,
  ) {
    return ScheduleMonthHeader(
      date: date,
    );
  }

  Widget _defaultTileHandleBuilder(bool enabled) {
    return DefaultTileHandle(
      enabled: enabled,
    );
  }

  Widget _defaultCalendarZoomDetector(
    CalendarController controller,
    Widget child,
  ) {
    return child;
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarComponents &&
        other.calendarHeaderBuilder == calendarHeaderBuilder &&
        other.dayHeaderBuilder == dayHeaderBuilder &&
        other.weekNumberBuilder == weekNumberBuilder &&
        other.hourLineBuilder == hourLineBuilder &&
        other.timelineBuilder == timelineBuilder &&
        other.daySeparatorBuilder == daySeparatorBuilder;
  }

  @override
  int get hashCode => Object.hash(
        calendarHeaderBuilder,
        dayHeaderBuilder,
        weekNumberBuilder,
        hourLineBuilder,
        timelineBuilder,
        daySeparatorBuilder,
      );
}
