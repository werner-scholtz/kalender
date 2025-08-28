import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/time_of_day_range.dart';

export 'package:kalender/kalender_extensions.dart';
export 'package:kalender/src/models/calendar_events/calendar_event.dart';
export 'package:kalender/src/models/time_of_day_range.dart';

/// Signature for the strategy that determines how DayEvents are laid out.
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
  double? minimumTileHeight,
  EventLayoutDelegateCache? cache,
);

/// A [EventLayoutStrategy] that lays out the tiles on top of each other.
EventLayoutDelegate overlapLayoutStrategy<T extends Object?>(
  Iterable<CalendarEvent<T>> events,
  DateTime date,
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
  double? minimumTileHeight,
  EventLayoutDelegateCache? cache,
) {
  return OverlapLayoutDelegate<T>(
    events: events,
    date: date,
    heightPerMinute: heightPerMinute,
    timeOfDayRange: timeOfDayRange,
    minimumTileHeight: minimumTileHeight,
    layoutCache: cache ?? EventLayoutDelegateCache(),
  );
}

/// A [EventLayoutStrategy] that lays out the tiles side by side.
EventLayoutDelegate sideBySideLayoutStrategy<T extends Object?>(
  Iterable<CalendarEvent<T>> events,
  DateTime date,
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
  double? minimumTileHeight,
  EventLayoutDelegateCache? cache,
) {
  return SideBySideLayoutDelegate<T>(
    events: events,
    date: date,
    heightPerMinute: heightPerMinute,
    timeOfDayRange: timeOfDayRange,
    minimumTileHeight: minimumTileHeight,
    layoutCache: cache ?? EventLayoutDelegateCache(),
  );
}

/// A cache for [EventLayoutDelegate]s.
///
/// This is used to cache some values that are recalculated often.
/// What can/do we need to cache here ?
///
class EventLayoutDelegateCache {
  final Map<String, Map<int, VerticalLayoutData>> _dateCache = {};

  /// Generates a cache key based on the [date], [heightPerMinute], and [timeRange].
  String _generateCacheKey(DateTime date, double heightPerMinute, TimeOfDayRange timeRange) {
    return '${date.millisecondsSinceEpoch}_${heightPerMinute}_${timeRange.hashCode}';
  }

  /// Caches the vertical layout data for the given [date], [heightPerMinute], and [timeOfDayRange].
  Map<int, VerticalLayoutData>? getCache(DateTime date, double heightPerMinute, TimeOfDayRange timeOfDayRange) {
    final key = _generateCacheKey(date, heightPerMinute, timeOfDayRange);
    return _dateCache[key];
  }

  void setCache(DateTime date, double heightPerMinute, TimeOfDayRange timeRange, Map<int, VerticalLayoutData> cache) {
    final key = _generateCacheKey(date, heightPerMinute, timeRange);
    _dateCache[key] = cache;
  }

  void clearAll() => _dateCache.clear();
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
    required this.minimumTileHeight,
    required this.layoutCache,
  });

  /// The date for which the events are laid out.
  final DateTime date;

  /// The time of day range for which the events are laid out.
  final TimeOfDayRange timeOfDayRange;

  /// The list of events that will be laid out. (The order of these events are the same as the widget's)
  final Iterable<CalendarEvent<T>> events;

  /// The height per minute of the current view.
  final double heightPerMinute;

  /// The minimum height of a tile.
  final double? minimumTileHeight;

  /// The cache for the [EventLayoutDelegate].
  final EventLayoutDelegateCache layoutCache;

  /// Sorts the [CalendarEvent]s.
  ///
  /// This is used to sort the events before passing them to the [EventLayoutDelegate].
  /// Override this method to provide custom sorting.
  List<CalendarEvent<T>> sortEvents(Iterable<CalendarEvent<T>> events);

  /// Calculates the height of an item based on the [duration] and [heightPerMinute] of the event.
  ///
  /// [event] - The event to calculate the height of.
  /// [heightPerMinute] - The per minute of the current view.
  double calculateHeight(CalendarEvent<T> event) {
    final durationOnDate = event.dateTimeRangeAsUtc.dateTimeRangeOnDate(date)?.duration ?? Duration.zero;
    final height = ((durationOnDate.inSeconds / 60) * heightPerMinute);
    if (minimumTileHeight != null && height < minimumTileHeight!) {
      return minimumTileHeight!;
    }
    return height;
  }

  /// Calculates the distance from the start of the day to the start of the [event].
  ///
  /// [event] - The event to calculate the distance from.
  ///
  /// * Note: this takes into account the [TimeOfDayRange] of the [EventLayoutDelegate].
  double calculateDistanceFromStart(CalendarEvent<T> event) {
    final eventStart = event.dateTimeRangeAsUtc.dateTimeRangeOnDate(date)?.start ?? date.startOfDay;
    final dateStart = timeOfDayRange.start.toDateTime(date);
    return (eventStart.difference(dateStart).inMinutes * heightPerMinute);
  }

  /// This is used to sort the vertical layout data after calculation.
  List<VerticalLayoutData> sortVerticalLayoutData(List<VerticalLayoutData> layoutData);

  /// Vertical layout of the events.
  ///
  /// Calculates the top and bottom of each event, and ensues that they are within the bounds of the widget.
  ///
  /// [size] - The size of the widget.
  List<VerticalLayoutData> calculateVerticalLayoutData(Size size) {
    final numberOfChildren = events.length;
    final currentCache = <int, VerticalLayoutData>{};
    final cache = layoutCache.getCache(date, heightPerMinute, timeOfDayRange);

    if (cache == null) {
      // If there is no cache, calculate the layout data for each event.
      for (var i = 0; i < numberOfChildren; i++) {
        final id = i;
        final event = events.elementAt(i);
        final eventHash = event.hashCode;
        currentCache[eventHash] = _calculateSingleEventLayout(id, size, event);
      }
    } else {
      // If there is a cache, use it to calculate the layout data for each event.
      for (var i = 0; i < numberOfChildren; i++) {
        final id = i;
        final event = events.elementAt(i);
        final eventHash = event.hashCode;

        final cached = cache[eventHash];
        if (cached == null) {
          currentCache[eventHash] = _calculateSingleEventLayout(id, size, event);
        } else {
          currentCache[eventHash] = cached.copyWith(id: id);
        }
      }
    }

    layoutCache.setCache(date, heightPerMinute, timeOfDayRange, currentCache);
    return sortVerticalLayoutData(currentCache.values.toList());
  }

  VerticalLayoutData _calculateSingleEventLayout(int id, Size size, CalendarEvent<T> event) {
    var top = calculateDistanceFromStart(event);
    final height = calculateHeight(event);
    var bottom = top + height;

    final overlap = size.height - bottom;
    // Check if the event is outside the bounds of the widget.
    if (overlap.isNegative) {
      // Update the top and bottom to fit within the bounds.
      top += overlap;
      bottom += overlap;
    }

    // Round top and bottom to one decimal place.
    // This is to prevent floating point errors from causing issues with the layout.
    top = (top * 10).roundToDouble() / 10;
    bottom = (bottom * 10).roundToDouble() / 10;

    return VerticalLayoutData(id: id, top: top, bottom: bottom);
  }

  /// Groups the [VerticalLayoutData] into horizontal groups.
  List<HorizontalGroupData> groupVerticalLayoutData(
    List<VerticalLayoutData> verticalLayoutData,
  ) {
    final horizontalGroups = <HorizontalGroupData>[];

    for (var i = 0; i < verticalLayoutData.length; i++) {
      final layoutData = verticalLayoutData.elementAt(i);
      final id = layoutData.id;
      final top = layoutData.top;
      final bottom = layoutData.bottom;

      // If the layout data is already in a group, skip it.
      if (horizontalGroups.any((group) => group.containsId(id))) continue;

      // Find the index of the group that overlaps with the layout data.
      final groupIndex = horizontalGroups.indexWhere((group) {
        return group.overlaps(top, bottom);
      });

      if (groupIndex != -1) {
        final group = horizontalGroups.elementAt(groupIndex);
        group.add(layoutData);
      } else {
        horizontalGroups.add(HorizontalGroupData(layoutData));
      }
    }

    return horizontalGroups;
  }

  /// Finds the longest chain of overlapping events using depth-first search.
  ///
  /// This method determines the maximum number of events that overlap at any given time,
  /// which is used to calculate the optimal width for each event tile in side-by-side layouts.
  ///
  /// This algorithm can get expensive, so it should be used sparingly.
  ///
  /// [verticalLayoutData] - The collection of vertical layout data for all events.
  ///
  /// Returns the length of the longest chain of overlapping events.
  int findLongestChain(Iterable<VerticalLayoutData> verticalLayoutData) {
    // Early return if no events to process
    if (verticalLayoutData.isEmpty) return 0;

    final dataList = verticalLayoutData.toList();
    // Key: event index, Value: longest chain starting from that event
    final memo = <int, int>{};

    int depthFirstSearch(int currentIndex, Set<int> visited) {
      // If we've already calculated this, return cached result
      if (memo.containsKey(currentIndex)) return memo[currentIndex]!;
      var maxLength = 1;

      // Check all other events to see if they overlap with current event
      for (var i = 0; i < dataList.length; i++) {
        // Skip if it's the same event, already visited, or doesn't overlap
        if (i != currentIndex && !visited.contains(i) && dataList[currentIndex].overlaps(dataList[i])) {
          final newVisited = Set<int>.from(visited)..add(i);
          maxLength = max(maxLength, 1 + depthFirstSearch(i, newVisited));
        }
      }

      memo[currentIndex] = maxLength;
      return maxLength;
    }

    var maxChain = 1;
    for (var i = 0; i < dataList.length; i++) {
      maxChain = max(maxChain, depthFirstSearch(i, {i}));
    }

    return maxChain;
  }

  @override
  bool shouldRelayout(covariant EventLayoutDelegate oldDelegate) {
    return oldDelegate.events != events ||
        oldDelegate.heightPerMinute != heightPerMinute ||
        oldDelegate.timeOfDayRange != timeOfDayRange ||
        oldDelegate.date != date ||
        oldDelegate.minimumTileHeight != minimumTileHeight;
  }
}

/// The [OverlapLayoutDelegate] lays out [CalendarEvent]'s, by stacking them on top of one another.
class OverlapLayoutDelegate<T extends Object?> extends EventLayoutDelegate<T> {
  OverlapLayoutDelegate({
    required super.events,
    required super.heightPerMinute,
    required super.date,
    required super.timeOfDayRange,
    required super.minimumTileHeight,
    required super.layoutCache,
  });

  @override
  List<CalendarEvent<T>> sortEvents(Iterable<CalendarEvent<T>> events) {
    return events.toList()
      ..sort((a, b) => b.duration.compareTo(a.duration))
      ..sort((a, b) => b.duration.compareTo(a.duration) == 0 ? b.startAsUtc.compareTo(a.startAsUtc) : 0);
  }

  @override
  void performLayout(Size size) {
    // Calculate the vertical layout data.
    final verticalLayoutData = calculateVerticalLayoutData(size);

    // Group the vertical layout data into horizontal groups.
    final horizontalGroups = groupVerticalLayoutData(verticalLayoutData);

    for (var i = 0; i < horizontalGroups.length; i++) {
      final group = horizontalGroups.elementAt(i);

      final layoutData = <EventLayoutData>[];
      for (final data in group.verticalLayoutData) {
        // Check with how many already laid out events this event overlaps.
        final overlaps = layoutData.where((e) => e.overlaps(data));
        final numberOfOverlaps = overlaps.length + 1;

        double? lastWidth;
        if (overlaps.isNotEmpty) lastWidth = overlaps.reduce((e, f) => e.width <= f.width ? e : f).width;

        double width;
        double xOffset;
        if (lastWidth == null) {
          width = size.width / numberOfOverlaps;
          xOffset = width * (numberOfOverlaps - 1);
        } else {
          // TODO: make this adjustable ?
          width = lastWidth / 1.8;
          xOffset = size.width - width;
        }

        // Layout the tile.
        layoutChild(data.id, BoxConstraints.tightFor(width: width, height: data.height));

        // Position the tile.
        positionChild(data.id, Offset(xOffset, data.top));

        // Add the layout data to the list.
        layoutData.add(EventLayoutData(left: xOffset, right: size.width, verticalLayoutData: data));
      }
    }
  }

  @override
  List<VerticalLayoutData> sortVerticalLayoutData(List<VerticalLayoutData> layoutData) => layoutData;
}

/// The [SideBySideLayoutDelegate] lays out [CalendarEvent]'s next to one another.
class SideBySideLayoutDelegate<T extends Object?> extends EventLayoutDelegate<T> {
  SideBySideLayoutDelegate({
    required super.events,
    required super.heightPerMinute,
    required super.date,
    required super.timeOfDayRange,
    required super.minimumTileHeight,
    required super.layoutCache,
  });

  @override
  List<CalendarEvent<T>> sortEvents(Iterable<CalendarEvent<T>> events) => events.toList();
  @override
  List<VerticalLayoutData> sortVerticalLayoutData(List<VerticalLayoutData> layoutData) {
    // Sort the data from top to bottom.
    // If the top values are equal compare the bottom
    return layoutData
      ..sort((a, b) {
        return a.top.compareTo(b.top) == 0 ? b.bottom.compareTo(a.bottom) : a.top.compareTo(b.top);
      });
  }

  @override
  void performLayout(Size size) {
    // Calculate the vertical layout data.
    final verticalLayoutData = calculateVerticalLayoutData(size);

    // Group the vertical layout data into horizontal groups.
    final horizontalGroups = groupVerticalLayoutData(verticalLayoutData);

    for (var i = 0; i < horizontalGroups.length; i++) {
      final group = horizontalGroups.elementAt(i);
      final verticalLayoutData = group.verticalLayoutData
        ..sort(
          (a, b) => b.height.compareTo(a.height) == 0 ? b.top.compareTo(a.top) : b.height.compareTo(a.height),
        );

      final numberOfEvents = verticalLayoutData.length;
      final longest = findLongestChain(verticalLayoutData);
      final childWidth = size.width / longest;

      final tiles = <int, Offset>{};
      final tileWidths = <int, double>{};
      for (var i = 0; i < numberOfEvents; i++) {
        final data = verticalLayoutData.elementAt(i);
        final id = data.id;

        // Find the overlaps to the left of the tile.
        final tilesToLeft = verticalLayoutData.getRange(0, i);
        final overlapsLeft = tilesToLeft.where((e) => e.overlaps(data));
        final lastOverlapLeft = overlapsLeft.lastOrNull;

        // Calculate the x offset of the tile.
        final double tileXOffset; // = childWidth * overlapsLeft;
        if (lastOverlapLeft != null) {
          tileXOffset = tiles[lastOverlapLeft.id]!.dx + tileWidths[lastOverlapLeft.id]!;
        } else {
          tileXOffset = childWidth * overlapsLeft.length;
        }

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

        tiles[id] = Offset(tileXOffset, data.top);
        tileWidths[id] = tileWidth;
      }

      for (final tile in tiles.entries) {
        positionChild(tile.key, tile.value);
      }
    }
  }
}

/// This stores the vertical layout data of a single [CalendarEvent].
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

  /// Checks if this [VerticalLayoutData] overlaps with [other].
  bool overlaps(VerticalLayoutData other) {
    final isInside = other.top > top && other.bottom < bottom;

    final overlapTop = other.top <= top && other.bottom > top;

    final overlapBottom = other.top < bottom && other.bottom >= bottom;

    final outside = other.top <= top && other.bottom >= bottom;

    return isInside || overlapTop || overlapBottom || outside;
  }

  @override
  String toString() => 'id: $id, top: $top, bottom: $bottom';

  /// Creates a copy of this [VerticalLayoutData] with a new [id].
  VerticalLayoutData copyWith({int? id}) {
    return VerticalLayoutData(id: id ?? this.id, top: top, bottom: bottom);
  }
}

/// This stores the final layout data of a single [CalendarEvent].
class EventLayoutData {
  /// The top of the event.
  final double left;

  /// The bottom of the event.
  final double right;

  /// The vertical layout data of the event.
  final VerticalLayoutData verticalLayoutData;

  EventLayoutData({
    required this.left,
    required this.right,
    required this.verticalLayoutData,
  });

  /// The width of the event.
  double get width => right - left;

  /// The id of the event.
  int get id => verticalLayoutData.id;

  /// Checks if this [EventLayoutData] overlaps with [other].
  bool overlaps(VerticalLayoutData other) => verticalLayoutData.overlaps(other);
}

/// This stores horizontal data [top] and [bottom] for a group of [VerticalLayoutData].
class HorizontalGroupData {
  final List<VerticalLayoutData> verticalLayoutData = [];

  /// The top of the group of [VerticalLayoutData].
  double top = double.infinity;

  /// The bottom of the group of [VerticalLayoutData].
  double bottom = double.negativeInfinity;

  HorizontalGroupData(VerticalLayoutData initialData) {
    verticalLayoutData.add(initialData);
    top = initialData.top;
    bottom = initialData.bottom;
  }

  /// Adds the [layoutData] to the [HorizontalGroupData].
  void add(VerticalLayoutData layoutData) {
    verticalLayoutData.add(layoutData);
    top = layoutData.top < top ? layoutData.top : top;
    bottom = layoutData.bottom > bottom ? layoutData.bottom : bottom;
  }

  /// Whether the [HorizontalGroupData] overlaps with the given [top] and [bottom].
  bool overlaps(double top, double bottom) {
    // Check if it is inside the HorizontalGroup.
    final isInside = top > this.top && bottom < this.bottom;

    // Check if it overlaps with the top line.
    final overlapsTop = top <= this.top && bottom > this.top;

    // Check if it overlaps with the bottom line.
    final overlapsBottom = top < this.bottom && bottom >= this.bottom;

    // Check if it overlaps completely.
    final isOutside = top <= this.top && bottom >= this.bottom;

    return isInside || overlapsTop || overlapsBottom || isOutside;
  }

  /// Whether the [HorizontalGroupData] contains the [id].
  bool containsId(int id) => verticalLayoutData.any((layoutData) => layoutData.id == id);

  @override
  String toString() => 'top: $top, bottom: $bottom';
}
