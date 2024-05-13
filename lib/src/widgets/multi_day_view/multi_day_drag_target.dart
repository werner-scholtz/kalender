import 'package:flutter/material.dart';

import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/providers/multi_day_body_provider.dart';
import 'package:kalender/src/models/time_of_day_range.dart';
import 'package:kalender/src/models/view_configurations/export.dart';
import 'package:kalender/src/widgets/components/navigation_trigger.dart';
import 'package:kalender/src/widgets/multi_day_view/multi_day_body.dart';

/// A [StatefulWidget] that provides a [DragTarget] for [CalendarEvent]s on a [MultiDayBody].
class MultiDayDragTarget<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;

  final MultiDayViewController<T> viewController;

  final ValueNotifier<CalendarEvent<T>?> eventBeingDragged;

  final MultiDayBodyCallbacks<T>? callbacks;

  /// Creates a [MultiDayDragTarget].
  const MultiDayDragTarget({
    super.key,
    required this.eventsController,
    required this.viewController,
    required this.eventBeingDragged,
    required this.callbacks,
  });

  @override
  State<MultiDayDragTarget<T>> createState() => _MultiDayDragTargetState<T>();
}

class _MultiDayDragTargetState<T extends Object?>
    extends State<MultiDayDragTarget<T>> {
  /// The [MultiDayBodyProvider] of the current context.
  MultiDayBodyProvider get provider => MultiDayBodyProvider.of(context);
  double get dayWidth => provider.dayWidth;
  double get heightPerMinute => provider.heightPerMinute;
  double get pageWidth => provider.pageWidth;
  ScrollController get scrollController => provider.scrollController;
  TimeOfDayRange get timeOfDayRange => provider.timeOfDayRange;
  DateTimeRange get visibleDateTimeRange => provider.visibleDateTimeRange.value;
  List<DateTime> get visibleDates => visibleDateTimeRange.datesSpanned;
  MultiDayViewConfiguration get viewConfiguration => provider.viewConfiguration;

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
    final snapIntervalMinutes = provider.viewConfiguration.snapIntervalMinutes;
    final numberOfIntervals = (durationFromStart / snapIntervalMinutes).round();
    final duration = Duration(minutes: snapIntervalMinutes * numberOfIntervals);

    // Calculate the start time.
    var startTime = startOfDate.add(duration);
    if (!timeOfDayRange.isAllDay) {
      startTime = _clampDateTime(date, startTime, eventDuration);
    }

    return startTime;
  }

  CalendarEvent<T> updateEvent(CalendarEvent<T> event, DateTime newStartTime) {
    final duration = event.dateTimeRange.duration;
    final endTime = newStartTime.add(duration);
    final newRange = DateTimeRange(start: newStartTime, end: endTime);

    // Update the event with the new range.
    final updatedEvent = event.copyWith(dateTimeRange: newRange);

    return updatedEvent;
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

  @override
  Widget build(BuildContext context) {
    return DragTarget<CalendarEvent<T>>(
      hitTestBehavior: HitTestBehavior.translucent,
      onWillAcceptWithDetails: (details) {
        final event = details.data;
        final eventDuration = event.duration;

        // Check if the event will fit within the time of day range.
        if (event.duration > timeOfDayRange.duration) return false;

        // Find the global position of the drop target widget.
        final renderObject = context.findRenderObject()! as RenderBox;
        final globalPosition = renderObject.localToGlobal(Offset.zero);

        widgetPosition = globalPosition;

        // Calculate the size of the feedback widget.
        final eventHeight = eventDuration.inMinutes * heightPerMinute;

        // Set the size of the feedback widget.
        provider.dropTargetWidgetSize.value = Size(dayWidth, eventHeight);

        return true;
      },
      onMove: (details) {
        // Calculate the relative cursor position.
        final cursorPosition = _calculateRelativeCursorPosition(details.offset);
        if (cursorPosition == null) return;

        // Calculate the date of the cursor.
        final date = _calculateCursorDate(cursorPosition);
        if (date == null) return;

        final event = details.data;

        // Calculate the start time of the event.
        final startTime = _calculateStartTime(
          date,
          event.duration,
          cursorPosition,
        );

        // Update the event with the new start time.
        final updatedEvent = updateEvent(details.data, startTime);

        // Update the event being dragged.
        widget.eventBeingDragged.value = updatedEvent;
      },
      onLeave: (data) {
        widgetPosition = null;
        widget.eventBeingDragged.value = null;
      },
      onAcceptWithDetails: (details) {
        // Calculate the relative cursor position.
        final cursorPosition = _calculateRelativeCursorPosition(details.offset);
        if (cursorPosition == null) return;

        // Calculate the date of the cursor.
        final date = _calculateCursorDate(cursorPosition);
        if (date == null) return;

        final event = details.data;

        // Calculate the start time of the event.
        final startTime = _calculateStartTime(
          date,
          event.duration,
          cursorPosition,
        );

        // Update the event with the new start time.
        final updatedEvent = updateEvent(event, startTime);

        // Update the event in the events controller.
        widget.eventsController.updateEvent(
          event: event,
          updatedEvent: updatedEvent,
        );

        widgetPosition = null;
        widget.eventsController.feedbackWidgetSize.value = Size.zero;
        widget.eventBeingDragged.value = null;
      },
      builder: (context, candidateData, rejectedData) {
        // Check if the candidateData is null.
        if (candidateData.firstOrNull == null) return const SizedBox();

        final pageTriggerSetup = provider.pageTriggerConfiguration;
        final triggerWidth = pageTriggerSetup.triggerWidth.call(pageWidth);
        final pageAnimationDuration = pageTriggerSetup.animationDuration;
        final pageTriggerDelay = pageTriggerSetup.triggerDelay;
        final pageAnimationCurve = pageTriggerSetup.animationCurve;

        final rightTrigger = NavigationTrigger(
          triggerDelay: pageTriggerDelay,
          onTrigger: () {
            widget.viewController.animateToNextPage(
              duration: pageAnimationDuration,
              curve: pageAnimationCurve,
            );
          },
          child: pageTriggerSetup.rightTriggerWidget,
        );

        final leftTrigger = NavigationTrigger(
          triggerDelay: pageTriggerDelay,
          onTrigger: () {
            widget.viewController.animateToPreviousPage(
              duration: pageAnimationDuration,
              curve: pageAnimationCurve,
            );
          },
          child: pageTriggerSetup.leftTriggerWidget,
        );

        final scrollTriggerSetup = provider.scrollTriggerConfiguration;
        final triggerHeight =
            scrollTriggerSetup.triggerHeight.call(provider.viewportHeight);
        final scrollTriggerDelay = scrollTriggerSetup.triggerDelay;
        final scrollAnimationDuration = scrollTriggerSetup.animationDuration;
        final scrollAnimationCurve = scrollTriggerSetup.animationCurve;

        final topScrollTrigger = NavigationTrigger(
          triggerDelay: scrollTriggerDelay,
          onTrigger: () {
            scrollController.animateTo(
              scrollController.offset - triggerHeight,
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
              scrollController.offset + triggerHeight,
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
