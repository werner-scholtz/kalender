import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';

/// A wrapper class for a [CalendarEvent] that is being resized.
class ResizeEvent<T> {
  /// The [CalendarEvent] that is being resized.
  final CalendarEvent<T> event;

  /// The direction that the [CalendarEvent] is being resized in.
  final ResizeDirection direction;

  /// Creates a [ResizeEvent] with the given [CalendarEvent] and [ResizeDirection].
  ResizeEvent(this.event, this.direction);

  /// Updates the [ResizeEvent]'s [CalendarEvent] with the new [DateTimeRange].
  ResizeEvent<T> updateDateTimeRange(
    DateTimeRange dateTimeRange,
  ) {
    final updatedEvent = event.copyWith(dateTimeRange: dateTimeRange.asLocal);
    return ResizeEvent<T>(updatedEvent, direction);
  }
}
