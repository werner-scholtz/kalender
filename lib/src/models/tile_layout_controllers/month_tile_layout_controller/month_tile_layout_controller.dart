import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

abstract class MonthTileLayoutController<T> {
  MonthTileLayoutController({
    required this.visibleDateRange,
    required this.cellWidth,
    required this.tileHeight,
  });

  /// The [DateTimeRange] that is visible on the calendar.
  final DateTimeRange visibleDateRange;

  /// The width of each day.
  ///
  /// This is used to calculate the [left] and [width] of the event.
  final double cellWidth;

  /// The height of each event.
  final double tileHeight;

  /// The maximum width of the page.
  late final double maxWidth = cellWidth * (visibleDateRange.duration.inDays);

  /// The maximum height of the stack.
  double stackHeight = 0;

  /// The number of rows in the stack.
  int numberOfRows = 0;

  /// Layout a list of [events].
  List<PositionedMonthTileData<T>> layoutEvents(
    Iterable<CalendarEvent<T>> events,
  );

  /// Layout a single [event].
  PositionedMonthTileData<T> layoutSingleEvent(CalendarEvent<T> event);
}

class PositionedMonthTileData<T> {
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

  PositionedMonthTileData({
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
    return other is PositionedMonthTileData<T> &&
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
