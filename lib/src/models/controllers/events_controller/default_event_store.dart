// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/controllers/events_controller/event_store.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:timezone/timezone.dart';

/// Maps a timezone location name to its [DateToEventIds].
///
/// {@category Events}
typedef LocationDateIdMap = Map<String, DateToEventIds>;

/// Maps a date key from [DefaultEventStore.toKey] to the ids of the events on that date.
///
/// {@category Events}
typedef DateToEventIds = Map<String, Set<String>>;

/// Maps an event id to its [KalenderEvent].
///
/// {@category Events}
typedef EventIdToEvent = Map<String, KalenderEvent>;

/// The default class for storing [KalenderEvent]s.
///
/// {@category Events}
class DefaultEventStore extends EventStore {
  /// Predefined locations for optimizations.
  ///
  /// Locations not listed here get their index built on first use.
  final List<Location> locations;

  /// A Map containing all events.
  final idEvent = EventIdToEvent();

  /// Map of location strings to date maps.
  final locationDateIdMap = LocationDateIdMap();

  /// The default location string.
  static const defaultLocation = 'default';

  /// Convert a [FloatingDateTime] to a key string.
  String toKey(FloatingDateTime date) => '${date.year}-${date.month}-${date.day}';

  /// Create a [DefaultEventStore] with optional predefined [locations].
  DefaultEventStore({required this.locations}) {
    populateAllLocations();
  }

  @override
  Iterable<KalenderEvent> get events => idEvent.values;

  @override
  KalenderEvent? byId(String id) => idEvent[id];

  @override
  void clear() {
    locationDateIdMap.clear();
    idEvent.clear();

    locationDateIdMap.addAll({
      defaultLocation: DateToEventIds(),
      for (final location in locations) location.name: DateToEventIds(),
    });
  }

  @override
  String addNewEvent(KalenderEvent event) {
    addEvent(event);
    return event.id;
  }

  @override
  void removeById(String id) {
    final event = byId(id);
    assert(event != null, 'The event with id $id cannot be removed as it does not exist in the map.');
    if (event == null) return;
    removeEvent(event);
  }

  @override
  void removeEvent(KalenderEvent event) {
    final id = event.id;
    assert(idEvent[id] != null, 'The event: $event cannot be removed as it does not exist in the map.');
    idEvent.remove(id);

    for (final locationString in locationDateIdMap.keys) {
      final location = locationString == defaultLocation ? null : getLocation(locationString);
      final dates = event.floatingRange(location: location).dates();
      for (final date in dates) {
        locationDateIdMap[locationString]![toKey(date)]?.remove(id);
      }
    }
  }

  @override
  void removeEvents(List<KalenderEvent> events) => events.forEach(removeEvent);

  @override
  void updateEvent(KalenderEvent event, KalenderEvent updatedEvent) {
    removeEvent(event);
    addEvent(updatedEvent);
  }

  @override
  void removeWhere(bool Function(String key, KalenderEvent element) test) {
    // Collect the events to remove first, before modifying idEvent, so that
    // removeEvent can still look them up while cleaning up locationDateIdMap.
    final eventsToRemove = idEvent.entries
        .where((entry) => test(entry.key, entry.value))
        .map((entry) => entry.value)
        .toList();

    eventsToRemove.forEach(removeEvent);
  }

  @override
  Set<String> eventIdsInRange(FloatingDateTimeRange range, Location? location) {
    final locationString = location?.name ?? defaultLocation;
    final hasLocation = hasDateToEventIds(locationString);

    if (!hasLocation) {
      locations.add(location!);
      populateLocation(location);
    }

    final days = range.dates();
    final eventIds = <String>{};
    for (final day in days) {
      final dateIds = locationDateIdMap[locationString]!;
      eventIds.addAll(dateIds[toKey(day)] ?? {});
    }

    return eventIds;
  }

  /// Add an [event] to the map.
  void addEvent(KalenderEvent event) {
    final id = event.id;
    idEvent[id] = event;

    for (final locationString in locationDateIdMap.keys) {
      final location = locationString == defaultLocation ? null : getLocation(locationString);
      addEventToLocation(location, event);
    }
  }

  /// Populate all predefined locations in the [locationDateIdMap].
  void populateAllLocations() {
    populateLocation(null);

    for (final locations in locations) {
      populateLocation(locations);
    }
  }

  /// Check if the [locationDateIdMap] contains the given [location].
  bool hasDateToEventIds(String location) => locationDateIdMap.containsKey(location);

  /// Populate the [locationDateIdMap] with a new [location] if it does not exist.
  void populateLocation(Location? location) {
    final locationString = location?.name ?? defaultLocation;

    if (!hasDateToEventIds(locationString)) locationDateIdMap[locationString] = DateToEventIds();

    for (final event in idEvent.values) {
      addEventToLocation(location, event);
    }
  }

  /// Add an [event] to the specified [location] in the [locationDateIdMap].
  void addEventToLocation(Location? location, KalenderEvent event) {
    final locationString = location?.name ?? defaultLocation;
    final dates = event.floatingRange(location: location).dates();
    for (final date in dates) {
      locationDateIdMap[locationString]!.update(
        toKey(date),
        (value) => value..add(event.id),
        ifAbsent: () => {event.id},
      );
    }
  }
}
