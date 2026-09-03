import 'package:kalender/kalender.dart';

/// A class that maps [KalenderEvent]s to dates.
///
/// This class is used to store [KalenderEvent]s and retrieve them based on the date.
abstract class EventStore {
  /// A iterable of all [KalenderEvent]s in the store.
  Iterable<KalenderEvent> get events;

  /// Retrieve a [KalenderEvent] by it's id if it exists.
  KalenderEvent? byId(String id);

  /// Add a new [event] to the map.
  String addNewEvent(KalenderEvent event);

  /// Update an [event] in the map with the [updatedEvent].
  void updateEvent(KalenderEvent event, KalenderEvent updatedEvent);

  /// Remove the [event].
  void removeEvent(KalenderEvent event);

  /// Remove a list of [KalenderEvent]s.
  void removeEvents(List<KalenderEvent> events);

  /// Remove an event by its id.
  void removeById(String id);

  /// Remove events where where [test] returns true.
  void removeWhere(bool Function(String key, KalenderEvent element) test);

  /// Clear all events.
  void clear();

  /// Retrieves the IDs of events that occur during the specified [dateTimeRange].
  ///
  /// Parameters:
  /// - [dateTimeRange]: The internal date time range to search for events.
  /// - [location]: The location for which to retrieve the event IDs.
  Set<String> eventIdsFromDateTimeRange(InternalDateTimeRange dateTimeRange, Location? location);
}
