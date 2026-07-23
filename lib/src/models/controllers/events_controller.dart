import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/calendar_events/multi_day_rule.dart';

/// The [EventsController] is used to manage [CalendarEvent]s.
///
/// This class can be extended to create custom [EventsController]s.
/// e.g. [DefaultEventsController]
abstract class EventsController with ChangeNotifier {
  /// A ValueNotifier that holds the size of the feedback widget.
  final feedbackWidgetSize = ValueNotifier<Size>(Size.zero);

  /// The list of [CalendarEvent]s.
  Iterable<CalendarEvent> get events;

  /// Adds an [CalendarEvent] to the [EventsController].
  ///
  /// Returns the id assigned to the event.
  String addEvent(CalendarEvent event);

  /// Adds a list of [CalendarEvent]s to the [EventsController].
  ///
  /// Returns the id's assigned to the events in order.
  List<String> addEvents(List<CalendarEvent> events);

  /// Removes an [CalendarEvent] from the list of [CalendarEvent]s.
  void removeEvent(CalendarEvent event);

  /// Remove a list of [CalendarEvent] from the controller.
  void removeEvents(List<CalendarEvent> events);

  /// Remove an [CalendarEvent] with its id.
  void removeById(String id);

  /// Removes a list of [CalendarEvent]s from the list of [CalendarEvent]s.
  ///
  /// The events will be removed where [test] returns true.
  void removeWhere(bool Function(String key, CalendarEvent element) test);

  /// Removes all [CalendarEvent]s from the controller.
  void clearEvents();

  /// Replaces all [CalendarEvent]s with [events] in a single update.
  ///
  /// Prefer this over [clearEvents] followed by [addEvents] when swapping the
  /// whole set, for example after loading a new source. It avoids the
  /// intermediate empty state and, where the implementation allows, notifies
  /// listeners once instead of twice.
  ///
  /// Returns the id's assigned to the events in order.
  ///
  /// The default implementation clears then adds. Subclasses may override to do
  /// it atomically.
  List<String> replaceEvents(List<CalendarEvent> events) {
    clearEvents();
    return addEvents(events);
  }

  /// Updates an [CalendarEvent].
  ///
  /// The [event] is the event that needs to be changed.
  /// The [updatedEvent] is the event that will replace the [event].
  void updateEvent({
    required CalendarEvent event,
    required CalendarEvent updatedEvent,
  });

  /// Retrieve a [CalendarEvent] by it's id if it exists.
  CalendarEvent? byId(String id);

  /// Finds the [CalendarEvent]s that occur during the [dateTimeRange].
  ///
  /// The [dateTimeRange] is the range of dates to search for events.
  /// The [includeMultiDayEvents] determines if events spanning multiple days should be included.
  /// The [includeDayEvents] determines if events that are shorter than 1 day should be included.
  /// The [location] is the current location TODO
  /// [multiDayRule] decides which events count as multi-day. Pass the current
  /// view's [ViewConfiguration.multiDayRule]; an event overriding it with
  /// [CalendarEvent.multiDayRule] takes precedence.
  Iterable<CalendarEvent> eventsFromDateTimeRange(
    InternalDateTimeRange dateTimeRange, {
    required MultiDayRule multiDayRule,
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
    Location? location,
  });
}
