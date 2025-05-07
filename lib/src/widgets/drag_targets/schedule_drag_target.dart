import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/mixins/drag_target_utils.dart';

/// A [StatefulWidget] that provides a [DragTarget] for [Create], [Resize], [Reschedule] objects.
///
/// The [ScheduleDayDragTarget] specializes in accepting [Draggable] widgets for a multi day body.
class ScheduleDayDragTarget<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final CalendarCallbacks<T>? callbacks;

  /// Creates a [ScheduleDayDragTarget].
  const ScheduleDayDragTarget({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.callbacks,
  });

  @override
  State<ScheduleDayDragTarget<T>> createState() => _ScheduleDayDragTargetState<T>();
}

class _ScheduleDayDragTargetState<T extends Object?> extends State<ScheduleDayDragTarget<T>>
    with DragTargetUtilities<T> {
  @override
  // TODO: implement dayWidth
  double get dayWidth => throw UnimplementedError();

  @override
  // TODO: implement visibleDates
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
          onResize: (event, direction) => direction.vertical,
          onReschedule: (event) {
            // Set the size of the feedback widget.
            // TODO: make this dynamic.
            const height = 24.0;
            const width = 100.0;
            feedbackWidgetSize.value = Size(width, height);
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
    // TODO: implement calculateCursorDateTime
    debugPrint('calculateCursorDateTime not implemented');
    return null;
  }

  @override
  CalendarEvent<T>? rescheduleEvent(CalendarEvent<T> event, DateTime cursorDateTime) {
    // TODO: implement rescheduleEvent
    debugPrint('rescheduleEvent not implemented');
    return null;
  }

  @override
  CalendarEvent<T>? resizeEvent(CalendarEvent<T> event, ResizeDirection direction, DateTime cursorDateTime) {
    // TODO: implement resizeEvent
    debugPrint('resizeEvent not implemented');
    return null;
  }
}
