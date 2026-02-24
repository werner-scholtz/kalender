import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/controllers/events_controller/default_event_store.dart';

/// The default [EventsController] for managing [CalendarEvent]s.
class DefaultEventsController extends EventsController {
  final List<Location> locations;

  /// Creates a [DefaultEventsController].
  ///
  /// The [locations] can be provided to the [DefaultEventStore] to optimize the retrieval and addition of events based on location.
  DefaultEventsController({List<Location>? locations}) : locations = locations ?? [];

  late final eventStore = DefaultEventStore(locations: locations);

  @override
  Iterable<CalendarEvent> get events => eventStore.events;

  @override
  String addEvent(CalendarEvent event) {
    final id = eventStore.addNewEvent(event);
    notifyListeners();
    return id;
  }

  @override
  List<String> addEvents(List<CalendarEvent> events) {
    final ids = events.map(eventStore.addNewEvent).toList();
    notifyListeners();
    return ids;
  }

  @override
  void removeEvent(CalendarEvent event) {
    eventStore.removeEvent(event);
    notifyListeners();
  }

  @override
  void removeEvents(List<CalendarEvent> events) {
    eventStore.removeEvents(events);
    notifyListeners();
  }

  @override
  void removeById(String id) {
    eventStore.removeById(id);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(String key, CalendarEvent element) test) {
    eventStore.removeWhere(test);
    notifyListeners();
  }

  @override
  void clearEvents() {
    eventStore.clear();
    notifyListeners();
  }

  @override
  void updateEvent({
    required CalendarEvent event,
    required CalendarEvent updatedEvent,
  }) {
    updatedEvent.id = event.id;
    eventStore.updateEvent(event, updatedEvent);
    notifyListeners();
  }

  @override
  CalendarEvent? byId(String id) => eventStore.byId(id);

  @override
  Iterable<CalendarEvent> eventsFromDateTimeRange(
    InternalDateTimeRange dateTimeRange, {
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
    Location? location,
  }) {
    final eventIds = eventStore.eventIdsFromDateTimeRange(dateTimeRange, location);
    final events = eventIds.map((id) => eventStore.byId(id)).nonNulls;

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
  Iterable<CalendarEvent> _allEventsFromDateTimeRange(
    Iterable<CalendarEvent> events,
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

  /// Finds the [CalendarEvent]s longer than 1 day that occur during the [dateTimeRange].
  Iterable<CalendarEvent> _multiDayEventsFromDateTimeRange(
    Iterable<CalendarEvent> events,
    InternalDateTimeRange dateTimeRange,
    Location? location,
  ) {
    return events.where((event) {
      // If the event is not a multi day event, return false.
      if (!event.isMultiDayEvent) return false;
      return event.internalRange(location: location).overlaps(dateTimeRange);
    });
  }

  /// Finds the [CalendarEvent]s that are shorter than 1 day that occur during the [dateTimeRange].
  Iterable<CalendarEvent> _dayEventsFromDateTimeRange(
    Iterable<CalendarEvent> events,
    InternalDateTimeRange dateTimeRange,
    Location? location,
  ) {
    return events.where((event) {
      // If the event is a multi day event, return false.
      if (event.isMultiDayEvent) return false;

      // If the event is a zero duration event at the start of the day, we should check for touching.
      final touching = _checkTouching(event, location);

      return event.internalRange(location: location).overlaps(dateTimeRange, touching: touching);
    });
  }

  /// Check if the event is touching the start of the day, and that is a zero duration event.
  bool _checkTouching(CalendarEvent event, Location? location) {
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
