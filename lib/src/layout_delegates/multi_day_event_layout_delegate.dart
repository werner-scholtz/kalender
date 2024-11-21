import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';

/// Signature for the strategy that determines how multi-day events are laid out.
typedef MultiDayEventLayoutStrategy<T extends Object?> = MultiDayEventLayoutDelegate<T> Function(
  List<CalendarEvent<T>> events,
  DateTimeRange dateTimeRange,
  double multiDayTileHeight,
);

/// The default [MultiDayEventLayoutStrategy].
MultiDayEventLayoutDelegate defaultMultiDayLayoutStrategy<T extends Object?>(
  List<CalendarEvent<T>> events,
  DateTimeRange dateTimeRange,
  double multiDayTileHeight,
) {
  return DefaultMultiDayLayoutDelegate<T>(
    events: events,
    dateTimeRange: dateTimeRange,
    multiDayTileHeight: multiDayTileHeight,
  );
}

/// The base class for [MultiDayEventLayoutDelegate]'s.
abstract class MultiDayEventLayoutDelegate<T extends Object?> extends MultiChildLayoutDelegate {
  MultiDayEventLayoutDelegate({
    required this.events,
    required this.dateTimeRange,
    required this.multiDayTileHeight,
  });

  /// The list of events that will be laid out. (The order of these events are the same as the widget's)
  final List<CalendarEvent<T>> events;
  final DateTimeRange dateTimeRange;
  final double multiDayTileHeight;

  @override
  bool shouldRelayout(covariant MultiDayEventLayoutDelegate oldDelegate) {
    return oldDelegate.events != events ||
        oldDelegate.dateTimeRange != dateTimeRange ||
        oldDelegate.multiDayTileHeight != multiDayTileHeight;
  }

  @override
  @mustCallSuper
  Size getSize(BoxConstraints constraints);
}

/// TODO: This is still a WIP
class DefaultMultiDayLayoutDelegate<T> extends MultiDayEventLayoutDelegate<T> {
  DefaultMultiDayLayoutDelegate({
    required super.events,
    required super.dateTimeRange,
    required super.multiDayTileHeight,
  });

  @override
  Size getSize(BoxConstraints constraints) {
    super.getSize(constraints);

    /// TODO: this does not work 100% correctly.
    /// For single days this seems to work fine, but for multi-day events it does not.
    var maxOverlaps = 0;
    for (final event in events) {
      final overlaps = events.where((e) => e.datesSpanned.any(event.datesSpanned.contains));
      maxOverlaps = max(maxOverlaps, overlaps.length);
    }

    return Size(constraints.maxWidth, maxOverlaps * multiDayTileHeight + multiDayTileHeight);
  }

  @override
  void performLayout(Size size) {
    final numberOfChildren = events.length;
    final visibleDates = dateTimeRange.days;
    final dayWidth = size.width / visibleDates.length;

    final tileSizes = <int, Size>{};
    final tileDx = <int, double>{};

    // Loop through each event.
    for (var i = 0; i < numberOfChildren; i++) {
      final event = events[i];

      final eventDates = event.datesSpannedAsUtc;

      // first visible date.
      final firstVisibleDate = eventDates.firstWhere(visibleDates.contains, orElse: () => eventDates.first);

      // last visible date.
      final lastVisibleDate = eventDates.lastWhere(visibleDates.contains, orElse: () => eventDates.last);

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
      final childSize = layoutChild(i, BoxConstraints.tightFor(width: tileWidth, height: multiDayTileHeight));

      tileSizes[i] = childSize;
    }

    final tilePositions = <int, Offset>{};
    for (var id = 0; id < numberOfChildren; id++) {
      final event = events[id];

      // Find events that fill the same dates as the current event.
      final eventsAbove = tilePositions.keys
          .map((e) => events[e])
          .where((eventAbove) => eventAbove.datesSpannedAsUtc.any(event.datesSpannedAsUtc.contains))
          .toList();

      var dy = 0.0;
      if (eventsAbove.isNotEmpty) {
        final eventAboveID = events.indexOf(eventsAbove.last);
        dy = tilePositions[eventAboveID]!.dy + multiDayTileHeight;
      }

      tilePositions[id] = Offset(tileDx[id]!, dy.roundToDouble());
    }

    for (var id = 0; id < numberOfChildren; id++) {
      positionChild(id, tilePositions[id]!);
    }
  }
}
