import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart' show EventInteraction;
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';

/// TODO: Re-Document xD.

/// A calendar event that can be displayed and managed by calendar views.
///
/// A [CalendarEvent] represents a time-based item with optional associated data
/// that can be rendered in calendar interfaces. Each event has a defined time
/// range and supports various interaction modes for user operations.
///
/// ```dart
/// // Simple event
/// final meeting = CalendarEvent<String>(
///   dateTimeRange: DateTimeRange(
///     start: DateTime(2024, 1, 15, 14, 0),
///     end: DateTime(2024, 1, 15, 15, 0),
///   ),
///   data: 'Team Meeting',
/// );
///
/// // Multi-day event with custom interaction
/// final conference = CalendarEvent<Conference>(
///   dateTimeRange: DateTimeRange(
///     start: DateTime(2024, 3, 1),
///     end: DateTime(2024, 3, 3),
///   ),
///   data: Conference('Flutter Forward'),
///   interaction: EventInteraction.allowResize(),
/// );
/// ```
///
/// All time calculations are performed in UTC internally for consistency.
/// Use the timezone-aware methods for location-specific operations:
///
/// ```dart
/// final nyLocation = getLocation('America/New_York');
///
/// // Get UTC time range
/// final utcRange = event.dateTimeRangeAsUtc(nyLocation);
///
/// // Get dates the event spans in a specific timezone
/// final spannedDates = event.datesSpanned(nyLocation);
/// ```
///
/// ## Event Identification
///
/// Events are automatically assigned unique IDs by the [EventsController].
/// Do not manually set the [id] property as it's managed internally.
///
/// See also:
/// - [EventsController] for managing collections of events
/// - [EventInteraction] for configuring user interaction permissions
class CalendarEvent<T extends Object?> {
  /// The optional data associated with this event.
  ///
  /// This can be any object type and is typically used to store
  /// application-specific information about the event such as
  /// titles, descriptions, or complex domain objects.
  ///
  /// Example:
  /// ```dart
  /// final event = CalendarEvent<Meeting>(
  ///   data: Meeting(title: 'Stand-up', attendees: ['Alice', 'Bob']),
  ///   dateTimeRange: someRange,
  /// );
  /// ```
  final T? data;

  /// Whether this event can be modified through user interactions.
  ///
  /// **Deprecated**: Use [interaction] property instead for more granular control.
  /// This property will be removed in version 1.0.0.
  ///
  /// When `true`, allows all modifications. When `false`, prevents all modifications.
  @Deprecated('Use interaction property instead. Will be removed in 1.0.0')
  final bool canModify;

  /// Defines what user interactions are allowed for this event.
  ///
  /// This property controls whether users can drag, resize, or otherwise
  /// modify the event in calendar views. It provides more granular control
  // ignore: deprecated_member_use_from_same_package
  /// than the deprecated [canModify] property.
  ///
  /// Example:
  /// ```dart
  /// // Allow all interactions
  /// EventInteraction.allowAll()
  ///
  /// // Allow only dragging, no resizing
  /// EventInteraction.allowDrag()
  ///
  /// // Read-only event
  /// EventInteraction.allowNone()
  /// ```
  final EventInteraction interaction;

  /// The internal time range representation stored in UTC.
  final DateTimeRange utcDateTimeRange;

  /// The unique identifier for this event.
  ///
  /// This is automatically assigned by the [EventsController] when the event
  /// is added. The initial value of -1 indicates an unassigned event.
  ///
  /// **Important**: Do not set this value manually. It's managed internally
  /// by the event storage system.
  int _id = -1;

  /// Gets the unique identifier for this event.
  ///
  /// Returns -1 if the event hasn't been added to a controller yet.
  int get id => _id;

  /// Sets the unique identifier for this event.
  ///
  /// This can only be set once by the event storage system. Subsequent
  /// attempts to change the ID are ignored to maintain data integrity.
  set id(int value) {
    if (_id != -1) return;
    _id = value;
  }

  /// Creates a new calendar event with the specified time range and optional data.
  ///
  /// The [dateTimeRange] defines when the event occurs and is required.
  /// All other parameters are optional and have sensible defaults.
  ///
  /// Parameters:
  /// - [dateTimeRange]: The time period when this event occurs
  /// - [data]: Optional application-specific data to associate with the event
  /// - [canModify]: Deprecated. Whether the event can be modified (defaults to true)
  /// - [interaction]: Controls what user interactions are allowed (defaults based on canModify)
  CalendarEvent({
    required DateTimeRange dateTimeRange,
    this.data,
    this.canModify = true,
    EventInteraction? interaction,
  })  : utcDateTimeRange = dateTimeRange.toUtc(),
        interaction =
            interaction ?? (canModify ? const EventInteraction.allowAll() : const EventInteraction.allowNone());

  DateTime get start => utcDateTimeRange.start;
  DateTime get end => utcDateTimeRange.end;
  Duration get duration => utcDateTimeRange.duration;

  /// TODO: Check if this makes sense logically, especially when dst comes into play.
  /// Whether this event spans more than one calendar day.
  ///
  /// Returns `true` if the event duration is greater than 24 hours.
  /// This is useful for rendering logic that needs to handle multi-day
  /// events differently from single-day events.
  bool get isMultiDayEvent => duration.inDays > 0;

  CalendarEvent<T> copyWith({
    DateTimeRange? dateTimeRange,
    T? data,
    bool? canModify,
    EventInteraction? interaction,
  }) {
    return CalendarEvent<T>(
      data: data ?? this.data,
      dateTimeRange: dateTimeRange ?? this.utcDateTimeRange,
      // ignore: deprecated_member_use_from_same_package
      canModify: canModify ?? this.canModify,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  String toString() {
    return 'CalendarEvent<$T> ($id):'
        '\nDisplayRange:  $utcDateTimeRange'
        '\ndata: ${data.toString()}';
  }

  /// Determines whether this event is equal to another [CalendarEvent].
  ///
  /// Two events are considered equal if they have the same ID, time range,
  /// data, and interaction properties. This is used for efficient updates
  /// and duplicate detection in collections.
  @override
  bool operator ==(Object other) {
    return other is CalendarEvent<T> &&
        other.id == id &&
        other.utcDateTimeRange == utcDateTimeRange &&
        other.data == data &&
        // ignore: deprecated_member_use_from_same_package
        other.canModify == canModify &&
        other.interaction == interaction;
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  int get hashCode => Object.hash(id, utcDateTimeRange, data, canModify, interaction);
}
