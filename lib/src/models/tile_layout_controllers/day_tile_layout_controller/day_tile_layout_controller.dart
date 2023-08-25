import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

abstract class DayTileLayoutController<T> {
  const DayTileLayoutController({
    required this.visibleDateRange,
    required this.visibleDates,
    required this.heightPerMinute,
    required this.dayWidth,
  });

  /// The [DateTimeRange] that is visible on the calendar.
  final DateTimeRange visibleDateRange;

  /// The [DateTime]s that are visible on the calendar.
  final List<DateTime> visibleDates;

  /// The height of each minute.
  ///
  /// This is used to calculate the [top] and [height] of the events.
  final double heightPerMinute;

  /// The width of each day.
  ///
  /// This is used to calculate the [left] and [width] of the event.
  final double dayWidth;

  /// Generate tile groups from the [events].
  List<TileGroup<T>> generateTileGroups(
    Iterable<CalendarEvent<T>> events,
  );

  /// Positioned a single event on the calendar.
  ///
  /// This is mainly used for the chaning event.
  List<PositionedTileData<T>> layoutSelectedEvent(CalendarEvent<T> event);
}

class TileGroup<T> {
  /// The date that the tile's will be displayed on.
  final DateTime date;

  /// The tile group's left value.
  final double tileGroupLeft;

  /// The tile group's top value.
  final double tileGroupTop;

  /// The initial width of the tiles.
  final double tileGroupWidth;

  /// The height of the tile group.
  final double tileGroupHeight;

  /// The [PositionedTileData] that are used to position the tiles in this group.
  final List<PositionedTileData<T>> tilePositionData;

  /// The [CalendarEvent]'s that are in this group.
  final Iterable<CalendarEvent<T>> events;

  TileGroup({
    required this.date,
    required this.tileGroupLeft,
    required this.tileGroupTop,
    required this.tileGroupWidth,
    required this.tileGroupHeight,
    required this.tilePositionData,
    required this.events,
  });
}

class PositionedTileData<T> {
  /// The event that the tile represents.
  final CalendarEvent<T> event;

  /// The date that the tile is displayed on.
  final DateTime date;

  /// The distance that the tile's left edge is inset from the left of the stack.
  final double left;

  /// The distance that the tile's top edge is inset from the top of the stack.
  final double top;

  /// The tile's height.
  final double height;

  /// The tile's width.
  final double width;

  /// If the tile should draw an outline.
  final bool drawOutline;

  final bool continuesBefore;

  final bool continuesAfter;

  PositionedTileData({
    required this.event,
    required this.date,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.drawOutline,
    required this.continuesBefore,
    required this.continuesAfter,
  });

  @override
  bool operator ==(Object other) {
    return other is PositionedTileData<T> &&
        other.date == date &&
        other.left == left &&
        other.top == top &&
        other.height == height &&
        other.width == width &&
        other.event == event &&
        other.drawOutline == drawOutline;
  }

  @override
  int get hashCode =>
      Object.hash(date, top, left, height, width, event, drawOutline);
}
