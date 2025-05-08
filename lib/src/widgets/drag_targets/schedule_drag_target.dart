import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/mixins/drag_target_utils.dart';

/// A [StatefulWidget] that provides a [DragTarget] for [Create], [Resize], [Reschedule] objects.
///
/// The [ScheduleDragTarget] specializes in accepting [Draggable] widgets for a multi day body.
class ScheduleDragTarget<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final CalendarCallbacks<T>? callbacks;
  final ContinuousScheduleViewController<T> scheduleViewController;
  final BoxConstraints constraints;

  /// Creates a [ScheduleDragTarget].
  const ScheduleDragTarget({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.callbacks,
    required this.scheduleViewController,
    required this.constraints,
  });

  @override
  State<ScheduleDragTarget<T>> createState() => _ScheduleDragTargetState<T>();
}

class _ScheduleDragTargetState<T extends Object?> extends State<ScheduleDragTarget<T>> with DragTargetUtilities<T> {
  @override
  double get dayWidth => widget.constraints.maxWidth;

  @override
  List<DateTime> get visibleDates => throw UnimplementedError();

  @override
  EventsController<T> get eventsController => widget.eventsController;
  ValueNotifier<Size?> get feedbackWidgetSize => eventsController.feedbackWidgetSize;

  @override
  CalendarController<T> get controller => widget.calendarController;

  @override
  CalendarCallbacks<T>? get callbacks => widget.callbacks;

  @override
  bool get multiDayDragTarget => false;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      hitTestBehavior: HitTestBehavior.translucent,
      onWillAcceptWithDetails: (details) {
        return onWillAcceptWithDetails(
          details,
          onResize: (event, direction) => false,
          onReschedule: (event) {
            // Set the size of the feedback widget.
            const height = 24.0;
            feedbackWidgetSize.value = Size(dayWidth, height);
            controller.selectEvent(event, internal: true);
            return true;
          },
        );
      },
      onMove: onMove,
      onAcceptWithDetails: onAcceptWithDetails,
      onLeave: onLeave,
      builder: (context, candidateData, rejectedData) {
        return const SizedBox.expand();
      },
    );
  }

  @override
  DateTime? calculateCursorDateTime(Offset offset, {Offset feedbackWidgetOffset = Offset.zero}) {
    // Calculate the relative cursor position.
    final localCursorPosition = calculateLocalCursorPosition(offset);
    if (localCursorPosition == null) return null;

    // Find the item index based on the cursor position.
    final viewController = widget.scheduleViewController;
    final itemPositions = viewController.itemPositionsListener.itemPositions.value;
    final proportionalOffset = localCursorPosition.dy / widget.constraints.maxHeight;
    final itemIndex = itemPositions
        .where((item) => item.itemLeadingEdge <= proportionalOffset && item.itemTrailingEdge >= proportionalOffset)
        .map((item) => item.index)
        .firstOrNull;

    // If no item index is found, return null.
    if (itemIndex == null) return null;

    // Get the date for the item index.
    final eventId = viewController.itemIndexEventId[itemIndex];
    final date = viewController.eventIdDateIndex[eventId];
    return date;
  }

  @override
  CalendarEvent<T>? rescheduleEvent(CalendarEvent<T> event, DateTime cursorDateTime) {
    final rangeAsUtc = event.dateTimeRangeAsUtc;
    if (event.isMultiDayEvent) {
      final duration = rangeAsUtc.duration;
      final endTime = cursorDateTime.add(duration);
      final newRange = DateTimeRange(start: cursorDateTime, end: endTime);
      return event.copyWith(dateTimeRange: newRange);
    } else {
      final newStart = rangeAsUtc.start.copyWith(
        year: cursorDateTime.year,
        month: cursorDateTime.month,
        day: cursorDateTime.day,
      );
      final newEnd = rangeAsUtc.end.copyWith(
        year: cursorDateTime.year,
        month: cursorDateTime.month,
        day: cursorDateTime.day,
      );
      return event.copyWith(dateTimeRange: DateTimeRange(start: newStart, end: newEnd).asLocal);
    }
  }

  @override
  CalendarEvent<T>? resizeEvent(CalendarEvent<T> event, ResizeDirection direction, DateTime cursorDateTime) => null;
}
