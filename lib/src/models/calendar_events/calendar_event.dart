import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_events/base_event.dart';

/// A class representing an event with additional data and modifiable behavior.
class CalendarEvent<T extends Object?> extends BaseEvent<T> {
  /// Additional data for the [CalendarEvent].
  final T? data;

  /// Whether this [CalendarEvent] can be modified.
  final bool canModify;

  CalendarEvent({
    required DateTimeRange dateTimeRange,
    this.data,
    this.canModify = true,
  }) : super(dateTimeRange: dateTimeRange);

  /// Copy the [CalendarEvent] with the new values.
  @override
  CalendarEvent<T> copyWith({
    DateTimeRange? dateTimeRange,
    T? data,
    bool? canModify,
  }) {
    return CalendarEvent<T>(
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      data: data ?? this.data,
      canModify: canModify ?? this.canModify,
    );
  }

  @override
  String toString() {
    return 'id: $id, data: $data, start: $start, end: $end, canModify: $canModify';
  }
}
