import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

mixin NewDraggableWidget<T extends Object?> {
  CalendarController<T> get controller;
  CalendarCallbacks<T>? get callbacks;

  /// Calculate the initial dateTimeRange of a new event.
  ///
  /// [date] is the date the draggable is located at.
  /// [localPosition] is the last known position of the cursor.
  InternalDateTimeRange calculateDateTimeRange(InternalDateTime date, Offset localPosition);

  /// Create a TapDetail for the new event.
  ///
  /// [range] is the dateTimeRange of the new event.
  /// [localPosition] is the last known position of the cursor.
  TapDetail createTapDetail(BuildContext context, InternalDateTimeRange range, Offset localPosition);

  /// Create the new event and select it where needed.
  void createNewEvent(BuildContext context, InternalDateTime date, Offset localPosition) {
    final dateTimeRange = calculateDateTimeRange(date, localPosition);
    final newEvent = CalendarEvent<T>(dateTimeRange: dateTimeRange.forLocation(location: context.location));

    CalendarEvent<T>? event;
    if (callbacks?.onEventCreateWithDetail != null) {
      final detail = createTapDetail(context, dateTimeRange, localPosition);
      event = callbacks?.onEventCreateWithDetail?.call(newEvent, detail);
    } else if (callbacks?.onEventCreate != null) {
      event = callbacks?.onEventCreate?.call(newEvent);
    }

    event ??= newEvent;
    controller.setNewEvent(event);
    controller.selectEvent(event);
  }

  /// Deselect the new event.
  // ignore: strict_top_level_inference
  void onDragFinished([_, __]) => controller.clearNewEvent();
}
