import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

mixin NewDraggableWidget<T extends Object?> {
  /// Calculate the initial dateTimeRange of a new event.
  ///
  /// [date] is the date the draggable is located at.
  /// [localPosition] is the last known position of the cursor.
  DateTimeRange calculateDateTimeRange(DateTime date, Offset localPosition, BuildContext context);

  /// Create a TapDetail for the new event.
  ///
  /// [range] is the dateTimeRange of the new event.
  /// [localPosition] is the last known position of the cursor.
  TapDetail createTapDetail(BuildContext context, DateTimeRange range, Offset localPosition);

  /// Create the new event and select it where needed.
  void createNewEvent(
    BuildContext context,
    DateTime date,
    Offset localPosition,
    CalendarCallbacks<T>? callbacks,
    CalendarController<T> controller,
  ) {
    final dateTimeRange = calculateDateTimeRange(date, localPosition, context);
    final newEvent = CalendarEvent<T>(dateTimeRange: dateTimeRange.asLocal);

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
  void onDragFinished(CalendarController<T> controller, [_, __]) => controller.clearNewEvent();
}
