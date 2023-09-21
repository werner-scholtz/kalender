import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// The base MultiChildLayoutDelegate for [MultiDayEventGroupLayoutDelegate]'s
///
abstract class MultiDayEventGroupLayoutDelegate<T>
    extends MultiChildLayoutDelegate {
  MultiDayEventGroupLayoutDelegate({
    required this.events,
    required this.visibleDates,
  });

  final List<CalendarEvent<T>> events;
  final List<DateTime> visibleDates;

  @override
  bool shouldRelayout(covariant MultiDayEventGroupLayoutDelegate oldDelegate) {
    return oldDelegate.events != events;
  }
}

class MultiDayEventGroupDefaultLayoutDelegate<T>
    extends MultiDayEventGroupLayoutDelegate<T> {
  MultiDayEventGroupDefaultLayoutDelegate({
    required super.events,
    required super.visibleDates,
  });

  @override
  void performLayout(Size size) {
    final numChildren = events.length;
    final dayWidth = size.width / visibleDates.length;

    final tileSizes = <Object, Size>{};
    for (var i = 0; i < numChildren; i++) {
      final id = i;
      final event = events[id];

      final tileWidth = event.datesSpanned.length * dayWidth;

      final childSize = layoutChild(
        id,
        BoxConstraints.tightFor(
          width: tileWidth,
        ),
      );

      tileSizes[id] = childSize;
    }

    for (var id = 0; id < numChildren; id++) {
      final event = events[id];
      final dx = 0.0;
      final dy = 0.0;

      positionChild(
        id,
        Offset(dx, dy),
      );
    }
  }
}
