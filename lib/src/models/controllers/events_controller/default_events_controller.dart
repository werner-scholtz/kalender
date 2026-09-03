import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/controllers/events_controller/default_event_store.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/kalender_events/multi_day_rule.dart';

/// The default [EventsController] for managing [KalenderEvent]s.
class DefaultEventsController extends EventsController {
  final List<Location> locations;

  /// Creates a [DefaultEventsController].
  ///
  /// The [locations] can be provided to the [DefaultEventStore] to optimize the retrieval and addition of events based on location.
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
  void updateEvent({
    required KalenderEvent event,
    required KalenderEvent updatedEvent,
  }) {
    updatedEvent.id = event.id;
    eventStore.updateEvent(event, updatedEvent);
    notifyListeners();
  }

  @override
  KalenderEvent? byId(String id) => eventStore.byId(id);

  @override
  Iterable<KalenderEvent> eventsFromDateTimeRange(
    InternalDateTimeRange dateTimeRange, {
    required MultiDayRule multiDayRule,
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
    Location? location,
  }) {
    final eventIds = eventStore.eventIdsFromDateTimeRange(dateTimeRange, location);
    final events = eventIds.map((id) => eventStore.byId(id)).nonNulls;

    if (includeMultiDayEvents && includeDayEvents) {
      return _allEventsFromDateTimeRange(events, dateTimeRange, location);
    } else if (includeMultiDayEvents) {
      return _multiDayEventsFromDateTimeRange(events, dateTimeRange, location, multiDayRule);
    } else if (includeDayEvents) {
      return _dayEventsFromDateTimeRange(events, dateTimeRange, location, multiDayRule);
    } else {
      return [];
    }
  }

  /// Finds all the [KalenderEvent]s that occur during the [dateTimeRange].
  Iterable<KalenderEvent> _allEventsFromDateTimeRange(
    Iterable<KalenderEvent> events,
    InternalDateTimeRange dateTimeRange,
    Location? location,
  ) {
    return events.where(
      (event) {
        // If the event is a zero duration event at the start of the day, we should check for touching.
        final touching = _checkTouching(event, location);
        return event.internalRange(location: location).overlaps(dateTimeRange, touching: touching);
      },
    );
  }

  /// Finds the [KalenderEvent]s longer than 1 day that occur during the [dateTimeRange].
  Iterable<KalenderEvent> _multiDayEventsFromDateTimeRange(
    Iterable<KalenderEvent> events,
    InternalDateTimeRange dateTimeRange,
    Location? location,
    MultiDayRule multiDayRule,
  ) {
    return events.where((event) {
      // If the event is not a multi day event, return false.
      if (!event.spansMultipleDays(location: location, defaultRule: multiDayRule)) return false;
      return event.internalRange(location: location).overlaps(dateTimeRange);
    });
  }

  /// Finds the [KalenderEvent]s that are shorter than 1 day that occur during the [dateTimeRange].
  Iterable<KalenderEvent> _dayEventsFromDateTimeRange(
    Iterable<KalenderEvent> events,
    InternalDateTimeRange dateTimeRange,
    Location? location,
    MultiDayRule multiDayRule,
  ) {
    return events.where((event) {
      // If the event is a multi day event, return false.
      if (event.spansMultipleDays(location: location, defaultRule: multiDayRule)) return false;

      // If the event is a zero duration event at the start of the day, we should check for touching.
      final touching = _checkTouching(event, location);

      return event.internalRange(location: location).overlaps(dateTimeRange, touching: touching);
    });
  }

  /// Check if the event is touching the start of the day, and that is a zero duration event.
  bool _checkTouching(KalenderEvent event, Location? location) {
    final internalStart = event.internalStart(location: location);
    final internalEnd = event.internalEnd(location: location);

    return internalStart == internalEnd &&
        internalStart ==
            InternalDateTime(
              internalStart.year,
              internalStart.month,
              internalStart.day,
            );
  }
}
