import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_events/base_event.dart';

/// A class representing an time range event with additional data.
class TimeRegionEvent<T extends Object?> extends BaseEvent<T> {
  /// Additional data for the [TimeRegionEvent].
  T? data;

  TimeRegionEvent({
    required DateTimeRange dateTimeRange,
    this.data,
  }) : super(dateTimeRange: dateTimeRange);

  /// Copy the [TimeRegionEvent] with the new values.
  @override
  TimeRegionEvent<T> copyWith({
    DateTimeRange? dateTimeRange,
    T? data,
  }) {
    return TimeRegionEvent<T>(
      data: data,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
    );
  }

  @override
  String toString() {
    return 'id: $id, data: $data, start: $start, end: $end';
  }
}
