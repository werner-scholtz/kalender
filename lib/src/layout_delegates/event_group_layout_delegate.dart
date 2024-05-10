import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/event_group.dart';

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

    for (var i = 0; i < numberOfChildren; i++) {
      final tileId = i;

      // Calculate the distance from the top of the group to the top of the event.
      final tileYOffset = calculateDistanceFromStartOfGroup(
        group.events[i].dateTimeRangeOnDate(group.start).start,
      );

      // Calculate the height of the tile.
      final duration = group.events[i].dateTimeRangeOnDate(group.date).duration;
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
