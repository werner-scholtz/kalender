import 'dart:math' hide log;

import 'package:kalender/src/models/calendar/calendar_event.dart';

/// A group of [CalendarEvent]'s that will be stacked on top of each other.
class MultiDayEventGroup<T> {
  factory MultiDayEventGroup.fromEvents({
    required Iterable<CalendarEvent<T>> events,
  }) {
    var maxNumberOfStackedEvents = 0;
    // Loop through each event on the date.
    for (final event in events) {
      // Find all events that overlap with the current event.
      final eventsAbove = events.where(
        (eventAbove) {
          return eventAbove.datesSpanned.any(event.datesSpanned.contains);
        },
      );

      maxNumberOfStackedEvents = max(
        maxNumberOfStackedEvents,
        eventsAbove.length,
      );
    }

    // Sort the events by start dateTime.
    final sortedEvents = events.toList()
      ..sort(
        (a, b) => a.start.compareTo(b.start),
      )
      ..sort(
        (a, b) => b.end.compareTo(a.end),
      );

    return MultiDayEventGroup<T>(
      events: sortedEvents,
      maxNumberOfStackedEvents: maxNumberOfStackedEvents,
    );
  }

  const MultiDayEventGroup({
    required this.events,
    required this.maxNumberOfStackedEvents,
  });

  /// The maximum number of [CalendarEvent]'s that are stacked on top of each other.
  final int maxNumberOfStackedEvents;

  /// The [CalendarEvent]'s that are in this group.
  final List<CalendarEvent<T>> events;
}
