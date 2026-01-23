import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A class used by the [DragTargetUtilities] to determine that a [CalendarEvent] is being rescheduled.
class Reschedule {
  /// The [CalendarEvent] that is being rescheduled.
  final CalendarEvent event;

  /// Create a reschedule object from a [CalendarEvent].
  Reschedule({required this.event});
}

/// A class used by the [DragTargetUtilities] to determine that a [CalendarEvent] is being resized.
class Resize {
  /// The [CalendarEvent] that is being resized.
  final CalendarEvent event;

  /// The direction that the [CalendarEvent] is being resized in.
  final ResizeDirection direction;

  /// Create a reschedule object from a [CalendarEvent] and a [ResizeDirection].
  Resize({
    required this.event,
    required this.direction,
  });

  bool get verticalResize => direction.vertical;
  bool get horizontalResize => direction.horizontal;

  /// Updates the [Resize]'s [CalendarEvent] with the new [DateTimeRange].
  Resize updateDateTimeRange(
    DateTimeRange dateTimeRange,
  ) {
    final updatedEvent = event.copyWith(dateTimeRange: dateTimeRange);
    return Resize(event: updatedEvent, direction: direction);
  }
}

/// A class used by the [DragTargetUtilities] to determine that a [CalendarEvent] is being created.
class Create {
  /// The id of the controller that is creating this event.
  final int controllerId;

  Create({required this.controllerId});
}
