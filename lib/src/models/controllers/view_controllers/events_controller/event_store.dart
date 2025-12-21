import 'package:kalender/kalender.dart';

/// A class that maps [CalendarEvent]s to dates.
///
/// This class is used to store [CalendarEvent]s and retrieve them based on the date.
abstract class EventStore {
  Iterable<CalendarEvent> get events;

  /// Retrieve a [CalendarEvent] by it's id if it exists.
  CalendarEvent? byId(int id);

  /// Add a new [event] to the map.
  int addNewEvent(CalendarEvent event);

  /// Update an [event] in the map with the [updatedEvent].
  void updateEvent(CalendarEvent event, CalendarEvent updatedEvent);

  /// Remove the [event].
  void removeEvent(CalendarEvent event);

  void removeEvents(List<CalendarEvent> events);

  /// Remove an event by its id.
  void removeById(int id);

  /// Remove events where where [test] returns true.
  void removeWhere(bool Function(int key, CalendarEvent element) test);

  /// Clear all events.
  void clear();

  /// Retrieves the IDs of events that occur during the specified [dateTimeRange].
  ///
  /// Parameters:
  /// - [dateTimeRange]: The internal date time range to search for events.
  /// - [location]: The location for which to retrieve the event IDs.
  Set<int> eventIdsFromDateTimeRange(InternalDateTimeRange dateTimeRange, Location? location);
}