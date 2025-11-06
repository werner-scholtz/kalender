import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/controllers/view_controllers/events_controller/default_date_map.dart';
import 'package:timezone/timezone.dart';

/// The default [EventsController] for managing [CalendarEvent]s.
class DefaultEventsController<T extends Object?> extends EventsController<T> {
  @override
  final List<Location> locations;

  /// Creates a [DefaultEventsController].
  DefaultEventsController({this.locations = const []});

  @override
  late final dateMap = DefaultDateMap<T>(locations: locations);

  @override
  Iterable<CalendarEvent<T>> get events => dateMap.events;
}
