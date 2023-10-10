import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_page_content.dart';

class EventTile<T> extends StatefulWidget {
  const EventTile({
    super.key,
    required this.event,
    required this.tileConfiguration,
    required this.isChanging,
    required this.snapData,
  });

  final CalendarEvent<T> event;
  final TileConfiguration tileConfiguration;

  final bool isChanging;
  final MultiDayPageData snapData;

  @override
  State<EventTile<T>> createState() => _EventTileState<T>();
}

class _EventTileState<T> extends State<EventTile<T>> {
  late final CalendarScope<T> scope = CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => scope.eventsController;
  MultiDayPageData get snapData => widget.snapData;

  bool get isMobileDevice => scope.platformData.isMobileDevice;
  bool get useMobileGestures => isMobileDevice && widget.event.canModify;
  bool get useDesktopGestures => !isMobileDevice && widget.event.canModify;

  late DateTimeRange initialDateTimeRange;

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  @override
  void initState() {
    super.initState();
    initialDateTimeRange = widget.event.dateTimeRange;
  }

  @override
  void didUpdateWidget(covariant EventTile<T> oldWidget) {
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
        if (useDesktopGestures) {
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
            !controller.isResizingBottom &&
            !controller.isResizingTop) {
          onLongPressStart = _onLongPressStart;
          onLongPressMoveUpdate = _onLongPressMoveUpdate;
          onLongPressEnd = _onLongPressEnd;
        }

        // Assign the resize buttons
        Widget? resizeTopWidget;
        Widget? resizeBottomWidget;

        // Check if the event can be modified and if the event is being rescheduled.
        if (widget.event.canModify && !controller.isRescheduling) {
          if (useDesktopGestures) {
            resizeBottomWidget = _resizeBottomDesktopWidget();
            resizeTopWidget = _resizeTopDesktopWidget();
          } else if (useMobileGestures && widget.isChanging) {
            // Assign the resize buttons to use mobile gestures.

            // Check if the event continues before the visible date range.
            if (!widget.tileConfiguration.continuesBefore) {
              resizeTopWidget = resizeTopMobileWidget(
                handleSize: handleSize,
                enabled: !controller.isResizingBottom,
              );
            }

            // Check if the event continues after the visible date range.
            if (!widget.tileConfiguration.continuesAfter) {
              resizeBottomWidget = resizeBottomMobileWidget(
                handleSize: handleSize,
                enabled: !controller.isResizingTop,
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
    controller.selectEvent(widget.event);
    controller.isResizingTop = true;
  }

  void _onVerticalDragStartBottom(DragStartDetails details) {
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;

    initialDateTimeRange = widget.event.dateTimeRange;
    controller.selectEvent(widget.event);
    controller.isResizingBottom = true;
  }

  /// Handles the onVerticalDragStart event.
  void _onVerticalDragStart(DragStartDetails details) {
    initialDateTimeRange = widget.event.dateTimeRange;
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    controller.selectEvent(widget.event);
  }

  /// Handles the onVerticalDragUpdate event (Start).
  void _onVerticalDragUpdateTop(DragUpdateDetails details) {
    cursorOffset += details.delta;

    final verticalSteps = (cursorOffset.dy / snapData.verticalStep).round();
    if (verticalSteps == currentVerticalSteps) return;

    final newStart = initialDateTimeRange.start.add(
      snapData.verticalStepDuration * verticalSteps,
    );

    // Add now to the snap points if applicable.
    final now = DateTime.now();
    if (snapData.snapToTimeIndicator) {
      snapData.snapPoints.add(now);
    }

    final index = snapData.snapPoints.indexWhere(
      (element) =>
          element.difference(newStart).abs() <= snapData.verticalSnapRange,
    );

    if (scope.eventsController.selectedEvent == null) return;

    if (index != -1 && snapData.snapPoints[index].isBefore(widget.event.end)) {
      scope.eventsController.selectedEvent!.start = snapData.snapPoints[index];
    } else {
      if (newStart.isBefore(widget.event.end)) {
        scope.eventsController.selectedEvent!.start = newStart;
      }
    }

    currentVerticalSteps = verticalSteps;

    // Remove now from the snap points if applicable.
    if (snapData.snapToTimeIndicator) {
      snapData.snapPoints.remove(now);
    }
  }

  /// Handles the onVerticalDragUpdate event (End).
  void _onVerticalDragUpdateBottom(DragUpdateDetails details) {
    cursorOffset += details.delta;
    // Calculate the new vertical steps.
    final verticalSteps = (cursorOffset.dy / snapData.verticalStep).round();

    if (verticalSteps == currentVerticalSteps) return;

    // Calculate the new end time.
    final newEnd = initialDateTimeRange.end.add(
      snapData.verticalStepDuration * verticalSteps,
    );

    // Add now to the snap points if applicable.
    final now = DateTime.now();
    if (snapData.snapToTimeIndicator) {
      snapData.snapPoints.add(now);
    }

    final index = snapData.snapPoints.indexWhere(
      (element) =>
          element.difference(newEnd).abs() <= snapData.verticalSnapRange,
    );

    if (scope.eventsController.selectedEvent == null) return;

    if (index != -1 && snapData.snapPoints[index].isAfter(widget.event.start)) {
      scope.eventsController.selectedEvent!.end = snapData.snapPoints[index];
    } else {
      if (newEnd.isAfter(widget.event.start)) {
        scope.eventsController.selectedEvent!.end = newEnd;
      }
    }

    currentVerticalSteps = verticalSteps;

    // Remove now from the snap points if applicable.
    if (snapData.snapToTimeIndicator) {
      snapData.snapPoints.remove(now);
    }
  }

  /// Handles the onVerticalDragEnd event.
  Future<void> _onVerticalDragEnd(DragEndDetails details) async {
    final selectedEvent = scope.eventsController.selectedEvent!;
    controller.isResizingBottom = false;
    controller.isResizingTop = false;
    controller.deselectEvent();

    await scope.functions.onEventChanged?.call(
      initialDateTimeRange,
      selectedEvent,
    );
  }

  /// Handles the onRescheduleStart event.
  void _onRescheduleStart() {
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;

    controller.selectEvent(widget.event);
    scope.eventsController.isRescheduling = true;
    initialDateTimeRange = widget.event.dateTimeRange;

    scope.functions.onEventChangeStart?.call(widget.event);
  }

  /// Reschedules the [CalendarEvent] to the the [cursorOffset] or the nearest snap point.
  void _onReschedule(Offset cursorOffset) {
    // Calculate the new vertical steps.
    final verticalSteps = (cursorOffset.dy / snapData.verticalStep).round();

    // Calculate the new horizontal steps if applicable.
    var horizontalSteps = 0;
    horizontalSteps = (cursorOffset.dx / snapData.horizontalStep).round();

    if (verticalSteps == currentVerticalSteps &&
        horizontalSteps == currentHorizontalSteps) {
      return;
    }

    final horizontalDurationDelta =
        snapData.horizontalStepDuration * horizontalSteps;

    // Calculate the new start time.
    var newStart = initialDateTimeRange.start
        .add(horizontalDurationDelta)
        .add(snapData.verticalStepDuration * verticalSteps);

    // Calculate the new end time.
    var newEnd = initialDateTimeRange.end
        .add(horizontalDurationDelta)
        .add(snapData.verticalStepDuration * verticalSteps);

    final now = DateTime.now();
    if (snapData.snapToTimeIndicator) {
      snapData.snapPoints.add(now);
    }

    // Find the index of the snap point that is within a duration of 15 minutes of the startTime.
    final startIndex = snapData.snapPoints.indexWhere(
      (element) =>
          element.difference(newStart).abs() <= snapData.verticalSnapRange,
    );

    // Find the index of the snap point that is within a duration of 15 minutes of the endTime.
    final endIndex = snapData.snapPoints.indexWhere(
      (element) =>
          element.difference(newEnd).abs() <= snapData.verticalSnapRange,
    );

    // Check if the start or end snap points should be used.
    if (startIndex != -1) {
      newStart = snapData.snapPoints[startIndex];
      newEnd = newStart.add(initialDateTimeRange.duration);
    } else if (endIndex != -1) {
      newEnd = snapData.snapPoints[endIndex];
      newStart = newEnd.subtract(initialDateTimeRange.duration);
    }

    final newDateTimeRange = DateTimeRange(
      start: newStart,
      end: newEnd,
    );

    if (newDateTimeRange.start.isWithin(snapData.visibleDateRange) ||
        newDateTimeRange.end.isWithin(snapData.visibleDateRange)) {
      scope.eventsController.selectedEvent!.dateTimeRange = newDateTimeRange;
    }

    if (snapData.snapToTimeIndicator) {
      snapData.snapPoints.remove(now);
    }

    currentHorizontalSteps = horizontalSteps;
    currentVerticalSteps = verticalSteps;
  }

  /// Handles the onRescheduleEnd event.
  Future<void> _onRescheduleEnd() async {
    final selectedEvent = scope.eventsController.selectedEvent!;
    controller.isRescheduling = false;
    controller.deselectEvent();

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
        child: scope.components.tileHandleBuilder(enabled),
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
        child: scope.components.tileHandleBuilder(
          enabled,
        ),
      ),
    );
  }
}
