import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// The base MultiChildLayoutDelegate for [MultiDayEventsLayoutDelegate]'s
///
/// [events] is the list of [CalendarEvent]'s that should be laid out.
///
/// [visibleDateRange] is the [DateTimeRange] of the visible dates.
///
/// [multiDayTileHeight] is the height of a tile in the [MultiDayEventGroupWidget].
///
abstract class MultiDayEventsLayoutDelegate<T>
    extends MultiChildLayoutDelegate {
  MultiDayEventsLayoutDelegate({
    required this.events,
    required this.visibleDateRange,
    required this.multiDayTileHeight,
  });

  final List<CalendarEvent<T>> events;
  final DateTimeRange visibleDateRange;
  final double multiDayTileHeight;

  @override
  bool shouldRelayout(covariant MultiDayEventsLayoutDelegate oldDelegate) {
    return oldDelegate.events != events;
  }
}

class MultiDayEventsDefaultLayoutDelegate<T>
    extends MultiDayEventsLayoutDelegate<T> {
  MultiDayEventsDefaultLayoutDelegate({
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

      final eventDates = event.datesSpanned;

      // first visible date.
      final firstVisibleDate = eventDates.firstWhere(
        visibleDates.contains,
      );

      // last visible date.
      final lastVisibleDate = eventDates.lastWhere(
        visibleDates.contains,
      );

      final visibleEventDates = eventDates.getRange(
        eventDates.indexOf(firstVisibleDate),
        eventDates.indexOf(lastVisibleDate) + 1,
      );

      final dx = (visibleDates.indexOf(visibleEventDates.first) * dayWidth)
          .roundToDouble();
      tileDx[id] = dx;

      // Calculate the width of the tile.
      final tileWidth = ((visibleEventDates.length) * dayWidth).roundToDouble();

      // Layout the tile.
      final childSize = layoutChild(
        id,
        BoxConstraints.tightFor(
          width: tileWidth,
          height: multiDayTileHeight,
        ),
      );

      tileSizes[id] = childSize;
    }

    final tilePositions = <int, Offset>{};
    for (var id = 0; id < numChildren; id++) {
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
    for (var id = 0; id < numChildren; id++) {
      positionChild(
        id,
        tilePositions[id]!,
      );
    }
  }
}
