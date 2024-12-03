import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';

typedef UpdatedEvent<T> = (CalendarEvent<T>, CalendarEvent<T>);

mixin DragTargetUtilities<T> {
  BuildContext get context;
  CalendarController<T> get controller;
  EventsController<T> get eventsController;
  CalendarCallbacks<T>? get callbacks;
  double get dayWidth;
  List<DateTime> get visibleDates;
  bool get multiDayDragTarget;

  /// A copy of the event being created.
  CalendarEvent<T>? newEvent;

  /// Get the global position of the [DragTarget] widget.
  Offset? get dragTargetPosition {
    // Find the global position of the drop target widget.
    final renderObject = context.findRenderObject()! as RenderBox;
    final globalPosition = renderObject.localToGlobal(Offset.zero);
    return globalPosition;
  }

  /// Get the [DragTarget] widget's [RenderBox].
  RenderBox get dragTargetRenderBox => context.findRenderObject()! as RenderBox;

  /// Handle the [DragTarget.onWillAcceptWithDetails].
  bool onWillAcceptWithDetails(
    DragTargetDetails<Object?> details, {
    required bool Function(CalendarEvent<T> event, ResizeDirection direction) onResize,
    required bool Function(CalendarEvent<T> event) onReschedule,
  }) {
    return _handleDragDetails(
      details,
      onCreate: (controllerId) => controllerId == controller.id,
      onResize: onResize,
      onReschedule: onReschedule,
      onOther: () => false,
    );
  }

  /// Handle the [DragTarget.onMove].
  void onMove(DragTargetDetails<Object?> details) {
    return _handleDragDetails<void>(
      details,
      onCreate: (controllerId) {
        if (controllerId != controllerId) return;

        final date = calculateCursorDateTime(details.offset);
        if (date == null) return;

        final updatedEvent = createEvent(date);
        if (updatedEvent == null) return;

        controller.selectedEvent.value = updatedEvent;
      },
      onResize: (event, direction) {
        final cursorDate = calculateCursorDateTime(details.offset);
        if (cursorDate == null) return;

        final updatedEvent = resizeEvent(event, direction, cursorDate);
        if (updatedEvent == null) return;

        // Update the event being resized.
        controller.updateEvent(updatedEvent, internal: true);
      },
      onReschedule: (event) {
        final cursorDate = calculateCursorDateTime(details.offset);
        if (cursorDate == null) return;

        final rescheduledEvent = rescheduleEvent(event, cursorDate);
        if (rescheduledEvent == null) return;

        // Update the event being dragged.
        controller.updateEvent(rescheduledEvent, internal: true);
      },
      onOther: () {},
    );
  }

  /// Handle the [DragTarget.onAcceptWithDetails].
  void onAcceptWithDetails(DragTargetDetails<Object?> details) {
    final result = _handleDragDetails<UpdatedEvent<T>?>(
      details,
      onCreate: (controllerId) {
        if (controllerId != controllerId) return null;

        final date = calculateCursorDateTime(details.offset);
        if (date == null) return null;

        final updatedEvent = createEvent(date);
        if (updatedEvent == null) return null;

        callbacks?.onEventCreated?.call(updatedEvent);
        newEvent = null;
        controller.deselectEvent();

        return null;
      },
      onResize: (event, direction) {
        final cursorDate = calculateCursorDateTime(details.offset);
        if (cursorDate == null) return null;
        final updatedEvent = resizeEvent(event, direction, cursorDate);
        if (updatedEvent == null) return null;
        return (event, updatedEvent);
      },
      onReschedule: (event) {
        final cursorDate = calculateCursorDateTime(details.offset);
        if (cursorDate == null) return null;
        final updatedEvent = rescheduleEvent(event, cursorDate);
        if (updatedEvent == null) return null;
        return (event, updatedEvent);
      },
      onOther: () => null,
    );

    if (result == null) return;
    final originalEvent = result.$1;
    final updatedEvent = result.$2;

    // Update the event in the events controller.
    eventsController.updateEvent(event: originalEvent, updatedEvent: updatedEvent);
    eventsController.feedbackWidgetSize.value = Size.zero;
    controller.deselectEvent();
    callbacks?.onEventChanged?.call(originalEvent, updatedEvent);
  }

  /// Handle the [DragTarget.onLeave]
  void onLeave(Object? details) {
    controller.deselectEvent();
    newEvent = null;
  }

  /// Reschedule an event.
  CalendarEvent<T>? rescheduleEvent(CalendarEvent<T> event, DateTime cursorDateTime);

  /// Resize an event.
  CalendarEvent<T>? resizeEvent(CalendarEvent<T> event, ResizeDirection direction, DateTime cursorDateTime);

  /// Reschedule an event.
  CalendarEvent<T>? createEvent(DateTime cursorDateTime) {
    newEvent ??= controller.newEvent;
    return newEvent;
  }

  /// Processes the [DragTargetDetails] and handle different types of detail data (reschedule, resize, create, other).
  ///
  /// [onCreate] - handle the [Create] type.
  /// [onResize] - handle the [Resize] type.
  /// [onReschedule] - handle the [Reschedule] type.
  /// [onOther] - handle other types.
  ///
  /// Each handler function returns a value of type [K], which is the result of handling the data.
  K _handleDragDetails<K extends Object?>(
    DragTargetDetails<Object?> details, {
    required K Function(int controllerId) onCreate,
    required K Function(CalendarEvent<T> event, ResizeDirection direction) onResize,
    required K Function(CalendarEvent<T> event) onReschedule,
    required K Function() onOther,
  }) {
    final data = details.data;
    if (data is Create) {
      return onCreate(data.controllerId);
    } else if (data is Resize<T>) {
      return onResize(data.event, data.direction);
    } else if (data is Reschedule<T>) {
      return onReschedule(data.event);
    } else {
      return onOther.call();
    }
  }

  /// Calculate the local position of the cursor for the [DragTarget] widget.
  ///
  /// [cursorPosition] Comes from the [DragTargetDetails.offset].
  /// [scrollOffset] The scroll offset of the current view.
  ///
  /// This calculates the local position of the cursor on the [DragTarget] widget.
  Offset? calculateLocalCursorPosition(
    Offset cursorPosition, {
    Offset scrollOffset = Offset.zero,
  }) {
    final cursorWithFeedbackWidget = cursorPosition + scrollOffset;
    return dragTargetRenderBox.globalToLocal(cursorWithFeedbackWidget);
  }

  /// Calculate the [DateTime] of the cursor.
  DateTime? calculateCursorDateTime(
    Offset offset, {
    Offset feedbackWidgetOffset = Offset.zero,
  });

  /// Calculate the [DateTimeRange] from the start [DateTime].
  ///
  /// Will return a [DateTimeRange] with an updated start [DateTime] and the same end [DateTime].
  /// - In the case where the new start [DateTime] is after the end [DateTime], the start and end [DateTime]s will be swapped.
  /// - In the case where the [DateTime]s are the same, the original [DateTimeRange] will be returned.
  DateTimeRange calculateDateTimeRangeFromStart(
    DateTimeRange dateTimeRange,
    DateTime newStart,
  ) {
    if (newStart.isBefore(dateTimeRange.end)) {
      return DateTimeRange(start: newStart, end: dateTimeRange.end);
    } else if (newStart.isAtSameMomentAs(dateTimeRange.end)) {
      return DateTimeRange(start: dateTimeRange.start, end: dateTimeRange.end);
    } else {
      return DateTimeRange(start: dateTimeRange.end, end: newStart);
    }
  }

  /// Calculate the [DateTimeRange] from the end [DateTime].
  ///
  /// Will return a [DateTimeRange] with an updated end [DateTime] and the same start [DateTime].
  /// - In the case where the new end [DateTime] is before the start [DateTime], the start and end [DateTime]s will be swapped.
  /// - In the case where the [DateTime]s are the same, the original [DateTimeRange] will be returned.
  DateTimeRange calculateDateTimeRangeFromEnd(
    DateTimeRange dateTimeRange,
    DateTime newEnd,
  ) {
    if (newEnd.isBefore(dateTimeRange.start)) {
      return DateTimeRange(start: newEnd, end: dateTimeRange.start);
    } else if (newEnd.isAtSameMomentAs(dateTimeRange.start)) {
      return DateTimeRange(start: dateTimeRange.start, end: dateTimeRange.end);
    } else {
      return DateTimeRange(start: dateTimeRange.start, end: newEnd);
    }
  }
}
