import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:timezone/timezone.dart';

/// Maps timezone location names to their respective date-to-event-ID indexes.
///
/// Each location (timezone) maintains its own mapping of dates to event IDs,
/// allowing efficient querying of events within specific timezones.
///
/// Example structure:
/// ```dart
/// {
///   'America/New_York': {DateTime(2024, 1, 15): {1, 3, 7}},
///   'Europe/London': {DateTime(2024, 1, 15): {2, 5}},
///   'default': {DateTime(2024, 1, 15): {1, 2, 3, 5, 7}},
/// }
/// ```
typedef LocationDateIdMap = Map<String, DateToEventIds>;

/// Maps calendar dates to sets of event IDs that occur on those dates.
///
/// The [DateTime] keys represent calendar dates (typically at midnight UTC)
/// and the [Set<int>] values contain the IDs of all events that span or
/// occur on that date.
///
/// This structure enables efficient lookup of events within date ranges
/// by checking only the relevant date entries.
///
/// Example:
/// ```dart
/// {
///   DateTime.utc(2024, 1, 15): {101, 102, 105},
///   DateTime.utc(2024, 1, 16): {103, 105},
/// }
/// ```
typedef DateToEventIds = Map<DateTime, Set<int>>;

/// Maps unique event IDs to their corresponding [CalendarEvent] instances.
///
/// This serves as the primary storage for calendar events, providing
/// O(1) lookup by event ID. Used in conjunction with [DateToEventIds]
/// for efficient event retrieval.
///
/// Example:
/// ```dart
/// {
///   101: CalendarEvent(data: 'Meeting', ...),
///   102: CalendarEvent(data: 'Lunch', ...),
/// }
/// ```
typedef EventIdToEvent<T> = Map<int, CalendarEvent<T>>;

/// TODO: What happens if a location that was not predefined is used ?
/// The default class for storing [CalendarEvent]s.
class DefaultDateMap<T> extends EventStore<T> {
  @override
  final List<Location> locations;

  /// Create a [DefaultDateMap] with optional predefined [locations].
  DefaultDateMap({this.locations = const []}) {
    populateAllLocations();
  }

  /// The last assigned event ID.
  int _lastId = 0;

  /// Get the next available event ID.
  int get _nextId {
    _lastId++;
    return _lastId;
  }

  /// A Map containing all events.
  final idEvent = EventIdToEvent<T>();

  /// Map of location strings to date maps.
  final locationDateIdMap = LocationDateIdMap();

  /// The default location string.
  static const defaultLocation = 'default';

  @override
  Iterable<CalendarEvent<T>> get events => idEvent.values;

  @override
  CalendarEvent<T>? byId(int id) => idEvent[id];

  /// Clear the [locationDateIdMap] and [idEvent] maps.
  @override
  void clear() {
    locationDateIdMap.clear();
    idEvent.clear();

    // Re-add the default locations.
    locationDateIdMap.addAll({
      defaultLocation: DateToEventIds(),
      for (final location in locations) location.name: DateToEventIds(),
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
    final event = byId(id);
    assert(event != null, 'The event with id $id cannot be removed as it does not exist in the map.');
    if (event == null) return;
    removeEvent(event);
  }

  @override
  void removeEvents(List<CalendarEvent<T>> events) => events.forEach(removeEvent);

  @override
  void updateEvent(CalendarEvent<T> event, CalendarEvent<T> updatedEvent) {
    removeEvent(event);
    _addEvent(updatedEvent);
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
  void removeWhere(bool Function(int key, CalendarEvent<T> element) test) {
    final idsToRemove = <int>[];

    idEvent.removeWhere((key, event) {
      final shouldRemove = test(key, event);
      if (shouldRemove) idsToRemove.add(key);
      return shouldRemove;
    });

    idsToRemove.forEach(removeById);
  }

  @override
  Set<int> eventIdsFromDateTimeRange(DateTimeRange dateTimeRange, Location? location) {
    assert(dateTimeRange.isUtc, 'The DateTimeRange must be in UTC.');

    // Ensure the location exists in the map.
    final hasLocation = hasDateToEventIds(location?.name ?? defaultLocation);
    // If the location does not exist, populate it.
    if (!hasLocation) populateLocation(location);

    final days = dateTimeRange.dates();
    final eventIds = <int>{};
    for (final day in days) {
      final locationString = location?.name ?? defaultLocation;
      final dateIds = locationDateIdMap[locationString]!;
      eventIds.addAll(dateIds[day] ?? {});
    }
    return eventIds;
  }

  /// Retrieve the [DateToEventIds] for the given [location].
  DateToEventIds dateToEventIds(String location) => locationDateIdMap[location]!;

  /// Check if the [locationDateIdMap] contains the given [location].
  bool hasDateToEventIds(String location) => locationDateIdMap.containsKey(location);

  /// Populate all predefined locations in the [locationDateIdMap].
  void populateAllLocations() {
    // Populate the default location.
    populateLocation(null);

    // Populate the predefined locations.
    for (final locations in locations) {
      populateLocation(locations);
    }
  }

  /// Populate the [locationDateIdMap] with a new [location] if it does not exist.
  void populateLocation(Location? location) {
    // If the location is null, use the default location.
    final locationString = location?.name ?? defaultLocation;

    // Add the location if it does not exist.
    if (!hasDateToEventIds(locationString)) locationDateIdMap[locationString] = DateToEventIds();

    // Add all existing events to the new location.
    for (final event in idEvent.values) {
      _addEventToLocation(location, event);
    }
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

  /// Add an [event] to the specified [location] in the [locationDateIdMap].
  void _addEventToLocation(Location? location, CalendarEvent<T> event) {
    final locationString = location?.name ?? defaultLocation;
    final dates = event.datesSpanned(location);

    for (final date in dates) {
      locationDateIdMap[locationString]!.update(
        date,
        (value) => value..add(event.id),
        ifAbsent: () => {event.id},
      );
    }
  }
}
