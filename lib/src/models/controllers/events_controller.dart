import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';

/// A controller for [CalendarEvent]s.
///
/// This is used to store and manage the [CalendarEvent]s.
class EventsController<T extends Object?> with ChangeNotifier {
  ValueNotifier<Size> feedbackWidgetSize = ValueNotifier(Size.zero);

  /// The list of [CalendarEvent]s.
  final Map<int, CalendarEvent<T>> _events = {};
  Iterable<CalendarEvent<T>> get events => _events.values;

  /// A Map of dates and event ids.
  final DateMap _dateMap = DateMap();

  int _lastId = 0;
  int get _nextId {
    _lastId++;
    return _lastId;
  }

  /// Adds an [CalendarEvent] to the [EventsController].
  void addEvent(CalendarEvent<T> event) {
    _assignIdAndAdd(event);
    notifyListeners();
  }

  /// Adds a list of [CalendarEvent]s to the [EventsController].
  void addEvents(List<CalendarEvent<T>> events) {
    for (final event in events) {
      _assignIdAndAdd(event);
    }
    notifyListeners();
  }

  /// Removes an [CalendarEvent] from the list of [CalendarEvent]s.
  void removeEvent(CalendarEvent<T> event) {
    assert(event.id != -1, 'The id of the event must be set before removing it.');
    _events.remove(event.id);
    _dateMap.removeEvent(event);
    notifyListeners();
  }

  /// Removes a list of [CalendarEvent]s from the list of [CalendarEvent]s.
  ///
  /// The events will be removed where [test] returns true.
  void removeWhere(bool Function(int key, CalendarEvent<T> element) test) {
    _events.removeWhere(
      (key, event) {
        final remove = test(key, event);
        if (remove) _dateMap.removeEvent(event);
        return remove;
      },
    );
    notifyListeners();
  }

  /// Removes all [CalendarEvent]s from [_events].
  void clearEvents() {
    _events.clear();
    _dateMap.clear();
    notifyListeners();
  }

  /// Updates an [CalendarEvent].
  ///
  /// The [event] is the event that needs to be changed.
  /// The [updatedEvent] is the event that will replace the [event].
  void updateEvent({
    required CalendarEvent<T> event,
    required CalendarEvent<T> updatedEvent,
  }) {
    updatedEvent.id = event.id;
    _events[event.id] = updatedEvent;
    _dateMap.updateEvent(event, updatedEvent);
    notifyListeners();
  }

  /// Assigns an id to the [event] and adds it to the [_events] Map.
  void _assignIdAndAdd(CalendarEvent<T> event) {
    assert(event.id == -1, 'The id of the event must not be set manually.');

    event.id = _nextId;
    _dateMap.addEvent(event);

    // Add the event to the Map.
    _events[event.id] = event;
  }

  /// Finds the [CalendarEvent]s that occur during the [dateTimeRange].
  Iterable<CalendarEvent<T>> eventsFromDateTimeRange(
    DateTimeRange dateTimeRange, {
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
  }) {
    final eventIds = _dateMap.eventIdsFromDateTimeRange(dateTimeRange);
    final events = eventIds.map((id) => _events[id]).nonNulls;

    if (includeMultiDayEvents && includeDayEvents) {
      return events.where((event) => event.occursDuringDateTimeRange(dateTimeRange));
    } else if (includeMultiDayEvents) {
      return _multiDayEventsFromDateTimeRange(events, dateTimeRange);
    } else if (includeDayEvents) {
      return _dayEventsFromDateTimeRange(events, dateTimeRange);
    } else {
      return [];
    }
  }

  /// Finds the [CalendarEvent]s longer than 1 day that occur during the [dateTimeRange].
  Iterable<CalendarEvent<T>> _multiDayEventsFromDateTimeRange(
    Iterable<CalendarEvent<T>> events,
    DateTimeRange dateTimeRange,
  ) {
    return events.where((event) {
      // If the event is not a multi day event, return false.
      if (!event.isMultiDayEvent) return false;
      return event.occursDuringDateTimeRange(dateTimeRange);
    });
  }

  /// Finds the [CalendarEvent]s that are shorter than 1 day that occur during the [dateTimeRange].
  Iterable<CalendarEvent<T>> _dayEventsFromDateTimeRange(
    Iterable<CalendarEvent<T>> events,
    DateTimeRange dateTimeRange,
  ) {
    return events.where((event) {
      // If the event is a multi day event, return false.
      if (event.isMultiDayEvent) return false;
      return event.occursDuringDateTimeRange(dateTimeRange);
    });
  }
}

/// A class for searching the events by date more efficient.
class DateMap {
  /// Map of the [DateTime] and event ids.
  final Map<DateTime, Set<int>> _dateMap = {};

  /// Clear the [_dateMap].
  void clear() => _dateMap.clear();

  /// Add an [event] to the map.
  void addEvent(CalendarEvent event) {
    final id = event.id;
    final dates = event.datesSpannedAsUtc;
    for (final date in dates) {
      _dateMap.update(
        date,
        (value) => value..add(id),
        ifAbsent: () => {id},
      );
    }
  }

  /// Remove an [event] from the map.
  void removeEvent(CalendarEvent event) {
    final id = event.id;
    final dates = event.datesSpannedAsUtc;
    for (final date in dates) {
      _dateMap.update(
        date,
        (value) => value..remove(id),
      );
    }
  }

  /// Update an [event] in the map with the [updatedEvent].
  void updateEvent(CalendarEvent event, CalendarEvent updatedEvent) {
    removeEvent(event);
    addEvent(updatedEvent);
  }

  /// Retrieve a [Set] of event id's from the map.
  Set<int> eventIdsFromDateTimeRange(DateTimeRange dateTimeRange) {
    final days = dateTimeRange.asUtc.days;
    final eventIds = <int>{};
    for (final day in days) {
      eventIds.addAll(_dateMap[day] ?? {});
    }
    return eventIds;
  }
}
