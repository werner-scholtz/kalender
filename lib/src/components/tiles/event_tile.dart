import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class EventGestureDetector<T> extends StatefulWidget {
  const EventGestureDetector({
    super.key,
    required this.event,
    required this.tileConfiguration,
    required this.visibleDateTimeRange,
    required this.isChanging,
    required this.heightPerMinute,
    required this.verticalStep,
    required this.horizontalStep,
    required this.snapPoints,
  });

  final CalendarEvent<T> event;
  final TileConfiguration tileConfiguration;

  final DateTimeRange visibleDateTimeRange;

  final bool isChanging;
  final double heightPerMinute;
  final double verticalStep;
  final double horizontalStep;
  final List<DateTime> snapPoints;

  @override
  State<EventGestureDetector<T>> createState() =>
      _EventGestureDetectorState<T>();
}

class _EventGestureDetectorState<T> extends State<EventGestureDetector<T>> {
  late final CalendarScope<T> scope = CalendarScope.of<T>(context);
  CalendarEventsController<T> get eventsController => scope.eventsController;

  late final CalendarComponents components =
      CalendarStyleProvider.of(context).components;

  MultiDayViewConfiguration get viewConfiguration =>
      scope.state.viewConfiguration as MultiDayViewConfiguration;

  List<DateTime> get snapPoints => widget.snapPoints;

  Duration get verticalStepDuration => viewConfiguration.verticalStepDuration;
  Duration get horizontalStepDuration =>
      viewConfiguration.horizontalStepDuration;
  Duration get verticalSnapRange => viewConfiguration.verticalSnapRange;

  bool get snapToTimeIndicator => viewConfiguration.timeIndicatorSnapping;
  bool get isMobileDevice => scope.platformData.isMobileDevice;
  bool get useMobileGestures => isMobileDevice && widget.event.canModify;
  bool get useDesktopGestures => !isMobileDevice && widget.event.canModify;

  int get startHour => viewConfiguration.startHour;
  int get endHour => viewConfiguration.endHour;

  late DateTimeRange initialDateTimeRange;

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  bool get canResize {
    final viewConfig = scope.state.viewConfiguration;
    if (viewConfig is MultiDayViewConfiguration) {
      return viewConfig.enableResizing;
    } else {
      return true;
    }
  }

  bool get canReschedule {
    final viewConfig = scope.state.viewConfiguration;
    if (viewConfig is MultiDayViewConfiguration) {
      return viewConfig.enableRescheduling;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    initialDateTimeRange = widget.event.dateTimeRange;
  }

  @override
  void didUpdateWidget(covariant EventGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.event != oldWidget.event) {
      initialDateTimeRange = widget.event.dateTimeRange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final handleSize = (constraints.maxHeight * 0.8).clamp(0.0, 16.0);

        // Get the onTap function.
        final onTap = _onTap;

        // Get the onPanStart, onPanUpdate, and onPanEnd functions.
        void Function(DragStartDetails details)? onPanStart;
        void Function(DragUpdateDetails details)? onPanUpdate;
        Future<void> Function(DragEndDetails details)? onPanEnd;
        if (useDesktopGestures && canReschedule) {
          onPanStart = _onPanStart;
          onPanUpdate = _onPanUpdate;
          onPanEnd = _onPanEnd;
        }

        // Get the onLongPressStart, onLongPressMoveUpdate, and onLongPressEnd functions.
        void Function(LongPressStartDetails details)? onLongPressStart;
        void Function(LongPressMoveUpdateDetails details)?
            onLongPressMoveUpdate;
        Future<void> Function(LongPressEndDetails details)? onLongPressEnd;
        if (useMobileGestures &&
            !eventsController.isResizingBottom &&
            !eventsController.isResizingTop &&
            canReschedule) {
          onLongPressStart = _onLongPressStart;
          onLongPressMoveUpdate = _onLongPressMoveUpdate;
          onLongPressEnd = _onLongPressEnd;
        }

        // Assign the resize buttons
        Widget? resizeTopWidget;
        Widget? resizeBottomWidget;

        // Check if the event can be modified and if the event is being rescheduled.
        if (widget.event.canModify &&
            !eventsController.isRescheduling &&
            canResize) {
          if (useDesktopGestures) {
            resizeBottomWidget = _resizeBottomDesktopWidget();
            resizeTopWidget = _resizeTopDesktopWidget();
          } else if (useMobileGestures && widget.isChanging) {
            // Assign the resize buttons to use mobile gestures.

            // Check if the event continues before the visible date range.
            if (!widget.tileConfiguration.continuesBefore) {
              resizeTopWidget = resizeTopMobileWidget(
                handleSize: handleSize,
                enabled: !eventsController.isResizingBottom,
              );
            }

            // Check if the event continues after the visible date range.
            if (!widget.tileConfiguration.continuesAfter) {
              resizeBottomWidget = resizeBottomMobileWidget(
                handleSize: handleSize,
                enabled: !eventsController.isResizingTop,
              );
            }
          }
        }

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            onPanStart: onPanStart,
            onPanUpdate: onPanUpdate,
            onPanEnd: (details) async => await onPanEnd?.call(details),
            onLongPressStart: onLongPressStart,
            onLongPressMoveUpdate: onLongPressMoveUpdate,
            onLongPressEnd: (details) async =>
                await onLongPressEnd?.call(details),
            child: Stack(
              fit: StackFit.expand,
              children: [
                scope.tileComponents.tileBuilder!(
                  widget.event,
                  widget.tileConfiguration,
                ),
                if (resizeTopWidget != null) resizeTopWidget,
                if (resizeBottomWidget != null) resizeBottomWidget,
              ],
            ),
          ),
        );
      },
    );
  }

  /// Handles the onTap event.
  Future<void> _onTap() async {
    await scope.functions.onEventTapped?.call(widget.event);
    scope.eventsController.forceUpdate();
  }

  /// Handles the onPanStart event.
  void _onPanStart(DragStartDetails details) {
    cursorOffset = Offset.zero;
    _onRescheduleStart();
  }

  /// Handles the onPanUpdate event.
  void _onPanUpdate(DragUpdateDetails details) {
    cursorOffset += details.delta;
    _onReschedule(cursorOffset);
  }

  /// Handles the onPanEnd event.
  Future<void> _onPanEnd(DragEndDetails details) async {
    await _onRescheduleEnd();
  }

  /// Handles the onLongPressStart event.
  void _onLongPressStart(LongPressStartDetails details) {
    _onRescheduleStart();
  }

  /// Handles the onLongPressMoveUpdate event.
  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _onReschedule(details.localOffsetFromOrigin);
  }

  /// Handles the onLongPressEnd event.
  Future<void> _onLongPressEnd(LongPressEndDetails details) async {
    await _onRescheduleEnd();
  }

  void _onVerticalDragStartTop(DragStartDetails details) {
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;

    initialDateTimeRange = widget.event.dateTimeRange;
    eventsController.selectEvent(widget.event);
    eventsController.isResizingTop = true;
  }

  void _onVerticalDragStartBottom(DragStartDetails details) {
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;

    initialDateTimeRange = widget.event.dateTimeRange;
    eventsController.selectEvent(widget.event);
    eventsController.isResizingBottom = true;
  }

  /// Handles the onVerticalDragStart event.
  void _onVerticalDragStart(DragStartDetails details) {
    initialDateTimeRange = widget.event.dateTimeRange;
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    eventsController.selectEvent(widget.event);
  }

  /// Handles the onVerticalDragUpdate event (Start).
  void _onVerticalDragUpdateTop(DragUpdateDetails details) {
    cursorOffset += details.delta;

    final verticalSteps = (cursorOffset.dy / widget.verticalStep).round();
    if (verticalSteps == currentVerticalSteps) return;

    final start = initialDateTimeRange.start.add(
      verticalStepDuration * verticalSteps,
    );

    // Add now to the snap points if applicable.
    final now = DateTime.now();
    if (snapToTimeIndicator) {
      snapPoints.add(now);
    }

    // Find the index of the snap point that is within a duration of verticalSnapRange minutes of the startTime.
    final index = snapPoints.indexWhere(
      (element) => element.difference(start).abs() <= verticalSnapRange,
    );

    final DateTime newStart;
    if (index != -1 && snapPoints[index].isBefore(widget.event.end)) {
      // use the snap point.
      newStart = snapPoints[index];
    } else if (start.isBefore(widget.event.end)) {
      // use the calculated start.
      newStart = start;
    } else {
      // use the current start.
      newStart = eventsController.selectedEvent!.start;
    }

    // Calculate the deltaDuration.
    final deltaDuration = newStart.difference(
      eventsController.selectedEvent!.start,
    );

    if (viewConfiguration.customStartEndHour) {
      if (newStart.hour >= startHour &&
          newStart.isSameDay(initialDateTimeRange.start)) {
        // Reschedule the event's start.
        eventsController.rescheduleSelectedEventStart(
          deltaDuration,
        );
      }
    } else {
      // Reschedule the event's start.
      eventsController.rescheduleSelectedEventStart(
        deltaDuration,
      );
    }

    currentVerticalSteps = verticalSteps;

    // Remove now from the snap points if applicable.
    if (snapToTimeIndicator) {
      snapPoints.remove(now);
    }
  }

  /// Handles the onVerticalDragUpdate event (End).
  void _onVerticalDragUpdateBottom(DragUpdateDetails details) {
    cursorOffset += details.delta;
    // Calculate the new vertical steps.
    final verticalSteps = (cursorOffset.dy / widget.verticalStep).round();

    if (verticalSteps == currentVerticalSteps) return;

    // Calculate the new end time.
    final end = initialDateTimeRange.end.add(
      verticalStepDuration * verticalSteps,
    );

    // Add now to the snap points if applicable.
    final now = DateTime.now();
    if (snapToTimeIndicator) {
      snapPoints.add(now);
    }

    // Find the index of the snap point that is within a duration of verticalSnapRange minutes of the endTime.
    final index = snapPoints.indexWhere(
      (element) => element.difference(end).abs() <= verticalSnapRange,
    );

    final DateTime newEnd;
    if (index != -1 && snapPoints[index].isAfter(widget.event.start)) {
      // use the snap point.
      newEnd = snapPoints[index];
    } else if (end.isAfter(widget.event.start)) {
      // use the calculated end.
      newEnd = end;
    } else {
      // use the current end.
      newEnd = eventsController.selectedEvent!.end;
    }

    // Calculate the delta.
    final deltaDuration = newEnd.difference(
      eventsController.selectedEvent!.end,
    );

    if (viewConfiguration.customStartEndHour) {
      if (newEnd.hour <= endHour &&
          newEnd.isSameDay(initialDateTimeRange.end)) {
        // Reschedule the event's end.
        eventsController.rescheduleSelectedEventEnd(
          deltaDuration,
        );
      }
    } else {
      // Reschedule the event's end.
      eventsController.rescheduleSelectedEventEnd(
        deltaDuration,
      );
    }

    currentVerticalSteps = verticalSteps;

    // Remove now from the snap points if applicable.
    if (snapToTimeIndicator) {
      snapPoints.remove(now);
    }
  }

  /// Handles the onVerticalDragEnd event.
  Future<void> _onVerticalDragEnd(DragEndDetails details) async {
    final selectedEvent = eventsController.selectedEvent!;
    eventsController.isResizingBottom = false;
    eventsController.isResizingTop = false;
    eventsController.deselectEvent();

    await scope.functions.onEventChanged?.call(
      initialDateTimeRange,
      selectedEvent,
    );
  }

  /// Handles the onRescheduleStart event.
  void _onRescheduleStart() {
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;

    eventsController.selectEvent(widget.event);
    eventsController.isRescheduling = true;
    initialDateTimeRange = widget.event.dateTimeRange;

    scope.functions.onEventChangeStart?.call(widget.event);
  }

  /// Reschedules the [CalendarEvent] to the the [cursorOffset] or the nearest snap point.
  void _onReschedule(Offset cursorOffset) {
    // Calculate the new vertical steps.
    final verticalSteps = (cursorOffset.dy / widget.verticalStep).round();

    // Calculate the new horizontal steps if applicable.
    var horizontalSteps = 0;
    horizontalSteps = (cursorOffset.dx / widget.horizontalStep).round();

    if (verticalSteps == currentVerticalSteps &&
        horizontalSteps == currentHorizontalSteps) {
      return;
    }

    final horizontalDurationDelta = horizontalStepDuration * horizontalSteps;

    // Calculate the new start time.
    var newStart = initialDateTimeRange.start
        .add(horizontalDurationDelta)
        .add(verticalStepDuration * verticalSteps);

    // Calculate the new end time.
    var newEnd = initialDateTimeRange.end
        .add(horizontalDurationDelta)
        .add(verticalStepDuration * verticalSteps);

    final now = DateTime.now();
    if (snapToTimeIndicator) {
      snapPoints.add(now);
    }

    // Find the index of the snap point that is within a duration of 15 minutes of the startTime.
    final startIndex = snapPoints.indexWhere(
      (element) => element.difference(newStart).abs() <= verticalSnapRange,
    );

    // Find the index of the snap point that is within a duration of 15 minutes of the endTime.
    final endIndex = snapPoints.indexWhere(
      (element) => element.difference(newEnd).abs() <= verticalSnapRange,
    );

    // Check if the start or end snap points should be used.
    if (startIndex != -1) {
      newStart = snapPoints[startIndex];
      newEnd = newStart.add(initialDateTimeRange.duration);
    } else if (endIndex != -1) {
      newEnd = snapPoints[endIndex];
      newStart = newEnd.subtract(initialDateTimeRange.duration);
    }

    // Create the new DateTimeRange.
    final newDateTimeRange = DateTimeRange(
      start: newStart,
      end: newEnd,
    );

    final startIsWithin =
        newDateTimeRange.start.isWithin(widget.visibleDateTimeRange);

    final endIsWithin =
        newDateTimeRange.end.isWithin(widget.visibleDateTimeRange);

    /// TODO: Fix the bug where dragging to the end of the day locks event to that day.
    if (startIsWithin || endIsWithin) {
      // Check if custom start and end hours are used.
      if (viewConfiguration.customStartEndHour) {
        if (newDateTimeRange.start.isSameDay(newDateTimeRange.end)) {
          if (newDateTimeRange.start.hour >= startHour &&
              newDateTimeRange.end.hour <= endHour) {
            // Calculate the deltaDuration.
            final deltaDuration = newStart.difference(
              eventsController.selectedEvent!.start,
            );

            // Reschedule the event.
            eventsController.rescheduleSelectedEvent(
              deltaDuration,
            );
          }
        }
      } else {
        // Calculate the deltaDuration.
        final deltaDuration = newStart.difference(
          eventsController.selectedEvent!.start,
        );

        // Reschedule the event.
        eventsController.rescheduleSelectedEvent(
          deltaDuration,
        );
      }
    }

    if (snapToTimeIndicator) {
      snapPoints.remove(now);
    }

    currentHorizontalSteps = horizontalSteps;
    currentVerticalSteps = verticalSteps;
  }

  /// Handles the onRescheduleEnd event.
  Future<void> _onRescheduleEnd() async {
    final selectedEvent = eventsController.selectedEvent!;
    eventsController.isRescheduling = false;
    eventsController.deselectEvent();

    await scope.functions.onEventChanged?.call(
      initialDateTimeRange,
      selectedEvent,
    );
  }

  Positioned resizeTopMobileWidget({
    required double handleSize,
    required bool enabled,
  }) {
    return Positioned(
      top: 0,
      right: 0,
      height: handleSize,
      width: handleSize,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragStart: enabled ? _onVerticalDragStartTop : null,
        onVerticalDragUpdate: enabled ? _onVerticalDragUpdateTop : null,
        onVerticalDragEnd: enabled
            ? (details) async {
                _onVerticalDragEnd(details);
              }
            : null,
        child: components.tileHandleBuilder(enabled),
      ),
    );
  }

  Positioned _resizeTopDesktopWidget() {
    return Positioned(
      top: 0,
      height: 16,
      left: 0,
      right: 0,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeRow,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragStart: _onVerticalDragStart,
          onVerticalDragUpdate: _onVerticalDragUpdateTop,
          onVerticalDragEnd: (details) async => _onVerticalDragEnd(details),
        ),
      ),
    );
  }

  Positioned _resizeBottomDesktopWidget() {
    return Positioned(
      bottom: 0,
      height: 8,
      left: 0,
      right: 0,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeRow,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragStart: _onVerticalDragStart,
          onVerticalDragUpdate: _onVerticalDragUpdateBottom,
          onVerticalDragEnd: (details) async => _onVerticalDragEnd(details),
        ),
      ),
    );
  }

  Positioned resizeBottomMobileWidget({
    required double handleSize,
    required bool enabled,
  }) {
    return Positioned(
      bottom: 0,
      left: 0,
      height: handleSize,
      width: handleSize,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragStart: _onVerticalDragStartBottom,
        onVerticalDragUpdate: _onVerticalDragUpdateBottom,
        onVerticalDragEnd: (details) async {
          _onVerticalDragEnd(details);
        },
        child: components.tileHandleBuilder(
          enabled,
        ),
      ),
    );
  }
}
