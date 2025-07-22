import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/draggable/new_draggable.dart';

/// This widget generates draggable widgets for each visible day.
/// - These draggable widgets are used to create new events.
///
class DayEventDraggableWidgets<T extends Object?> extends StatefulWidget {
  final CalendarController<T> controller;

  final CalendarCallbacks<T>? callbacks;

  final DateTimeRange visibleDateTimeRange;
  final TimeOfDayRange timeOfDayRange;
  final double dayWidth;
  final double pageHeight;
  final double heightPerMinute;

  const DayEventDraggableWidgets({
    super.key,
    required this.controller,
    required this.callbacks,
    required this.visibleDateTimeRange,
    required this.timeOfDayRange,
    required this.pageHeight,
    required this.dayWidth,
    required this.heightPerMinute,
  });

  @override
  State<DayEventDraggableWidgets<T>> createState() => _DayEventDraggableWidgetsState<T>();
}

class _DayEventDraggableWidgetsState<T extends Object?> extends State<DayEventDraggableWidgets<T>>
    with NewDraggableWidget<T> {
  @override
  Widget build(BuildContext context) {
    var localPosition = Offset.zero;

    /// Check if this is affected by removing interaction.
    return Listener(
      onPointerDown: (event) => localPosition = event.localPosition,
      onPointerSignal: (event) => localPosition = event.localPosition,
      onPointerMove: (event) => localPosition = event.localPosition,
      child: Row(
        children: [
          if (context.interaction.allowEventCreation)
            for (final date in widget.visibleDateTimeRange.dates())
              GestureDetector(
                onTapUp: (details) =>
                    widget.callbacks?.onTapped?.call(_calculateTimeAndDate(date, localPosition).asLocal),
                child: switch (context.interaction.createEventGesture) {
                  CreateEventGesture.tap => Draggable(
                      dragAnchorStrategy: pointerDragAnchorStrategy,
                      onDragStarted: () => createNewEvent(date, localPosition),
                      onDraggableCanceled: onDragFinished,
                      onDragEnd: onDragFinished,
                      data: Create(controllerId: widget.controller.id),
                      feedback: Container(color: Colors.transparent, width: 1, height: 1),
                      child: Container(color: Colors.transparent, width: widget.dayWidth, height: widget.pageHeight),
                    ),
                  CreateEventGesture.longPress => LongPressDraggable(
                      dragAnchorStrategy: pointerDragAnchorStrategy,
                      onDragStarted: () => createNewEvent(date, localPosition),
                      onDraggableCanceled: onDragFinished,
                      onDragEnd: onDragFinished,
                      data: Create(controllerId: widget.controller.id),
                      feedback: Container(color: Colors.transparent, width: 1, height: 1),
                      child: Container(color: Colors.transparent, width: widget.dayWidth, height: widget.pageHeight),
                    ),
                },
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
    final start = _calculateTimeAndDate(date, localPosition);
    final snapInterval = context.snapping.snapIntervalMinutes;
    final end = start.copyWith(minute: start.minute + snapInterval);
    return DateTimeRange(start: start, end: end);
  }

  /// Calculate a DateTime from the [date] of the draggable and the [localPosition] of the cursor.
  DateTime _calculateTimeAndDate(DateTime date, Offset localPosition) {
    // Calculate the duration from the top of the page to the localPosition.
    final durationFromStart = localPosition.dy ~/ widget.heightPerMinute;
    final durationFromTop = Duration(minutes: durationFromStart.round());

    // Calculate the start of the day.
    final startOfDay = widget.timeOfDayRange.start.toDateTime(date);

    // Calculate dateTime of the cursor.
    final startOfEvent = startOfDay.add(durationFromTop);

    // Snap the datetime based on the snap strategy.
    final snappedDateTime = context.snapping.eventSnapStrategy(
      startOfEvent,
      startOfDay,
      context.snapping.snapIntervalMinutes,
    );

    return snappedDateTime;
  }

  @override
  CalendarCallbacks<T>? get callbacks => widget.callbacks;

  @override
  CalendarController<T> get controller => widget.controller;
}
