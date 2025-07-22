import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/draggable/new_draggable.dart';

class MultiDayDraggable<T extends Object?> extends StatefulWidget {
  final DateTimeRange visibleDateTimeRange;
  const MultiDayDraggable({super.key, required this.visibleDateTimeRange});
  @override
  State<MultiDayDraggable<T>> createState() => _MultiDayDraggableState<T>();
}

class _MultiDayDraggableState<T extends Object?> extends State<MultiDayDraggable<T>> with NewDraggableWidget<T> {
  @override
  CalendarCallbacks<T>? get callbacks => context.callbacks<T>();

  @override
  CalendarController<T> get controller => context.calendarController<T>();

  @override
  Widget build(BuildContext context) {
    var localPosition = Offset.zero;

    /// TODO: See if there are improvements to be made here. (specifically with context.interaction)
    return Listener(
      onPointerDown: (event) => localPosition = event.localPosition,
      onPointerSignal: (event) => localPosition = event.localPosition,
      onPointerMove: (event) => localPosition = event.localPosition,
      child: Row(
        children: [
          for (final date in widget.visibleDateTimeRange.dates())
            if (context.interaction.allowEventCreation)
              Expanded(
                child: GestureDetector(
                  onTapUp: (details) =>
                      callbacks?.onMultiDayTapped?.call(calculateDateTimeRange(date, localPosition).asLocal),
                  child: switch (context.interaction.createEventGesture) {
                    CreateEventGesture.tap => Draggable(
                        onDragStarted: () => createNewEvent(date, localPosition),
                        onDraggableCanceled: onDragFinished,
                        onDragEnd: onDragFinished,
                        dragAnchorStrategy: pointerDragAnchorStrategy,
                        data: Create(controllerId: controller.id),
                        feedback: Container(color: Colors.transparent, width: 1, height: 1),
                        child: Container(color: Colors.transparent),
                      ),
                    CreateEventGesture.longPress => LongPressDraggable(
                        onDragStarted: () => createNewEvent(date, localPosition),
                        onDraggableCanceled: onDragFinished,
                        onDragEnd: onDragFinished,
                        dragAnchorStrategy: pointerDragAnchorStrategy,
                        data: Create(controllerId: controller.id),
                        feedback: Container(color: Colors.transparent, width: 1, height: 1),
                        child: Container(color: Colors.transparent),
                      ),
                  },
                ),
              ),
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
    final start = date;
    final end = start.endOfDay;
    return DateTimeRange(start: start, end: end);
  }
}
