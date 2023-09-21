import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// The base MultiChildLayoutDelegate for [MultiDayEventGroupLayoutDelegate]'s
///
abstract class MultiDayEventGroupLayoutDelegate<T>
    extends MultiChildLayoutDelegate {
  MultiDayEventGroupLayoutDelegate({
    required this.events,
    required this.visibleDateRange,
    required this.multiDayTileHeight,
  });

  final List<CalendarEvent<T>> events;
  final DateTimeRange visibleDateRange;
  final double multiDayTileHeight;

  @override
  bool shouldRelayout(covariant MultiDayEventGroupLayoutDelegate oldDelegate) {
    return oldDelegate.events != events;
  }
}

class MultiDayEventGroupDefaultLayoutDelegate<T>
    extends MultiDayEventGroupLayoutDelegate<T> {
  MultiDayEventGroupDefaultLayoutDelegate({
    required super.events,
    required super.visibleDateRange,
    required super.multiDayTileHeight,
  });

  @override
  void performLayout(Size size) {
    final numChildren = events.length;
    final visibleDates = visibleDateRange.datesSpanned;
    final dayWidth = size.width / visibleDates.length;

    final tileSizes = <int, Size>{};
    final tileDx = <int, double>{};

    /// Loop through each event.
    for (var i = 0; i < numChildren; i++) {
      final id = i;
      final event = events[id];

      // Calculate the width of the tile.
      final tileWidth = event.datesSpanned.length * dayWidth;

      // Layout the tile.
      final childSize = layoutChild(
        id,
        BoxConstraints.tightFor(
          width: tileWidth,
          height: multiDayTileHeight,
        ),
      );
      tileSizes[id] = childSize;

      // Calculate the x position of the tile.
      final dx = visibleDates.indexOf(event.datesSpanned.first) * dayWidth;
      tileDx[id] = dx;
    }

    final tilePositions = <int, Offset>{};
    for (var id = 0; id < numChildren; id++) {
      if (tilePositions.isEmpty) {
        tilePositions[id] = Offset(tileDx[id]!, 0.0);
      } else {
        tilePositions[id] = Offset(tileDx[id]!, 50.0);
      }
    }
    for (var id = 0; id < numChildren; id++) {
      positionChild(
        id,
        tilePositions[id]!,
      );
    }

    // final tileDy = <Object, double>{};
    // for (var id = 0; id < numChildren; id++) {
    //   final event = events[id];

    //   final dy = id * multiDayTileHeight;

    //   tileDy[id] = dy;
    // }

    // for (var id = 0; id < numChildren; id++) {
    //   positionChild(
    //     id,
    //     Offset(tileDx[id]!, tileDy[id]!),
    //   );
    // }
  }
}
