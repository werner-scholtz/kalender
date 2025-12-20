import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';

/// The default [EventsController] for managing [CalendarEvent]s.
class DefaultEventsController extends EventsController<int> {
  final List<Location> locations;

  /// Creates a [DefaultEventsController].
  DefaultEventsController({List<Location>? locations}) : locations = locations ?? [];

  late final dateMap = DefaultEventStore(locations: locations);

  @override
  Iterable<CalendarEvent> get events => dateMap.events;

  @override
  int addEvent(CalendarEvent event) {
    final id = dateMap.addNewEvent(event);
    notifyListeners();
    return id;
  }

  @override
  List<int> addEvents(List<CalendarEvent> events) {
    final ids = events.map(dateMap.addNewEvent).toList();
    notifyListeners();
    return ids;
  }

  @override
  void removeEvent(CalendarEvent event) {
    dateMap.removeEvent(event);
    notifyListeners();
  }

  @override
  void removeEvents(List<CalendarEvent> events) {
    dateMap.removeEvents(events);
    notifyListeners();
  }

  @override
  void removeById(int id) {
    assert(id != -1, 'Must be a valid id.');
    dateMap.removeById(id);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(int key, CalendarEvent element) test) {
    dateMap.removeWhere(test);
    notifyListeners();
  }

  @override
  void clearEvents() {
    dateMap.clear();
    notifyListeners();
  }

  @override
  void updateEvent({
    required CalendarEvent event,
    required CalendarEvent updatedEvent,
  }) {
    updatedEvent.id = event.id;
    dateMap.updateEvent(event, updatedEvent);
    notifyListeners();
  }

  @override
  CalendarEvent? byId(int id) => dateMap.byId(id);

@override
  Iterable<CalendarEvent> eventsFromDateTimeRange(
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


