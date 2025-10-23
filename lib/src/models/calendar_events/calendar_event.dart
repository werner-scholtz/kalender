import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart' show EventInteraction;
import 'package:kalender/kalender_extensions.dart';
import 'package:timezone/timezone.dart';

/// TODO: consider a abstract class for CalendarEvent that needs to be implemented by users.
///
/// A class representing a object that can be displayed by the calendar.
///
/// A calendar event requires a [DateTimeRange] this is used by the [CalendarView] to render the event.
///
/// Any calculations done with the [_dateTimeRange] should be done in utc time and then converted back to local time.
class CalendarEvent<T extends Object?> {
  /// The data of the [CalendarEvent].
  final T? data;

  /// The start of the event as provided.
  final DateTime start;

  /// The end of the event as provided.
  final DateTime end;

  /// Whether this [CalendarEvent] can be modified.
  /// *This will be deprecated in the future.
  /// TODO: Depricate this in 1.0.0
  final bool canModify;

  /// The interaction for the [CalendarEvent].
  ///
  /// * This will override the behavior from [canModify] property.
  final EventInteraction interaction;

  /// The display range of the [CalendarEvent].
  final DisplayDateTimeRange displayDateTimeRange;

  /// The id of the [CalendarEvent].
  /// Do not set this value manually as this is set by the [EventsController].
  int _id = -1;
  int get id => _id;
  set id(int value) {
    if (_id != -1) return;
    _id = value;
  }

  CalendarEvent({
    required DateTimeRange dateTimeRange,
    this.data,
    this.canModify = true,
    EventInteraction? interaction,
  })  : start = dateTimeRange.start,
        end = dateTimeRange.end,
        displayDateTimeRange = DisplayDateTimeRange.from(start: dateTimeRange.start, end: dateTimeRange.end),
        interaction =
            interaction ?? (canModify ? const EventInteraction.allowAll() : const EventInteraction.allowNone());

  /// The [DateTimeRange] of the [CalendarEvent] as provided.
  DateTimeRange get dateTimeRange => DateTimeRange(start: start, end: end);

  DateTimeRange dateTimeRangeAsUtc([Location? location]) => displayDateTimeRange.toLocal(location).asUtc;
  DateTime startAsUtc([Location? location]) => displayDateTimeRange.startToLocal(location).asUtc;
  DateTime endAsUtc([Location? location]) => displayDateTimeRange.endToLocal(location).asUtc;

  /// The total duration of the [CalendarEvent] this uses utc time for the calculation.
  Duration get duration => displayDateTimeRange.duration;

  /// Whether the [CalendarEvent] is longer than a day.
  bool get isMultiDayEvent => duration.inDays > 0;

  /// The [DateTime]s that the [CalendarEvent] spans. This uses utc time.
  List<DateTime> datesSpanned(Location? location) => displayDateTimeRange.toLocal(location).asUtc.dates();

  /// Copy the [CalendarEvent] with the new values.
  CalendarEvent<T> copyWith({
    DateTimeRange? dateTimeRange,
    T? data,
    bool? canModify,
    EventInteraction? interaction,
  }) {
    return CalendarEvent<T>(
      data: data ?? this.data,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      canModify: canModify ?? this.canModify,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  String toString() {
    return 'CalendarEvent<$T> ($id):'
        '\nDisplayRange:  $displayDateTimeRange'
        '\ndata: ${data.toString()}';
  }

  /// Check if the [CalendarEvent] is equal to another [CalendarEvent].
  @override
  bool operator ==(Object other) {
    return other is CalendarEvent<T> &&
        other.id == id &&
        other.start == start &&
        other.end == end &&
        other.data == data &&
        other.canModify == canModify &&
        other.interaction == interaction;
  }

  @override
  int get hashCode => Object.hash(id, start, end, data, canModify, interaction);
}

/// A specialized [DateTimeRange] that ensures both start and end times are stored in UTC.
///
/// This class extends [DateTimeRange] and enforces that all date times are in UTC format.
/// It provides utilities for working with time zones and converting between local and UTC times.
///
/// Example:
/// ```dart
/// final range = DisplayDateTimeRange(
///   start: DateTime.utc(2024, 1, 1),
///   end: DateTime.utc(2024, 1, 2),
/// );
/// ```
///
/// Use [DisplayDateTimeRange.from] to create an instance from non-UTC date times,
/// which will automatically convert them to UTC while preserving the exact moment in time.
class DisplayDateTimeRange extends DateTimeRange {
  DisplayDateTimeRange({
    required super.start,
    required super.end,
  }) : assert(start.isUtc && end.isUtc, 'Start and end date must be in UTC');

  DisplayDateTimeRange.from({
    required DateTime start,
    required DateTime end,
  }) : this(
          start: DateTime.fromMicrosecondsSinceEpoch(start.microsecondsSinceEpoch, isUtc: true),
          end: DateTime.fromMicrosecondsSinceEpoch(end.microsecondsSinceEpoch, isUtc: true),
        );

  /// The total duration of the [DisplayDateTimeRange].
  ///
  /// Because [start] and [end] are required to be in UTC, this calculation is safe.
  @override
  Duration get duration => end.difference(start);

  /// TODO: Improve the documentation for the following methods. also add to string and equality.

  /// Converts the [DisplayDateTimeRange] to a [DateTimeRange] in local time for the specified [location].
  DateTimeRange toLocal(Location? location) {
    if (location == null) {
      return DateTimeRange(start: start.toLocal(), end: end.toLocal());
    } else {
      final localStart = TZDateTime.from(start, location);
      final localEnd = TZDateTime.from(end, location);
      return DateTimeRange(start: localStart, end: localEnd);
    }
  }

  /// Converts the start time to local time for the specified [location].
  DateTime startToLocal(Location? location) {
    if (location == null) {
      return start.toLocal();
    } else {
      final localStart = TZDateTime.from(start, location);
      return localStart;
    }
  }

  /// Converts the end time to local time for the specified [location].
  DateTime endToLocal(Location? location) {
    if (location == null) {
      return end.toLocal();
    } else {
      final localEnd = TZDateTime.from(end, location);
      return localEnd;
    }
  }
}
