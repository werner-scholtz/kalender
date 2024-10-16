import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';

import 'package:kalender/src/models/mixins/drag_target_utils.dart';
import 'package:kalender/src/models/mixins/snap_points.dart';
import 'package:kalender/src/models/resize_event.dart';
import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/widgets/internal_components/navigation_trigger.dart';

// TODO: more detailed documentation.
// Consider moving the logic into a separate class.

/// A [StatefulWidget] that provides a [DragTarget] for [CalendarEvent]s on a [MultiDayBody].
class DayDragTarget<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final MultiDayViewController<T> viewController;

  final ScrollController scrollController;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;
  final MultiDayBodyConfiguration bodyConfiguration;

  final TimeOfDayRange timeOfDayRange;
  final double pageWidth;
  final double dayWidth;
  final double viewPortHeight;
  final double heightPerMinute;

  final HorizontalTriggerWidgetBuilder? leftPageTrigger;
  final HorizontalTriggerWidgetBuilder? rightPageTrigger;
  final VerticalTriggerWidgetBuilder? topScrollTrigger;
  final VerticalTriggerWidgetBuilder? bottomScrollTrigger;

  /// Creates a [DayDragTarget].
  const DayDragTarget({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.viewController,
    required this.scrollController,
    required this.callbacks,
    required this.tileComponents,
    required this.bodyConfiguration,
    required this.timeOfDayRange,
    required this.pageWidth,
    required this.dayWidth,
    required this.viewPortHeight,
    required this.heightPerMinute,
    required this.leftPageTrigger,
    required this.rightPageTrigger,
    required this.topScrollTrigger,
    required this.bottomScrollTrigger,
  });

  @override
  State<DayDragTarget<T>> createState() => _DayDragTargetState<T>();
}

class _DayDragTargetState<T extends Object?> extends State<DayDragTarget<T>>
    with SnapPoints, DragTargetUtils {
  EventsController<T> get eventsController => widget.eventsController;
  CalendarController<T> get controller => widget.calendarController;
  MultiDayViewController<T> get viewController => widget.viewController;
  ScrollController get scrollController => widget.scrollController;
  TimeOfDayRange get timeOfDayRange => widget.timeOfDayRange;
  DateTimeRange get visibleDateTimeRange => viewController.visibleDateTimeRange.value;
  List<DateTime> get visibleDates => visibleDateTimeRange.days;
  MultiDayBodyConfiguration get bodyConfiguration => widget.bodyConfiguration;
  CalendarCallbacks<T>? get callbacks => widget.callbacks;

  double get dayWidth => widget.dayWidth;
  double get heightPerMinute => widget.heightPerMinute;
  double get pageWidth => widget.pageWidth;
  double get viewPortHeight => widget.viewPortHeight;
  bool get showMultiDayEvents => bodyConfiguration.showMultiDayEvents;

  ValueNotifier<Size?> get feedbackWidgetSize => eventsController.feedbackWidgetSize;
  MultiDayViewConfiguration get viewConfiguration => viewController.viewConfiguration;

  /// The position of the widget.
  Offset? widgetPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewController.visibleEvents.addListener(_updateSnapPoints);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      hitTestBehavior: HitTestBehavior.translucent,
      onWillAcceptWithDetails: _onWillAcceptWithDetails,
      onMove: _onMove,
      onAcceptWithDetails: _onAcceptWithDetails,
      onLeave: _onLeave,
      builder: (context, candidateData, rejectedData) {
        // Check if the candidateData is null.
        if (candidateData.firstOrNull == null) return const SizedBox();

        final pageTriggerSetup = bodyConfiguration.pageTriggerConfiguration;
        final triggerWidth = pageWidth / 50;
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
          child: widget.rightPageTrigger?.call(pageWidth) ??
              SizedBox(width: triggerWidth, height: viewPortHeight),
        );

        final leftTrigger = NavigationTrigger(
          triggerDelay: pageTriggerDelay,
          onTrigger: () {
            viewController.animateToPreviousPage(
              duration: pageAnimationDuration,
              curve: pageAnimationCurve,
            );
          },
          child: widget.leftPageTrigger?.call(pageWidth) ??
              SizedBox(width: triggerWidth, height: viewPortHeight),
        );

        final scrollTriggerSetup = bodyConfiguration.scrollTriggerConfiguration;
        final triggerHeight = scrollTriggerSetup.triggerHeight.call(viewPortHeight);
        final scrollTriggerDelay = scrollTriggerSetup.triggerDelay;
        final scrollAnimationDuration = scrollTriggerSetup.animationDuration;
        final scrollAnimationCurve = scrollTriggerSetup.animationCurve;
        final scrollAmount = scrollTriggerSetup.scrollAmount.call(viewPortHeight);

        final topScrollTrigger = NavigationTrigger(
          triggerDelay: scrollTriggerDelay,
          onTrigger: () {
            scrollController.animateTo(
              scrollController.offset - scrollAmount,
              duration: scrollAnimationDuration,
              curve: scrollAnimationCurve,
            );
          },
          child: widget.topScrollTrigger?.call(viewPortHeight) ??
              SizedBox(height: triggerHeight, width: pageWidth),
        );

        final bottomScrollTrigger = NavigationTrigger(
          triggerDelay: scrollTriggerDelay,
          onTrigger: () {
            scrollController.animateTo(
              scrollController.offset + scrollAmount,
              duration: scrollAnimationDuration,
              curve: scrollAnimationCurve,
            );
          },
          child: widget.bottomScrollTrigger?.call(viewPortHeight) ??
              SizedBox(height: triggerHeight, width: pageWidth),
        );

        return Stack(
          children: [
            PositionedDirectional(
              start: 0,
              end: 0,
              child: topScrollTrigger,
            ),
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              child: bottomScrollTrigger,
            ),
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              child: leftTrigger,
            ),
            PositionedDirectional(
              end: 0,
              top: 0,
              bottom: 0,
              child: rightTrigger,
            ),
          ],
        );
      },
    );
  }

  bool _onWillAcceptWithDetails(DragTargetDetails<Object> details) {
    final data = details.data;
    if (data is CalendarEvent<T>) {
      // Handle the rescheduling of the event.

      final eventDuration = data.duration;

      // Check if the event will fit within the time of day range.
      if (!timeOfDayRange.isAllDay && data.duration > timeOfDayRange.duration) return false;

      // Check if the event is a multi day event.
      if (!showMultiDayEvents && data.isMultiDayEvent) return false;

      // Calculate the size of the feedback widget.
      final eventHeight = eventDuration.inMinutes * heightPerMinute;

      // Set the size of the feedback widget.
      feedbackWidgetSize.value = Size(dayWidth, eventHeight);

      _updateWidgetPosition();

      controller.selectEvent(data, internal: true);
      return true;
    } else if (data is ResizeEvent<T>) {
      // Check that the resize direction is either top or bottom.
      if (data.direction != ResizeDirection.top && data.direction != ResizeDirection.bottom) {
        return false;
      }

      _updateWidgetPosition();
      return true;
    } else {
      return false;
    }
  }

  void _onMove(DragTargetDetails<Object> details) {
    if (details.data is CalendarEvent<T>) {
      // Handle the rescheduling of the event.
      final event = details.data as CalendarEvent<T>;

      final updatedEvent = _rescheduleEvent(event, details.offset);
      if (updatedEvent == null) return;

      // Update the event being dragged.
      controller.updateEvent(updatedEvent, internal: true);
    } else if (details.data is ResizeEvent<T>) {
      final resizeEvent = details.data as ResizeEvent<T>;

      final updatedEvent = _resizeEvent(resizeEvent, details.offset);
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

    widgetPosition = null;
    eventsController.feedbackWidgetSize.value = Size.zero;
    controller.deselectEvent();

    callbacks?.onEventChanged?.call(originalEvent, updatedEvent);
  }

  void _onLeave(Object? data) {
    widgetPosition = null;
    controller.deselectEvent();
  }

  /// Calculate the [DateTime] of the cursor.
  DateTime? _calculateCursorDateTime(
    Offset offset, {
    Offset feedbackWidgetOffset = Offset.zero,
  }) {
    final cursorPosition = _calculateRelativeCursorPosition(
      offset,
      feedbackWidgetOffset: feedbackWidgetOffset,
    );
    if (cursorPosition == null) return null;

    final cursorDate = _calculateCursorDate(cursorPosition);
    if (cursorDate == null) return null;

    // Calculate the start of the day.
    final startOfDate = timeOfDayRange.start.toDateTime(cursorDate);

    // Calculate the duration to add to the startOfDate.
    final durationFromStart = cursorPosition.dy ~/ heightPerMinute;
    final snapIntervalMinutes = bodyConfiguration.snapIntervalMinutes;
    final numberOfIntervals = (durationFromStart / snapIntervalMinutes).round();
    final duration = Duration(minutes: snapIntervalMinutes * numberOfIntervals);

    return startOfDate.add(duration).asLocal();
  }

  /// Calculate the date of the cursor.
  DateTime? _calculateCursorDate(Offset cursorPosition) {
    // Calculate the date of the cursor.
    final cursorDate = (cursorPosition.dx / dayWidth);
    final cursorDateIndex = cursorDate.floor();
    if (cursorDateIndex < 0) return null;
    final date = visibleDates.elementAtOrNull(cursorDateIndex);
    return date;
  }

  /// Calculate the relative cursor position.
  Offset? _calculateRelativeCursorPosition(
    Offset cursorPosition, {
    Offset feedbackWidgetOffset = Offset.zero,
  }) {
    if (widgetPosition == null) return null;

    // Current scroll offset.
    final scrollOffset = Offset(0, scrollController.offset);
    // print(scrollOffset);

    // Calculate the position of the cursor relative to the current widget.
    final relativeCursorPosition =
        cursorPosition + feedbackWidgetOffset + scrollOffset - widgetPosition!;

    print(relativeCursorPosition);

    return relativeCursorPosition;
  }

  /// Update the [CalendarEvent] based on the [Offset] delta.
  CalendarEvent<T>? _rescheduleEvent(CalendarEvent<T> event, Offset offset) {
    final cursorDateTime = _calculateCursorDateTime(
      offset,
      feedbackWidgetOffset: Offset(dayWidth / 2, 0),
    );
    if (cursorDateTime == null) return null;

    DateTime start;

    if (timeOfDayRange.isAllDay) {
      start = cursorDateTime;
    } else {
      final startOfDate = timeOfDayRange.start.toDateTime(cursorDateTime);
      final endOfDate = timeOfDayRange.end.toDateTime(cursorDateTime);
      if (cursorDateTime.isBefore(startOfDate)) {
        start = startOfDate;
      } else if (cursorDateTime.add(event.duration).isAfter(endOfDate)) {
        start = endOfDate.subtract(event.duration);
      } else {
        start = cursorDateTime;
      }
    }

    // Calculate the new dateTimeRange for the event.
    final duration = event.dateTimeRange.duration;
    var end = start.add(duration);

    // Add now to the snap points.
    late final now = DateTime.now();
    if (bodyConfiguration.snapToTimeIndicator) addSnapPoint(now);

    // Find the index of the snap point that is within a duration of snapRange of the start.
    final startSnapPoint = findSnapPoint(start, bodyConfiguration.snapRange);
    if (startSnapPoint != null && startSnapPoint.isBefore(end)) {
      start = startSnapPoint;
      end = start.add(duration);
    }

    // Find the index of the snap point that is within a duration of snapRange of the end.
    late final endSnapPoint = findSnapPoint(end, bodyConfiguration.snapRange);
    final canUseEndSnapPoint =
        startSnapPoint == null && endSnapPoint != null && endSnapPoint.isAfter(start);
    if (canUseEndSnapPoint) {
      // Calculate the new end time.
      end = endSnapPoint;
      start = end.subtract(duration);
    }

    // Update the event with the new range.
    final newRange = DateTimeRange(start: start, end: end);
    final updatedEvent = event.copyWith(dateTimeRange: newRange.asLocal);

    // Remove now from the snap points.
    if (bodyConfiguration.snapToTimeIndicator) removeSnapPoint(now);

    return updatedEvent;
  }

  /// Update the [ResizeEvent] based on the [Offset] delta.
  CalendarEvent<T>? _resizeEvent(ResizeEvent<T> resizeEvent, Offset offset) {
    // Calculate the start time of the event.
    final cursorDateTime = _calculateCursorDateTime(offset);
    if (cursorDateTime == null) return null;

    final event = resizeEvent.event;

    DateTimeRange dateTimeRange;
    if (resizeEvent.direction == ResizeDirection.top) {
      dateTimeRange = calculateDateTimeRangeFromStart(event.dateTimeRange, cursorDateTime);
    } else if (resizeEvent.direction == ResizeDirection.bottom) {
      dateTimeRange = calculateDateTimeRangeFromEnd(event.dateTimeRange, cursorDateTime);
    } else {
      throw Exception('Invalid resize direction.');
    }

    return resizeEvent.event.copyWith(dateTimeRange: dateTimeRange.asLocal);
  }

  /// Update the snap points.
  void _updateSnapPoints() {
    if (!bodyConfiguration.snapToOtherEvents) return;
    clearSnapPoints();
    addEventSnapPoints(viewController.visibleEvents.value);
  }

  void _updateWidgetPosition() {
    // Find the global position of the drop target widget.
    final renderObject = context.findRenderObject()! as RenderBox;
    final globalPosition = renderObject.localToGlobal(Offset.zero);
    widgetPosition = globalPosition;
  }
}
