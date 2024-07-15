import 'package:kalender/src/type_definitions.dart';

/// The callbacks used by the [MultiDayBody].
class CalendarCallbacks<T extends Object?> {
  final OnEventTapped<T>? onEventTapped;
  final OnEventChanged<T>? onEventChanged;
  final OnEventCreated? onEventCreated;
  final OnPageChanged? onPageChanged;

  const CalendarCallbacks({
    this.onEventTapped,
    this.onEventChanged,
    this.onEventCreated,
    this.onPageChanged,
  });
}
