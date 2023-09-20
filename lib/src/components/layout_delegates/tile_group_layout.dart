import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// The base MultiChildLayoutDelegate for [TileGroupLayoutDelegate]'s
///
abstract class TileGroupLayoutDelegate<T> extends MultiChildLayoutDelegate {
  TileGroupLayoutDelegate({
    required this.events,
    required this.startOfGroup,
    required this.heightPerMinute,
  });

  final DateTime startOfGroup;
  final double heightPerMinute;
  final List<CalendarEvent<T>> events;

  @override
  bool shouldRelayout(covariant TileGroupLayoutDelegate oldDelegate) {
    return oldDelegate.events != events;
  }
}

/// A [TileGroupLayoutDelegate] that lays out the tiles on top of each other.
class TileGroupLayoutDelegateOverlap<T> extends TileGroupLayoutDelegate<T> {
  TileGroupLayoutDelegateOverlap({
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
          event.durationOnDate(startOfGroup).inMinutes * heightPerMinute;

      final childSize = layoutChild(
        id,
        BoxConstraints.tightFor(
          width: tileWidth - ((i * tileWidth) / 5),
          height: childHeight,
        ),
      );

      tileSizes[id] = childSize;
    }

    for (var id = 0; id < numChildren; id++) {
      final event = events[id];
      final dx = 0.0 + ((id * tileWidth) / 5);
      final dy = event
              .dateTimeRangeOnDate(startOfGroup)
              .start
              .difference(startOfGroup)
              .inMinutes *
          heightPerMinute;

      positionChild(
        id,
        Offset(dx, dy),
      );
    }
  }
}

/// A [TileGroupLayoutDelegate] that lays out the tiles next to each other.
class TileGroupLayoutDelegateBasic<T> extends TileGroupLayoutDelegate<T> {
  TileGroupLayoutDelegateBasic({
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
          width: size.width / numChildren,
          height:
              event.durationOnDate(startOfGroup).inMinutes * heightPerMinute,
        ),
      );

      tileSizes[id] = childSize;
    }

    for (var id = 0; id < numChildren; id++) {
      final event = events[id];
      final dx = id * tileConstraints.maxWidth;
      final dy = event
              .dateTimeRangeOnDate(startOfGroup)
              .start
              .difference(startOfGroup)
              .inMinutes *
          heightPerMinute;

      positionChild(
        id,
        Offset(dx, dy),
      );
    }
  }
}
