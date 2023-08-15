import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

/// TODO: Create a builder for a [DayTileGestureDetector].
class DayTileGestureDetector<T> extends StatefulWidget {
  const DayTileGestureDetector({
    super.key,
    required this.child,
    required this.event,
    required this.visibleDateTimeRange,
    required this.verticalDurationStep,
    required this.verticalStep,
    required this.horizontalDurationStep,
    required this.horizontalStep,
    required this.snapPoints,
    required this.eventSnapping,
    required this.continuesBefore,
    required this.continuesAfter,
    required this.snapToRange,
  });
  final Widget child;

  final DateTimeRange visibleDateTimeRange;

  final CalendarEvent<T> event;

  /// The duration of the vertical step when dragging/resizing an event.
  final Duration verticalDurationStep;
  final double verticalStep;

  /// The duration of the horizontal step when dragging an event.
  final Duration? horizontalDurationStep;
  final double? horizontalStep;

  final Duration snapToRange;
  final List<DateTime> snapPoints;
  final bool eventSnapping;

  final bool continuesBefore;
  final bool continuesAfter;

  @override
  State<DayTileGestureDetector<T>> createState() =>
      _DayTileGestureDetectorState<T>();
}

class _DayTileGestureDetectorState<T> extends State<DayTileGestureDetector<T>> {
  late CalendarEvent<T> event;
  late DateTimeRange initialDateTimeRange;
  late List<DateTime> snapPoints;
  late bool eventSnapping;

  CalendarScope<T> get scope => CalendarScope.of<T>(context);

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  bool get modifyable => event.modifyable;
  bool get canBeChangedDesktop => modifyable && !isMobileDevice;
  bool get isMobileDevice => scope.platformData.isMobileDevice;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    initialDateTimeRange = event.dateTimeRange;
    snapPoints = widget.snapPoints;
  }

  @override
  void didUpdateWidget(covariant DayTileGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    event = widget.event;
    eventSnapping = widget.eventSnapping;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onPanStart: canBeChangedDesktop ? _onPanStart : null,
            // isMobileDevice || !event.modifyable ? null : _onPanStart,
            onPanUpdate: canBeChangedDesktop ? _onPanUpdate : null,
            // isMobileDevice || !event.modifyable ? null : _onPanUpdate,
            onPanEnd: canBeChangedDesktop
                ? (DragEndDetails details) async => _onPanEnd(details)
                : null,
            //  isMobileDevice || !event.modifyable ? null : _onPanEnd,
            onLongPressStart:
                isMobileDevice && modifyable ? _onLongPressStart : null,
            onLongPressMoveUpdate:
                isMobileDevice && modifyable ? _onLongPressMoveUpdate : null,
            onLongPressEnd: isMobileDevice && modifyable
                ? (LongPressEndDetails details) async =>
                    _onLongPressEnd(details)
                : null,
            onTap: _onTap,
            child: widget.child,
          ),
          if (canBeChangedDesktop)
            widget.continuesBefore
                ? const SizedBox.shrink()
                : Positioned(
                    top: 0,
                    height: 8,
                    left: 0,
                    right: 0,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeRow,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragStart:
                            canBeChangedDesktop ? _onVerticalDragStart : null,
                        // isMobileDevice ? null : _onVerticalDragStart,
                        onVerticalDragUpdate:
                            canBeChangedDesktop ? _resizeStart : null,
                        // isMobileDevice ? null : _resizeStart,
                        onVerticalDragEnd: canBeChangedDesktop
                            ? (DragEndDetails details) async =>
                                _onVerticalDragEnd(details)
                            : null,
                        // isMobileDevice ? null : _onVerticalDragEnd,
                      ),
                    ),
                  ),
          if (canBeChangedDesktop)
            widget.continuesAfter
                ? const SizedBox.shrink()
                : Positioned(
                    bottom: 0,
                    height: 8,
                    left: 0,
                    right: 0,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeRow,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragStart:
                            canBeChangedDesktop ? _onVerticalDragStart : null,
                        // isMobileDevice ? null : _onVerticalDragStart,
                        onVerticalDragUpdate:
                            canBeChangedDesktop ? _resizeEnd : null,
                        // isMobileDevice ? null : _resizeEnd,
                        onVerticalDragEnd: canBeChangedDesktop
                            ? (DragEndDetails details) async =>
                                _onVerticalDragEnd(details)
                            : null,
                        // isMobileDevice ? null : _onVerticalDragEnd,
                      ),
                    ),
                  ),
        ],
      ),
    );
  }

  /// Trigger the [onEventTapped] function.
  void _onTap() async {
    if (scope.eventsController.chaningEvent == null) {
      // Set the changing event.
      scope.eventsController.chaningEvent = event;
      scope.eventsController.isMoving = true;

      // Call the onEventTapped function.
      await scope.functions.onEventTapped
          ?.call(scope.eventsController.chaningEvent!);

      // Reset the changing event.
      scope.eventsController.isMoving = false;
      scope.eventsController.chaningEvent = null;
    }
  }

  void _onPanStart(DragStartDetails details) {
    cursorOffset = Offset.zero;
    _onRescheduleStart();
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    await _onRescheduleEnd();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    cursorOffset += details.delta;
    _onReschedule(cursorOffset);
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _onRescheduleStart();
  }

  Future<void> _onLongPressEnd(LongPressEndDetails details) async {
    await _onRescheduleEnd();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _onReschedule(details.localOffsetFromOrigin);
  }

  void _onRescheduleStart() {
    initialDateTimeRange = widget.visibleDateTimeRange;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;

    scope.eventsController.isMoving = true;
    scope.eventsController.chaningEvent = event;
    initialDateTimeRange = event.dateTimeRange;
  }

  Future<void> _onRescheduleEnd() async {
    await scope.functions.onEventChanged?.call(
      initialDateTimeRange,
      scope.eventsController.chaningEvent!,
    );
    scope.eventsController.chaningEvent = null;
    scope.eventsController.isMoving = false;
  }

  void _onReschedule(Offset cursorOffset) {
    // Calculate the new vertical steps.
    int verticalSteps = (cursorOffset.dy / widget.verticalStep).round();
    if (verticalSteps != currentVerticalSteps) {
      currentVerticalSteps = verticalSteps;
    }

    // Calculate the new horizontal steps if applicable.
    int horizontalSteps = 0;
    if (widget.horizontalStep != null) {
      horizontalSteps = (cursorOffset.dx / widget.horizontalStep!).round();
      if (horizontalSteps != currentHorizontalSteps) {
        currentHorizontalSteps = horizontalSteps;
      }
    }
    Duration horizontalDurationDelta =
        (widget.horizontalDurationStep ?? const Duration(minutes: 0)) *
            horizontalSteps;

    // Calculate the new start time.
    DateTime newStart = initialDateTimeRange.start
        .add(horizontalDurationDelta)
        .add(widget.verticalDurationStep * verticalSteps);

    // Calculate the new end time.
    DateTime newEnd = initialDateTimeRange.end
        .add(horizontalDurationDelta)
        .add(widget.verticalDurationStep * verticalSteps);

    ///TODO: make the snap time configurable.

    // Find the index of the snap point that is within a duration of 15 minutes of the startTime.
    int startIndex = snapPoints.indexWhere(
      (DateTime element) =>
          element.difference(newStart).abs() <= widget.snapToRange,
    );

    // Find the index of the snap point that is within a duration of 15 minutes of the endTime.
    int endIndex = snapPoints.indexWhere(
      (DateTime element) =>
          element.difference(newEnd).abs() <= widget.snapToRange,
    );

    // Check if the start or end snap points should be used.
    if (startIndex != -1) {
      newStart = snapPoints[startIndex];
      newEnd = newStart.add(initialDateTimeRange.duration);
    } else if (endIndex != -1) {
      newEnd = snapPoints[endIndex];
      newStart = newEnd.subtract(initialDateTimeRange.duration);
    }

    DateTimeRange newDateTimeRange = DateTimeRange(
      start: newStart,
      end: newEnd,
    );

    if (newDateTimeRange.start.isWithin(widget.visibleDateTimeRange) ||
        newDateTimeRange.end.isWithin(widget.visibleDateTimeRange)) {
      scope.eventsController.chaningEvent!.dateTimeRange = newDateTimeRange;
    }
  }

  void _onVerticalDragStart(DragStartDetails details) {
    initialDateTimeRange = event.dateTimeRange;
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    scope.eventsController.chaningEvent = event;
    scope.eventsController.isMoving = true;
  }

  Future<void> _onVerticalDragEnd(DragEndDetails details) async {
    await scope.functions.onEventChanged
        ?.call(initialDateTimeRange, scope.eventsController.chaningEvent!);
    scope.eventsController.isMoving = false;
    scope.eventsController.chaningEvent = null;
  }

  void _resizeStart(DragUpdateDetails details) {
    cursorOffset += details.delta;

    int steps = (cursorOffset.dy / widget.verticalStep).round();
    if (steps != currentVerticalSteps) {
      DateTime newStart =
          initialDateTimeRange.start.add(widget.verticalDurationStep * steps);

      int index = snapPoints.indexWhere(
        (DateTime element) =>
            element.difference(newStart).abs() <= widget.snapToRange,
      );

      if (scope.eventsController.chaningEvent == null) return;

      if (index != -1 && snapPoints[index].isBefore(event.end)) {
        scope.eventsController.chaningEvent!.start = snapPoints[index];
      } else {
        if (newStart.isBefore(event.end)) {
          scope.eventsController.chaningEvent!.start = newStart;
        }
      }

      currentVerticalSteps = steps;
    }
  }

  void _resizeEnd(DragUpdateDetails details) {
    cursorOffset += details.delta;
    int steps = (cursorOffset.dy / widget.verticalStep).round();
    if (steps != currentVerticalSteps) {
      DateTime newEnd =
          initialDateTimeRange.end.add(widget.verticalDurationStep * steps);

      int index = snapPoints.indexWhere(
        (DateTime element) =>
            element.difference(newEnd).abs() <= widget.snapToRange,
      );

      if (scope.eventsController.chaningEvent == null) return;

      if (index != -1 && snapPoints[index].isAfter(event.start)) {
        scope.eventsController.chaningEvent!.end = snapPoints[index];
      } else {
        if (newEnd.isAfter(event.start)) {
          scope.eventsController.chaningEvent!.end = newEnd;
        }
      }

      currentVerticalSteps = steps;
    }
  }
}
