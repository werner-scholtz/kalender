import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/draggable/new_draggable.dart';

/// This widget generates draggable widgets for each visible day.
/// - These draggable widgets are used to create new events.
///
class DayDraggable<T extends Object?> extends StatefulWidget {
  final DateTimeRange visibleDateTimeRange;
  final TimeOfDayRange timeOfDayRange;
  final double pageHeight;

  const DayDraggable({
    super.key,
    required this.visibleDateTimeRange,
    required this.timeOfDayRange,
    required this.pageHeight,
  });

  @override
  State<DayDraggable<T>> createState() => _DayDraggableState<T>();
}

class _DayDraggableState<T extends Object?> extends State<DayDraggable<T>> with NewDraggableWidget<T> {
  @override
  CalendarCallbacks<T>? get callbacks => context.callbacks<T>();

  @override
  CalendarController<T> get controller => context.calendarController<T>();

  @override
  Widget build(BuildContext context) {
    if (!context.interaction.allowEventCreation) return const SizedBox.shrink();

    var localPosition = Offset.zero;

    /// Check if this is affected by removing interaction.
    return Listener(
      onPointerDown: (event) => localPosition = event.localPosition,
      onPointerSignal: (event) => localPosition = event.localPosition,
      onPointerMove: (event) => localPosition = event.localPosition,
      child: Row(
        children: [
          for (final date in widget.visibleDateTimeRange.dates())
            Expanded(
              child: GestureDetector(
                onTapUp: callbacks?.hasOnTapped == true ? (details) => _notifyTap(date, localPosition) : null,
                onLongPressEnd:
                    callbacks?.hasOnLongPressed == true ? (details) => _notifyTap(date, localPosition) : null,
                child: switch (context.interaction.createEventGesture) {
                  CreateEventGesture.tap => Draggable(
                      dragAnchorStrategy: pointerDragAnchorStrategy,
                      onDragStarted: () => createNewEvent(date, localPosition),
                      onDraggableCanceled: onDragFinished,
                      onDragEnd: onDragFinished,
                      data: Create(controllerId: controller.id),
                      feedback: Container(color: Colors.transparent, width: 1, height: 1),
                      child: Container(color: Colors.transparent, height: widget.pageHeight),
                    ),
                  CreateEventGesture.longPress => LongPressDraggable(
                      dragAnchorStrategy: pointerDragAnchorStrategy,
                      onDragStarted: () => createNewEvent(date, localPosition),
                      onDraggableCanceled: onDragFinished,
                      onDragEnd: onDragFinished,
                      data: Create(controllerId: controller.id),
                      feedback: Container(color: Colors.transparent, width: 1, height: 1),
                      child: Container(color: Colors.transparent, height: widget.pageHeight),
                    ),
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Notify the callbacks about the tap / longPress.
  void _notifyTap(DateTime date, Offset localPosition) {
    final dateTime = _calculateTimeAndDate(date, localPosition).asLocal;
    callbacks?.onLongPressed?.call(dateTime);
    callbacks?.onLongPressedWithDetails?.call(DayDetail(dateTime));
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
    final durationFromStart = localPosition.dy ~/ context.heightPerMinute;
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
}
