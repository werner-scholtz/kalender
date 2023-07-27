import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar_event.dart';

class MultiDayLayoutController<T extends Object?> {
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

  /// The maximum height of the stack.
  double stackHeight = 0;

  MultiDayLayoutController({
    required this.visibleDateRange,
    required this.dayWidth,
    required this.tileHeight,
  });

  List<PositionedMultiDayTileData<T>> arrageEvents(
    Iterable<CalendarEvent<T>> events, {
    CalendarEvent<T>? selectedEvent,
  }) {
    stackHeight = 0;
    void updateStackHeight(double top) {
      if (stackHeight < top + tileHeight) {
        stackHeight = top + tileHeight;
      }
    }

    List<PositionedMultiDayTileData<T>> arrangedEvents = [];
    void addArrangedEvent(PositionedMultiDayTileData<T> arragnedEvent) {
      if (arrangedEvents.contains(arragnedEvent)) return;
      arrangedEvents.add(arragnedEvent);
    }

    List<CalendarEvent<T>> eventsToArrange = events.toList()
      // Sort events by start dateTime
      ..sort((CalendarEvent<T> a, CalendarEvent<T> b) => a.start.compareTo(b.start));

    for (CalendarEvent<T> event in eventsToArrange) {
      double left = calculateLeft(event.start);
      double width = calculateWidth(event.dateTimeRange);

      List<DateTime> datesFilled = event.datesSpanned;

      // Find events that fill the same dates as the current event.
      List<PositionedMultiDayTileData<T>> arragedEventsAbove = arrangedEvents.where(
        (PositionedMultiDayTileData<T> arragnedEvent) {
          return arragnedEvent.event.datesSpanned
              .any((DateTime date) => datesFilled.contains(date));
        },
      ).toList()
        ..sort((PositionedMultiDayTileData<T> a, PositionedMultiDayTileData<T> b) =>
            a.top.compareTo(b.top));

      double top = 0;
      if (arragedEventsAbove.isNotEmpty) {
        top = arragedEventsAbove.last.top + tileHeight;
      }

      updateStackHeight(top);

      addArrangedEvent(
        positionMultidayEvent(
          event: event,
          left: left,
          top: top,
          width: width,
        ),
      );
    }

    if (selectedEvent != null) {
      List<PositionedMultiDayTileData<T>> selectedArrangedEvent = arrangedEvents
          .where((PositionedMultiDayTileData<T> element) => element.event == selectedEvent)
          .toList();
      if (selectedArrangedEvent.isNotEmpty) {
        arrangedEvents
            .removeWhere((PositionedMultiDayTileData<T> element) => element.event == selectedEvent);
        arrangedEvents.addAll(selectedArrangedEvent);
      }
    }

    return arrangedEvents;
  }

  PositionedMultiDayTileData<T> arrangeEvent(CalendarEvent<T> event) {
    double left = calculateLeft(event.start);
    double width = calculateWidth(event.dateTimeRange);

    return positionMultidayEvent(
      event: event,
      left: left,
      width: width,
      top: 0,
    );
  }

  PositionedMultiDayTileData<T> positionMultidayEvent({
    required CalendarEvent<T> event,
    required double left,
    required double top,
    required double width,
  }) {
    double checkedWidth = width;

    double checkedleft = left;
    bool continuesBefore = false;
    if (checkedleft < 0) {
      checkedleft = 0;
      checkedWidth = width + left;
      continuesBefore = true;
    }

    double checkedRight = left + width;
    bool continuesAfter = false;
    if (checkedRight > maxWidth) {
      checkedWidth = maxWidth - left;
      continuesAfter = true;
    }

    return PositionedMultiDayTileData<T>(
      event: event,
      dateRange: event.dateTimeRange,
      left: checkedleft,
      top: top,
      width: checkedWidth,
      height: tileHeight,
      continuesBefore: continuesBefore,
      continuesAfter: continuesAfter,
    );
  }

  /// Calculates the top position of the event.
  double calculateTop(int numberOfEventsAbove) => tileHeight * numberOfEventsAbove;

  /// Calculates the left position of the event.
  double calculateLeft(DateTime date) =>
      (date.startOfDay.difference(visibleDateRange.start).inDays * dayWidth);

  /// Calculates the width of the event.
  double calculateWidth(DateTimeRange dateRange) => (dateRange.dayDifference * dayWidth);
}

class PositionedMultiDayTileData<T extends Object?> {
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
