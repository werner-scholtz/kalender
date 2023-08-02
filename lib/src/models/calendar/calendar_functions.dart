import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// The [CalendarFunctions] class contains the functions that are called when:
///  * an event is changed, tapped, or created
///  * when a date is tapped.
class CalendarFunctions<T extends Object?> {
  const CalendarFunctions({
    this.onEventChanged,
    this.onEventTapped,
    this.onCreateEvent,
    this.onDateTapped,
  });

  /// The [Function] called when the event is changed.
  final Future<void> Function(DateTimeRange initialDateTimeRange, CalendarEvent<T> event)?
      onEventChanged;

  /// The [Function] called when the event is tapped.
  final Future<void> Function(CalendarEvent<T> event)? onEventTapped;

  /// The [Function] called when an event is created.
  final Future<CalendarEvent<T>?> Function(CalendarEvent<T> newEvent)? onCreateEvent;

  /// The [Function] called when the event is tapped.
  final Function(DateTime date)? onDateTapped;

  @override
  operator ==(Object other) {
    return other is CalendarFunctions &&
        other.onEventChanged == onEventChanged &&
        other.onEventTapped == onEventTapped &&
        other.onCreateEvent == onCreateEvent &&
        other.onDateTapped == onDateTapped;
  }

  @override
  int get hashCode => Object.hash(
        onEventChanged,
        onEventTapped,
        onCreateEvent,
        onDateTapped,
      );
}
