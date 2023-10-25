import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// The base MultiChildLayoutDelegate for [EventGroupLayoutDelegate]'s
///
/// This class is used to layout the [CalendarEvent]'s in a [EventGroupWidget].
///
/// [events] is the list of [CalendarEvent]'s that are overlapping.
///
/// [heightPerMinute] is the height of a minute in the [EventGroupWidget].
///
/// [date] is the start of the day/
/// * this is used to calculate the offset of the [CalendarEvent] from the start of the day.
///
///  _________ The start of the day
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
  });

  final DateTime date;
  final double heightPerMinute;
  final List<CalendarEvent<T>> events;

  @override
  bool shouldRelayout(covariant EventGroupLayoutDelegate oldDelegate) {
    return oldDelegate.events != events;
  }

  double calculateTop(Duration timeBeforeStart, double heightPerMinute) {
    return (timeBeforeStart.inMinutes * heightPerMinute).ceilToDouble();
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return ((duration.inSeconds / 60) * heightPerMinute).floorToDouble();
  }
}

/// A [EventGroupLayoutDelegate] that lays out the tiles on top of each other.
class EventGroupOverlapLayoutDelegate<T> extends EventGroupLayoutDelegate<T> {
  EventGroupOverlapLayoutDelegate({
    required super.events,
    required super.date,
    required super.heightPerMinute,
  });

  @override
  void performLayout(Size size) {
    final numChildren = events.length;
    final tileWidth = size.width;

    final tileSizes = <Object, Size>{};
    for (var i = 0; i < numChildren; i++) {
      final id = i;
      final event = events[id];

      // Calculate the height of the tile.
      var childHeight = calculateHeight(
        event.durationOnDate(date),
        heightPerMinute,
      );

      if (event.forcedHeight != null) {
        childHeight = event.forcedHeight!;
      }

      // Layout the tile.
      final childSize = layoutChild(
        id,
        BoxConstraints.tightFor(
          width: (tileWidth - ((i * tileWidth) / 5)).floorToDouble(),
          height: childHeight,
        ),
      );

      // tileSizes[id] = childSize;
      tileSizes[id] = BoxConstraints.tight(size).constrain(childSize);
    }

    for (var id = 0; id < numChildren; id++) {
      final event = events[id];
      final dx = 0.0 + ((id * tileWidth) / 5);

      // Calculate the top offset of the tile.
      final eventStartOnDate = event.dateTimeRangeOnDate(date).start;
      final timeBeforeStart = eventStartOnDate.difference(date);
      final dy = calculateTop(timeBeforeStart, heightPerMinute);

      positionChild(
        id,
        Offset(dx, dy),
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
  });

  @override
  void performLayout(Size size) {
    final numChildren = events.length;

    final tileConstraints = BoxConstraints.expand(
      width: size.width / numChildren,
      height: size.height,
    );

    final tileSizes = <Object, Size>{};

    for (var i = 0; i < numChildren; i++) {
      final id = i;
      final event = events[id];

      // Calculate the height of the tile.
      final childHeight = calculateHeight(
        event.durationOnDate(date),
        heightPerMinute,
      );

      final childSize = layoutChild(
        id,
        BoxConstraints.tightFor(
          width: (size.width / numChildren).floorToDouble(),
          height: childHeight,
        ),
      );

      tileSizes[id] = BoxConstraints.tight(size).constrain(childSize);
    }

    for (var id = 0; id < numChildren; id++) {
      final event = events[id];
      final dx = id * tileConstraints.maxWidth;

      // Calculate the top offset of the tile.
      final eventStartOnDate = event.dateTimeRangeOnDate(date).start;
      final timeBeforeStart = eventStartOnDate.difference(date);
      final dy = calculateTop(timeBeforeStart, heightPerMinute);

      positionChild(
        id,
        Offset(dx, dy),
      );
    }
  }
}
