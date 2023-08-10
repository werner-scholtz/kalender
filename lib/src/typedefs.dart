import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

import 'package:kalender/src/models/tile_configurations/month_tile_configuration.dart';
import 'package:kalender/src/models/tile_configurations/multi_day_tile_configuration.dart';
import 'package:kalender/src/models/tile_configurations/tile_configuration.dart';

/// The [CalendarHeaderBuilder] is used to build the header displayed in the calendar's header.
typedef CalendarHeaderBuilder<T extends Object?> = Widget Function(
  DateTimeRange visibleDateTimeRange,
);

/// The [DayHeaderBuilder] is used to build the header displayed above a day.
typedef DayHeaderBuilder<T extends Object?> = Widget Function(
  DateTime date,
  void Function(DateTime date)? onTapped,
);

/// The [HourlinesBuilder] is used to build the hourlines displayed on calendar's.
typedef HourlinesBuilder<T extends Object?> = Widget Function(
  double hourlineWidth,
  double hourHeight,
);

/// The [DaySepratorBuilder] is used to build the seperators between days.
typedef DaySepratorBuilder<T extends Object?> = Widget Function(
  double pageHeight,
  double dayWidth,
  int numberOfDays,
);

/// The [TimelineBuilder] is used to build the timeline displayed on the left side of the calendar.
typedef TimelineBuilder<T extends Object?> = Widget Function(
  double timelineWidth,
  double height,
  double hourHeight,
);

/// The [WeekNumberBuilder] is used to build the week number displayed on the left side of the calendar.
typedef WeekNumberBuilder<T extends Object?> = Widget Function(DateTimeRange visibleDateRange);

/// The [TimeIndicatorBuilder] is used to build the time indicator displayed on current day.
typedef TimeIndicatorBuilder = Widget Function(
  double timeIndicatorWidth,
  double areaHeight,
  DateTimeRange visibleDateRange,
  double heightPerMinute,
);

/// The [TileBuilder]
///
/// The [drawOutline] parameter is used to indicate whether the event should be drawn with an outline.
/// This is true when the event is displayed on top of another event.
///
/// This builder is used to build event tiles that are displayed on [PageType.singleDay] and [PageType.multiDay] days.
/// The [continuesBefore] and [continuesAfter] parameters are used to indicate whether the event
/// continues before or after the day they are displayed on.
typedef TileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  TileConfiguration configuration,
);

/// The [MultiDayTileBuilder]
///
/// This builder is used to build event tiles that are displayed on multiple days.
/// The [continuesBefore] and [continuesAfter] parameters are used to indicate whether the event
/// continues before or after the visible date range.
typedef MultiDayTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  MultiDayTileConfiguration configuration,
);

/// The [MonthTileBuilder]
///
/// This builder is used to build event tiles that are displayed on a specific date.
typedef MonthTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  MonthTileConfiguration configuration,
);

/// The [ScheduleEventTileBuilder]
///
/// This builder is used to build event tiles that are displayed on a specific date.
typedef ScheduleEventTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  DateTime date,
);
