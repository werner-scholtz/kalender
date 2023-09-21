import 'dart:math';

import 'package:kalender/src/extensions.dart';
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
      // Get a list of events that overlap with each other.
      final overlappingEvents = _findOverlappingEvents(
        initialEvent: event,
        otherEvents: events,
      );

      maxNumberOfStackedEvents = max(
        maxNumberOfStackedEvents,
        overlappingEvents.length,
      );
    }

    // Sort the events by start dateTime.
    final sortedEvents = events.toList()
      ..sort(
        (a, b) => a.start.compareTo(b.start),
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

  /// Finds events that overlap with the [initialEvent] from the [otherEvents], and all events that overlap with those events etc..
  Iterable<CalendarEvent<T>> _findOverlappingEvents({
    required CalendarEvent<T> initialEvent,
    required Iterable<CalendarEvent<T>> otherEvents,
    int maxIterations = 25,
  }) {
    final overlappingEvents = <CalendarEvent<T>>{initialEvent};
    var previousLength = 0;
    var iteration = 0;
    while (previousLength != overlappingEvents.length &&
        iteration <= maxIterations) {
      final newOverlappingEvents = <CalendarEvent<T>>[];
      for (var event in overlappingEvents) {
        newOverlappingEvents.addAll(
          otherEvents.where(
            (otherEvent) => ((otherEvent.start.startOfDay
                        .isWithin(event.dateTimeRange) ||
                    otherEvent.end.endOfDay.isWithin(event.dateTimeRange)) ||
                otherEvent.start == event.start ||
                otherEvent.end == event.end),
          ),
        );
      }
      previousLength = overlappingEvents.length;
      overlappingEvents.addAll(newOverlappingEvents);
      iteration++;
    }

    return overlappingEvents;
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
