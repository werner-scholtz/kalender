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
}
