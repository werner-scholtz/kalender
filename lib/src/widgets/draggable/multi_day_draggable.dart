import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/widgets/draggable/new_draggable.dart';

class NewMultiDayEventDraggableWidgets<T extends Object?> extends NewDraggableWidget<T> {
  final EventsController<T> eventsController;
  final CalendarCallbacks<T>? callbacks;
  final DateTimeRange visibleDateTimeRange;
  final CreateEventTrigger createEventTrigger;
  final double dayWidth;
  final bool allowEventCreation;

  const NewMultiDayEventDraggableWidgets({
    super.key,
    required super.controller,
    required this.eventsController,
    required this.callbacks,
    required this.visibleDateTimeRange,
    required this.createEventTrigger,
    required this.dayWidth,
    required this.allowEventCreation,
  });

  @override
  Widget build(BuildContext context) {
    var localPosition = Offset.zero;

    return Listener(
      onPointerDown: (event) => localPosition = event.localPosition,
      onPointerSignal: (event) => localPosition = event.localPosition,
      onPointerMove: (event) => localPosition = event.localPosition,
      child: Row(
        children: [
          if (allowEventCreation)
            for (final date in visibleDateTimeRange.days)
              switch (createEventTrigger) {
                CreateEventTrigger.tap => Draggable(
                    onDragStarted: () => createNewEvent(date, localPosition),
                    onDraggableCanceled: onDragFinished,
                    onDragEnd: onDragFinished,
                    dragAnchorStrategy: pointerDragAnchorStrategy,
                    data: Create(controllerId: controller.id),
                    feedback: Container(color: Colors.transparent, width: 1, height: 1),
                    child: Container(color: Colors.transparent, width: dayWidth),
                  ),
                CreateEventTrigger.longPress => LongPressDraggable(
                    onDragStarted: () => createNewEvent(date, localPosition),
                    onDraggableCanceled: onDragFinished,
                    onDragEnd: onDragFinished,
                    dragAnchorStrategy: pointerDragAnchorStrategy,
                    data: Create(controllerId: controller.id),
                    feedback: Container(color: Colors.transparent, width: 1, height: 1),
                    child: Container(color: Colors.transparent, width: dayWidth),
                  ),
              },
        ],
      ),
    );
  }

  /// Calculate the initial dateTimeRange of a new event.
  ///
  /// [date] is the date the draggable is located at.
  /// [localPosition] is the last known position of the cursor.
  @override
  DateTimeRange calculateDateTimeRange(DateTime date, Offset localPosition) {
    final start = _calculateTimeAndDate(date, localPosition);
    final end = start.endOfDay;
    return DateTimeRange(start: start, end: end);
  }

  // TODO: look into detemine if the cursor is closer to start / end of day.
  DateTime _calculateTimeAndDate(DateTime date, Offset localPosition) {
    // Calculate the date of the position.
    final visibleDates = visibleDateTimeRange.days;
    final cursorDate = (localPosition.dx / dayWidth);

    final cursorDateIndex = cursorDate.floor();
    if (cursorDateIndex < 0) return visibleDates.first;

    final date = visibleDates.elementAtOrNull(cursorDateIndex);
    if (date == null) return visibleDates.first;

    return date.asLocal();
  }
}
