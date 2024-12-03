import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/mixins/drag_target_utils.dart';
import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/widgets/internal_components/cursor_navigation_trigger.dart';

import 'package:kalender/src/models/calendar_events/draggable_event.dart';

/// A [StatefulWidget] that provides a [DragTarget] for [Draggable] widgets containing a [Create], [Resize], [Reschedule] object.
///
/// The [MultiDayDragTarget] specializes in accepting [Draggable] widgets for a multi day header / month body.
class MultiDayDragTarget<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;
  final PageTriggerConfiguration pageTriggerSetup;
  final DateTimeRange visibleDateTimeRange;
  final double dayWidth;
  final double pageWidth;
  final double tileHeight;
  final bool allowSingleDayEvents;

  final HorizontalTriggerWidgetBuilder? leftPageTrigger;
  final HorizontalTriggerWidgetBuilder? rightPageTrigger;

  const MultiDayDragTarget({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.callbacks,
    required this.tileComponents,
    required this.pageTriggerSetup,
    required this.visibleDateTimeRange,
    required this.dayWidth,
    required this.pageWidth,
    required this.tileHeight,
    required this.allowSingleDayEvents,
    required this.leftPageTrigger,
    required this.rightPageTrigger,
  });

  @override
  State<MultiDayDragTarget<T>> createState() => _MultiDayDragTargetState<T>();
}

class _MultiDayDragTargetState<T extends Object?> extends State<MultiDayDragTarget<T>> with DragTargetUtilities<T> {
  @override
  EventsController<T> get eventsController => widget.eventsController;
  @override
  CalendarController<T> get controller => widget.calendarController;
  @override
  double get dayWidth => widget.dayWidth;
  @override
  CalendarCallbacks<T>? get callbacks => widget.callbacks;
  @override
  List<DateTime> get visibleDates => visibleDateTimeRange.days;
  @override
  bool get multiDayDragTarget => true;

  ViewController<T> get viewController => controller.viewController!;
  TileComponents<T> get tileComponents => widget.tileComponents;
  DateTimeRange get visibleDateTimeRange => widget.visibleDateTimeRange;
  PageTriggerConfiguration get pageTrigger => widget.pageTriggerSetup;

  ValueNotifier<Size> get feedbackWidgetSize => eventsController.feedbackWidgetSize;

  double get pageWidth => widget.pageWidth;
  double get tileHeight => widget.tileHeight;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAcceptWithDetails: (details) {
        return onWillAcceptWithDetails(
          details,
          onResize: (event, direction) => direction.horizontal,
          onReschedule: (event) {
            if (!widget.allowSingleDayEvents && !event.isMultiDayEvent) return false;
            // Set the size of the feedback widget.
            feedbackWidgetSize.value = Size(min(pageWidth, dayWidth * event.datesSpanned.length), tileHeight);
            controller.selectEvent(event, internal: true);
            return true;
          },
        );
      },
      onMove: onMove,
      onAcceptWithDetails: onAcceptWithDetails,
      onLeave: onLeave,
      builder: (context, candidateData, rejectedData) {
        // Check if the candidateData is null.
        if (candidateData.firstOrNull == null) return const SizedBox();

        final triggerWidth = pageWidth / 50;
        final pageAnimationDuration = pageTrigger.animationDuration;
        final pageTriggerDelay = pageTrigger.triggerDelay;
        final pageAnimationCurve = pageTrigger.animationCurve;

        final rightTrigger = CursorNavigationTrigger(
          triggerDelay: pageTriggerDelay,
          onTrigger: () => viewController.animateToNextPage(duration: pageAnimationDuration, curve: pageAnimationCurve),
          child: widget.rightPageTrigger?.call(pageWidth) ??
              ConstrainedBox(constraints: BoxConstraints.expand(width: triggerWidth)),
        );

        final leftTrigger = CursorNavigationTrigger(
          triggerDelay: pageTriggerDelay,
          onTrigger: () =>
              viewController.animateToPreviousPage(duration: pageAnimationDuration, curve: pageAnimationCurve),
          child: widget.leftPageTrigger?.call(pageWidth) ??
              ConstrainedBox(constraints: BoxConstraints.expand(width: triggerWidth)),
        );

        return Stack(
          children: [
            PositionedDirectional(end: 0, top: 0, bottom: 0, child: rightTrigger),
            PositionedDirectional(start: 0, top: 0, bottom: 0, child: leftTrigger),
          ],
        );
      },
    );
  }

  @override
  DateTime? calculateCursorDateTime(
    Offset offset, {
    Offset feedbackWidgetOffset = Offset.zero,
  }) {
    // Calculate the relative cursor position.
    final localCursorPosition = calculateLocalCursorPosition(offset);
    if (localCursorPosition == null) return null;

    final cursorDateIndex = (localCursorPosition.dx / dayWidth).floor();
    if (cursorDateIndex < 0) return null;
    final date = cursorDateIndex > visibleDates.length
        ? visibleDates.elementAt(visibleDates.length - 1).endOfDay
        : visibleDates.elementAtOrNull(cursorDateIndex);

    return date;
  }

  @override
  CalendarEvent<T>? rescheduleEvent(CalendarEvent<T> event, DateTime cursorDateTime) {
    // Calculate the new dateTimeRange for the event.
    final newStartTime = cursorDateTime;
    final duration = event.dateTimeRange.duration;
    final endTime = newStartTime.add(duration);
    final newRange = DateTimeRange(start: newStartTime, end: endTime);

    // Update the event with the new start time.
    final updatedEvent = event.copyWith(dateTimeRange: newRange.asLocal);

    return updatedEvent;
  }

  @override
  CalendarEvent<T>? resizeEvent(CalendarEvent<T> event, ResizeDirection direction, DateTime cursorDateTime) {
    final range = switch (direction) {
      ResizeDirection.left => calculateDateTimeRangeFromStart(event.dateTimeRange, cursorDateTime),
      ResizeDirection.right => calculateDateTimeRangeFromEnd(event.dateTimeRange, cursorDateTime.endOfDay),
      _ => null
    };
    if (range == null) return null;
    return event.copyWith(dateTimeRange: range.asLocal);
  }

  @override
  CalendarEvent<T>? createEvent(DateTime cursorDateTime) {
    final event = super.createEvent(cursorDateTime);
    if (event == null) return null;

    var range = newEvent!.dateTimeRange;

    if ((cursorDateTime.isSameDay(range.start) || cursorDateTime.isSameDay(range.end)) ||
        cursorDateTime.isAfter(range.start)) {
      range = DateTimeRange(start: range.start.startOfDay, end: cursorDateTime.endOfDay);
    } else if (cursorDateTime.isBefore(range.start)) {
      range = DateTimeRange(start: cursorDateTime, end: range.start.endOfDay);
    }

    return event.copyWith(dateTimeRange: range.asLocal);
  }
}
