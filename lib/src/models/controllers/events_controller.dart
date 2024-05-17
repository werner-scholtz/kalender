import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_event.dart';

/// A controller for [CalendarEvent]s.
///
/// This is used to store and manage the [CalendarEvent]s.
class EventsController<T extends Object?> with ChangeNotifier {
  ValueNotifier<Size> feedbackWidgetSize = ValueNotifier(Size.zero);

  /// The list of [CalendarEvent]s.
  final Map<int, CalendarEvent<T>> _events = {};
  Iterable<CalendarEvent<T>> get events => _events.values;

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
    assert(
      event.id != -1,
      'The id of the event must be set before removing it.',
    );
    _events.remove(event.id);
    notifyListeners();
  }

  /// Removes a list of [CalendarEvent]s from the list of [CalendarEvent]s.
  ///
  /// The events will be removed where [test] returns true.
  void removeWhere(bool Function(int key, CalendarEvent<T> element) test) {
    _events.removeWhere(
      (key, event) {
        return test(key, event);
      },
    );
    _events.removeWhere(test);
    notifyListeners();
  }

  /// Removes all [CalendarEvent]s from [_events].
  void clearEvents() {
    _events.clear();
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
    notifyListeners();
  }

  /// Assigns an id to the [event] and adds it to the [_events] Map.
  void _assignIdAndAdd(CalendarEvent<T> event) {
    assert(
      event.id == -1,
      'The id of the event must not be set manually.',
    );

    // Set the id of the event.
    if (_events.isEmpty) {
      event.id = 0;
    } else {
      event.id = _events.keys.last + 1;
    }

    // Add the event to the Map.
    _events[event.id] = event;
  }

  /// Finds the [CalendarEvent]s that occur during the [dateTimeRange].
  Iterable<CalendarEvent<T>> eventsFromDateTimeRange(
    DateTimeRange dateTimeRange, {
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
  }) {
    if (includeMultiDayEvents && includeDayEvents) {
      return events.where((event) {
        return event.occursDuringDateTimeRange(dateTimeRange);
      });
    } else if (includeMultiDayEvents) {
      return _multiDayEventsFromDateTimeRange(dateTimeRange);
    } else if (includeDayEvents) {
      return _dayEventsFromDateTimeRange(dateTimeRange);
    } else {
      return [];
    }
  }

  /// Finds the [CalendarEvent]s longer than 1 day that occur during the [dateTimeRange].
  Iterable<CalendarEvent<T>> _multiDayEventsFromDateTimeRange(
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
    DateTimeRange dateTimeRange,
  ) {
    return events.where((event) {
      // If the event is a multi day event, return false.
      if (event.isMultiDayEvent) return false;
      return event.occursDuringDateTimeRange(dateTimeRange);
    });
  }
}
