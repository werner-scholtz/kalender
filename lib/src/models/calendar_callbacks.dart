import 'package:kalender/src/type_definitions.dart';

/// The callbacks used by the [MultiDayBody].
class CalendarCallbacks<T extends Object?> {
  final OnEventTapped<T>? onEventTapped;
  final OnEventChanged<T>? onEventChanged;
  final OnEventCreate<T>? onEventCreate;
  final OnEventCreated<T>? onEventCreated;
  final OnPageChanged? onPageChanged;

  const CalendarCallbacks({
    this.onEventTapped,
    this.onEventChanged,
    this.onEventCreate,
    this.onEventCreated,
    this.onPageChanged,
  });
}
