import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// The base MultiChildLayoutDelegate for [EventGroupLayoutDelegate]'s
///
/// This class is used to layout the [CalendarEvent]'s in a [EventGroupWidget].
///
/// [events] is the list of [CalendarEvent]'s that should be laid out.
///
/// [heightPerMinute] is the height of a minute in the [EventGroupWidget].
///
/// [startOfGroup] is the [DateTime] start of the group of events.
/// * this is used to calculate the offset of the [CalendarEvent] from the top of the [EventGroupWidget].
///
///  _________The start of the group.
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
    required this.startOfGroup,
    required this.heightPerMinute,
  });

  final DateTime startOfGroup;
  final double heightPerMinute;
  final List<CalendarEvent<T>> events;

  @override
  bool shouldRelayout(covariant EventGroupLayoutDelegate oldDelegate) {
    return oldDelegate.events != events;
  }
}

/// A [EventGroupLayoutDelegate] that lays out the tiles on top of each other.
class EventGroupOverlapLayoutDelegate<T> extends EventGroupLayoutDelegate<T> {
  EventGroupOverlapLayoutDelegate({
    required super.events,
    required super.startOfGroup,
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
      final childHeight =
          (event.durationOnDate(startOfGroup).inMinutes * heightPerMinute)
              .floorToDouble();

      final childSize = layoutChild(
        id,
        BoxConstraints.tightFor(
          width: (tileWidth - ((i * tileWidth) / 5)).floorToDouble(),
          height: childHeight,
        ),
      );

      tileSizes[id] = childSize;
    }

    for (var id = 0; id < numChildren; id++) {
      final event = events[id];
      final dx = 0.0 + ((id * tileWidth) / 5);
      final dy = (event
                  .dateTimeRangeOnDate(startOfGroup)
                  .start
                  .difference(startOfGroup)
                  .inMinutes *
              heightPerMinute)
          .floorToDouble();

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
    required super.startOfGroup,
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
      final childSize = layoutChild(
        id,
        BoxConstraints.tightFor(
          width: (size.width / numChildren).floorToDouble(),
          height:
              (event.durationOnDate(startOfGroup).inMinutes * heightPerMinute)
                  .floorToDouble(),
        ),
      );

      tileSizes[id] = childSize;
    }

    for (var id = 0; id < numChildren; id++) {
      final event = events[id];
      final dx = id * tileConstraints.maxWidth;
      final dy = (event
                  .dateTimeRangeOnDate(startOfGroup)
                  .start
                  .difference(startOfGroup)
                  .inMinutes *
              heightPerMinute)
          .floorToDouble();

      positionChild(
        id,
        Offset(dx, dy),
      );
    }
  }
}
