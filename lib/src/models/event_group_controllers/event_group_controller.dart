import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// A controller that generates [EventGroup]'s for a list of events.
class EventGroupController<T> {
  const EventGroupController();

  /// Generate the [EventGroup]'s for a list of events.
  Iterable<EventGroup<T>> generateTileGroups({
    required List<DateTime> visibleDates,
    required Iterable<CalendarEvent<T>> events,
  }) {
    final tileGroups = <EventGroup<T>>[];

    // Loop through each date.
    for (final date in visibleDates) {
      // log(date.toString(), name: 'Date');
      // log(events.length.toString(), name: 'Events');
      // Get a list of events that are visible on the date.
      final eventsOnDate = _findEventsOnDate(events, date);

      // log(eventsOnDate.length.toString());

      final tileGroupsOnDate = <EventGroup<T>>[];

      // Loop through each event on the date.
      for (final event in eventsOnDate) {
        // If the event is already in a group, skip it.
        if (tileGroupsOnDate.any((element) => element.events.contains(event))) {
          continue;
        }

        // Get a list of events that overlap with each other.
        final overlappingEvents = _findOverlappingEvents(
          initialEvent: event,
          otherEvents: eventsOnDate,
        ).toList();

        final dateTimeRangeOnDate = event.dateTimeRangeOnDate(date);
        var start = dateTimeRangeOnDate.start;
        var end = dateTimeRangeOnDate.end;

        for (final event in overlappingEvents) {
          final dateTimeRange = event.dateTimeRangeOnDate(date);
          if (dateTimeRange.start.isBefore(start)) {
            start = dateTimeRange.start;
          }
          if (dateTimeRange.end.isAfter(end)) {
            end = dateTimeRange.end;
          }
        }

        // Sort the events by duration.
        final events = overlappingEvents
          ..sort(
            (a, b) => b.duration.compareTo(a.duration),
          );

        // Generate the tile group.
        final tileGroup = EventGroup<T>(
          date: date,
          events: events,
          dateTimeRange: DateTimeRange(start: start, end: end),
        );

        // Add the tile group to the tileGroups on this date.
        tileGroupsOnDate.add(tileGroup);
      }

      // Add the tile groups to the list.
      tileGroups.addAll(tileGroupsOnDate);
    }

    return tileGroups;
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
            (otherEvent) => ((otherEvent.start.isWithin(event.dateTimeRange) ||
                    otherEvent.end.isWithin(event.dateTimeRange)) ||
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

  /// Returns a list of [CalendarEvent]'s that are visible on the [date].
  List<CalendarEvent<T>> _findEventsOnDate(
    Iterable<CalendarEvent<T>> events,
    DateTime date,
  ) {
    final eventsOnDate = events.where(
      (element) {
        return element.occursDuringDateTimeRange(date.dayRange);
        // element.start.isSameDay(date) || element.end.isSameDay(date);
      },
    );

    return eventsOnDate.toList()
      ..sort(
        (a, b) => a.start.compareTo(b.start),
      );
  }
}

/// A group of [CalendarEvent]'s that are overlapping.
class EventGroup<T> {
  const EventGroup({
    required this.date,
    required this.events,
    required this.dateTimeRange,
  });

  /// The date that the tile's will be displayed on.
  final DateTime date;

  /// The [DateTimeRange] that the tile's will be displayed on.
  final DateTimeRange dateTimeRange;
  DateTime get start => dateTimeRange.start;
  DateTime get end => dateTimeRange.end;

  /// The [CalendarEvent]'s that are in this group.
  final List<CalendarEvent<T>> events;
}
