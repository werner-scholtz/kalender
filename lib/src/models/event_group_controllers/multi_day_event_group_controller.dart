import 'dart:math' hide log;

import 'package:kalender/src/models/calendar/calendar_event.dart';

/// A controller that generates [MultiDayEventGroup]'s for a list of events.
class MultiDayEventGroupController<T> {
  const MultiDayEventGroupController();

  /// Generate the [MultiDayEventGroup]'s for a list of events.
  MultiDayEventGroup<T> generateMultiDayEventGroup({
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

    final multiDayEventGroup = MultiDayEventGroup<T>(
      events: sortedEvents,
      maxNumberOfStackedEvents: maxNumberOfStackedEvents,
    );

    return multiDayEventGroup;
  }

  /// Generate the [MultiDayEventGroup]'s for a single event.
  MultiDayEventGroup<T> generateDayTileGroupsFromSingleEvent({
    required CalendarEvent<T> event,
  }) {
    return MultiDayEventGroup<T>(
      events: [event],
      maxNumberOfStackedEvents: 1,
    );
  }
}

/// A group of [CalendarEvent]'s that will be stacked on top of each other.
class MultiDayEventGroup<T> {
  const MultiDayEventGroup({
    required this.events,
    required this.maxNumberOfStackedEvents,
  });

  /// The maximum number of [CalendarEvent]'s that are stacked on top of each other.
  final int maxNumberOfStackedEvents;

  /// The [CalendarEvent]'s that are in this group.
  final List<CalendarEvent<T>> events;
}
