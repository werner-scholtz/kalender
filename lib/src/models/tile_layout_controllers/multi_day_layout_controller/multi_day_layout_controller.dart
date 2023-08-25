import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

abstract class MultiDayTileLayoutController<T> {
  MultiDayTileLayoutController({
    required this.visibleDateRange,
    required this.dayWidth,
    required this.tileHeight,
    // required this.isMultidayView,
  });

  /// The [DateTimeRange] that is visible on the calendar.
  final DateTimeRange visibleDateRange;

  /// The width of each day.
  ///
  /// This is used to calculate the [left] and [width] of the event.
  final double dayWidth;

  /// The height of each event.
  final double tileHeight;

  /// The maximum width of the page.
  late final double maxWidth = dayWidth * (visibleDateRange.duration.inDays);

  /// Whether the view is a multiday view.
  // final bool isMultidayView;

  /// Layout a list of [events].
  MultiDayLayoutData<T> layoutEvents(
    Iterable<CalendarEvent<T>> events,
  );

  /// Layout a single [event].
  PositionedMultiDayTileData<T> layoutSingleEvent(CalendarEvent<T> event);
}

/// This class is used to store the layout data for the multiday view.
///
/// It contains the [layedOutTiles] and the [stackHeight].
/// The [layedOutTiles] are the [PositionedMultiDayTileData] that are used to render the tiles.
/// The [stackHeight] is the height of the stack that the tiles are rendered in.
class MultiDayLayoutData<T extends Object?> {
  MultiDayLayoutData({
    required this.layedOutTiles,
    required this.stackHeight,
  });

  final List<PositionedMultiDayTileData<T>> layedOutTiles;

  final double stackHeight;
}

/// This class is used to store the layout data for a tile.
///
/// It contains the [event], [dateRange], [left], [top], [width], and [height].
/// The [event] is the event that the tile represents.
/// The [dateRange] is the [DateTimeRange] that the tile is rendered on.
/// The [left] is the distance that the tile's left edge is inset from the left of the stack.
/// The [top] is the distance that the tile's top edge is inset from the top of the stack.
/// The [width] is the tile's width.
/// The [height] is the tile's height.
/// The [continuesBefore] is whether the event continues before the visible date range.
/// The [continuesAfter] is whether the event continues after the visible date range.
class PositionedMultiDayTileData<T> {
  /// The event that the tile represents.
  final CalendarEvent<T> event;

  /// The [DateTimeRange] this tile is rendered on.
  final DateTimeRange dateRange;

  /// The distance that the tile's left edge is inset from the left of the stack.
  final double left;

  /// The distance that the tile's top edge is inset from the top of the stack.
  final double top;

  /// The tile's width.
  final double width;

  /// The tile's height.
  final double height;

  /// Whether the event continues before the visible date range.
  final bool continuesBefore;

  /// Whether the event continues after the visible date range.
  final bool continuesAfter;

  PositionedMultiDayTileData({
    required this.event,
    required this.dateRange,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    this.continuesBefore = false,
    this.continuesAfter = false,
  });

  @override
  String toString() {
    return 'top: $top, left: $left, width: $width, height: $height';
  }

  @override
  bool operator ==(Object other) {
    return other is PositionedMultiDayTileData<T> &&
        other.event == event &&
        other.dateRange == dateRange &&
        other.left == left &&
        other.top == top &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(event, dateRange, left, top, width, height);
}
