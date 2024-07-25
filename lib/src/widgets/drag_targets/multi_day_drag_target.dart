import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/mixins/drag_target_utils.dart';
import 'package:kalender/src/models/resize_event.dart';
import 'package:kalender/src/widgets/components/navigation_trigger.dart';

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

  final Widget? leftTriggerWidget;
  final Widget? rightTriggerWidget;

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
    required this.leftTriggerWidget,
    required this.rightTriggerWidget,
  });

  @override
  State<MultiDayDragTarget<T>> createState() => _MultiDayDragTargetState<T>();
}

class _MultiDayDragTargetState<T extends Object?> extends State<MultiDayDragTarget<T>>
    with DragTargetUtils {
  EventsController<T> get eventsController => widget.eventsController;
  CalendarController<T> get controller => widget.calendarController;
  ViewController<T> get viewController => controller.viewController!;
  CalendarCallbacks<T>? get callbacks => widget.callbacks;
  TileComponents<T> get tileComponents => widget.tileComponents;
  DateTimeRange get visibleDateTimeRange => widget.visibleDateTimeRange;
  List<DateTime> get visibleDates => visibleDateTimeRange.datesSpanned;
  PageTriggerConfiguration get pageTriggerSetup => widget.pageTriggerSetup;

  ValueNotifier<Size> get feedbackWidgetSize {
    return eventsController.feedbackWidgetSize;
  }

  double get dayWidth => widget.dayWidth;
  double get pageWidth => widget.pageWidth;
  double get tileHeight => widget.tileHeight;

  /// The position of the widget.
  Offset? widgetPosition;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAcceptWithDetails: _onWillAcceptWithDetails,
      onMove: _onMove,
      onAcceptWithDetails: _onAcceptWithDetails,
      onLeave: _onLeave,
      builder: (context, candidateData, rejectedData) {
        // Check if the candidateData is null.
        if (candidateData.firstOrNull == null) return const SizedBox();

        final triggerWidth = pageTriggerSetup.triggerWidth.call(pageWidth);
        final pageAnimationDuration = pageTriggerSetup.animationDuration;
        final pageTriggerDelay = pageTriggerSetup.triggerDelay;
        final pageAnimationCurve = pageTriggerSetup.animationCurve;

        final rightTrigger = NavigationTrigger(
          triggerDelay: pageTriggerDelay,
          onTrigger: () {
            viewController.animateToNextPage(
              duration: pageAnimationDuration,
              curve: pageAnimationCurve,
            );
          },
          child: widget.rightTriggerWidget,
        );

        final leftTrigger = NavigationTrigger(
          triggerDelay: pageTriggerDelay,
          onTrigger: () {
            viewController.animateToPreviousPage(
              duration: pageAnimationDuration,
              curve: pageAnimationCurve,
            );
          },
          child: widget.leftTriggerWidget,
        );

        return Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: triggerWidth,
              child: rightTrigger,
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: triggerWidth,
              child: leftTrigger,
            ),
          ],
        );
      },
    );
  }

  bool _onWillAcceptWithDetails(DragTargetDetails<Object> details) {
    final data = details.data;
    if (data is CalendarEvent<T>) {
      if (!widget.allowSingleDayEvents && !data.isMultiDayEvent) {
        return false;
      }

      // Set the size of the feedback widget.
      final feedBackWidth = dayWidth * data.datesSpanned.length;
      feedbackWidgetSize.value = Size(
        min(pageWidth, feedBackWidth),
        tileHeight,
      );

      _updateWidgetPosition();
      return true;
    } else if (data is ResizeEvent<T>) {
      // Check that the resize direction is either top or bottom.
      if (data.direction != ResizeDirection.left && data.direction != ResizeDirection.right) {
        return false;
      }

      _updateWidgetPosition();
      return true;
    } else {
      return false;
    }
  }

  void _onMove(DragTargetDetails<Object> details) {
    final data = details.data;
    if (data is CalendarEvent<T>) {
      final updatedEvent = _rescheduleEvent(data, details.offset);
      if (updatedEvent == null) return;

      controller.updateEvent(updatedEvent, internal: true);
    } else if (data is ResizeEvent<T>) {
      final updatedEvent = _resizeEvent(data, details.offset);
      if (updatedEvent == null) return;
      controller.updateEvent(updatedEvent, internal: true);
    }
  }

  void _onAcceptWithDetails(DragTargetDetails<Object> details) {
    final data = details.data;
    CalendarEvent<T>? updatedEvent;
    CalendarEvent<T>? originalEvent;

    if (data is CalendarEvent<T>) {
      originalEvent = data;
      updatedEvent = _rescheduleEvent(data, details.offset);
    } else if (data is ResizeEvent<T>) {
      originalEvent = data.event;
      updatedEvent = _resizeEvent(data, details.offset);
    }

    if (updatedEvent == null || originalEvent == null) return;

    // Update the event in the events controller.
    eventsController.updateEvent(event: originalEvent, updatedEvent: updatedEvent);

    eventsController.feedbackWidgetSize.value = Size.zero;
    widgetPosition = null;
    controller.deselectEvent();

    callbacks?.onEventChanged?.call(originalEvent, updatedEvent);
  }

  void _onLeave(Object? data) {
    widgetPosition = null;
    controller.deselectEvent();
  }

  void _updateWidgetPosition() {
    // Find the global position of the drop target widget.
    final renderObject = context.findRenderObject()! as RenderBox;
    final globalPosition = renderObject.localToGlobal(Offset.zero);
    widgetPosition = globalPosition;
  }

  /// Calculate the relative cursor position.
  Offset? _calculateRelativeCursorPosition(Offset cursorPosition) {
    if (widgetPosition == null) return null;

    // Calculate the widget offset.
    final feedbackWidgetOffset = Offset(dayWidth / 2, 0);

    // Calculate the position of the cursor relative to the current widget.
    final relativeCursorPosition = cursorPosition + feedbackWidgetOffset - widgetPosition!;

    return relativeCursorPosition;
  }

  /// Calculate the date of the cursor.
  DateTime? _calculateCursorDate(Offset offset) {
    // Calculate the relative cursor position.
    final cursorPosition = _calculateRelativeCursorPosition(offset);
    if (cursorPosition == null) return null;

    // Calculate the date of the cursor.
    final cursorDate = (cursorPosition.dx / dayWidth);
    final cursorDateIndex = cursorDate.floor();
    if (cursorDateIndex < 0) return null;
    final date = visibleDates.elementAtOrNull(cursorDateIndex);
    return date;
  }

  DateTime _calculateStartTime(DateTime start, DateTime date) {
    return start.copyWith(
      year: date.year,
      month: date.month,
      day: date.day,
    );
  }

  CalendarEvent<T>? _rescheduleEvent(CalendarEvent<T> event, Offset offset) {
    // Calculate the date of the cursor.
    final date = _calculateCursorDate(offset);
    if (date == null) return null;

    // Calculate the new dateTimeRange for the event.
    final newStartTime = _calculateStartTime(
      event.dateTimeRange.start,
      date,
    );
    final duration = event.dateTimeRange.duration;
    final endTime = newStartTime.add(duration);
    final newRange = DateTimeRange(start: newStartTime, end: endTime);

    // Update the event with the new start time.
    final updatedEvent = event.copyWith(dateTimeRange: newRange);

    return updatedEvent;
  }

  CalendarEvent<T>? _resizeEvent(ResizeEvent<T> resizeEvent, Offset offset) {
    // Calculate the date of the cursor.
    final date = _calculateCursorDate(offset);
    if (date == null) return null;

    final event = resizeEvent.event;

    DateTimeRange range;
    if (resizeEvent.direction == ResizeDirection.left) {
      final newStartTime = _calculateStartTime(event.dateTimeRange.start, date);
      range = calculateDateTimeRangeFromStart(event.dateTimeRange, newStartTime);
    } else if (resizeEvent.direction == ResizeDirection.right) {
      final newEndTime = _calculateStartTime(event.dateTimeRange.end, date);
      range = calculateDateTimeRangeFromEnd(event.dateTimeRange, newEndTime);
    } else {
      throw Exception('Invalid resize direction.');
    }

    return resizeEvent.event.copyWith(dateTimeRange: range);
  }
}
