import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// The [CalendarEventHandlers] class contains the functions that are called by the calendar view.
///  * an event is changed, tapped, or created
///  * when a date is tapped.
class CalendarEventHandlers<T> {
  const CalendarEventHandlers({
    this.onEventChanged,
    this.onEventTapped,
    // this.onCreateEvent,
    this.onDateTapped,
    this.onEventChangeStart,
    this.onPageChanged,
    this.onCreateEvent,
    this.onEventCreated,
  });

  /// The [Function] called before the event is changed.
  final void Function(CalendarEvent<T> event)? onEventChangeStart;

  /// The [Function] called after the event is changed.
  ///
  /// The [Function] must return a [Future] so the UI can update on completion.
  final Future<void> Function(
    DateTimeRange initialDateTimeRange,
    CalendarEvent<T> event,
  )? onEventChanged;

  /// The [Function] called when the event is tapped.
  ///
  /// The [Function] must return a [Future] so the UI can update on completion.
  final Future<void> Function(
    CalendarEvent<T> event,
  )? onEventTapped;

  /// The [Function] called when a new event can be created.
  ///
  /// * When the user taps an empty space on the calendar.
  /// * When the user initiates a drag event on an empty space (Desktop).
  ///
  /// The event returned by this function is used to create a new event,
  /// in the case of a drag event, the returned event's date time range will be modified accordingly.
  final CalendarEvent<T> Function(
    DateTimeRange initialDateTimeRange,
  )? onCreateEvent;

  /// The [Function] called once the new event has been created.
  ///
  /// The [Function] must return a [Future] so the UI can update on completion.
  final Future<void> Function(
    CalendarEvent<T> newEvent,
  )? onEventCreated;

  /// The [Function] called when the event is tapped.
  final void Function(
    DateTime date,
  )? onDateTapped;

  /// The [Function] called when the page has changed.
  final void Function(
    DateTimeRange visibleDateTimeRange,
  )? onPageChanged;

  @override
  operator ==(Object other) {
    return other is CalendarEventHandlers<T> &&
        other.onEventChanged == onEventChanged &&
        other.onEventTapped == onEventTapped &&
        other.onCreateEvent == onCreateEvent &&
        other.onEventCreated == onEventCreated &&
        other.onDateTapped == onDateTapped;
  }

  @override
  int get hashCode => Object.hash(
        onEventChanged,
        onEventTapped,
        onCreateEvent,
        onEventCreated,
        onDateTapped,
      );
}
