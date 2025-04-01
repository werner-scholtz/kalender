import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The callbacks used by the [CalendarView].
///
/// - These callbacks are used to notify the parent widget of events that occur in the [CalendarView].
class CalendarCallbacks<T extends Object?> {
  final OnEventTapped<T>? onEventTapped;
  final OnEventCreate<T>? onEventCreate;
  final OnEventCreated<T>? onEventCreated;
  final OnEventChange<T>? onEventChange;
  final OnEventChanged<T>? onEventChanged;
  final OnPageChanged? onPageChanged;
  final OnTapped? onTapped;
  final OnMultiDayTapped? onMultiDayTapped;

  /// Creates a set of callbacks for the [CalendarView].
  const CalendarCallbacks({
    this.onEventTapped,
    this.onEventChange,
    this.onEventChanged,
    this.onEventCreate,
    this.onEventCreated,
    this.onPageChanged,
    this.onTapped,
    this.onMultiDayTapped,
  });

  CalendarCallbacks<T> copyWith({
    OnEventTapped<T>? onEventTapped,
    OnEventCreate<T>? onEventCreate,
    OnEventCreated<T>? onEventCreated,
    OnEventChange<T>? onEventChange,
    OnEventChanged<T>? onEventChanged,
    OnPageChanged? onPageChanged,
    OnTapped? onTapped,
    OnMultiDayTapped? onMultiDayTapped,
  }) {
    return CalendarCallbacks<T>(
      onEventTapped: onEventTapped ?? this.onEventTapped,
      onEventCreate: onEventCreate ?? this.onEventCreate,
      onEventCreated: onEventCreated ?? this.onEventCreated,
      onEventChange: onEventChange ?? this.onEventChange,
      onEventChanged: onEventChanged ?? this.onEventChanged,
      onPageChanged: onPageChanged ?? this.onPageChanged,
      onTapped: onTapped ?? this.onTapped,
      onMultiDayTapped: onMultiDayTapped ?? this.onMultiDayTapped,
    );
  }
}

/// The callback for when an event is tapped.
///
/// The [event] is the event that was tapped.
/// The [renderBox] is the [RenderBox] of the event tile.
typedef OnEventTapped<T extends Object?> = void Function(
  CalendarEvent<T> event,
  RenderBox renderBox,
);

/// The callback for when an event is about to be changed.
typedef OnEventChange<T extends Object?> = void Function(
  CalendarEvent<T> event,
);

/// The callback for when an event is changed.
///
/// [event] is the original event.
/// [updatedEvent] is the updated event.
typedef OnEventChanged<T extends Object?> = void Function(
  CalendarEvent<T> event,
  CalendarEvent<T> updatedEvent,
);

/// The call back for creating a new event.
///
/// [event] is the event that will be created.
typedef OnEventCreate<T extends Object?> = CalendarEvent<T>? Function(
  CalendarEvent<T> event,
);

/// The callback for a new event has been created.
///
/// [event] is the event that was created.
typedef OnEventCreated<T extends Object?> = void Function(
  CalendarEvent<T> event,
);

/// The callback for when a calendar page is changed.
///
/// [visibleDateTimeRange] is the range of dates that are visible.
typedef OnPageChanged = void Function(DateTimeRange visibleDateTimeRange);

/// The callback for when a user taps on the calendar.
///
/// [date] is the DateTime that was tapped.
typedef OnTapped = void Function(DateTime date);

/// The callback for when a user taps on a multi-day calendar.
///
/// [dateRange] is the range of dates that was tapped.
typedef OnMultiDayTapped = void Function(DateTimeRange dateRange);


/// The callback for when a user taps on a expandable multi-day calendar widget.
/// 
/// [date] is the date for which the expand widget is displayed for.
/// [renderBox] is the [RenderBox] of the expand widget.
typedef OnMultiDayExpand = void Function(
  DateTime date,
  RenderBox renderBox,
);