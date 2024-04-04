import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// The base MultiChildLayoutDelegate for [EventGroupLayoutDelegate]'s
///
/// This class is used to layout the [CalendarEvent]'s in a [EventGroupWidget].
///
/// [events] is the list of [CalendarEvent]'s that are overlapping.
///
/// [heightPerMinute] is the height of a minute in the [EventGroupWidget].
///
/// [date] is the start of the day.
/// * this is used to calculate the offset of the [CalendarEvent] from the start of the day.
///
/// [startHour] is the start hour of the day.
///
/// [endHour] is the end hour of the day.
///
///  _________ The start of the day (StartHour)
/// |       ↑
/// |       | this can be calculated using
/// |       | (event.dateTimeRangeOnDate(startOfGroup).start.difference(startOfGroup).inMinutes * heightPerMinute)
/// |       ↓
/// | ________The start of the event.
/// | |
/// | |
/// | |
/// | |
/// | |
/// | |
/// | |
/// | |________
/// |
/// |
/// |__________
///
abstract class EventGroupLayoutDelegate<T> extends MultiChildLayoutDelegate {
  EventGroupLayoutDelegate({
    required this.events,
    required this.date,
    required this.heightPerMinute,
    required this.startHour,
    required this.endHour,
  });

  final DateTime date;
  final double heightPerMinute;
  final List<CalendarEvent<T>> events;
  final int startHour;
  final int endHour;

  @override
  bool shouldRelayout(covariant EventGroupLayoutDelegate oldDelegate) {
    return oldDelegate.events != events;
  }

  double calculateYPosition(Duration timeBeforeStart, double heightPerMinute) {
    return (timeBeforeStart.inMinutes * heightPerMinute).ceilToDouble();
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return ((duration.inSeconds / 60) * heightPerMinute).floorToDouble();
  }

  /// The y position of the start hour.
  double get startHourPosition => calculateYPosition(
        Duration(hours: startHour),
        heightPerMinute,
      );

  /// The y position of the end hour.
  double get endHourPosition => calculateYPosition(
        Duration(hours: endHour),
        heightPerMinute,
      );

  /// The start time of the day.
  late DateTime startTime = DateTime(
    date.year,
    date.month,
    date.day,
    startHour,
  );

  /// The end time of the day.
  late DateTime endTime = DateTime(
    date.year,
    date.month,
    date.day,
    endHour,
  );
}

/// A [EventGroupLayoutDelegate] that lays out the tiles on top of each other.
class EventGroupOverlapLayoutDelegate<T> extends EventGroupLayoutDelegate<T> {
  EventGroupOverlapLayoutDelegate({
    required super.events,
    required super.date,
    required super.heightPerMinute,
    required super.startHour,
    required super.endHour,
  });

  @override
  void performLayout(Size size) {
    final startDy = startHourPosition;
    final endDy = endHourPosition;

    final numChildren = events.length;
    final tileWidth = size.width;

    for (var i = 0; i < numChildren; i++) {
      final id = i;
      final event = events[id];

      // Calculate the x offset of the tile.
      final xOffset = (tileWidth / numChildren) * id;

      // Calculate the top offset of the tile.
      final eventStartOnDate = event.dateTimeRangeOnDate(date).start;
      final timeBeforeStart = eventStartOnDate.difference(date);

      // Clamp the y position to the start and end hour.
      final dy = calculateYPosition(
        timeBeforeStart,
        heightPerMinute,
      ).clamp(startDy, endDy);

      final start =
          eventStartOnDate.isBefore(startTime) ? startTime : eventStartOnDate;
      final eventEndOnDate = event.dateTimeRangeOnDate(date).end;
      final end = eventEndOnDate.isAfter(endTime) ? endTime : eventEndOnDate;

      // Calculate the height of the tile.
      var childHeight = calculateHeight(
        end.difference(start),
        heightPerMinute,
      );

      // if the child height is less than 0, make it invisible.
      if (childHeight < 0) {
        childHeight = 0.0001;
      }

      // Calculate the width of the tile.
      final width = (tileWidth / numChildren) * (numChildren - id);

      // Layout the tile.
      layoutChild(
        id,
        BoxConstraints.tightFor(
          width: width,
          height: childHeight,
        ),
      );

      positionChild(
        id,
        Offset(xOffset, dy),
      );
    }
  }
}

/// A [EventGroupLayoutDelegate] that lays out the tiles next to each other.
class EventGroupBasicLayoutDelegate<T> extends EventGroupLayoutDelegate<T> {
  EventGroupBasicLayoutDelegate({
    required super.events,
    required super.date,
    required super.heightPerMinute,
    required super.startHour,
    required super.endHour,
  });

  @override
  void performLayout(Size size) {
    final startDy = startHourPosition;
    final endDy = endHourPosition;
    final numChildren = events.length;

    final tileWidths = <int, double>{};
    final tilePositions = <int, Offset>{};
    final tileHeight = <int, double>{};
    var entriesToRight = 0;

    // Find the longest consecutive batch of events that are each others right.
    for (var id = 0; id < numChildren; id++) {
      int findEventsToRight(
        List<CalendarEvent> entriesBefore,
      ) {
        final indexOfNextEvent = events.indexWhere(
          (otherEvent) {
            return entriesBefore.last.duration >= otherEvent.duration &&
                !entriesBefore.contains(otherEvent) &&
                entriesBefore.last.dateTimeRange
                    .overlaps(otherEvent.dateTimeRange);
          },
        );

        if (indexOfNextEvent == -1) {
          return entriesBefore.length;
        } else {
          entriesBefore.add(events[indexOfNextEvent]);
          return findEventsToRight(entriesBefore);
        }
      }

      entriesToRight = max(
        entriesToRight,
        findEventsToRight(<CalendarEvent>[events[id]]),
      );
    }

    // Set the width of each tile.
    tileWidths.addEntries({
      for (var i = 0; i < numChildren; i++)
        MapEntry(i, (size.width / max(entriesToRight, 1)).floorToDouble()),
    });

    // Calculate position of each tile.
    for (var id = 0; id < numChildren; id++) {
      final event = events[id];

      final eventsBefore = tilePositions.keys.map((e) => events[e]).where(
        (eventBefore) {
          return event.dateTimeRange.overlaps(eventBefore.dateTimeRange) &&
              eventBefore.duration >= event.duration;
        },
      ).toList();

      final eventsAfter = events
          .where(
            (element) =>
                element.dateTimeRange.overlaps(event.dateTimeRange) &&
                element.duration <= event.duration &&
                element != event &&
                !tilePositions.keys.contains(events.indexOf(element)),
          )
          .toList();

      var dx = 0.0;
      if (eventsBefore.isNotEmpty) {
        final eventBeforeID = events.indexOf(eventsBefore.last);
        final eventBeforeDx = tilePositions[eventBeforeID]!.dx;
        dx = eventBeforeDx + tileWidths[eventBeforeID]!;

        if (eventsAfter.isEmpty) {
          // if there are no events after, then expand the tile to the end of the screen.
          tileWidths[id] = size.width - dx;
        }
      }

      // Calculate the top offset of the tile.
      final eventStartOnDate = event.dateTimeRangeOnDate(date).start;
      final timeBeforeStart = eventStartOnDate.difference(date);

      // Clamp the y position to the start and end hour.
      final dy = calculateYPosition(
        timeBeforeStart,
        heightPerMinute,
      ).clamp(startDy, endDy);

      final start =
          eventStartOnDate.isBefore(startTime) ? startTime : eventStartOnDate;
      final eventEndOnDate = event.dateTimeRangeOnDate(date).end;
      final end = eventEndOnDate.isAfter(endTime) ? endTime : eventEndOnDate;

      final childHeight = calculateHeight(
        end.difference(start),
        heightPerMinute,
      );

      tileHeight[id] = childHeight;
      tilePositions[id] = Offset(dx, dy);
    }

    // Layout the tiles.
    for (var id = 0; id < numChildren; id++) {
      final height = tileHeight[id]!;
      final position = tilePositions[id]!;
      final tileWidth = tileWidths[id]!;

      layoutChild(
        id,
        BoxConstraints.tightFor(
          width: tileWidth,
          height: height,
        ),
      );

      positionChild(
        id,
        position,
      );
    }
  }
}
