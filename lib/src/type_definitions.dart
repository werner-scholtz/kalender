import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/time_of_day_range.dart';

/// The callback for when an event is tapped.
typedef OnEventTapped<T extends Object?> = void Function(
  CalendarEvent<T> event,
);

/// The callback for when an event's [DateTimeRange] is changed.
typedef OnEventChanged<T extends Object?> = void Function(
  CalendarEvent<T> event,
  CalendarEvent<T> updatedEvent,
);

/// The callback for when the calendar is tapped.
typedef OnEventCreated<T extends Object?> = void Function(
  CalendarEvent<T> event,
);

/// The callback for when a calendar page is changed.
typedef OnPageChanged = void Function(DateTimeRange visibleDateTimeRange);

/// Widget builders ///

/// The default builder for the event tiles.
typedef TileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
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
  CalendarEvent<T> eventGroup,
);

/// The hour lines builder.
typedef HourLinesBuilder = Widget Function(
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
);

/// The time line builder.
typedef TimeLineBuilder = Widget Function(
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
);

/// The day separator builder.
typedef DaySeparatorBuilder = Widget Function();

/// The time indicator builder.
typedef TimeIndicatorBuilder = Widget Function(
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
  double timelineWidth,
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
