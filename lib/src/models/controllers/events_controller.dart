import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:timezone/timezone.dart';

/// The [EventsController] is used to manage [CalendarEvent]s.
///
/// This class can be extended to create custom [EventsController]s.
/// e.g. [DefaultEventsController]
abstract class EventsController<T extends Object?> with ChangeNotifier {
  /// A ValueNotifier that holds the size of the feedback widget.
  final feedbackWidgetSize = ValueNotifier<Size>(Size.zero);

  /// The list of [CalendarEvent]s.
  Iterable<CalendarEvent<T>> get events;

  /// A Map of dates and event ids.
  DateMap<T> get dateMap;

  /// A list of predefined locations.
  ///
  /// If you know the locations that will be used in advance, you can
  /// provide them here to improve performance.
  /// TODO: this should maybe be dynamic so it remains extensible ?
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

  /// TODO: Require that we pass in a location as well this will require a rethink of how events are actually stored and retrieved.

  /// Finds the [CalendarEvent]s that occur during the [dateTimeRange].
  ///
  /// The [dateTimeRange] is the range of dates to search for events.
  /// The [includeMultiDayEvents] determines if events spanning multiple days should be included.
  /// The [includeDayEvents] determines if events that are shorter than 1 day should be included.
  Iterable<CalendarEvent<T>> eventsFromDateTimeRange(
    DateTimeRange dateTimeRange,
    // TODO: this should maybe be dynamic so it remains extensible.
    Location? location, {
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
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
    DateTimeRange dateTimeRange,
    Location? location,
  ) {
    return events.where(
      (event) {
        // If the event is a zero duration event at the start of the day, we should check for touching.
        final touching = _checkTouching(event);
        return event.dateTimeRangeAsUtc(location).overlaps(dateTimeRange, touching: touching);
      },
    );
  }

  /// Finds the [CalendarEvent]s longer than 1 day that occur during the [dateTimeRange].
  Iterable<CalendarEvent<T>> _multiDayEventsFromDateTimeRange(
    Iterable<CalendarEvent<T>> events,
    DateTimeRange dateTimeRange,
    Location? location,
  ) {
    return events.where((event) {
      // If the event is not a multi day event, return false.
      if (!event.isMultiDayEvent) return false;
      return event.dateTimeRangeAsUtc(location).overlaps(dateTimeRange);
    });
  }

  /// Finds the [CalendarEvent]s that are shorter than 1 day that occur during the [dateTimeRange].
  Iterable<CalendarEvent<T>> _dayEventsFromDateTimeRange(
    Iterable<CalendarEvent<T>> events,
    DateTimeRange dateTimeRange,
    Location? location,
  ) {
    return events.where((event) {
      // If the event is a multi day event, return false.
      if (event.isMultiDayEvent) return false;

      // If the event is a zero duration event at the start of the day, we should check for touching.
      final touching = _checkTouching(event);

      return event.dateTimeRangeAsUtc(location).overlaps(dateTimeRange, touching: touching);
    });
  }

  /// Check if the event is touching the start of the day, and that is a zero duration event.
  bool _checkTouching(CalendarEvent event) => event.start == event.end && event.start == event.start.startOfDay;
}

/// The default [EventsController] for managing [CalendarEvent]s.
class DefaultEventsController<T extends Object?> extends EventsController<T> {
  @override
  final List<Location> locations;

  @override
  late final dateMap = DefaultDateMap<T>(locations: locations);

  /// Creates a [DefaultEventsController] with optional predefined [locations].
  DefaultEventsController({this.locations = const []});

  @override
  Iterable<CalendarEvent<T>> get events => dateMap.events;
}

/// TODO: how can we ensure that what is retrieved here is always correct ?
/// A class that maps [CalendarEvent]s to dates.
///
/// This class is used to store [CalendarEvent]s and retrieve them based on the date.
abstract class DateMap<T> {
  /// A internal map of events.
  Iterable<CalendarEvent<T>> get events;

  /// A List of predefined locations that will be cached.
  List<Location> get locations;

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

  /// Retrieve a [Set] of event id's from the map that occur during the [dateTimeRange] for a specific [location].
  /// TODO: this should maybe be dynamic so it remains extensible.
  Set<int> eventIdsFromDateTimeRange(DateTimeRange dateTimeRange, Location? location);
}

/// A map of location strings to date maps.
typedef LocationDateIdMap = Map<String, DateIdMap>;

/// Map of the [DateTime.millisecondsSinceEpoch] and event ids.
///
/// The [DateTime.millisecondsSinceEpoch] is the date.
/// The [Set] of [int] is the ids of the events.
typedef DateIdMap = Map<DateTime, Set<int>>;

/// A map of event id's to [CalendarEvent]s.
typedef IdEventMap<T> = Map<int, CalendarEvent<T>>;


/// TODO: What happens if a location that was not predefined is used ?
/// The default class for storing [CalendarEvent]s.
class DefaultDateMap<T> extends DateMap<T> {
  @override
  final List<Location> locations;

  /// Map of location strings to date maps.
  late final LocationDateIdMap locationDateIdMap = {
    ...{defaultLocation: DateIdMap()},
    for (final location in locations) location.name: DateIdMap(),
  };

  /// A Map containing all events.
  final idEvent = IdEventMap<T>();

  int _lastId = 0;
  int get _nextId {
    _lastId++;
    return _lastId;
  }

  /// Create a [DefaultDateMap] with optional predefined [locations].
  DefaultDateMap({this.locations = const []});

  /// Retrieve the [DateIdMap] for the given [location].
  DateIdMap dateIdMap(String location) => locationDateIdMap[location]!;

  @override
  Iterable<CalendarEvent<T>> get events => idEvent.values;

  @override
  CalendarEvent<T>? byId(int id) => idEvent[id];

  /// The default location string.
  static const defaultLocation = 'default';

  /// Clear the [locationDateIdMap] and [idEvent] maps.
  @override
  void clear() {
    locationDateIdMap.clear();
    idEvent.clear();

    // Re-add the default locations.
    locationDateIdMap.addAll({
      defaultLocation: DateIdMap(),
      for (final location in locations) location.name: DateIdMap(),
    });
  }

  @override
  int addNewEvent(CalendarEvent<T> event) {
    final eventWithId = assignId(event);
    _addEvent(eventWithId);
    return eventWithId.id;
  }

  @override
  void removeById(int id) {
    final event = idEvent[id];
    assert(event != null, 'The event with id $id cannot be removed as it does not exist in the map.');
    if (event == null) return;
    removeEvent(event);
  }

  @override
  void removeEvent(CalendarEvent event) {
    final id = event.id;
    assert(idEvent[id] != null, 'The event: $event cannot be removed as it does not exist in the map.');
    idEvent.remove(id);

    for (final locationString in locationDateIdMap.keys) {
      final location = locationString == defaultLocation ? null : getLocation(locationString);
      final dates = event.datesSpanned(location);
      for (final date in dates) {
        locationDateIdMap[locationString]!.update(
          date,
          (value) => value..remove(id),
        );
      }
    }
  }

  @override
  void removeEvents(List<CalendarEvent<T>> events) => events.forEach(removeEvent);

  @override
  void updateEvent(CalendarEvent<T> event, CalendarEvent<T> updatedEvent) {
    removeEvent(event);
    _addEvent(updatedEvent);
  }

  /// TODO: Check that this works correctly.
  @override
  void removeWhere(bool Function(int key, CalendarEvent<T> element) test) {
    return idEvent.removeWhere((key, event) => test(key, event));
  }

  @override
  Set<int> eventIdsFromDateTimeRange(DateTimeRange dateTimeRange, Location? location) {
    assert(dateTimeRange.isUtc, 'The DateTimeRange must be in UTC.');
    final days = dateTimeRange.dates();
    final eventIds = <int>{};
    for (final day in days) {
      final locationString = location?.name ?? defaultLocation;
      final dateIds = locationDateIdMap[locationString]!;
      eventIds.addAll(dateIds[day] ?? {});
    }
    return eventIds;
  }

  /// Assign and id to an event.
  CalendarEvent<T> assignId(CalendarEvent<T> event) {
    assert(event.id == -1, 'The id of the event must not be set manually.');
    event.id = _nextId;
    return event;
  }

  /// Add an [event] to the map.
  void _addEvent(CalendarEvent<T> event) {
    final id = event.id;
    idEvent[id] = event;

    for (final locationString in locationDateIdMap.keys) {
      final location = locationString == defaultLocation ? null : getLocation(locationString);
      final dates = event.datesSpanned(location);

      for (final date in dates) {
        locationDateIdMap[locationString]!.update(
          date,
          (value) => value..add(id),
          ifAbsent: () => {id},
        );
      }
    }
  }
}
