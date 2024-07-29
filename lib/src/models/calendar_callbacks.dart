import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/calendar_view.dart';

/// The callbacks used by the [CalendarView].
///
/// - These callbacks are used to notify the parent widget of events that occur in the [CalendarView].
class CalendarCallbacks<T extends Object?> {
  final OnEventTapped<T>? onEventTapped;
  final OnEventChange<T>? onEventChange;
  final OnEventChanged<T>? onEventChanged;
  final OnEventCreate<T>? onEventCreate;
  final OnEventCreated<T>? onEventCreated;
  final OnPageChanged? onPageChanged;

  /// Creates a set of callbacks for the [CalendarView].
  const CalendarCallbacks({
    this.onEventTapped,
    this.onEventChange,
    this.onEventChanged,
    this.onEventCreate,
    this.onEventCreated,
    this.onPageChanged,
  });
}
