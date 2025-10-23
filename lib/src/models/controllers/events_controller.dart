import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/controllers/events_controller/default_date_map.dart';
import 'package:kalender/src/models/controllers/events_controller/default_events_controller.dart';
import 'package:timezone/timezone.dart';

export 'package:kalender/src/models/controllers/events_controller/default_date_map.dart';
export 'package:kalender/src/models/controllers/events_controller/default_events_controller.dart';

/// The [EventsController] is used to manage [CalendarEvent]s for calendar views.
///
/// This abstract class provides a high-level interface for event management operations
/// including adding, removing, updating, and querying events. It uses an [EventStore]
/// internally to handle the actual storage and indexing.
///
/// - **Event Lifecycle**: Add, update, remove events with automatic change notifications
/// - **Date-Range Queries**: Find events within specific time periods
/// - **Location Support**: Filter events by timezone/location
/// - **Change Notifications**: Implements [ChangeNotifier] for UI updates
///
/// Extend this class or use [DefaultEventsController] for basic implementations:
///
/// ```dart
/// final controller = DefaultEventsController<MyEventData>();
///
/// // Add an event
/// final eventId = controller.addEvent(CalendarEvent(
///   dateTimeRange: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(hours: 1))),
///   data: MyEventData('Meeting'),
/// ));
///
/// // Query events for a date range
/// final events = controller.eventsFromDateTimeRange(
///   DateTimeRange(start: startDate, end: endDate),
///   myLocation,
/// );
/// ```
abstract class EventsController<T extends Object?> with ChangeNotifier {
  /// A ValueNotifier that holds the size of the feedback widget.
  ///
  /// This is used internally by the calendar views to manage drag-and-drop
  /// feedback visualization. Applications typically don't need to interact
  /// with this directly.
  final feedbackWidgetSize = ValueNotifier<Size>(Size.zero);

  /// All events currently managed by this controller.
  ///
  /// This provides read-only access to the complete collection of events.
  /// The order of events in this iterable is implementation-dependent.
  ///
  /// Use this for operations that need to iterate over all events, such as
  /// displaying event counts or performing bulk validations.
  Iterable<CalendarEvent<T>> get events;

  /// The underlying storage system for events.
  ///
  /// This [EventStore] handles the actual storage, indexing, and retrieval
  /// of calendar events. Application code typically does not access this directly,
  /// instead use the methods provided by this [EventsController].
  EventStore<T> get eventStore;

  /// Predefined locations from the [timezone](https://pub.dev/packages/timezone) package for performance optimizations.
  ///
  /// If you know the locations (timezones) that will be frequently used,
  /// provide them here to improve query performance. This allows the
  /// implementation to pre-compute location-specific indexes.
  ///
  /// Example:
  /// ```dart
  /// // Ensure that the timezone package's database is initialized.
  /// import 'package:timezone/timezone.dart';
  ///
  /// @override
  /// List<Location> get locations => [
  ///   getLocation('America/New_York'),
  ///   getLocation('Europe/London'),
  ///   getLocation('Asia/Tokyo'),
  /// ];
  /// ```
  List<Location> get locations;

  /// Adds a [CalendarEvent] to the controller.
  ///
  /// The event will be automatically assigned a unique ID and indexed
  /// for efficient retrieval. Listeners will be notified of the change.
  ///
  /// Returns the ID assigned to the event, which can be used later
  /// for operations like [removeById] or [byId].
  ///
  /// Example:
  /// ```dart
  /// final event = CalendarEvent(
  ///   dateTimeRange: DateTimeRange(
  ///     start: DateTime(2024, 1, 15, 10),
  ///     end: DateTime(2024, 1, 15, 11),
  ///   ),
  ///   data: MyEventData('Team Meeting'),
  /// );
  /// final eventId = controller.addEvent(event);
  /// ```
  int addEvent(CalendarEvent<T> event) {
    final id = eventStore.addNewEvent(event);
    notifyListeners();
    return id;
  }

  /// Adds multiple [CalendarEvent]s to the controller in a single operation.
  ///
  /// This is more efficient than calling [addEvent] multiple times as it
  /// only triggers [notifyListeners] once.
  ///
  /// Returns the IDs assigned to the events in the same order as the input list.
  ///
  /// Example:
  /// ```dart
  /// final events = [
  ///   CalendarEvent(dateTimeRange: range1, data: data1),
  ///   CalendarEvent(dateTimeRange: range2, data: data2),
  /// ];
  /// final eventIds = controller.addEvents(events);
  /// print('Added ${eventIds.length} events');
  /// ```
  List<int> addEvents(List<CalendarEvent<T>> events) {
    final ids = events.map(eventStore.addNewEvent).toList();
    notifyListeners();
    return ids;
  }

  /// Removes a [CalendarEvent] from the controller.
  ///
  /// If the event is not found in the controller, this method has no effect.
  /// Listeners will be notified if an event was actually removed.
  ///
  /// Example:
  /// ```dart
  /// controller.removeEvent(myEvent);
  /// ```
  /// TODO: This should be updated so that if no event was removed no notification is sent.
  void removeEvent(CalendarEvent<T> event) {
    eventStore.removeEvent(event);
    notifyListeners();
  }

  /// Removes multiple [CalendarEvent]s from the controller in a single operation.
  ///
  /// Example:
  /// ```dart
  /// final eventsToRemove = [event1, event2, event3];
  /// controller.removeEvents(eventsToRemove);
  /// ```
  void removeEvents(List<CalendarEvent<T>> events) {
    eventStore.removeEvents(events);
    notifyListeners();
  }

  /// Removes a [CalendarEvent] by its unique identifier.
  ///
  /// The [id] must be a valid ID (not -1). If no event with the given ID
  /// exists/
  ///
  /// Throws an [AssertionError] if [id] is -1.
  ///
  /// Example:
  /// ```dart
  /// final eventId = controller.addEvent(myEvent);
  /// // Later...
  /// controller.removeById(eventId);
  /// ```
  void removeById(int id) {
    assert(id != -1, 'Must be a valid id.');
    eventStore.removeById(id);
    notifyListeners();
  }

  /// Removes all events where the [test] function returns true.
  ///
  /// The [test] function receives the event ID and the event itself,
  /// allowing for flexible removal criteria.
  ///
  /// Example:
  /// ```dart
  /// // Remove all events with null data
  /// controller.removeWhere((id, event) => event.data == null);
  ///
  /// // Remove events in a specific date range
  /// controller.removeWhere((id, event) =>
  ///   event.start.isAfter(cutoffDate));
  /// ```
  void removeWhere(bool Function(int key, CalendarEvent<T> element) test) {
    eventStore.removeWhere(test);
    notifyListeners();
  }

  /// Removes all events from the event store.
  ///
  /// After calling this method, [events] will be empty.
  /// Listeners will be notified of the change.
  ///
  /// Example:
  /// ```dart
  /// controller.clearEvents();
  /// assert(controller.events.isEmpty);
  /// ```
  void clearEvents() {
    eventStore.clear();
    notifyListeners();
  }

  /// Updates an existing [CalendarEvent] with new data.
  ///
  /// The [event] parameter should be the current event instance, and
  /// [updatedEvent] contains the new data. The event ID will be preserved
  /// and transferred to the updated event.
  ///
  /// Both events must be non-null. If the original [event] is not found,
  /// this method may throw or have no effect depending on the implementation.
  ///
  /// Example:
  /// ```dart
  /// final originalEvent = controller.byId(eventId)!;
  /// final updatedEvent = CalendarEvent(
  ///   dateTimeRange: newDateTimeRange,
  ///   data: originalEvent.data..title = 'Updated Title',
  /// );
  /// controller.updateEvent(
  ///   event: originalEvent,
  ///   updatedEvent: updatedEvent,
  /// );
  /// ```
  void updateEvent({
    required CalendarEvent<T> event,
    required CalendarEvent<T> updatedEvent,
  }) {
    updatedEvent.id = event.id;
    eventStore.updateEvent(event, updatedEvent);
    notifyListeners();
  }

  /// Retrieves a [CalendarEvent] by its unique identifier.
  ///
  /// Returns `null` if no event with the given [id] exists.
  ///
  /// This is useful for retrieving events when you only have their ID,
  /// such as from user interactions or stored references.
  ///
  /// Example:
  /// ```dart
  /// final event = controller.byId(123);
  /// if (event != null) {
  ///   print('Found event: ${event.data}');
  /// } else {
  ///   print('Event not found');
  /// }
  /// ```
  CalendarEvent<T>? byId(int id) => eventStore.byId(id);

  /// Finds all [CalendarEvent]s that occur during the specified [dateTimeRange].
  ///
  /// This is the primary method for querying events within a time period.
  /// The method supports filtering by event type and handles timezone
  /// conversions when a [location] is provided.
  ///
  /// - [dateTimeRange]: The time period to search within
  /// - [location]: Optional timezone for location-specific filtering
  /// - [includeMultiDayEvents]: Whether to include events spanning multiple days
  /// - [includeDayEvents]: Whether to include events shorter than one day
  ///
  /// Returns an iterable of events that overlap with the given range.
  /// Events at the boundary are included based on the overlap rules and
  /// event type (zero-duration events at day start use touching semantics).
  ///
  /// Example:
  /// ```dart
  /// final thisWeek = DateTimeRange(
  ///   start: DateTime.now().startOfWeek,
  ///   end: DateTime.now().endOfWeek,
  /// );
  ///
  /// // Get all events this week
  /// final allEvents = controller.eventsFromDateTimeRange(thisWeek, null);
  ///
  /// // Get only multi-day events this week
  /// final multiDayOnly = controller.eventsFromDateTimeRange(
  ///   thisWeek,
  ///   null,
  ///   includeMultiDayEvents: true,
  ///   includeDayEvents: false,
  /// );
  /// ```
  Iterable<CalendarEvent<T>> eventsFromDateTimeRange(
    DateTimeRange dateTimeRange,
    Location? location, {
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
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

  /// Finds all [CalendarEvent]s that occur during the [dateTimeRange].
  ///
  /// This internal method handles the overlap detection for all event types.
  /// Zero-duration events at the start of a day use touching semantics.
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

  /// Finds [CalendarEvent]s longer than 1 day that occur during the [dateTimeRange].
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

  /// Finds [CalendarEvent]s shorter than 1 day that occur during the [dateTimeRange].
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

  /// Checks if an event should use touching semantics for overlap detection.
  ///
  /// Returns true for zero-duration events that occur exactly at the start
  /// of a day (midnight). These events use touching semantics to ensure
  /// they are included in date range queries.
  bool _checkTouching(CalendarEvent event) => event.start == event.end && event.start == event.start.startOfDay;
}

/// A storage and indexing system for [CalendarEvent]s that enables efficient retrieval by date ranges and locations.
///
/// The [EventStore] acts as an abstraction layer between the [EventsController] and the underlying
/// event storage mechanism. It provides:
///
/// - **Event Storage**: Add, update, remove, and retrieve calendar events
/// - **Date-based Indexing**: Efficiently find events within specific date ranges
/// - **Location Support**: Filter events by timezone/location
/// - **ID Management**: Automatic assignment and lookup of unique event IDs
///
/// The [EventStore] is typically used internally by [EventsController] implementations see [DefaultEventStore]
/// and should not be accessed directly by application code. Instead, use the
/// [EventsController] methods which delegate to the underlying [EventStore].
///
/// Example:
/// ```dart
/// class MyEventStore<T> extends EventStore<T> {
///   final Map<int, CalendarEvent<T>> _events = {};
///   final Map<DateTime, Set<int>> _dateIndex = {};
///
///   @override
///   int addNewEvent(CalendarEvent<T> event) {
///     final id = _generateId();
///     event.id = id;
///     _events[id] = event;
///     _indexEventByDates(event);
///     return id;
///   }
///
///   // ... other implementations
/// }
/// ```
abstract class EventStore<T> {
  /// All events currently stored in this [EventStore].
  ///
  /// This provides read-only access to the complete collection of events.
  /// The order of events in this iterable is implementation-dependent.
  Iterable<CalendarEvent<T>> get events;

  /// Predefined locations that will be cached for performance optimization.
  ///
  /// If you know the locations (timezones) that will be frequently used,
  /// provide them here to improve query performance. This allows the
  /// implementation to pre-compute location-specific indexes.
  List<Location> get locations;

  /// Retrieves a [CalendarEvent] by its unique identifier.
  ///
  /// Returns `null` if no event with the given [id] exists.
  ///
  /// Example:
  /// ```dart
  /// final event = eventStore.byId(123);
  /// if (event != null) {
  ///   print('Found event: ${event.data}');
  /// }
  /// ```
  CalendarEvent<T>? byId(int id);

  /// Adds a new [event] to the store and assigns it a unique ID.
  ///
  /// The event's ID will be automatically set by this method.
  /// Returns the assigned ID for future reference.
  ///
  /// Example:
  /// ```dart
  /// final event = CalendarEvent(dateTimeRange: someRange, data: myData);
  /// final eventId = eventStore.addNewEvent(event);
  /// print('Event added with ID: $eventId');
  /// ```
  int addNewEvent(CalendarEvent<T> event);

  /// Updates an existing [event] with new data from [updatedEvent].
  ///
  /// The [event] parameter should be the current event instance, and
  /// [updatedEvent] contains the new data. The event ID will be preserved.
  ///
  /// Throws if the original [event] is not found in the store.
  void updateEvent(CalendarEvent<T> event, CalendarEvent<T> updatedEvent);

  /// Removes a single [event] from the store.
  ///
  /// If the event is not found, this method has no effect.
  void removeEvent(CalendarEvent<T> event);

  /// Removes multiple [events] from the store in a single operation.
  void removeEvents(List<CalendarEvent<T>> events);

  /// Removes an event by its unique [id].
  ///
  /// If no event with the given ID exists, this method has no effect.
  void removeById(int id);

  /// Removes all events where the [test] function returns true.
  ///
  /// The [test] function receives the event ID and the event itself.
  ///
  /// Example:
  /// ```dart
  /// // Remove all events with null data
  /// eventStore.removeWhere((id, event) => event.data == null);
  /// ```
  void removeWhere(bool Function(int key, CalendarEvent<T> element) test);

  /// Removes all events from the store.
  ///
  /// After calling this method, [events] will be empty.
  void clear();

  /// Retrieves the IDs of events that occur during the specified [dateTimeRange].
  ///
  /// This is the core query method that enables efficient date-based event lookup.
  ///
  /// Parameters:
  /// - [dateTimeRange]: The time period to search within (should be in UTC)
  /// - [location]: Optional timezone for location-specific filtering
  ///
  /// Returns a [Set] of event IDs that can be used with [byId] to retrieve
  /// the actual event objects.
  ///
  /// Example:
  /// ```dart
  /// final range = DateTimeRange(
  ///   start: DateTime.utc(2024, 1, 1),
  ///   end: DateTime.utc(2024, 1, 7),
  /// );
  /// final eventIds = eventStore.eventIdsFromDateTimeRange(range, myLocation);
  /// final events = eventIds.map((id) => eventStore.byId(id)).nonNulls;
  /// ```
  Set<int> eventIdsFromDateTimeRange(DateTimeRange dateTimeRange, Location? location);
}
