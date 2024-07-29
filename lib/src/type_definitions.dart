import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/time_of_day_range.dart';
import 'package:kalender/src/widgets/components/day_header.dart';
import 'package:kalender/src/widgets/components/day_separator.dart';
import 'package:kalender/src/widgets/components/hour_lines.dart';
import 'package:kalender/src/widgets/components/month_grid.dart';
import 'package:kalender/src/widgets/components/time_indicator.dart';
import 'package:kalender/src/widgets/components/time_line.dart';
import 'package:kalender/src/widgets/components/week_day_header.dart';
import 'package:kalender/src/widgets/components/week_number.dart';

/// The callback for when an event is tapped.
///
/// The [event] is the event that was tapped.
/// The [renderBox] is the [RenderBox] of the event tile.
typedef OnEventTapped<T extends Object?> = void Function(
  CalendarEvent<T> event,
  RenderBox renderBox,
);

/// The callback for when an event is about to be changed.
typedef OnEventChange<T extends Object?> = void Function(
  CalendarEvent<T> event,
); 

/// The callback for when an event is changed.
///
/// [event] is the original event.
/// [updatedEvent] is the updated event.
typedef OnEventChanged<T extends Object?> = void Function(
  CalendarEvent<T> event,
  CalendarEvent<T> updatedEvent,
);

/// The call back for creating a new event.
typedef OnEventCreate<T extends Object?> = CalendarEvent<T> Function(
  CalendarEvent<T> event,
);

/// The callback for a new event has been created.
typedef OnEventCreated<T extends Object?> = void Function(
  CalendarEvent<T> event,
);

/// The callback for when a calendar page is changed.
typedef OnPageChanged = void Function(DateTimeRange visibleDateTimeRange);

/// Widget builders ///

/// The default builder for the event tiles.
typedef TileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  // TODO: add a parameter(s) that allows the user to customise the tile if it spans across multiple days.
  // It should allow the user to know how many days the event spans across and the date of the tile.
);

/// The builder for the event tile when dragging.
typedef TileWhenDraggingBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
);

/// The builder for the feedback tile. (When dragging)
typedef FeedbackTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  Size dropTargetWidgetSize,
);

/// The builder for the drop target event tile.
typedef TileDropTargetBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
);

/// The hour lines builder.
///
/// The [heightPerMinute] is the height of each minute.
/// The [timeOfDayRange] is the range of time that the hour lines will be displayed for.
/// The [style] is used to style the hour lines.
typedef HourLinesBuilder = Widget Function(
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
  HourLinesStyle? style,
);

/// The time line builder.
///
/// The [heightPerMinute] is the height of each minute.
/// The [timeOfDayRange] is the range of time that the time line will be displayed for.
/// The [style] is used to style the time line.
typedef TimeLineBuilder = Widget Function(
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
  TimelineStyle? style,
);

/// The day separator builder.
///
/// The [style] is used to style the day separator.
typedef DaySeparatorBuilder = Widget Function(
  DaySeparatorStyle? style,
);

/// The time indicator builder.
///
/// The [timeOfDayRange] is the range of time that the time indicator will be displayed for.
/// The [heightPerMinute] is the height of each minute.
/// The [timelineWidth] is the width of the timeline.
/// The [style] is used to style the time indicator.
typedef TimeIndicatorBuilder = Widget Function(
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
  double timelineWidth,
  TimeIndicatorStyle? style,
);

/// The day header builder.
///
/// The [date] is the date that the header will be displayed for.
/// The [style] is used to style the day header.
typedef DayHeaderBuilder = Widget Function(
  DateTime date,
  DayHeaderStyle? style,
);

/// The week number builder.
///
/// The [visibleDateTimeRange] is the range of dates that the week number will be displayed for.
/// The [style] is used to style the week number.
typedef WeekNumberBuilder = Widget Function(
  DateTimeRange visibleDateTimeRange,
  WeekNumberStyle? style,
);

/// The week day header builder.
///
/// The [date] is the date that the header will be displayed for.
/// The [style] is used to style the week day header.
typedef WeekDayHeaderBuilder = Widget Function(
  DateTime date,
  WeekDayHeaderStyle? style,
);

/// The month grid builder.
///
/// The [style] is used to style the month grid.
typedef MonthGridBuilder = Widget Function(
  MonthGridStyle? style,
);

/// The trigger widget builder, should be constrained in width.
/// 
/// The [pageWidth] is the width of the page.
typedef HorizontalTriggerWidgetBuilder = Widget Function(
  double pageWidth,
);

/// The trigger widget builder, should be constrained in height.
/// 
/// The [viewPortHeight] is the height of the page.
typedef VerticalTriggerWidgetBuilder = Widget Function(
  double viewPortHeight,
);

///

/// Calculates the VisibleDateRange from the [index].
///
/// [index] is the page index.
typedef DateTimeRangeFromIndex = DateTimeRange Function(int index);

/// Calculates the page index of the [date].
typedef IndexFromDate = int Function(DateTime date);

/// The number of pages for the [DateTimeRange] of the calendar.
typedef NumberOfPages = int Function();
