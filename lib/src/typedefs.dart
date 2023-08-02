import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The [CalendarHeaderBuilder] is used to build the header displayed in the calendar's header.
typedef CalendarHeaderBuilder<T extends Object?> = Widget Function(
  DateTimeRange visibleDateTimeRange,
);

/// The [DayHeaderBuilder] is used to build the header displayed above a day.
typedef DayHeaderBuilder<T extends Object?> = Widget Function(
  DateTime date,
  Function(DateTime date)? onTapped,
);

/// The [HourlineBuilder] is used to build the hourlines displayed on calendar's.
typedef HourlineBuilder<T extends Object?> = Widget Function(
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

/// The [EventTileBuilder]
///
/// The [drawOutline] parameter is used to indicate whether the event should be drawn with an outline.
/// This is true when the event is displayed on top of another event.
///
/// This builder is used to build event tiles that are displayed on [PageType.singleDay] and [PageType.multiDay] days.
/// The [continuesBefore] and [continuesAfter] parameters are used to indicate whether the event
/// continues before or after the day they are displayed on.
typedef EventTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  TileType tileType,
  bool drawOutline,
  bool continuesBefore,
  bool continuesAfter,
);

/// The [MultiDayEventTileBuilder]
///
/// This builder is used to build event tiles that are displayed on multiple days.
/// The [continuesBefore] and [continuesAfter] parameters are used to indicate whether the event
/// continues before or after the visible date range.
typedef MultiDayEventTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  TileType tileType,
  bool continuesBefore,
  bool continuesAfter,
);

/// The [MonthEventTileBuilder]
///
/// This builder is used to build event tiles that are displayed on a specific date.
typedef MonthEventTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  TileType tileType,
  DateTime date,
  bool continuesBefore,
  bool continuesAfter,
);

/// The [ScheduleEventTileBuilder]
///
/// This builder is used to build event tiles that are displayed on a specific date.
typedef ScheduleEventTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  DateTime date,
);

/// The [WeekNumberBuilder] is used to build the week number displayed on the left side of the calendar.
typedef WeekNumberBuilder<T extends Object?> = Widget Function(DateTimeRange visibleDateRange);

/// The [ScheduleDateBuilder] is used to build the date displayed on the left side of the calendar.
typedef ScheduleDateBuilder<T extends Object?> = Widget Function(
  DateTime date,
  void Function(DateTime date) onDateTapped,
);
