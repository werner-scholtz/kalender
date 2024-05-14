import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/event_group.dart';

/// Signature for the strategy that determines how DayEvents are layed out.
///
/// There are two built-in strategies:
///
///  * [overlapLayoutStrategy], which displays the tile over each other.
///
///  * [sideBySideLayoutStrategy], which displays the tiles next to each other.
///
typedef DayLayoutStrategy<T extends Object?> = EventGroupLayoutDelegate
    Function(
  EventGroup<T> eventGroup,
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
);

/// A [DayLayoutStrategy] that lays out the tiles on top of each other.
EventGroupLayoutDelegate overlapLayoutStrategy(
  EventGroup group,
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
) {
  return EventGroupOverlapLayoutDelegate(
    group: group,
    heightPerMinute: heightPerMinute,
    timeOfDayRange: timeOfDayRange,
  );
}

/// A [DayLayoutStrategy] that lays out the tiles next to each other.
EventGroupLayoutDelegate sideBySideLayoutStrategy(
  EventGroup eventGroup,
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
) {
  return EventGroupBasicLayoutDelegate(
    group: eventGroup,
    heightPerMinute: heightPerMinute,
    timeOfDayRange: timeOfDayRange,
  );
}

/// The base [MultiChildLayoutDelegate] class for laying out [EventGroup]s.
///
/// [EventGroupLayoutDelegate]s are used to layout [EventGroup]s
///
/// The [CustomMultiChildLayout] that uses this delegate will be sized according to the duration of the [EventGroup].
/// The [CustomMultiChildLayout] that uses this delegate will be positioned according to the [EventGroup]'s [DateTimeRange].
///
/// ex.
///
/// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <- Day-Start
///
///
///   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  <- CustomMultiChildLayout
///  |          EventGroup            |
///  |                                |
///  |                                |
///  |                                |
///   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///
///
/// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <- Day-End
///
///
/// Taking  a closer look at the event group:
///
///   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  <- EventGroup-Start
///  | |---------|
///  | |  Event  |
///  | |         |
///  | |         |
///  | |         |
///  | |---------|
///  |      |
///  |      | Distance can be calculated like so:
///  |      | (event.dateTimeRangeOnDate(startOfGroup).start.difference(startOfGroup).inMinutes * heightPerMinute)
///  |     \|/
///   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  <- EventGroup-End
///
///
abstract class EventGroupLayoutDelegate<T extends Object?>
    extends MultiChildLayoutDelegate {
  EventGroupLayoutDelegate({
    required this.group,
    required this.heightPerMinute,
    required this.timeOfDayRange,
  });

  final EventGroup<T> group;
  final TimeOfDayRange timeOfDayRange;
  final double heightPerMinute;

  /// Calculates the height of an item based on the [duration] and [heightPerMinute] of the event.
  ///
  /// [duration] - The duration of the event.
  /// [heightPerMinute] - The per minute of the current view.
  double calculateHeight(Duration duration, double heightPerMinute) {
    return ((duration.inSeconds / 60) * heightPerMinute);
  }

  /// Calculates the distance from the start of the group to the [dateTime].
  double calculateDistanceFromStartOfGroup(DateTime dateTime) {
    return (dateTime.difference(group.start).inMinutes * heightPerMinute);
  }

  @override
  bool shouldRelayout(covariant EventGroupLayoutDelegate oldDelegate) {
    return oldDelegate.group != group ||
        oldDelegate.heightPerMinute != heightPerMinute ||
        oldDelegate.timeOfDayRange != timeOfDayRange;
  }
}

/// A [EventGroupLayoutDelegate] that lays out the tiles on top of each other.
class EventGroupOverlapLayoutDelegate<T extends Object?>
    extends EventGroupLayoutDelegate<T> {
  EventGroupOverlapLayoutDelegate({
    required super.group,
    required super.heightPerMinute,
    required super.timeOfDayRange,
  });

  @override
  void performLayout(Size size) {
    final numberOfChildren = group.events.length;
    final baseWidth = size.width;
    final childWidth = baseWidth / numberOfChildren;
    final events = group.events;

    for (var i = 0; i < numberOfChildren; i++) {
      final tileId = i;

      // Calculate the distance from the top of the group to the top of the event.
      final tileYOffset = calculateDistanceFromStartOfGroup(
        events[i].dateTimeRangeOnDate(group.start).start,
      );

      // Calculate the height of the tile.
      final duration = events[i].dateTimeRangeOnDate(group.date).duration;
      final tileHeight = calculateHeight(duration, heightPerMinute);

      // Calculate the x offset of the tile.
      final tileXOffset = childWidth * tileId;

      // Calculate the width of the tile.
      final tileWidth = childWidth * (numberOfChildren - tileId);

      // Layout the tile.
      layoutChild(
        tileId,
        BoxConstraints.tightFor(
          width: tileWidth,
          height: tileHeight,
        ),
      );

      positionChild(
        tileId,
        Offset(tileXOffset, tileYOffset),
      );
    }
  }
}

/// A [EventGroupLayoutDelegate] that lays out the tiles next to each other.
class EventGroupBasicLayoutDelegate<T> extends EventGroupLayoutDelegate<T> {
  EventGroupBasicLayoutDelegate({
    required super.group,
    required super.heightPerMinute,
    required super.timeOfDayRange,
  });

  @override
  void performLayout(Size size) {
    final events = group.events;
    final numberOfChildren = group.events.length;

    final tileWidths = <int, double>{};
    final tilePositions = <int, Offset>{};
    final tileHeights = <int, double>{};
    var entriesToRight = 0;

    // Find the longest consecutive batch of events that are each others right.
    for (var id = 0; id < numberOfChildren; id++) {
      entriesToRight = max(
        entriesToRight,
        findNumberOfEventsToRight(events, <CalendarEvent>[events[id]]),
      );
    }

    // Calculate the width of each tile.
    tileWidths.addEntries({
      for (var i = 0; i < numberOfChildren; i++)
        MapEntry(i, (size.width / max(entriesToRight, 1)).floorToDouble()),
    });

    // Calculate position of each tile.
    for (var i = 0; i < numberOfChildren; i++) {
      final event = events[i];

      final eventsBefore = tilePositions.keys.map((e) => events[e]).where(
        (previous) {
          final overlap = event.dateTimeRange.overlaps(previous.dateTimeRange);
          final isShorter = previous.duration >= event.duration;
          return overlap && isShorter;
        },
      );

      final eventsAfter = events.where(
        (previous) {
          final overlaps = event.dateTimeRange.overlaps(previous.dateTimeRange);
          final isLonger = previous.duration <= event.duration;
          final isNotSelf = previous != event;
          final isPresent =
              tilePositions.keys.contains(events.indexOf(previous));
          return overlaps && isLonger && isNotSelf && !isPresent;
        },
      );

      var dx = 0.0;
      if (eventsBefore.isNotEmpty) {
        final eventBeforeID = events.indexOf(eventsBefore.last);
        final eventBeforeDx = tilePositions[eventBeforeID]!.dx;
        dx = eventBeforeDx + tileWidths[eventBeforeID]!;

        if (eventsAfter.isEmpty) {
          // if there are no events after, then expand the tile to the end of the screen.
          tileWidths[i] = size.width - dx;
        }
      }

      // Calculate the distance from the top of the group to the top of the event.
      final tileYOffset = calculateDistanceFromStartOfGroup(
        events[i].dateTimeRangeOnDate(group.start).start,
      );

      // Calculate the height of the tile.
      final duration = events[i].dateTimeRangeOnDate(group.date).duration;
      final tileHeight = calculateHeight(duration, heightPerMinute);

      tileHeights[i] = tileHeight;
      tilePositions[i] = Offset(dx, tileYOffset);
    }

    // Layout the tiles.
    for (var id = 0; id < numberOfChildren; id++) {
      final height = tileHeights[id]!;
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

  int findNumberOfEventsToRight(
    List<CalendarEvent> events,
    List<CalendarEvent> entriesBefore,
  ) {
    final indexOfNextEvent = events.indexWhere(
      (otherEvent) {
        final isLonger = entriesBefore.last.duration >= otherEvent.duration;
        final isPresent = entriesBefore.contains(otherEvent);
        final overlaps =
            entriesBefore.last.dateTimeRange.overlaps(otherEvent.dateTimeRange);

        return isLonger && !isPresent && overlaps;
      },
    );

    if (indexOfNextEvent == -1) {
      return entriesBefore.length;
    } else {
      entriesBefore.add(events[indexOfNextEvent]);
      return findNumberOfEventsToRight(events, entriesBefore);
    }
  }
}
