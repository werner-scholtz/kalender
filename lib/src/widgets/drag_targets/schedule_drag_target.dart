import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/internal_components/cursor_navigation_trigger.dart' show CursorNavigationTrigger;

/// A [StatefulWidget] that provides a [DragTarget] for [Create], [Resize], [Reschedule] objects.
///
/// The [ScheduleDragTarget] specializes in accepting [Draggable] widgets for a multi day body.
class ScheduleDragTarget<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final CalendarCallbacks<T>? callbacks;
  final ScheduleViewController<T> viewController;
  final BoxConstraints constraints;
  final bool paginated;

  final PageTriggerConfiguration pageTriggerConfiguration;
  final HorizontalTriggerWidgetBuilder? leftPageTrigger;
  final HorizontalTriggerWidgetBuilder? rightPageTrigger;

  final ScrollTriggerConfiguration scrollTriggerConfiguration;
  final HorizontalTriggerWidgetBuilder? topScrollTrigger;
  final HorizontalTriggerWidgetBuilder? bottomScrollTrigger;

  /// Creates a [ScheduleDragTarget].
  const ScheduleDragTarget({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.callbacks,
    required this.viewController,
    required this.constraints,
    required this.paginated,
    required this.pageTriggerConfiguration,
    this.leftPageTrigger,
    this.rightPageTrigger,
    required this.scrollTriggerConfiguration,
    this.topScrollTrigger,
    this.bottomScrollTrigger,
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

  @override
  CalendarController<T> get controller => widget.calendarController;

  @override
  CalendarCallbacks<T>? get callbacks => widget.callbacks;

  @override
  bool get multiDayDragTarget => false;

  // The width of the page, used for cursor navigation.
  double get pageWidth => widget.constraints.maxWidth;

  // The height of the viewport, used for cursor navigation.
  double get viewPortHeight => widget.constraints.maxHeight;

  ScheduleViewController<T> get viewController => widget.viewController;

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

            context.feedbackWidgetSizeNotifier<T>().value = Size(dayWidth, height);
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

        final pageTrigger = widget.pageTriggerConfiguration;
        final scrollTrigger = widget.scrollTriggerConfiguration;

        late final triggerWidth = pageWidth / 50;
        late final rightTrigger = CursorNavigationTrigger(
          triggerDelay: pageTrigger.triggerDelay,
          onTrigger: () => viewController.animateToNextPage(
            duration: pageTrigger.animationDuration,
            curve: pageTrigger.animationCurve,
          ),
          child: widget.rightPageTrigger?.call(pageWidth) ?? SizedBox(width: triggerWidth, height: viewPortHeight),
        );

        late final leftTrigger = CursorNavigationTrigger(
          triggerDelay: pageTrigger.triggerDelay,
          onTrigger: () => viewController.animateToPreviousPage(
            duration: pageTrigger.animationDuration,
            curve: pageTrigger.animationCurve,
          ),
          child: widget.leftPageTrigger?.call(pageWidth) ?? SizedBox(width: triggerWidth, height: viewPortHeight),
        );

        final triggerHeight = scrollTrigger.triggerHeight?.call(viewPortHeight) ?? viewPortHeight / 20;
        final topScrollTrigger = CursorNavigationTrigger(
          triggerDelay: scrollTrigger.triggerDelay,
          onTrigger: () {
            if (!viewController.hasInitialized) return;

            final positions = viewController.itemPositionsListener!.itemPositions.value;
            if (positions.isEmpty) return;
            final first = positions.reduce((value, element) => value.index < element.index ? value : element).index;

            final targetIndex = first - 1;
            if (targetIndex < 0) return;

            viewController.itemScrollController!.scrollTo(
              index: targetIndex,
              duration: scrollTrigger.animationDuration,
              curve: scrollTrigger.animationCurve,
            );
          },
          child: widget.topScrollTrigger?.call(viewPortHeight) ?? SizedBox(height: triggerHeight, width: pageWidth),
        );

        final bottomScrollTrigger = CursorNavigationTrigger(
          triggerDelay: scrollTrigger.triggerDelay,
          onTrigger: () {
            if (!viewController.hasInitialized) return;

            final positions = viewController.itemPositionsListener!.itemPositions.value;
            if (positions.isEmpty) return;

            final last = positions.reduce((value, element) => value.index > element.index ? value : element).index;
            final targetIndex = last + 1;
            if (targetIndex >= viewController.itemCount) return;

            viewController.itemScrollController!.scrollTo(
              index: targetIndex,
              duration: scrollTrigger.animationDuration,
              curve: scrollTrigger.animationCurve,
            );
          },
          child: widget.bottomScrollTrigger?.call(viewPortHeight) ?? SizedBox(height: triggerHeight, width: pageWidth),
        );

        return Stack(
          children: [
            PositionedDirectional(start: 0, end: 0, child: topScrollTrigger),
            PositionedDirectional(start: 0, end: 0, bottom: 0, child: bottomScrollTrigger),
            if (widget.paginated) PositionedDirectional(start: 0, top: 0, bottom: 0, child: leftTrigger),
            if (widget.paginated) PositionedDirectional(end: 0, top: 0, bottom: 0, child: rightTrigger),
          ],
        );
      },
    );
  }

  @override
  DateTime? calculateCursorDateTime(Offset offset, {Offset feedbackWidgetOffset = Offset.zero}) {
    // Calculate the relative cursor position.
    final localCursorPosition = calculateLocalCursorPosition(offset);
    if (localCursorPosition == null) return null;

    // Find the item index based on the cursor position.
    final viewController = widget.viewController;
    if (!viewController.hasInitialized) return null;

    final itemPositions = viewController.itemPositionsListener!.itemPositions.value;
    final proportionalOffset = localCursorPosition.dy / widget.constraints.maxHeight;
    final itemIndex = itemPositions
        .where((item) => item.itemLeadingEdge <= proportionalOffset && item.itemTrailingEdge >= proportionalOffset)
        .map((item) => item.index)
        .firstOrNull;

    // If no item index is found, return null.
    if (itemIndex == null) return null;

    // Get the date for the item index.
    final date = viewController.dateTimeFromIndex(itemIndex);
    return date;
  }

  @override
  CalendarEvent<T>? rescheduleEvent(CalendarEvent<T> event, DateTime cursorDateTime) {
    final rangeAsUtc = event.internalRange(location: context.location);
    // Set the highlighted date in the schedule view controller.
    widget.viewController.highlightedDateTimeRange.value = DateTimeRange(
      start: cursorDateTime,
      end: cursorDateTime.add(rangeAsUtc.duration),
    );
    if (event.isMultiDayEvent) {
      final duration = rangeAsUtc.duration;
      final endTime = cursorDateTime.add(duration);
      final newRange = DateTimeRange(start: cursorDateTime, end: endTime);
      return event.copyWith(dateTimeRange: newRange);
    } else {
      // Calculate the new dateTimeRange for the event.
      final newStartTime = cursorDateTime;
      final duration = event.duration;
      final endTime = newStartTime.add(duration);
      final newRange = DateTimeRange(start: newStartTime, end: endTime);

      // Update the event with the new start time.
      // TODO: this as local needs to be investigated.
      final updatedEvent = event.copyWith(dateTimeRange: newRange.asLocal);
      return updatedEvent;
    }
  }

  @override
  void onAcceptWithDetails(DragTargetDetails<Object?> details) {
    super.onAcceptWithDetails(details);
    widget.viewController.highlightedDateTimeRange.value = null;
  }

  @override
  void onLeave(Object? details) {
    super.onLeave(details);
    widget.viewController.highlightedDateTimeRange.value = null;
  }

  @override
  CalendarEvent<T>? resizeEvent(CalendarEvent<T> event, ResizeDirection direction, DateTime cursorDateTime) => null;
}
