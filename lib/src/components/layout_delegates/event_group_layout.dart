import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// The base MultiChildLayoutDelegate for [EventGroupLayoutDelegate]'s
///
/// This class is used to layout the [CalendarEvent]'s in a [EventGroupWidget].
///
/// [events] is the list of [CalendarEvent]'s that are overlapping.
///
/// [heightPerMinute] is the height of a minute in the [EventGroupWidget].
///
/// [date] is the start of the day.
/// * this is used to calculate the offset of the [CalendarEvent] from the start of the day.
///
///  _________ The start of the day ()
/// |       ↑
/// |       | this can be calculated using
/// |       | (event.dateTimeRangeOnDate(startOfGroup).start.difference(startOfGroup).inMinutes * heightPerMinute)
/// |       ↓
/// | ________The start of the event.
/// | |
/// | |
/// | |
/// | |
/// | |
/// | |
/// | |
/// | |________
/// |
/// |
/// |__________
///
abstract class EventGroupLayoutDelegate<T> extends MultiChildLayoutDelegate {
  EventGroupLayoutDelegate({
    required this.events,
    required this.date,
    required this.heightPerMinute,
    required this.startHour,
    required this.endHour,
  });

  final DateTime date;
  final double heightPerMinute;
  final List<CalendarEvent<T>> events;
  final int startHour;
  final int endHour;

  @override
  bool shouldRelayout(covariant EventGroupLayoutDelegate oldDelegate) {
    return oldDelegate.events != events;
  }

  double calculateYPosition(Duration timeBeforeStart, double heightPerMinute) {
    return (timeBeforeStart.inMinutes * heightPerMinute).ceilToDouble();
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return ((duration.inSeconds / 60) * heightPerMinute).floorToDouble();
  }

  /// The y position of the start hour.
  double get startHourPosition => calculateYPosition(
        Duration(hours: startHour),
        heightPerMinute,
      );

  /// The y position of the end hour.
  double get endHourPosition => calculateYPosition(
        Duration(hours: endHour),
        heightPerMinute,
      );

  late DateTime startTime = DateTime(
    date.year,
    date.month,
    date.day,
    startHour,
  );

  late DateTime endTime = DateTime(
    date.year,
    date.month,
    date.day,
    endHour,
  );
}

/// A [EventGroupLayoutDelegate] that lays out the tiles on top of each other.
class EventGroupOverlapLayoutDelegate<T> extends EventGroupLayoutDelegate<T> {
  EventGroupOverlapLayoutDelegate({
    required super.events,
    required super.date,
    required super.heightPerMinute,
    required super.startHour,
    required super.endHour,
  });

  @override
  void performLayout(Size size) {
    final startDy = startHourPosition;
    final endDy = endHourPosition;

    final numChildren = events.length;
    final tileWidth = size.width;

    for (var i = 0; i < numChildren; i++) {
      final id = i;
      final event = events[id];

      // Calculate width of the child.
      final childWidth = ((id * tileWidth) / 5);

      // Calculate the top offset of the tile.
      final eventStartOnDate = event.dateTimeRangeOnDate(date).start;
      final start =
          eventStartOnDate.isBefore(startTime) ? startTime : eventStartOnDate;

      final eventEndOnDate = event.dateTimeRangeOnDate(date).end;
      final end = eventEndOnDate.isAfter(endTime) ? endTime : eventEndOnDate;

      final timeBeforeStart = eventStartOnDate.difference(date);

      // Clamp the y position to the start and end hour.
      final dy = calculateYPosition(
        timeBeforeStart,
        heightPerMinute,
      ).clamp(startDy, endDy);

      // Calculate the height of the tile.
      var childHeight = calculateHeight(
        end.difference(start),
        heightPerMinute,
      );

      // if the child height is less than 0, make it invisible.
      if (childHeight < 0) {
        childHeight = 0.0001;
      }

      // Layout the tile.
      layoutChild(
        id,
        BoxConstraints.tightFor(
          width: (tileWidth - ((i * tileWidth) / 5)).floorToDouble(),
          height: childHeight,
        ),
      );

      positionChild(
        id,
        Offset(childWidth, dy),
      );
    }
  }
}

/// A [EventGroupLayoutDelegate] that lays out the tiles next to each other.
class EventGroupBasicLayoutDelegate<T> extends EventGroupLayoutDelegate<T> {
  EventGroupBasicLayoutDelegate({
    required super.events,
    required super.date,
    required super.heightPerMinute,
    required super.startHour,
    required super.endHour,
  });

  @override
  void performLayout(Size size) {
    final startDy = startHourPosition;
    final endDy = endHourPosition;

    final numChildren = events.length;

    final tileConstraints = BoxConstraints.expand(
      width: size.width / numChildren,
      height: size.height,
    );

    for (var i = 0; i < numChildren; i++) {
      final id = i;
      final event = events[id];

      final childWidth = (size.width / numChildren).floorToDouble();
      final dx = id * tileConstraints.maxWidth;

      // Calculate the top offset of the tile.
      final eventStartOnDate = event.dateTimeRangeOnDate(date).start;
      final start =
          eventStartOnDate.isBefore(startTime) ? startTime : eventStartOnDate;

      final eventEndOnDate = event.dateTimeRangeOnDate(date).end;
      final end = eventEndOnDate.isAfter(endTime) ? endTime : eventEndOnDate;

      final timeBeforeStart = eventStartOnDate.difference(date);

      // Clamp the y position to the start and end hour.
      final dy = calculateYPosition(
        timeBeforeStart,
        heightPerMinute,
      ).clamp(startDy, endDy);

      // Calculate the height of the tile.
      var childHeight = calculateHeight(
        end.difference(start),
        heightPerMinute,
      );

      // if the child height is less than 0, make it invisible.
      if (childHeight < 0) {
        childHeight = 0.0001;
      }

      layoutChild(
        id,
        BoxConstraints.tightFor(
          width: childWidth,
          height: childHeight,
        ),
      );

      positionChild(
        id,
        Offset(dx, dy),
      );
    }
  }
}
