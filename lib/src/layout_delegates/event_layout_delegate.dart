import 'package:flutter/material.dart';

import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/time_of_day_range.dart';
import 'package:kalender/src/extensions.dart';

export 'package:kalender/src/models/calendar_event.dart';
export 'package:kalender/src/models/time_of_day_range.dart';
export 'package:kalender/src/extensions.dart';


/// Signature for the strategy that determines how DayEvents are layed out.
///
/// There are two built-in strategies:
///
///  * [overlapLayoutStrategy], which displays the tile over each other.
///
///  * [sideBySideLayoutStrategy], which displays the tiles next to each other.
///
typedef EventLayoutStrategy<T extends Object?> = EventLayoutDelegate<T> Function(
  Iterable<CalendarEvent<T>> events,
  DateTime date,
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
);

/// A [EventLayoutStrategy] that lays out the tiles on top of each other.
EventLayoutDelegate overlapLayoutStrategy<T extends Object?>(
  Iterable<CalendarEvent<T>> events,
  DateTime date,
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
) {
  return OverlapLayoutDelegate<T>(
    events: events,
    date: date,
    heightPerMinute: heightPerMinute,
    timeOfDayRange: timeOfDayRange,
  );
}

/// A [EventLayoutStrategy] that lays out the tiles on top of each other.
EventLayoutDelegate sideBySideLayoutStrategy<T extends Object?>(
  Iterable<CalendarEvent<T>> events,
  DateTime date,
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
) {
  return SideBySideLayoutDelegate<T>(
    events: events,
    date: date,
    heightPerMinute: heightPerMinute,
    timeOfDayRange: timeOfDayRange,
  );
}

/// The base [MultiChildLayoutDelegate] class for laying out [CalendarEvent]s.
///
/// [EventLayoutDelegate]s are used to layout [CalendarEvent]s in  a [CustomMultiChildLayout].
///
/// The [EventLayoutDelegate] has some helper methods:
///
/// * [calculateHeight] - Calculates the height of an item based on the [Duration] and [heightPerMinute] of the event.
/// * [calculateDistanceFromStart] - Calculates the distance from the start of the day to the start of the [CalendarEvent].
/// * [calculateVerticalLayoutData] - Calculates the top and bottom of each event.
/// * [groupVerticalLayoutData] - Groups the [VerticalLayoutData] into horizontal groups.
///
abstract class EventLayoutDelegate<T extends Object?> extends MultiChildLayoutDelegate {
  EventLayoutDelegate({
    required this.events,
    required this.heightPerMinute,
    required this.date,
    required this.timeOfDayRange,
  });

  final Iterable<CalendarEvent<T>> events;
  final DateTime date;
  final TimeOfDayRange timeOfDayRange;
  final double heightPerMinute;

  /// Calculates the height of an item based on the [duration] and [heightPerMinute] of the event.
  ///
  /// [event] - The event to calculate the height of.
  /// [heightPerMinute] - The per minute of the current view.
  double calculateHeight(CalendarEvent<T> event) {
    final durationOnDate = event.dateTimeRangeOnDate(date).duration;
    return ((durationOnDate.inSeconds / 60) * heightPerMinute);
  }

  /// Calculates the distance from the start of the day to the start of the [event].
  ///
  /// [event] - The event to calculate the distance from.
  ///
  /// * Note: this takes into account the [TimeOfDayRange] of the [EventLayoutDelegate].
  double calculateDistanceFromStart(CalendarEvent<T> event) {
    final eventStart = event.dateTimeRangeOnDate(date).start;
    final dateStart = timeOfDayRange.start.toDateTime(date);
    return (eventStart.difference(dateStart).inMinutes * heightPerMinute);
  }

  /// Vertical layout of the events.
  ///
  /// Calculates the top and bottom of each event.
  Iterable<VerticalLayoutData> calculateVerticalLayoutData() {
    final numberOfChildren = events.length;
    final layoutEvents = <VerticalLayoutData>[];
    // Calculate the top and bottom of each event.
    for (var i = 0; i < numberOfChildren; i++) {
      final id = i;
      final event = events.elementAt(i);

      final top = calculateDistanceFromStart(event);
      final height = calculateHeight(event);
      final bottom = top + height;

      layoutEvents.add(VerticalLayoutData(id: id, top: top, bottom: bottom));
    }
    return layoutEvents;
  }

  /// Groups the [VerticalLayoutData] into horizontal groups.
  Iterable<HorizontalGroupData> groupVerticalLayoutData(
    Iterable<VerticalLayoutData> verticalLayoutData,
  ) {
    final horizontalGroups = <HorizontalGroupData>[];

    final sortedData = verticalLayoutData.toList()
    ..sort((a, b) => b.height.compareTo(a.height))
    ..sort((a, b) => b.height.compareTo(a.height) == 0 ? a.top.compareTo(b.top) : 0);

    for (var i = 0; i < sortedData.length; i++) {
      final layoutData = sortedData.elementAt(i);
      final id = layoutData.id;
      final top = layoutData.top;
      final bottom = layoutData.bottom;

      // If the layout data is already in a group, skip it.
      if (horizontalGroups.any((group) => group.containsId(id))) continue;

      // Find the index of the group that overlaps with the layout data.
      final groupIndex = horizontalGroups.indexWhere((group) => group.overlaps(top, bottom));

      if (groupIndex != -1) {
        final group = horizontalGroups.elementAt(groupIndex);
        group.add(layoutData);
      } else {
        horizontalGroups.add(HorizontalGroupData(layoutData));
      }
    }

    return horizontalGroups;
  }

  @override
  bool shouldRelayout(covariant EventLayoutDelegate oldDelegate) {
    return oldDelegate.events != events ||
        oldDelegate.heightPerMinute != heightPerMinute ||
        oldDelegate.timeOfDayRange != timeOfDayRange;
  }
}

// TODO: document.

class OverlapLayoutDelegate<T extends Object?> extends EventLayoutDelegate<T> {
  OverlapLayoutDelegate({
    required super.events,
    required super.heightPerMinute,
    required super.date,
    required super.timeOfDayRange,
  });

  @override
  void performLayout(Size size) {
    // Calculate the vertical layout data.
    final verticalLayoutData = calculateVerticalLayoutData();

    // Group the vertical layout data into horizontal groups.
    final horizontalGroups = groupVerticalLayoutData(verticalLayoutData);

    for (var i = 0; i < horizontalGroups.length; i++) {
      final group = horizontalGroups.elementAt(i);

      // Sort the vertical layout data by height and top.
      final verticalLayoutData = group.verticalLayoutData
        ..sort((a, b) => b.height.compareTo(a.height))
        ..sort((a, b) => b.height.compareTo(a.height) == 0 ? b.top.compareTo(a.top) : 0);

      final numberOfEvents = verticalLayoutData.length;

      final childWidth = size.width / numberOfEvents;

      for (var i = 0; i < numberOfEvents; i++) {
        final data = verticalLayoutData.elementAt(i);
        final id = data.id;

        // Calculate the x offset of the tile.
        final tileXOffset = childWidth * i;

        // Calculate the width of the tile.
        final tileWidth = childWidth * (numberOfEvents - i);

        // Layout the tile.
        layoutChild(
          id,
          BoxConstraints.tightFor(
            width: tileWidth,
            height: data.height,
          ),
        );

        positionChild(
          id,
          Offset(tileXOffset, data.top),
        );
      }
    }
  }
}

// TODO: document.

class SideBySideLayoutDelegate<T extends Object?> extends EventLayoutDelegate<T> {
  SideBySideLayoutDelegate({
    required super.events,
    required super.heightPerMinute,
    required super.date,
    required super.timeOfDayRange,
  });

  @override
  void performLayout(Size size) {
    // Calculate the vertical layout data.
    final verticalLayoutData = calculateVerticalLayoutData();

    // Group the vertical layout data into horizontal groups.
    final horizontalGroups = groupVerticalLayoutData(verticalLayoutData);

    for (var i = 0; i < horizontalGroups.length; i++) {
      final group = horizontalGroups.elementAt(i);
      final verticalLayoutData = group.verticalLayoutData
        ..sort((a, b) => b.height.compareTo(a.height))
        ..sort((a, b) => b.height.compareTo(a.height) == 0 ? a.top.compareTo(b.top) : 0);

      final numberOfEvents = verticalLayoutData.length;
      final longest = _findLongestChain(verticalLayoutData);
      final childWidth = size.width / longest;

      for (var i = 0; i < numberOfEvents; i++) {
        final data = verticalLayoutData.elementAt(i);
        final id = data.id;

        // Find the overlaps to the left of the tile.
        final tilesToLeft = verticalLayoutData.getRange(0, i);
        final overlapsLeft = tilesToLeft.where((e) => e.overlaps(data)).length;

        // Calculate the x offset of the tile.
        final tileXOffset = childWidth * overlapsLeft;

        // Find the overlaps to the right of the tile.
        final tilesToRight = verticalLayoutData.getRange(i + 1, numberOfEvents);
        final overlapsRight = tilesToRight.where((e) => e.overlaps(data)).toList();

        // Calculate the width of the tile.
        var tileWidth = childWidth;
        if (overlapsRight.isEmpty) {
          tileWidth = size.width - tileXOffset;
        }

        // Layout the tile.
        layoutChild(
          id,
          BoxConstraints.tightFor(
            width: tileWidth,
            height: data.height,
          ),
        );

        positionChild(
          id,
          Offset(tileXOffset, data.top),
        );
      }
    }
  }

  /// Finds the longest chain of overlapping events.
  int _findLongestChain(Iterable<VerticalLayoutData> verticalLayoutData) {
    var longest = <VerticalLayoutData>[];
    final currentChain = <VerticalLayoutData>[verticalLayoutData.first];

    void depthFirstSearch(VerticalLayoutData current, List<VerticalLayoutData> chain) {
      chain.add(current);

      var extended = false;
      for (var data in verticalLayoutData) {
        if (!chain.contains(data) && current.overlaps(data)) {
          extended = true;
          depthFirstSearch(data, chain);
        }
      }
      if (!extended && chain.length > longest.length) {
        longest = chain;
      }
    }

    for (var data in verticalLayoutData) {
      depthFirstSearch(data, []);
    }

    // Final comparison after loop
    if (currentChain.length > longest.length) longest = currentChain;

    var length = longest.length;
    for (var i = 0; i < longest.length; i++) {
      final current = longest[i];
      final next = longest.elementAtOrNull(i + 1);
      if (next != null && !current.overlaps(next)) length--;
    }
    return length;
  }
}


// TODO: document.
// TODO: fix issues, 

class VerticalLayoutData {
  /// The id of the event.
  final int id;

  /// The top of the event.
  final double top;

  /// The bottom of the event.
  final double bottom;

  VerticalLayoutData({required this.id, required this.top, required this.bottom});

  /// The height of the event.
  double get height => bottom - top;

  bool overlaps(VerticalLayoutData layoutData) {
    final inside = layoutData.top >= top && layoutData.bottom <= bottom;
    final overlapTop = layoutData.top < top && layoutData.bottom > top;
    final overlapBottom = layoutData.top < bottom && layoutData.bottom > bottom;
    final outside = layoutData.top <= top && layoutData.bottom >= bottom;
    return inside || overlapTop || overlapBottom || outside;
  }

  @override
  String toString() => 'id: $id, top: $top, bottom: $bottom';
}

class HorizontalGroupData {
  final List<VerticalLayoutData> verticalLayoutData = [];

  double top = double.infinity;
  double bottom = double.negativeInfinity;

  HorizontalGroupData(VerticalLayoutData layoutData) {
    verticalLayoutData.add(layoutData);
    top = layoutData.top;
    bottom = layoutData.bottom;
  }

  /// Adds the [layoutData] to the [HorizontalGroupData].
  void add(VerticalLayoutData layoutData) {
    verticalLayoutData.add(layoutData);
    top = layoutData.top < top ? layoutData.top : top;
    bottom = layoutData.bottom > bottom ? layoutData.bottom : bottom;
  }

  /// Whether the [HorizontalGroupData] overlaps with the given [top] and [bottom].
  bool overlaps(double top, double bottom) {
    final inside = top >= this.top && bottom <= this.bottom;
    final overlapTop = top < this.top && bottom > this.top;
    final overlapBottom = top < this.bottom && bottom > this.bottom;
    final outside = top <= this.top && bottom >= this.bottom;
    return inside || overlapTop || overlapBottom || outside;
  }

  /// Whether the [HorizontalGroupData] contains the [id].
  bool containsId(int id) => verticalLayoutData.any((layoutData) => layoutData.id == id);

  @override
  String toString() => 'top: $top, bottom: $bottom';
}
