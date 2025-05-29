import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The callbacks used by the [CalendarView].
///
/// - These callbacks are used to notify the parent widget of events that occur in the [CalendarView].
class CalendarCallbacks<T extends Object?> {
  /// The callback for when an event is tapped.
  ///
  /// * Note: both [onEventTapped] and [onEventTappedWithDetail] are called when an event is tapped.
  final OnEventTapped<T>? onEventTapped;

  /// The callback for when an event is tapped, with a list of touching events.
  ///
  /// * Note: both [onEventTapped] and [onEventTappedWithDetail] are called when an event is tapped.
  final OnEventTappedWithDetail<T>? onEventTappedWithDetail;

  /// The callback for when an event is about to be created.
  final OnEventCreate<T>? onEventCreate;

  /// The callback for when an event is created.
  final OnEventCreated<T>? onEventCreated;

  /// The callback for when an event is about to be changed.
  final OnEventChange<T>? onEventChange;

  /// The callback for when an event is changed.
  final OnEventChanged<T>? onEventChanged;

  /// The callback for when the calendar page is changed.
  final OnPageChanged? onPageChanged;

  /// The callback for when a user taps on the calendar.
  final OnTapped? onTapped;

  /// The callback for when a user taps on a multi-day calendar.
  final OnMultiDayTapped? onMultiDayTapped;

  /// Creates a set of callbacks for the [CalendarView].
  const CalendarCallbacks({
    this.onEventTapped,
    this.onEventTappedWithDetail,
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
typedef OnEventTapped<T extends Object?> = void Function(CalendarEvent<T> event, RenderBox renderBox);

/// The callback for when an event is tapped.
///
/// The [event] is the event that was tapped.
/// The [renderBox] is the [RenderBox] of the event tile.
/// The [detail] is the details of the date that was tapped.
/// - The [detail] can be a [DayDetail] or a [MultiDayDetail].
typedef OnEventTappedWithDetail<T extends Object?> = void Function(
  CalendarEvent<T> event,
  RenderBox renderBox,
  TapDetail detail,
);

abstract class TapDetail {
  const TapDetail();
}

class DayDetail extends TapDetail {
  final DateTime date;
  const DayDetail(this.date);
}

class MultiDayDetail extends TapDetail {
  final DateTimeRange dateTimeRange;
  const MultiDayDetail(this.dateTimeRange);
}

/// The callback for when an event is about to be changed.
typedef OnEventChange<T extends Object?> = void Function(CalendarEvent<T> event);

/// The callback for when an event is changed.
///
/// [event] is the original event.
/// [updatedEvent] is the updated event.
typedef OnEventChanged<T extends Object?> = void Function(CalendarEvent<T> event, CalendarEvent<T> updatedEvent);

/// The call back for creating a new event.
///
/// [event] is the event that will be created.
typedef OnEventCreate<T extends Object?> = CalendarEvent<T>? Function(CalendarEvent<T> event);

/// The callback for a new event has been created.
///
/// [event] is the event that was created.
typedef OnEventCreated<T extends Object?> = void Function(CalendarEvent<T> event);

/// The callback for when a calendar page is changed.
///
/// [dateTimeRange] is the range of dates that can be displayed in the new page.
typedef OnPageChanged = void Function(DateTimeRange dateTimeRange);

/// The callback for when a user taps on an empty space in day.
///
/// [date] is the DateTime that was tapped.
typedef OnTapped = void Function(DateTime date);

/// The callback for when a user taps on an empty space in a multi-day calendar.
///
/// [dateRange] is the range of dates that was tapped.
typedef OnMultiDayTapped = void Function(DateTimeRange dateRange);
