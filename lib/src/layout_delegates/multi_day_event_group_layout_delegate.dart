import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/groups/event_group.dart';

/// The base Mul`tiChildLayoutDelegate for [MultiDayEventsLayoutDelegate]'s
///
/// [MultiDayEventsLayoutDelegate]'s are used to layout [EventGroup]'s in a [MultiDayEventGroupWidget].
///
/// [multiDayTileHeight] is the height of a tile in the [MultiDayEventGroupWidget].
///
abstract class MultiDayEventsLayoutDelegate<T> extends MultiChildLayoutDelegate {
  MultiDayEventsLayoutDelegate({
    required this.group,
    required this.multiDayTileHeight,
  });

  final MultiDayEventGroup<T> group;
  final double multiDayTileHeight;

  @override
  bool shouldRelayout(covariant MultiDayEventsLayoutDelegate oldDelegate) {
    return oldDelegate.group != group || oldDelegate.multiDayTileHeight != multiDayTileHeight;
  }
}

// TODO: document this.

class MultiDayEventsDefaultLayoutDelegate<T> extends MultiDayEventsLayoutDelegate<T> {
  MultiDayEventsDefaultLayoutDelegate({
    required super.group,
    required super.multiDayTileHeight,
  });

  @override
  Size getSize(BoxConstraints constraints) {
    final events = group.sortedEvents;

    /// TODO: this does not work 100% correctly.
    /// For single days this seems to work fine, but for multi-day events it does not.
    var maxOverlaps = 0;
    for (final event in events) {
      final overlaps = events.where(
        (e) => e.datesSpanned.any(event.datesSpanned.contains),
      );
      maxOverlaps = max(maxOverlaps, overlaps.length);
    }

    return Size(
      constraints.maxWidth,
      maxOverlaps * multiDayTileHeight + multiDayTileHeight,
    );
  }

  @override
  void performLayout(Size size) {
    final events = group.sortedEvents;
    final numberOfChildren = events.length;
    final visibleDates = group.dateTimeRange.datesSpanned;
    final dayWidth = size.width / visibleDates.length;

    final tileSizes = <int, Size>{};
    final tileDx = <int, double>{};

    // Loop through each event.
    for (var i = 0; i < numberOfChildren; i++) {
      final event = events[i];

      final eventDates = event.datesSpanned;

      // first visible date.
      final firstVisibleDate = eventDates.firstWhere(
        visibleDates.contains,
        orElse: () => eventDates.first,
      );

      // last visible date.
      final lastVisibleDate = eventDates.lastWhere(
        visibleDates.contains,
        orElse: () => eventDates.last,
      );

      final visibleEventDates = eventDates.getRange(
        eventDates.indexOf(firstVisibleDate),
        eventDates.indexOf(lastVisibleDate) + 1,
      );

      final indexOfFirstVisibleDate = visibleDates.indexOf(visibleEventDates.first.startOfDay);
      final dx = (indexOfFirstVisibleDate * dayWidth).roundToDouble();
      tileDx[i] = dx;

      // Calculate the width of the tile.
      final tileWidth = ((visibleEventDates.length) * dayWidth).roundToDouble();

      // Layout the tile.
      final childSize = layoutChild(
        i,
        BoxConstraints.tightFor(
          width: tileWidth,
          height: multiDayTileHeight,
        ),
      );

      tileSizes[i] = childSize;
    }

    final tilePositions = <int, Offset>{};
    for (var id = 0; id < numberOfChildren; id++) {
      final event = events[id];

      // Find events that fill the same dates as the current event.
      final eventsAbove = tilePositions.keys.map((e) => events[e]).where(
        (eventAbove) {
          return eventAbove.datesSpanned.any(event.datesSpanned.contains);
        },
      ).toList();

      var dy = 0.0;
      if (eventsAbove.isNotEmpty) {
        final eventAboveID = events.indexOf(eventsAbove.last);
        dy = tilePositions[eventAboveID]!.dy + multiDayTileHeight;
      }

      tilePositions[id] = Offset(
        tileDx[id]!,
        dy.roundToDouble(),
      );
    }

    for (var id = 0; id < numberOfChildren; id++) {
      positionChild(
        id,
        tilePositions[id]!,
      );
    }
  }
}
