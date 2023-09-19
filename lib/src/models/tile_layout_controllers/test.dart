import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

class TileGroupController<T> {
  const TileGroupController();

  /// Generate the [TileGroup]'s for a list of events.
  List<TileGroup<T>> generateDayTileGroups({
    required List<DateTime> visibleDates,
    required Iterable<CalendarEvent<T>> events,
  }) {
    final tileGroups = <TileGroup<T>>[];

    // Loop through each date.
    for (final date in visibleDates) {
      // Get a list of events that are visible on the date.
      final eventsOnDate = _findEventsOnDate(events, date);

      final tileGroupsOnDate = <TileGroup<T>>[];

      // Loop through each event on the date.
      for (final event in events) {
        // If the event is already in a group, skip it.
        if (tileGroupsOnDate.any((element) => element.containsEvent(event))) {
          continue;
        }

        // Get a list of events that overlap with each other.
        final overlappingEvents = _findOverlappingEvents(
          initialEvent: event,
          otherEvents: eventsOnDate,
        );

        // Generate the tile group.
        final tileGroup = TileGroup<T>(
          date: date,
          events: overlappingEvents,
        );

        // Add the tile group to the tileGroups on this date.
        tileGroupsOnDate.add(tileGroup);
      }

      // Add the tile groups to the list.
      tileGroups.addAll(tileGroupsOnDate);
    }

    return tileGroups;
  }

  /// Generate the [TileGroup]'s for a single event.
  List<TileGroup<T>> generateDayTileGroupsFromSingleEvent({
    required CalendarEvent<T> event,
  }) {
    final dayTileGroups = <TileGroup<T>>[];

    for (final date in event.datesSpanned) {
      dayTileGroups.add(
        TileGroup<T>(
          date: date,
          events: [event],
        ),
      );
    }

    return dayTileGroups;
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
            (element) => ((element.start.isWithin(event.dateTimeRange) ||
                    element.end.isWithin(event.dateTimeRange)) ||
                element.start == event.start ||
                element.end == event.end),
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
  Iterable<CalendarEvent<T>> _findEventsOnDate(
    Iterable<CalendarEvent<T>> events,
    DateTime date,
  ) {
    return events.where(
      (element) => element.start.isSameDay(date) || element.end.isSameDay(date),
    );
  }
}

class TileGroup<T> {
  const TileGroup({
    required this.date,
    required this.events,
    void Function()? performLayout,
  });

  /// The date that the tile's will be displayed on.
  final DateTime date;

  /// The [CalendarEvent]'s that are in this group.
  final Iterable<CalendarEvent<T>> events;

  /// Layout the [DayTile]'s for this group.
  List<DayTile<T>> layoutEvents() {
    return events
        .map(
          (event) => DayTile(
            dateTimeRange: event.dateTimeRangeOnDate(date),
            event: event,
          ),
        )
        .toList();
  }

  /// Returns true if the [event] is in this group.
  bool containsEvent(CalendarEvent<T> event) {
    return events.contains(event);
  }
}

class DayTile<T> {
  const DayTile({
    required this.dateTimeRange,
    required this.event,
  });

  /// The [DateTimeRange] that the tile will be displayed on.
  final DateTimeRange dateTimeRange;

  /// The [CalendarEvent] that this tile represents.
  final CalendarEvent<T> event;
}
