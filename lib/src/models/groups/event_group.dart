import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_event.dart';

/// A group of [CalendarEvent]'s that are overlapping.
class EventGroup<T extends Object?> {
  const EventGroup({
    required this.date,
    required this.events,
    required this.dateTimeRange,
  });

  /// The date that the tile's will be displayed on.
  final DateTime date;

  /// The [DateTimeRange] where this group is visible.
  final DateTimeRange dateTimeRange;

  DateTime get start => dateTimeRange.start;
  DateTime get end => dateTimeRange.end;

  /// The [CalendarEvent]'s that are in this group.
  final List<CalendarEvent<T>> events;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventGroup<T> &&
        other.date == date &&
        other.dateTimeRange == dateTimeRange &&
        listEquals(other.events, events);
  }

  @override
  int get hashCode => Object.hash(date, dateTimeRange, events);
}

/// A group of [CalendarEvent]'s that are overlapping.
class MultiDayEventGroup<T extends Object?> {
  const MultiDayEventGroup({
    required this.events,
    required this.dateTimeRange,
  });

  /// The [DateTimeRange] where this group is visible.
  final DateTimeRange dateTimeRange;

  DateTime get start => dateTimeRange.start;
  DateTime get end => dateTimeRange.end;

  /// The [CalendarEvent]'s that are in this group.
  final Iterable<CalendarEvent<T>> events;

  /// The [CalendarEvent]'s that are in this group sorted by start and end.
  List<CalendarEvent<T>> get sortedEvents {
    return events.toList()
      ..sort((a, b) => a.start.compareTo(b.end))
      ..sort((a, b) => b.start.compareTo(a.end));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventGroup<T> && other.dateTimeRange == dateTimeRange && other.events == events;
  }

  @override
  int get hashCode => Object.hash(dateTimeRange, events);
}
