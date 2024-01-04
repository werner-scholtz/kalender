import 'package:flutter/material.dart';
import 'package:kalender/src/components/layout_delegates/event_group_layout.dart';
import 'package:kalender/src/components/layout_delegates/multi_day_event_group_layout.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
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

/// The [HourLinesBuilder] is used to build the hour lines displayed on calendar's.
typedef HourLinesBuilder<T extends Object?> = Widget Function(
  double hourHeight,
  double leftMargin,
);

/// The [DaySeparatorBuilder] is used to build the separators between days.
typedef DaySeparatorBuilder<T extends Object?> = Widget Function(
  int numberOfDays,
  double dayWidth,
);

/// The [TimelineBuilder] is used to build the timeline displayed on the left side of the calendar.
typedef TimelineBuilder<T extends Object?> = Widget Function(
  double hourHeight,
  int startHour,
  int endHour,
);

/// The [TimelineTextBuilder] is used to build the text displayed on the timeline.
typedef TimelineTextBuilder = Widget Function(
  TimeOfDay timeOfDay,
);

/// The [WeekNumberBuilder] is used to build the week number displayed on the left side of the calendar.
typedef WeekNumberBuilder<T extends Object?> = Widget Function(
  DateTimeRange visibleDateRange,
);

/// The [TimeIndicatorBuilder] is used to build the time indicator displayed on current day.
typedef TimeIndicatorBuilder = Widget Function(
  double heightPerMinute,
  double dayWidth,
);

/// The [MonthGridBuilder] is used to build the month grid displayed on the calendar.
typedef MonthGridBuilder = Widget Function();

/// The [MonthCellHeaderBuilder] is used to build the header displayed above a day.
typedef MonthCellHeaderBuilder = Widget Function(
  DateTime date,
  void Function(DateTime date)? onTapped,
);

/// The [MonthHeaderBuilder] is used to build the header displayed above the month grid.
typedef MonthHeaderBuilder = Widget Function(
  DateTime date,
);

/// The [ScheduleMonthHeaderBuilder] is used to build the header displayed above a month in the schedule view.
typedef ScheduleMonthHeaderBuilder = Widget Function(
  DateTime date,
);

/// The [CalendarZoomDetector] is layed on top of the multi day calendar area to detect zoom gestures.
typedef CalendarZoomDetector<T extends Object?> = Widget Function(
  CalendarController controller,
  Widget child,
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

/// The [TileHandleBuilder]
///
/// This builder is used to build the handle displayed on the event tiles. (Mobile only)
/// The [enabled] parameter is used to indicate whether the handle is enabled or not.
typedef TileHandleBuilder = Widget Function(bool enabled);

/// The [MultiDayTileBuilder]
///
/// This builder is used to build event tiles that are displayed on multiple days.
/// The [continuesBefore] and [continuesAfter] parameters are used to indicate whether the event
/// continues before or after the visible date range.
typedef MultiDayTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  MultiDayTileConfiguration configuration,
);

/// The [ScheduleTileBuilder]
///
/// This builder is used to build event tiles that are displayed on a specific date.
typedef ScheduleTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  DateTime date,
);

/// The [EventLayoutDelegateBuilder] is used to calculate the layout of the tiles displayed on a day.
///
/// The typedef is used to create a function that returns a [EventLayoutDelegateBuilder].
typedef EventLayoutDelegateBuilder<T extends Object?>
    = EventGroupLayoutDelegate<T> Function({
  required List<CalendarEvent<T>> events,
  required DateTime date,
  required double heightPerMinute,
  required int startHour,
  required int endHour,
});

/// The [EventLayoutDelegateBuilder] is used to calculate the layout of the tiles displayed on a day.
///
/// The typedef is used to create a function that returns a [EventLayoutDelegateBuilder].
typedef MultiDayEventLayoutDelegateBuilder<T extends Object?>
    = MultiDayEventsLayoutDelegate<T> Function({
  required DateTimeRange visibleDateRange,
  required double multiDayTileHeight,
  required List<CalendarEvent<T>> events,
});

typedef EventTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent event,
  TileConfiguration configuration,
  double heightPerMinute,
  bool isChanging,
  DateTimeRange visibleDateTimeRange,
  double verticalStep,
  double horizontalStep,
  List<DateTime> snapPoints,
);

typedef MultiDayEventTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent event,
  MultiDayTileConfiguration configuration,
  DateTimeRange rescheduleDateRange,
  double horizontalStep,
  Duration horizontalStepDuration,
  Duration? verticalStepDuration,
  double? verticalStep,
);
