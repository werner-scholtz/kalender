import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:timezone/timezone.dart';

/// The default [EventsController] for managing [CalendarEvent]s.
///
/// It uses a [DefaultEventStore] to store and retrieve events based on their dates.
class DefaultEventsController<T extends Object?> extends EventsController<T> {
  @override
  final List<Location> locations;

  @override
  final DefaultEventStore<T> eventStore;

  /// Creates a [DefaultEventsController] with optional predefined [locations].
  DefaultEventsController({this.locations = const []}) : eventStore = DefaultEventStore<T>(locations: locations);

  @override
  Iterable<CalendarEvent<T>> get events => eventStore.events;
}
