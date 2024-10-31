import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';

import 'package:kalender/src/models/mixins/drag_target_utils.dart';
import 'package:kalender/src/models/mixins/snap_points.dart';
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

class _DayDragTargetState<T extends Object?> extends State<DayDragTarget<T>> with SnapPoints, DragTargetUtilities<T> {
  @override
  EventsController<T> get eventsController => widget.eventsController;
  @override
  CalendarController<T> get controller => widget.calendarController;
  @override
  List<DateTime> get visibleDates => visibleDateTimeRange.days;
  @override
  CalendarCallbacks<T>? get callbacks => widget.callbacks;
  @override
  double get dayWidth => widget.dayWidth;
  @override
  bool get multiDayDragTarget => false;

  MultiDayViewController<T> get viewController => widget.viewController;
  ScrollController get scrollController => widget.scrollController;
  TimeOfDayRange get timeOfDayRange => widget.timeOfDayRange;
  DateTimeRange get visibleDateTimeRange => viewController.visibleDateTimeRange.value;
  MultiDayBodyConfiguration get bodyConfiguration => widget.bodyConfiguration;
  double get heightPerMinute => widget.heightPerMinute;
  double get pageWidth => widget.pageWidth;
  double get viewPortHeight => widget.viewPortHeight;
  bool get showMultiDayEvents => bodyConfiguration.showMultiDayEvents;

  ValueNotifier<Size?> get feedbackWidgetSize => eventsController.feedbackWidgetSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewController.visibleEvents.addListener(_updateSnapPoints);
    });
  }

  /// Update the snap points.
  void _updateSnapPoints() {
    if (!bodyConfiguration.snapToOtherEvents) return;
    clearSnapPoints();
    addEventSnapPoints(viewController.visibleEvents.value);
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      hitTestBehavior: HitTestBehavior.translucent,
      onWillAcceptWithDetails: (details) {
        return onWillAcceptWithDetails(
          details,
          onResize: (event, direction) => direction.vertical,
          onReschedule: (event) {
            final eventDuration = event.duration;
            // Check if the event will fit within the time of day range.
            if (!timeOfDayRange.isAllDay && event.duration > timeOfDayRange.duration) return false;
            // Check if the event is a multi day event.
            if (!showMultiDayEvents && event.isMultiDayEvent) return false;
            // Calculate the size of the feedback widget.
            final eventHeight = eventDuration.inMinutes * heightPerMinute;
            // Set the size of the feedback widget.
            feedbackWidgetSize.value = Size(dayWidth, eventHeight);
            // Select the event as an internal one.
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

        final pageTriggerSetup = bodyConfiguration.pageTriggerConfiguration;
        final triggerWidth = pageWidth / 50;
        final pageAnimationDuration = pageTriggerSetup.animationDuration;
        final pageTriggerDelay = pageTriggerSetup.triggerDelay;
        final pageAnimationCurve = pageTriggerSetup.animationCurve;

        final rightTrigger = NavigationTrigger(
          triggerDelay: pageTriggerDelay,
          onTrigger: () {
            viewController.animateToNextPage(duration: pageAnimationDuration, curve: pageAnimationCurve);
          },
          child: widget.rightPageTrigger?.call(pageWidth) ?? SizedBox(width: triggerWidth, height: viewPortHeight),
        );

        final leftTrigger = NavigationTrigger(
          triggerDelay: pageTriggerDelay,
          onTrigger: () {
            viewController.animateToPreviousPage(duration: pageAnimationDuration, curve: pageAnimationCurve);
          },
          child: widget.leftPageTrigger?.call(pageWidth) ?? SizedBox(width: triggerWidth, height: viewPortHeight),
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
          child: widget.topScrollTrigger?.call(viewPortHeight) ?? SizedBox(height: triggerHeight, width: pageWidth),
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
          child: widget.bottomScrollTrigger?.call(viewPortHeight) ?? SizedBox(height: triggerHeight, width: pageWidth),
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

  @override
  DateTime? calculateCursorDateTime(
    Offset offset, {
    Offset feedbackWidgetOffset = Offset.zero,
  }) {
    final localCursorPosition = calculateLocalCursorPosition(
      offset,
      feedbackWidgetOffset: feedbackWidgetOffset,
      scrollOffset: Offset(0, scrollController.offset),
    );
    if (localCursorPosition == null) return null;

    // Calculate only the date of the cursor from the local cursor position.
    final cursorDateIndex = (localCursorPosition.dx / dayWidth).floor();
    if (cursorDateIndex < 0) return null;
    final date = visibleDates.elementAtOrNull(cursorDateIndex);
    final cursorDate = date;
    if (cursorDate == null) return null;

    // Calculate the start of the day.
    final startOfDate = timeOfDayRange.start.toDateTime(cursorDate);

    // Calculate the duration to add to the startOfDate.
    final durationFromStart = localCursorPosition.dy ~/ heightPerMinute;
    final snapIntervalMinutes = bodyConfiguration.snapIntervalMinutes;
    final numberOfIntervals = (durationFromStart / snapIntervalMinutes).round();
    final duration = Duration(minutes: snapIntervalMinutes * numberOfIntervals);

    return startOfDate.add(duration).asLocal();
  }

  /// Update the [CalendarEvent] based on the [Offset] delta.
  @override
  CalendarEvent<T>? rescheduleEvent(CalendarEvent<T> event, DateTime cursorDateTime) {
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
    final canUseEndSnapPoint = startSnapPoint == null && endSnapPoint != null && endSnapPoint.isAfter(start);
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

  /// Update the [CalendarEvent] based on the [direction] and [cursorDateTime] delta.
  @override
  CalendarEvent<T>? resizeEvent(CalendarEvent<T> event, ResizeDirection direction, DateTime cursorDateTime) {
    //TODO: decide if this is valid, maybe it could resize the event anyways ?.
    if (!direction.vertical) return null;

    DateTimeRange dateTimeRange;
    if (direction == ResizeDirection.top) {
      dateTimeRange = calculateDateTimeRangeFromStart(event.dateTimeRange, cursorDateTime);
    } else if (direction == ResizeDirection.bottom) {
      dateTimeRange = calculateDateTimeRangeFromEnd(event.dateTimeRange, cursorDateTime);
    } else {
      throw Exception('Invalid resize direction.');
    }

    return event.copyWith(dateTimeRange: dateTimeRange.asLocal);
  }

  @override
  CalendarEvent<T>? createEvent(DateTime cursorDateTime) {
    // TODO: take the day time range into account.

    final event = super.createEvent(cursorDateTime);
    if (event == null) return null;

    var range = newEvent!.dateTimeRange;

    if (cursorDateTime.isAfter(range.start)) {
      range = DateTimeRange(start: range.start, end: cursorDateTime);
    } else if (cursorDateTime.isBefore(range.start)) {
      range = DateTimeRange(start: cursorDateTime, end: range.start);
    }

    return event.copyWith(dateTimeRange: range.asLocal);
  }
}
