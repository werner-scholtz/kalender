// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/controllers/events_controller/default_event_store.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/kalender_events/multi_day_rule.dart';

/// The default [EventsController] for managing [KalenderEvent]s.
///
/// {@category Events}
class DefaultEventsController extends EventsController {
  final List<Location> locations;

  /// The [locations] are passed to the [DefaultEventStore], which indexes events per location.
  DefaultEventsController({List<Location>? locations}) : locations = locations ?? [];

  late final eventStore = DefaultEventStore(locations: locations);

  @override
  Iterable<KalenderEvent> get events => eventStore.events;

  @override
  String addEvent(KalenderEvent event) {
    final id = eventStore.addNewEvent(event);
    notifyListeners();
    return id;
  }

  @override
  List<String> addEvents(List<KalenderEvent> events) {
    final ids = events.map(eventStore.addNewEvent).toList();
    notifyListeners();
    return ids;
  }

  @override
  void removeEvent(KalenderEvent event) {
    eventStore.removeEvent(event);
    notifyListeners();
  }

  @override
  void removeEvents(List<KalenderEvent> events) {
    eventStore.removeEvents(events);
    notifyListeners();
  }

  @override
  void removeById(String id) {
    eventStore.removeById(id);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(String key, KalenderEvent element) test) {
    eventStore.removeWhere(test);
    notifyListeners();
  }

  @override
  void clearEvents() {
    eventStore.clear();
    notifyListeners();
  }

  @override
  List<String> replaceEvents(List<KalenderEvent> events) {
    eventStore.clear();
    final ids = events.map(eventStore.addNewEvent).toList();
    notifyListeners();
    return ids;
  }

  @override
  void updateEvent({required KalenderEvent event, required KalenderEvent updatedEvent}) {
    updatedEvent.id = event.id;
    eventStore.updateEvent(event, updatedEvent);
    notifyListeners();
  }

  @override
  KalenderEvent? byId(String id) => eventStore.byId(id);

  @override
  Iterable<KalenderEvent> eventsInRange(
    FloatingDateTimeRange range, {
    required MultiDayRule multiDayRule,
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
    Location? location,
  }) {
    final eventIds = eventStore.eventIdsInRange(range, location);
    final events = eventIds.map((id) => eventStore.byId(id)).nonNulls;
    if (!includeMultiDayEvents && !includeDayEvents) return [];

    return events.where((event) {
      if (includeMultiDayEvents != includeDayEvents) {
        final multiDay = event.spansMultipleDays(location: location, defaultRule: multiDayRule);
        if (multiDay != includeMultiDayEvents) return false;
        if (multiDay) return event.floatingRange(location: location).overlaps(range);
      }
      final touching = _checkTouching(event, location);
      return event.floatingRange(location: location).overlaps(range, touching: touching);
    });
  }

  /// Check if the event is touching the start of the day, and that is a zero duration event.
  bool _checkTouching(KalenderEvent event, Location? location) {
    final floatingStart = event.floatingStart(location: location);
    final floatingEnd = event.floatingEnd(location: location);

    return floatingStart == floatingEnd && floatingStart.isStartOfDay;
  }
}
