import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/widgets/draggable/new_draggable.dart';

class MultiDayEventDraggableWidgets<T extends Object?> extends NewDraggableWidget<T> {
  final EventsController<T> eventsController;
  final DateTimeRange visibleDateTimeRange;
  final double dayWidth;
  final ValueNotifier<CalendarInteraction> interaction;

  const MultiDayEventDraggableWidgets({
    super.key,
    required super.controller,
    required this.eventsController,
    required this.visibleDateTimeRange,
    required this.dayWidth,
    required this.interaction,
    required super.callbacks,
  });

  @override
  Widget build(BuildContext context) {
    var localPosition = Offset.zero;

    return Listener(
        onPointerDown: (event) => localPosition = event.localPosition,
        onPointerSignal: (event) => localPosition = event.localPosition,
        onPointerMove: (event) => localPosition = event.localPosition,
        child: ValueListenableBuilder(
          valueListenable: interaction,
          builder: (context, interaction, child) {
            return Row(
              children: [
                if (interaction.allowEventCreation)
                  for (final date in visibleDateTimeRange.dates())
                    GestureDetector(
                      onTapUp: (details) =>
                          callbacks?.onMultiDayTapped?.call(calculateDateTimeRange(date, localPosition).asLocal),
                      child: switch (interaction.createEventGesture) {
                        CreateEventGesture.tap => Draggable(
                            onDragStarted: () => createNewEvent(date, localPosition),
                            onDraggableCanceled: onDragFinished,
                            onDragEnd: onDragFinished,
                            dragAnchorStrategy: pointerDragAnchorStrategy,
                            data: Create(controllerId: controller.id),
                            feedback: Container(color: Colors.transparent, width: 1, height: 1),
                            child: Container(color: Colors.transparent, width: dayWidth),
                          ),
                        CreateEventGesture.longPress => LongPressDraggable(
                            onDragStarted: () => createNewEvent(date, localPosition),
                            onDraggableCanceled: onDragFinished,
                            onDragEnd: onDragFinished,
                            dragAnchorStrategy: pointerDragAnchorStrategy,
                            data: Create(controllerId: controller.id),
                            feedback: Container(color: Colors.transparent, width: 1, height: 1),
                            child: Container(color: Colors.transparent, width: dayWidth),
                          ),
                      },
                    ),
              ],
            );
          },
        ));
  }

  /// Calculate the initial dateTimeRange of a new event.
  ///
  /// [date] is the date the draggable is located at.
  /// [localPosition] is the last known position of the cursor.
  @override
  DateTimeRange calculateDateTimeRange(DateTime date, Offset localPosition) {
    final start = date;
    final end = start.endOfDay;
    return DateTimeRange(start: start, end: end);
  }
}
