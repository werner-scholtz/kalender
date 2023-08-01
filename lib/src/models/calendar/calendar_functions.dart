import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

class CalendarFunctions<T extends Object?> {
  const CalendarFunctions({
    this.onEventChanged,
    this.onEventTapped,
    this.onCreateEvent,
    this.onDateTapped,
  });

  /// The [Function] called when the event is changed.
  final void Function(DateTimeRange initialDateTimeRange, CalendarEvent<T> event)? onEventChanged;

  /// The [Function] called when the event is tapped.
  final void Function(CalendarEvent<T> event)? onEventTapped;

  /// The [Function] called when an event is created.
  final Future<CalendarEvent<T>?> Function(CalendarEvent<T> newEvent)? onCreateEvent;

  /// The [Function] called when the event is tapped.
  final Function(DateTime date)? onDateTapped;
}
