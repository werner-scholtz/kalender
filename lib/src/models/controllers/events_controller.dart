import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/controllers/events_controller/default_events_controller.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/kalender_events/multi_day_rule.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// The [EventsController] is used to manage [KalenderEvent]s.
///
/// This class can be extended to create custom [EventsController]s.
/// e.g. [DefaultEventsController]
abstract class EventsController with ChangeNotifier {
  /// A ValueNotifier that holds the size of the feedback widget.
  final feedbackWidgetSize = ValueNotifier<Size>(Size.zero);

  /// The list of [KalenderEvent]s.
  Iterable<KalenderEvent> get events;

  /// Adds an [KalenderEvent] to the [EventsController].
  ///
  /// Returns the id assigned to the event.
  String addEvent(KalenderEvent event);

  /// Adds a list of [KalenderEvent]s to the [EventsController].
  ///
  /// Returns the id's assigned to the events in order.
  List<String> addEvents(List<KalenderEvent> events);

  /// Removes an [KalenderEvent] from the list of [KalenderEvent]s.
  void removeEvent(KalenderEvent event);

  /// Remove a list of [KalenderEvent] from the controller.
  void removeEvents(List<KalenderEvent> events);

  /// Remove an [KalenderEvent] with its id.
  void removeById(String id);

  /// Removes a list of [KalenderEvent]s from the list of [KalenderEvent]s.
  ///
  /// The events will be removed where [test] returns true.
  void removeWhere(bool Function(String key, KalenderEvent element) test);

  /// Removes all [KalenderEvent]s from the controller.
  void clearEvents();

  /// Replaces all [KalenderEvent]s with [events] in a single update.
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
  List<String> replaceEvents(List<KalenderEvent> events) {
    clearEvents();
    return addEvents(events);
  }

  /// Updates an [KalenderEvent].
  ///
  /// The [event] is the event that needs to be changed.
  /// The [updatedEvent] is the event that will replace the [event].
  void updateEvent({
    required KalenderEvent event,
    required KalenderEvent updatedEvent,
  });

  /// Retrieve a [KalenderEvent] by it's id if it exists.
  KalenderEvent? byId(String id);

  /// Finds the [KalenderEvent]s that occur during the [dateTimeRange].
  ///
  /// The [dateTimeRange] is the range of dates to search for events.
  /// The [includeMultiDayEvents] determines if events spanning multiple days should be included.
  /// The [includeDayEvents] determines if events that are shorter than 1 day should be included.
  /// The [location] is the calendar's timezone, used to place day boundaries when evaluating [multiDayRule].
  /// Pass the same one the calendar renders with.
  /// [multiDayRule] decides which events count as multi-day. Pass the current
  /// view's [ViewConfiguration.multiDayRule]; an event overriding it with
  /// [KalenderEvent.multiDayRule] takes precedence.
  Iterable<KalenderEvent> eventsFromDateTimeRange(
    InternalDateTimeRange dateTimeRange, {
    required MultiDayRule multiDayRule,
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
    Location? location,
  });
}
