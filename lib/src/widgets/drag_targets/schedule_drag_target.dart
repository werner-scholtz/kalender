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
  DateTime? calculateCursorDateTime(
    Offset offset, {
    Offset feedbackWidgetOffset = Offset.zero,
  }) {
    // final localCursorPosition = calculateLocalCursorPosition(offset, scrollOffset: Offset(0, scrollController.offset));
    // if (localCursorPosition == null) return null;

    // // Calculate only the date of the cursor from the local cursor position.
    // final cursorDateIndex = (localCursorPosition.dx / dayWidth).floor();
    // if (cursorDateIndex < 0) return null;

    // final date = Directionality.of(context) == TextDirection.ltr
    //     ? visibleDates.elementAtOrNull(cursorDateIndex)
    //     : visibleDates.elementAtOrNull(visibleDates.length - cursorDateIndex - 1);

    // final cursorDate = date;
    // if (cursorDate == null) return null;

    // // Calculate the start of the day.
    // final startOfDate = timeOfDayRange.start.toDateTime(cursorDate);

    // // Calculate the duration to add to the startOfDate.
    // final durationFromStart = localCursorPosition.dy ~/ heightPerMinute;
    // final numberOfIntervals = (durationFromStart / snapIntervalMinutes).round();
    // final duration = Duration(minutes: snapIntervalMinutes * numberOfIntervals);

    // return startOfDate.add(duration);
  }

  /// Update the [CalendarEvent] based on the [Offset] delta.
  @override
  CalendarEvent<T>? rescheduleEvent(CalendarEvent<T> event, DateTime cursorDateTime) {
    // DateTime start;

    // if (timeOfDayRange.isAllDay) {
    //   start = cursorDateTime;
    // } else {
    //   final startOfDate = timeOfDayRange.start.toDateTime(cursorDateTime);
    //   final endOfDate = timeOfDayRange.end.toDateTime(cursorDateTime);
    //   if (cursorDateTime.isBefore(startOfDate)) {
    //     start = startOfDate;
    //   } else if (cursorDateTime.add(event.duration).isAfter(endOfDate)) {
    //     start = endOfDate.subtract(event.duration);
    //   } else {
    //     start = cursorDateTime;
    //   }
    // }

    // // Calculate the new dateTimeRange for the event.
    // final duration = event.dateTimeRangeAsUtc.duration;
    // var end = start.add(duration);

    // // Add now to the snap points.
    // late final now = DateTime.now().asUtc;
    // if (snapToTimeIndicator) addSnapPoint(now);

    // // Find the index of the snap point that is within a duration of snapRange of the start.
    // final startSnapPoint = findSnapPoint(start, snapRange);
    // if (startSnapPoint != null && startSnapPoint.isBefore(end)) {
    //   start = startSnapPoint;
    //   end = start.add(duration);
    // }

    // // Find the index of the snap point that is within a duration of snapRange of the end.
    // late final endSnapPoint = findSnapPoint(end, snapRange);
    // final canUseEndSnapPoint = startSnapPoint == null && endSnapPoint != null && endSnapPoint.isAfter(start);
    // if (canUseEndSnapPoint) {
    //   // Calculate the new end time.
    //   end = endSnapPoint;
    //   start = end.subtract(duration);
    // }

    // // Update the event with the new range.
    // final newRange = DateTimeRange(start: start, end: end);
    // final updatedEvent = event.copyWith(dateTimeRange: newRange.asLocal);

    // // Remove now from the snap points.
    // if (snapToTimeIndicator) removeSnapPoint(now);

    // return updatedEvent;
  }

  /// Update the [CalendarEvent] based on the [direction] and [cursorDateTime] delta.
  @override
  CalendarEvent<T>? resizeEvent(CalendarEvent<T> event, ResizeDirection direction, DateTime cursorDateTime) {
    // // Ignore vertical direction resizing.
    // if (!direction.vertical) return null;

    // // Add now to the snap points.
    // late final now = DateTime.now().asUtc;
    // if (snapToTimeIndicator) addSnapPoint(now);

    // final cursorSnapPoint = findSnapPoint(cursorDateTime, snapRange) ?? cursorDateTime;

    // // Remove now from the snap points.
    // if (snapToTimeIndicator) removeSnapPoint(now);

    // final dateTimeRange = switch (direction) {
    //   ResizeDirection.top => calculateDateTimeRangeFromStart(event.dateTimeRangeAsUtc, cursorSnapPoint),
    //   ResizeDirection.bottom => calculateDateTimeRangeFromEnd(event.dateTimeRangeAsUtc, cursorSnapPoint),
    //   _ => null
    // };
    // if (dateTimeRange == null) return null;

    // return event.copyWith(dateTimeRange: dateTimeRange.asLocal);
  }

  @override
  CalendarEvent<T>? createEvent(DateTime cursorDateTime) {
    // final event = super.createEvent(cursorDateTime);
    // if (event == null) return null;

    // // TODO: This might need to take `dateTimeRange` into account otherwise some new events might be created in undisplayed area's.
    // var range = newEvent!.dateTimeRangeAsUtc;

    // if (cursorDateTime.isAfter(range.start)) {
    //   range = DateTimeRange(start: range.start, end: cursorDateTime);
    // } else if (cursorDateTime.isBefore(range.start)) {
    //   range = DateTimeRange(start: cursorDateTime, end: range.start);
    // }

    // return event.copyWith(dateTimeRange: range.asLocal);
  }
}
