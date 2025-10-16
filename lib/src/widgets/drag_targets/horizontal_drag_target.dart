import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/internal_components/cursor_navigation_trigger.dart';

/// A [StatefulWidget] that provides a [DragTarget] for [Draggable] widgets containing a [Create], [Resize], [Reschedule] object.
///
/// The [HorizontalDragTarget] specializes in accepting [Draggable] widgets for a multi day header / month body.
class HorizontalDragTarget<T extends Object?> extends StatefulWidget {
  final PageTriggerConfiguration pageTriggerSetup;
  final DateTimeRange visibleDateTimeRange;
  final double dayWidth;
  final double pageWidth;
  final double tileHeight;
  final HorizontalConfiguration<T> configuration;

  final HorizontalTriggerWidgetBuilder? leftPageTrigger;
  final HorizontalTriggerWidgetBuilder? rightPageTrigger;

  const HorizontalDragTarget({
    super.key,
    required this.pageTriggerSetup,
    required this.visibleDateTimeRange,
    required this.dayWidth,
    required this.pageWidth,
    required this.tileHeight,
    required this.configuration,
    required this.leftPageTrigger,
    required this.rightPageTrigger,
  });

  @override
  State<HorizontalDragTarget<T>> createState() => _HorizontalDragTargetState<T>();

  /// The default implementation for [onWillAcceptWithDetails] for a vertical drag target.
  /// This can be overridden by providing a custom implementation via [CalendarCallbacks.onWillAcceptWithDetailsHorizontal].
  ///
  /// By default the drag target will only accept draggables that are of type [Create], [Resize], or [Reschedule].
  /// The checks performed for each are detailed in the respective sections below.
  static bool onWillAcceptWithDetails<T>(
    DragTargetDetails<Object?> details,
    CalendarController<T> controller,
    HorizontalConfiguration configuration,
  ) {
    return DragTargetUtilities.handleDragDetails<bool, T>(
      details,
      onCreate: (controllerId) => controllerId == controller.id,
      onResize: (event, direction) => direction.horizontal,
      onReschedule: (event) {
        if (configuration.allowSingleDayEvents) return false;

        return true;
      },
      onOther: () => false,
    );
  }
}

class _HorizontalDragTargetState<T extends Object?> extends State<HorizontalDragTarget<T>> with DragTargetUtilities<T> {
  @override
  EventsController<T> get eventsController => context.eventsController<T>();
  @override
  CalendarController<T> get controller => context.calendarController<T>();
  @override
  double get dayWidth => widget.dayWidth;
  @override
  CalendarCallbacks<T>? get callbacks => context.callbacks<T>();
  @override
  List<DateTime> get visibleDates => visibleDateTimeRange.dates();
  @override
  bool get multiDayDragTarget => true;

  ViewController<T> get viewController => controller.viewController!;
  TileComponents<T> get tileComponents => context.tileComponents<T>();
  DateTimeRange get visibleDateTimeRange => widget.visibleDateTimeRange;
  PageTriggerConfiguration get pageTrigger => widget.pageTriggerSetup;

  double get pageWidth => widget.pageWidth;
  double get tileHeight => widget.tileHeight;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAcceptWithDetails: (details) {
        final correctType = DragTargetUtilities.handleDragDetails<bool, T>(
          details,
          onCreate: (controllerId) => true,
          onResize: (event, direction) => true,
          onReschedule: (event) => true,
          onOther: () => false,
        );

        if (!correctType) {
          debugPrint(
            'HorizontalDragTarget: cannot use details: $details because of unknown data type',
          );
          return false;
        }

        // First test if the details can be accepted at all.
        final accepted =
            callbacks?.onWillAcceptWithDetailsHorizontal?.call(details, controller, widget.configuration) ??
                HorizontalDragTarget.onWillAcceptWithDetails<T>(details, controller, widget.configuration);
        if (!accepted) return accepted;

        return onWillAcceptWithDetails(
          details,
          onResize: (event, direction) => direction.horizontal,
          onReschedule: (event) {
            // Set the size of the feedback widget.
            context.feedbackWidgetSizeNotifier<T>().value =
                Size(min(pageWidth, dayWidth * event.datesSpanned.length), tileHeight);

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

    final date = Directionality.of(context) == TextDirection.ltr
        ? visibleDates.elementAtOrNull(cursorDateIndex)
        : visibleDates.elementAtOrNull(visibleDates.length - cursorDateIndex - 1);

    return date;
  }

  @override
  CalendarEvent<T>? rescheduleEvent(CalendarEvent<T> event, DateTime cursorDateTime) {
    // Calculate the new dateTimeRange for the event.
    final start = event.dateTimeRangeAsUtc.start;
    final newStartTime = cursorDateTime.copyWith(
      hour: start.hour,
      minute: start.minute,
      second: start.second,
      millisecond: start.millisecond,
      microsecond: start.microsecond,
    );
    final duration = event.dateTimeRangeAsUtc.duration;
    final endTime = newStartTime.add(duration);
    final newRange = DateTimeRange(start: newStartTime, end: endTime);

    print(newRange);

    // Update the event with the new start time.
    final updatedEvent = event.copyWith(dateTimeRange: newRange.asLocal);

    return updatedEvent;
  }

  @override
  CalendarEvent<T>? resizeEvent(CalendarEvent<T> event, ResizeDirection direction, DateTime cursorDateTime) {
    final range = switch (direction) {
      ResizeDirection.left => calculateDateTimeRangeFromStart(event.dateTimeRangeAsUtc, cursorDateTime),
      ResizeDirection.right => calculateDateTimeRangeFromEnd(event.dateTimeRangeAsUtc, cursorDateTime.endOfDay),
      _ => null
    };
    if (range == null) return null;
    return event.copyWith(dateTimeRange: range.asLocal);
  }

  @override
  CalendarEvent<T>? createEvent(DateTime cursorDateTime) {
    final event = super.createEvent(cursorDateTime);
    if (event == null) return null;

    var range = newEvent!.dateTimeRangeAsUtc;

    if ((cursorDateTime.isSameDay(range.start) || cursorDateTime.isSameDay(range.end)) ||
        cursorDateTime.isAfter(range.start)) {
      range = DateTimeRange(start: range.start.startOfDay, end: cursorDateTime.endOfDay);
    } else if (cursorDateTime.isBefore(range.start)) {
      range = DateTimeRange(start: cursorDateTime, end: range.start.endOfDay);
    }

    return event.copyWith(dateTimeRange: range.asLocal);
  }
}
