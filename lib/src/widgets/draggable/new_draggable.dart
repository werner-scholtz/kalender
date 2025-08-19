import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

mixin NewDraggableWidget<T extends Object?> {
  CalendarController<T> get controller;
  CalendarCallbacks<T>? get callbacks;

  /// Calculate the DateTimeRange of the new event.
  DateTimeRange calculateDateTimeRange(DateTime date, Offset localPosition);

  /// Create the new event and select it where needed.
  void createNewEvent(DateTime date, Offset localPosition) {
    final dateTimeRange = calculateDateTimeRange(date, localPosition);
    final newEvent = CalendarEvent<T>(dateTimeRange: dateTimeRange.asLocal);
    final event = callbacks?.onEventCreate?.call(newEvent) ?? newEvent;

    controller.setNewEvent(event);
    controller.selectEvent(event);
  }

  /// Deselect the new event.
  // ignore: strict_top_level_inference
  void onDragFinished([_, __]) => controller.clearNewEvent();
}
