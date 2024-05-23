import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/mixins/snap_points.dart';
import 'package:kalender/src/widgets/components/navigation_trigger.dart';

/// A [StatefulWidget] that provides a [DragTarget] for [CalendarEvent]s on a [MultiDayBody].
class DayDragTarget<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final MultiDayViewController<T> viewController;
  final ScrollController scrollController;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;
  final ValueNotifier<CalendarEvent<T>?> eventBeingDragged;
  final MultiDayBodyConfiguration bodyConfiguration;

  final TimeOfDayRange timeOfDayRange;
  final double pageWidth;
  final double dayWidth;
  final double viewPortHeight;
  final double heightPerMinute;

  /// Creates a [DayDragTarget].
  const DayDragTarget({
    super.key,
    required this.eventsController,
    required this.viewController,
    required this.scrollController,
    required this.callbacks,
    required this.tileComponents,
    required this.eventBeingDragged,
    required this.bodyConfiguration,
    required this.timeOfDayRange,
    required this.pageWidth,
    required this.dayWidth,
    required this.viewPortHeight,
    required this.heightPerMinute,
  });

  @override
  State<DayDragTarget<T>> createState() => _DayDragTargetState<T>();
}

class _DayDragTargetState<T extends Object?> extends State<DayDragTarget<T>>
    with SnapPoints {
  EventsController<T> get eventsController => widget.eventsController;
  MultiDayViewController<T> get viewController => widget.viewController;
  ScrollController get scrollController => widget.scrollController;
  TimeOfDayRange get timeOfDayRange => widget.timeOfDayRange;
  DateTimeRange get visibleDateTimeRange =>
      viewController.visibleDateTimeRange.value;
  List<DateTime> get visibleDates => visibleDateTimeRange.datesSpanned;
  MultiDayBodyConfiguration get bodyConfiguration => widget.bodyConfiguration;

  double get dayWidth => widget.dayWidth;
  double get heightPerMinute => widget.heightPerMinute;
  double get pageWidth => widget.pageWidth;
  double get viewPortHeight => widget.viewPortHeight;
  bool get showMultiDayEvents => bodyConfiguration.showMultiDayEvents;

  ValueNotifier<CalendarEvent<T>?> get eventBeingDragged =>
      viewController.eventBeingDragged;
  ValueNotifier<Size?> get feedbackWidgetSize =>
      eventsController.feedbackWidgetSize;
  MultiDayViewConfiguration get viewConfiguration =>
      viewController.viewConfiguration;

  /// The position of the widget.
  Offset? widgetPosition;

  /// Calculate the relative cursor position.
  Offset? _calculateRelativeCursorPosition(Offset cursorPosition) {
    if (widgetPosition == null) return null;

    // Calculate the widget offset.
    final feedbackWidgetOffset = Offset(dayWidth / 2, 0);
    final scrollOffset = Offset(0, scrollController.offset);

    // Calculate the position of the cursor relative to the current widget.
    final relativeCursorPosition =
        cursorPosition + feedbackWidgetOffset + scrollOffset - widgetPosition!;

    return relativeCursorPosition;
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

  /// Calculate the start time of the event.
  DateTime _calculateStartTime(
    DateTime date,
    Duration eventDuration,
    Offset cursorPosition,
  ) {
    // Calculate the start of the day.
    final startOfDate = timeOfDayRange.start.toDateTime(date);

    // Calculate the duration to add to the startOfDate.
    final durationFromStart = cursorPosition.dy ~/ heightPerMinute;
    final snapIntervalMinutes = bodyConfiguration.snapIntervalMinutes;
    final numberOfIntervals = (durationFromStart / snapIntervalMinutes).round();
    final duration = Duration(minutes: snapIntervalMinutes * numberOfIntervals);

    // Calculate the start time.
    var startTime = startOfDate.add(duration);
    if (!timeOfDayRange.isAllDay) {
      startTime = _clampDateTime(date, startTime, eventDuration);
    }

    return startTime;
  }

  /// Clamp the start time of the event, so it doesn't go outside the bounds of the day.
  DateTime _clampDateTime(
    DateTime date,
    DateTime startOfEvent,
    Duration eventDuration,
  ) {
    final startOfDate = timeOfDayRange.start.toDateTime(date);
    final endOfDate = timeOfDayRange.end.toDateTime(date);

    if (startOfEvent.isBefore(startOfDate)) {
      return startOfDate;
    } else if (startOfEvent.add(eventDuration).isAfter(endOfDate)) {
      return endOfDate.subtract(eventDuration);
    } else {
      return startOfEvent;
    }
  }

  CalendarEvent<T>? _updateEvent(CalendarEvent<T> event, Offset offset) {
    // Calculate the relative cursor position.
    final cursorPosition = _calculateRelativeCursorPosition(offset);
    if (cursorPosition == null) return null;

    // Calculate the date of the cursor.
    final date = _calculateCursorDate(cursorPosition);
    if (date == null) return null;

    // Calculate the start time of the event.
    var start = _calculateStartTime(
      date,
      event.duration,
      cursorPosition,
    );

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
    final canUseEndSnapPoint = startSnapPoint == null &&
        endSnapPoint != null &&
        endSnapPoint.isAfter(start);
    if (canUseEndSnapPoint) {
      // Calculate the new end time.
      end = endSnapPoint;
      start = end.subtract(duration);
    }

    // Update the event with the new range.
    final newRange = DateTimeRange(start: start, end: end);
    final updatedEvent = event.copyWith(dateTimeRange: newRange);

    // Remove now from the snap points.
    if (bodyConfiguration.snapToTimeIndicator) removeSnapPoint(now);

    return updatedEvent;
  }

  /// Update the snap points.
  void _updateSnapPoints() {
    if (!bodyConfiguration.snapToOtherEvents) return;
    clearSnapPoints();
    addEventSnapPoints(viewController.visibleEvents.value);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewController.visibleEvents.addListener(_updateSnapPoints);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<CalendarEvent<T>>(
      hitTestBehavior: HitTestBehavior.translucent,
      onWillAcceptWithDetails: (details) {
        final event = details.data;
        final eventDuration = event.duration;

        // Check if the event will fit within the time of day range.
        if (!timeOfDayRange.isAllDay &&
            event.duration > timeOfDayRange.duration) return false;

        if (!showMultiDayEvents && event.isMultiDayEvent) {
          return false;
        }

        // Find the global position of the drop target widget.
        final renderObject = context.findRenderObject()! as RenderBox;
        final globalPosition = renderObject.localToGlobal(Offset.zero);
        widgetPosition = globalPosition;

        // Calculate the size of the feedback widget.
        final eventHeight = eventDuration.inMinutes * heightPerMinute;

        // Set the size of the feedback widget.
        feedbackWidgetSize.value = Size(dayWidth, eventHeight);

        return true;
      },
      onMove: (details) {
        final event = details.data;
        // Update the event with the new start time.
        final updatedEvent = _updateEvent(event, details.offset);
        if (updatedEvent == null) return;

        // Update the event being dragged.
        eventBeingDragged.value = updatedEvent;

        // Update the dragging event id.
        viewController.draggingEventId = event.id;
      },
      onAcceptWithDetails: (details) {
        final event = details.data;

        // Update the event with the new start time.
        final updatedEvent = _updateEvent(event, details.offset);
        if (updatedEvent == null) return;

        // Update the event in the events controller.
        eventsController.updateEvent(
          event: event,
          updatedEvent: updatedEvent,
        );

        // Reset the widget position and feedback widget size.
        widgetPosition = null;
        eventsController.feedbackWidgetSize.value = Size.zero;

        // Reset the event being dragged.
        eventBeingDragged.value = null;
        viewController.draggingEventId = null;
      },
      onLeave: (data) {
        widgetPosition = null;
        eventBeingDragged.value = null;
        viewController.draggingEventId = null;
      },
      builder: (context, candidateData, rejectedData) {
        // Check if the candidateData is null.
        if (candidateData.firstOrNull == null) return const SizedBox();

        final pageTriggerSetup = bodyConfiguration.pageTriggerConfiguration;
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
          child: pageTriggerSetup.rightTriggerWidget,
        );

        final leftTrigger = NavigationTrigger(
          triggerDelay: pageTriggerDelay,
          onTrigger: () {
            viewController.animateToPreviousPage(
              duration: pageAnimationDuration,
              curve: pageAnimationCurve,
            );
          },
          child: pageTriggerSetup.leftTriggerWidget,
        );

        final scrollTriggerSetup = bodyConfiguration.scrollTriggerConfiguration;
        final triggerHeight =
            scrollTriggerSetup.triggerHeight.call(viewPortHeight);
        final scrollTriggerDelay = scrollTriggerSetup.triggerDelay;
        final scrollAnimationDuration = scrollTriggerSetup.animationDuration;
        final scrollAnimationCurve = scrollTriggerSetup.animationCurve;
        final scrollAmount =
            scrollTriggerSetup.scrollAmount.call(viewPortHeight);

        final topScrollTrigger = NavigationTrigger(
          triggerDelay: scrollTriggerDelay,
          onTrigger: () {
            scrollController.animateTo(
              scrollController.offset - scrollAmount,
              duration: scrollAnimationDuration,
              curve: scrollAnimationCurve,
            );
          },
          child: scrollTriggerSetup.topTriggerWidget,
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
          child: scrollTriggerSetup.bottomTriggerWidget,
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
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: triggerHeight,
              child: topScrollTrigger,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: triggerHeight,
              child: bottomScrollTrigger,
            ),
          ],
        );
      },
    );
  }
}
