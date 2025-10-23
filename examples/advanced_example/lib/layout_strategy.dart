import 'package:advanced_example/main.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CustomSideBySideLayoutDelegate<T extends Object?> extends EventLayoutDelegate<T> {
  /// A List of people to group the events by.
  final List<Person> people;

  CustomSideBySideLayoutDelegate({
    required super.events,
    required super.heightPerMinute,
    required super.date,
    required super.timeOfDayRange,
    required super.minimumTileHeight,
    required super.layoutCache,
    required this.people,
    required super.location,
  });

  @override
  List<CalendarEvent<T>> sortEvents(Iterable<CalendarEvent<T>> events) => events.toList();

  @override
  List<VerticalLayoutData> sortVerticalLayoutData(List<VerticalLayoutData> layoutData) {
    // Sort the data from top to bottom.
    // If the top values are equal compare the bottom
    return layoutData..sort((a, b) {
      return a.top.compareTo(b.top) == 0 ? b.bottom.compareTo(a.bottom) : a.top.compareTo(b.top);
    });
  }

  @override
  void performLayout(Size size) {
    // Calculate the vertical layout data.
    final verticalLayoutData = calculateVerticalLayoutData(size);

    // Now split the events into the different people.
    final verticalData = <Person, List<VerticalLayoutData>>{};
    for (var event in verticalLayoutData) {
      final data = events.elementAt(event.id);
      if (data.data is Event) {
        final person = (data.data as Event).person;
        verticalData.putIfAbsent(person, () => []).add(event);
      }
    }

    // Group the vertical layout data into horizontal groups.
    final horizontalGroups = <Person, List<HorizontalGroupData>>{};
    for (var entry in verticalData.entries) {
      final person = entry.key;
      final data = entry.value;
      final horizontalGroup = groupVerticalLayoutData(data);
      horizontalGroups.putIfAbsent(person, () => horizontalGroup);
    }

    // Calculate the space available for each person.
    final space = Size(size.width / people.length, size.height);

    for (final (i, person) in people.indexed) {
      final group = horizontalGroups[person] ?? [];
      final position = Offset(i * space.width, 0);
      final rectForGroup = Rect.fromLTWH(position.dx, position.dy, space.width, space.height);
      performGroupLayout(group, rectForGroup);
    }
  }

  /// Performs the layout for a group of events.
  void performGroupLayout(List<HorizontalGroupData> horizontalGroups, Rect rect) {
    for (var i = 0; i < horizontalGroups.length; i++) {
      final group = horizontalGroups.elementAt(i);
      final verticalLayoutData = group.verticalLayoutData
        ..sort(
          (a, b) => b.height.compareTo(a.height) == 0
              ? b.top.compareTo(a.top)
              : b.height.compareTo(a.height),
        );

      final numberOfEvents = verticalLayoutData.length;
      final longest = findLongestChain(verticalLayoutData);
      final childWidth = rect.width / longest;

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
        double tileXOffset;
        if (lastOverlapLeft != null) {
          tileXOffset = tiles[lastOverlapLeft.id]!.dx + tileWidths[lastOverlapLeft.id]!;
        } else {
          // Use the left edge of the rectangle as a base if there are no overlaps to the left.
          tileXOffset = rect.left + (childWidth * overlapsLeft.length);
        }

        // Find the overlaps to the right of the tile.
        final tilesToRight = verticalLayoutData.getRange(i + 1, numberOfEvents);
        final overlapsRight = tilesToRight.where((e) => e.overlaps(data)).toList();

        // Calculate the width of the tile.
        var tileWidth = childWidth;
        if (overlapsRight.isEmpty) {
          // If there are no overlaps to the right, use the remaining width of the rectangle.
          tileWidth = rect.width - (tileXOffset - rect.left);
        }

        // Layout the tile.
        layoutChild(id, BoxConstraints.tightFor(width: tileWidth, height: data.height));

        tiles[id] = Offset(tileXOffset, data.top);
        tileWidths[id] = tileWidth;
      }

      for (final tile in tiles.entries) {
        positionChild(tile.key, tile.value);
      }
    }
  }
}
