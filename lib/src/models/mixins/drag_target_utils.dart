import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

typedef UpdatedEvent = (CalendarEvent, CalendarEvent);

mixin DragTargetUtilities {
  BuildContext get context;

  /// Whether [context] is still usable.
  ///
  /// Satisfied by [State.mounted]. Checked before any deferred work, since
  /// reading [State.context] after disposal throws rather than returning null.
  bool get mounted;
  CalendarController get controller;
  EventsController get eventsController;
  CalendarCallbacks? get callbacks;
  double get dayWidth;
  List<DateTime> get visibleDates;
  bool get multiDayDragTarget;

  /// The most recent move, waiting to be processed at the end of the frame.
  DragTargetDetails<Object?>? _pendingMove;

  /// Whether a callback is already registered for the pending move.
  bool _moveScheduled = false;

  /// A copy of the event being created.
  CalendarEvent? newEvent;

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
    required bool Function(CalendarEvent event, ResizeDirection direction) onResize,
    required bool Function(CalendarEvent event) onReschedule,
  }) {
    return handleDragDetails(
      details,
      onCreate: (controllerId) {
        if (controller.newEvent != null && newEvent == null) {
          newEvent = controller.newEvent;
          controller.selectEvent(newEvent!, internal: true);
        }
        return controllerId == controller.id;
      },
      onResize: onResize,
      onReschedule: onReschedule,
      onOther: () => false,
      resolveEvent: _resolveEvent,
    );
  }

  /// Handle the [DragTarget.onMove], processing at most one move per frame.
  ///
  /// Pointer moves can arrive faster than the display refreshes, and each one
  /// processed rebuilds the preview. Only the newest is worth drawing, so the
  /// rest are discarded rather than throttled against the clock.
  void onMove(DragTargetDetails<Object?> details) {
    _pendingMove = details;
    if (_moveScheduled) return;
    _moveScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveScheduled = false;
      final pending = _pendingMove;
      _pendingMove = null;
      if (pending == null || !mounted) return;
      _processMove(pending);
    });

    // addPostFrameCallback does not schedule a frame, and without one the
    // pending move would sit unprocessed.
    WidgetsBinding.instance.scheduleFrame();
  }

  /// Handle the [DragTarget.onMove].
  void _processMove(DragTargetDetails<Object?> details) {
    handleDragDetails(
      details,
      onCreate: (controllerId) {
        if (controllerId != controller.id) return;

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
      resolveEvent: _resolveEvent,
    );
  }

  /// Handle the [DragTarget.onAcceptWithDetails].
  void onAcceptWithDetails(DragTargetDetails<Object?> details) {
    final result = handleDragDetails(
      details,
      onCreate: (controllerId) {
        if (controllerId != controller.id) return null;

        final date = calculateCursorDateTime(details.offset);
        if (date == null) return null;

        final updatedEvent = createEvent(date);
        if (updatedEvent == null) return null;

        controller.deselectEvent();
        callbacks?.onEventCreated?.call(updatedEvent);
        newEvent = null;

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
      resolveEvent: _resolveEvent,
    );

    _cancelPendingMove();

    if (result == null) return;
    final originalEvent = result.$1;
    final updatedEvent = result.$2;

    context.feedbackWidgetSizeNotifier.value = Size.zero;
    controller.deselectEvent();
    callbacks?.onEventChanged?.call(originalEvent, updatedEvent);
  }

  /// Handle the [DragTarget.onLeave]
  void onLeave(Object? details) {
    _cancelPendingMove();
    controller.deselectEvent();
    newEvent = null;
  }

  /// Drop any move still waiting to be processed.
  ///
  /// A move queued during the drag would otherwise be processed after the drop
  /// has already deselected the event, reselecting it and leaving the preview
  /// behind as a duplicate of the event it was previewing.
  void _cancelPendingMove() => _pendingMove = null;

  /// Reschedule an event.
  CalendarEvent? rescheduleEvent(CalendarEvent event, InternalDateTime cursorDateTime);

  /// Resize an event.
  CalendarEvent? resizeEvent(CalendarEvent event, ResizeDirection direction, InternalDateTime cursorDateTime);

  /// Reschedule an event.
  CalendarEvent? createEvent(InternalDateTime cursorDateTime) => newEvent ??= controller.newEvent;

  /// Processes the [DragTargetDetails] and handle different types of detail data (reschedule, resize, create, other).
  ///
  /// [onCreate] - handle the [Create] type.
  /// [onResize] - handle the [Resize] type.
  /// [onReschedule] - handle the [Reschedule] type.
  /// [onOther] - handle other types.
  ///
  /// Each handler function returns a value of type [K], which is the result of handling the data.
  /// Resolves the latest version of the [event] from the [EventsController],
  /// falling back to the provided instance if not found.
  CalendarEvent _resolveEvent(CalendarEvent event) {
    return eventsController.byId(event.id) ?? event;
  }

  static K handleDragDetails<K extends Object?, T extends Object?>(
    DragTargetDetails<Object?> details, {
    required K Function(int controllerId) onCreate,
    required K Function(CalendarEvent event, ResizeDirection direction) onResize,
    required K Function(CalendarEvent event) onReschedule,
    required K Function() onOther,
    CalendarEvent Function(CalendarEvent event)? resolveEvent,
  }) {
    final data = details.data;
    if (data is Create) {
      return onCreate(data.controllerId);
    } else if (data is Resize) {
      final event = resolveEvent?.call(data.event) ?? data.event;
      return onResize(event, data.direction);
    } else if (data is Reschedule) {
      final event = resolveEvent?.call(data.event) ?? data.event;
      return onReschedule(event);
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
    return dragTargetRenderBox.globalToLocal(cursorPosition) + scrollOffset;
  }

  /// Calculate the [DateTime] of the cursor.
  InternalDateTime? calculateCursorDateTime(
    Offset offset, {
    Offset feedbackWidgetOffset = Offset.zero,
  });

  /// Calculate the [DateTimeRange] from the start [DateTime].
  ///
  /// Will return a [DateTimeRange] with an updated start [DateTime] and the same end [DateTime].
  /// - In the case where the new start [DateTime] is after the end [DateTime], the start and end [DateTime]s will be swapped.
  /// - In the case where the [DateTime]s are the same, the original [DateTimeRange] will be returned.
  InternalDateTimeRange calculateDateTimeRangeFromStart(
    DateTimeRange dateTimeRange,
    DateTime newStart,
  ) {
    if (newStart.isBefore(dateTimeRange.end)) {
      return InternalDateTimeRange(start: newStart, end: dateTimeRange.end);
    } else if (newStart.isAtSameMomentAs(dateTimeRange.end)) {
      return InternalDateTimeRange(start: dateTimeRange.start, end: dateTimeRange.end);
    } else {
      return InternalDateTimeRange(start: dateTimeRange.end, end: newStart);
    }
  }

  /// Calculate the [DateTimeRange] from the end [DateTime].
  ///
  /// Will return a [DateTimeRange] with an updated end [DateTime] and the same start [DateTime].
  /// - In the case where the new end [DateTime] is before the start [DateTime], the start and end [DateTime]s will be swapped.
  /// - In the case where the [DateTime]s are the same, the original [DateTimeRange] will be returned.
  InternalDateTimeRange calculateDateTimeRangeFromEnd(
    DateTimeRange dateTimeRange,
    DateTime newEnd,
  ) {
    if (newEnd.isBefore(dateTimeRange.start)) {
      return InternalDateTimeRange(start: newEnd, end: dateTimeRange.start);
    } else if (newEnd.isAtSameMomentAs(dateTimeRange.start)) {
      return InternalDateTimeRange(start: dateTimeRange.start, end: dateTimeRange.end);
    } else {
      return InternalDateTimeRange(start: dateTimeRange.start, end: newEnd);
    }
  }

  /// Converts an [InternalDateTimeRange] to a [DateTimeRange] for the current location,
  /// handling DST spring-forward gaps where start can get pushed past end.
  DateTimeRange toLocationDateTimeRange(InternalDateTimeRange range) {
    final location = context.location;
    var start = range.start.forLocation(location: location);
    var end = range.end.forLocation(location: location);
    if (start.isAfter(end)) (start, end) = (end, start);
    return DateTimeRange(start: start, end: end);
  }
}
