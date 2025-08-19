import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The callbacks used by the [CalendarView].
///
/// - These callbacks are used to notify the parent widget of events that occur in the [CalendarView].
class CalendarCallbacks<T extends Object?> {
  /// The callback for when an event is tapped.
  ///
  /// If you provide neither [onEventTapped] nor [onEventTappedWithDetail],
  /// Then the [GestureDetector] will not be enabled, and you can use your own gesture detector for event tiles.
  /// /// See TODO: add link to event mixins.
  final OnEventTapped<T>? onEventTapped;

  /// The callback for when an event is tapped, with details.
  ///
  /// If you provide neither [onEventTapped] nor [onEventTappedWithDetail],
  /// Then the [GestureDetector] will not be enabled, and you can use your own gesture detector for event tiles.
  /// /// See TODO: add link to event mixins.
  final OnEventTappedWithDetail<T>? onEventTappedWithDetail;

  /// The callback for when an event is about to be created.
  ///
  /// This is used by a [Draggable] or [LongPressDraggable] to create a new event.
  final OnEventCreate<T>? onEventCreate;

  /// The callback for when an event is created.
  ///
  /// This is used by a [DragTarget] to notify that a new event has been created.
  final OnEventCreated<T>? onEventCreated;

  /// The callback for when an event is about to be changed.
  ///
  /// This is used by a [Draggable] or [LongPressDraggable] to notify that an event is about to be changed.
  final OnEventChange<T>? onEventChange;

  /// The callback for when an event is changed.
  ///
  /// This is used by a [DragTarget] to notify that an event has been changed.
  final OnEventChanged<T>? onEventChanged;

  /// The callback for when the calendar page is changed.
  final OnPageChanged? onPageChanged;

  /// TODO: Check how these interact with the [Draggable] and [LongPressDraggable]s.

  /// The callback for when a user taps on the calendar.
  final OnTapped? onTapped;

  /// The callback for when a user taps on the calendar with details.
  ///
  /// The details can be a [DayDetail] or a [MultiDayDetail], depending on the calendar view.
  final OnTappedWithDetails? onTappedWithDetails;

  /// The callback for when a user long presses on the calendar.
  final OnLongPressed? onLongPressed;

  /// The callback for when a user long presses on the calendar with details.
  ///
  /// The details can be a [DayDetail] or a [MultiDayDetail], depending on the calendar view.
  final OnLongPressedWithDetails? onLongPressedWithDetails;

  /// The callback for when a user taps on a multi-day calendar.
  @Deprecated('Use onTapped or onLongPressed instead.')
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
    this.onTappedWithDetails,
    this.onLongPressed,
    this.onLongPressedWithDetails,
    this.onMultiDayTapped,
  });

  bool get hasOnEventTapped => onEventTapped != null || onEventTappedWithDetail != null;
  bool get hasOnLongPressed => onLongPressed != null || onLongPressedWithDetails != null;
  bool get hasOnTapped => onTapped != null || onTappedWithDetails != null;

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
      onTappedWithDetails: onTappedWithDetails ?? this.onTappedWithDetails,
      onLongPressed: onLongPressed ?? this.onLongPressed,
      onLongPressedWithDetails: onLongPressedWithDetails ?? this.onLongPressedWithDetails,
      // ignore: deprecated_member_use_from_same_package
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

/// The callback for when a user taps on an empty space in the calendar.
///
/// [date] is the DateTime that was tapped.
/// If you need more details, use [CalendarCallbacks.onTappedWithDetails].
typedef OnTapped = void Function(DateTime date);

/// The callback for when a user taps on an empty space in the calendar with details.
///
/// [details] is the details of the date that was tapped.
/// - The [details] can be a [DayDetail] or a [MultiDayDetail].
typedef OnTappedWithDetails = void Function(TapDetail details);

/// The callback for when a user long presses on an empty space in the calendar.
///
/// [date] is the DateTime that was long pressed.
/// If you need more details, use [CalendarCallbacks.onLongPressedWithDetails].
typedef OnLongPressed = void Function(DateTime date);

/// The callback for when a user long presses on an empty space in the calendar with details.
///
/// [details] is the details of the date that was long pressed.
/// - The [details] can be a [DayDetail] or a [MultiDayDetail].
typedef OnLongPressedWithDetails = void Function(TapDetail details);

abstract class TapDetail {
  const TapDetail();

  /// Returns true if the detail is a [DayDetail].
  bool get isDayDetail => this is DayDetail;

  /// Returns true if the detail is a [MultiDayDetail].
  bool get isMultiDayDetail => this is MultiDayDetail;
}

/// The detail for when the calendar is tapped.
class DayDetail extends TapDetail {
  /// The date that was tapped.
  final DateTime date;

  /// Creates a new [DayDetail] with the given date.
  const DayDetail(this.date);
}

/// The detail for when a multi-day range is tapped.
class MultiDayDetail extends TapDetail {
  /// The date range that was tapped.
  final DateTimeRange dateTimeRange;

  /// Creates a new [MultiDayDetail] with the given date range.
  const MultiDayDetail(this.dateTimeRange);
}

/// TODO: Depricate in 1.0.0
/// The callback for when a user taps on an empty space in a multi-day calendar.
///
/// [dateRange] is the range of dates that was tapped.
typedef OnMultiDayTapped = void Function(DateTimeRange dateRange);
