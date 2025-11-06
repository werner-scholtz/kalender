import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/extensions/internal.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:timezone/timezone.dart';

export 'package:kalender/src/models/controllers/view_controllers/events_controller/default_date_map.dart';
export 'package:kalender/src/models/controllers/view_controllers/events_controller/default_events_controller.dart';

/// The [EventsController] is used to manage [CalendarEvent]s.
///
/// This class can be extended to create custom [EventsController]s.
/// e.g. [DefaultEventsController]
abstract class EventsController<T extends Object?> with ChangeNotifier {
  /// A ValueNotifier that holds the size of the feedback widget.
  final feedbackWidgetSize = ValueNotifier<Size>(Size.zero);

  /// The list of [CalendarEvent]s.
  Iterable<CalendarEvent<T>> get events;

  /// TODO: rename to EventStore.
  /// A Map of dates and event ids.
  DateMap<T> get dateMap;

  /// Predefined locations from the [timezone](https://pub.dev/packages/timezone) package for optimizations.
  List<Location> get locations;

  /// Adds an [CalendarEvent] to the [EventsController].
  ///
  /// Returns the id assigned to the event.
  int addEvent(CalendarEvent<T> event) {
    final id = dateMap.addNewEvent(event);
    notifyListeners();
    return id;
  }

  /// Adds a list of [CalendarEvent]s to the [EventsController].
  ///
  /// Returns the id's assigned to the events in order.
  List<int> addEvents(List<CalendarEvent<T>> events) {
    final ids = events.map(dateMap.addNewEvent).toList();
    notifyListeners();
    return ids;
  }

  /// Removes an [CalendarEvent] from the list of [CalendarEvent]s.
  void removeEvent(CalendarEvent<T> event) {
    dateMap.removeEvent(event);
    notifyListeners();
  }

  /// Remove a list of [CalendarEvent] from the controller.
  void removeEvents(List<CalendarEvent<T>> events) {
    dateMap.removeEvents(events);
    notifyListeners();
  }

  /// Remove an [CalendarEvent] with its id.
  void removeById(int id) {
    assert(id != -1, 'Must be a valid id.');
    dateMap.removeById(id);
    notifyListeners();
  }

  /// Removes a list of [CalendarEvent]s from the list of [CalendarEvent]s.
  ///
  /// The events will be removed where [test] returns true.
  void removeWhere(bool Function(int key, CalendarEvent<T> element) test) {
    dateMap.removeWhere(test);
    notifyListeners();
  }

  /// Removes all [CalendarEvent]s from [_events].
  void clearEvents() {
    dateMap.clear();
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
    dateMap.updateEvent(event, updatedEvent);
    notifyListeners();
  }

  /// Retrieve a [CalendarEvent] by it's id if it exists.
  CalendarEvent<T>? byId(int id) => dateMap.byId(id);

  /// Finds the [CalendarEvent]s that occur during the [dateTimeRange].
  ///
  /// The [dateTimeRange] is the range of dates to search for events.
  /// The [includeMultiDayEvents] determines if events spanning multiple days should be included.
  /// The [includeDayEvents] determines if events that are shorter than 1 day should be included.
  Iterable<CalendarEvent<T>> eventsFromDateTimeRange(
    InternalDateTimeRange dateTimeRange, {
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
    required Location? location,
  }) {
    final eventIds = dateMap.eventIdsFromDateTimeRange(dateTimeRange, location);
    final events = eventIds.map((id) => dateMap.byId(id)).nonNulls;

    if (includeMultiDayEvents && includeDayEvents) {
      return _allEventsFromDateTimeRange(events, dateTimeRange, location);
    } else if (includeMultiDayEvents) {
      return _multiDayEventsFromDateTimeRange(events, dateTimeRange, location);
    } else if (includeDayEvents) {
      return _dayEventsFromDateTimeRange(events, dateTimeRange, location);
    } else {
      return [];
    }
  }

  /// Finds all the [CalendarEvent]s that occur during the [dateTimeRange].
  Iterable<CalendarEvent<T>> _allEventsFromDateTimeRange(
    Iterable<CalendarEvent<T>> events,
    InternalDateTimeRange dateTimeRange,
    Location? location,
  ) {
    return events.where(
      (event) {
        // If the event is a zero duration event at the start of the day, we should check for touching.
        final touching = _checkTouching(event);
        return event.internalRange(location).overlaps(dateTimeRange, touching: touching);
      },
    );
  }

  /// Finds the [CalendarEvent]s longer than 1 day that occur during the [dateTimeRange].
  Iterable<CalendarEvent<T>> _multiDayEventsFromDateTimeRange(
    Iterable<CalendarEvent<T>> events,
    InternalDateTimeRange dateTimeRange,
    Location? location,
  ) {
    return events.where((event) {
      // If the event is not a multi day event, return false.
      if (!event.isMultiDayEvent) return false;
      return event.internalRange(location).overlaps(dateTimeRange);
    });
  }

  /// Finds the [CalendarEvent]s that are shorter than 1 day that occur during the [dateTimeRange].
  Iterable<CalendarEvent<T>> _dayEventsFromDateTimeRange(
    Iterable<CalendarEvent<T>> events,
    InternalDateTimeRange dateTimeRange,
    Location? location,
  ) {
    return events.where((event) {
      // If the event is a multi day event, return false.
      if (event.isMultiDayEvent) return false;

      // If the event is a zero duration event at the start of the day, we should check for touching.
      final touching = _checkTouching(event);

      return event.internalRange(location).overlaps(dateTimeRange, touching: touching);
    });
  }

  /// Check if the event is touching the start of the day, and that is a zero duration event.
  bool _checkTouching(CalendarEvent event) => event.start == event.end && event.start == event.start.startOfDay;
}

/// A class that maps [CalendarEvent]s to dates.
///
/// This class is used to store [CalendarEvent]s and retrieve them based on the date.
abstract class DateMap<T> {
  Iterable<CalendarEvent<T>> get events;

  /// Retrieve a [CalendarEvent] by it's id if it exists.
  CalendarEvent<T>? byId(int id);

  /// Add a new [event] to the map.
  int addNewEvent(CalendarEvent<T> event);

  /// Update an [event] in the map with the [updatedEvent].
  void updateEvent(CalendarEvent<T> event, CalendarEvent<T> updatedEvent);

  /// Remove the [event].
  void removeEvent(CalendarEvent<T> event);

  void removeEvents(List<CalendarEvent<T>> events);

  /// Remove an event by its id.
  void removeById(int id);

  /// Remove events where where [test] returns true.
  void removeWhere(bool Function(int key, CalendarEvent<T> element) test);

  /// Clear all events.
  void clear();

  /// Retrieves the IDs of events that occur during the specified [dateTimeRange].
  ///
  /// Parameters:
  /// - [dateTimeRange]: The internal date time range to search for events.
  /// - [location]: The location for which to retrieve the event IDs.
  Set<int> eventIdsFromDateTimeRange(InternalDateTimeRange dateTimeRange, Location? location);
}
