import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';

class Reschedule<T extends Object?> {
  /// The [CalendarEvent] that is being rescheduled.
  final CalendarEvent<T> event;

  Reschedule({required this.event});
}

class Resize<T extends Object?> {
  /// The [CalendarEvent] that is being resized.
  final CalendarEvent<T> event;

  /// The direction that the [CalendarEvent] is being resized in.
  final ResizeDirection direction;

  Resize({
    required this.event,
    required this.direction,
  });

  bool get verticalResize => direction.vertical;
  bool get horizontalResize => direction.horizontal;

  /// Updates the [Resize]'s [CalendarEvent] with the new [DateTimeRange].
  Resize<T> updateDateTimeRange(
    DateTimeRange dateTimeRange,
  ) {
    final updatedEvent = event.copyWith(dateTimeRange: dateTimeRange);
    return Resize<T>(event: updatedEvent, direction: direction);
  }
}

class Create {
  /// The id of the controller that is creating this event.
  final int controllerId;

  Create({required this.controllerId});
}
