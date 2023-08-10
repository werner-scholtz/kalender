import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

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
  bool get isMobileDevice => scope.platformData.isMobileDevice;

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

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
    snapPoints = widget.snapPoints;
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
            onPanStart: isMobileDevice ? null : _onPanStart,
            onPanUpdate: isMobileDevice ? null : _onPanUpdate,
            onPanEnd: isMobileDevice ? null : _onPanEnd,
            onLongPressStart: isMobileDevice ? _onLongPressStart : null,
            onLongPressMoveUpdate:
                isMobileDevice ? _onLongPressMoveUpdate : null,
            onLongPressEnd: isMobileDevice ? _onLongPressEnd : null,
            onTap: _onTap,
            child: widget.child,
          ),
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
                          isMobileDevice ? null : _onVerticalDragStart,
                      onVerticalDragUpdate:
                          isMobileDevice ? null : _resizeStart,
                      onVerticalDragEnd:
                          isMobileDevice ? null : _onVerticalDragEnd,
                    ),
                  ),
                ),
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
                          isMobileDevice ? null : _onVerticalDragStart,
                      onVerticalDragUpdate: isMobileDevice ? null : _resizeEnd,
                      onVerticalDragEnd:
                          isMobileDevice ? null : _onVerticalDragEnd,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _onTap() async {
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

  void _onPanStart(DragStartDetails details) {
    _onRescheduleStart();
    scope.eventsController.isMoving = true;
    scope.eventsController.chaningEvent = event;
    initialDateTimeRange = event.dateTimeRange;
  }

  void _onPanEnd(DragEndDetails details) async {
    _onRescheduleEnd();
    await scope.functions.onEventChanged
        ?.call(initialDateTimeRange, scope.eventsController.chaningEvent!);
    scope.eventsController.chaningEvent = null;
    scope.eventsController.isMoving = false;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _onReschedule(cursorOffset += details.delta);
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _onRescheduleStart();
    scope.eventsController.isMoving = true;
    scope.eventsController.chaningEvent = event;
  }

  void _onLongPressEnd(LongPressEndDetails details) async {
    _onRescheduleEnd();
    await scope.functions.onEventChanged
        ?.call(initialDateTimeRange, scope.eventsController.chaningEvent!);
    scope.eventsController.chaningEvent = null;
    scope.eventsController.isMoving = false;
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _onReschedule(details.offsetFromOrigin);
  }

  void _onRescheduleStart() {
    initialDateTimeRange = widget.visibleDateTimeRange;
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;
  }

  void _onRescheduleEnd() {
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;
  }

  void _onReschedule(Offset cursorOffset) {
    int verticalSteps = (cursorOffset.dy / widget.verticalStep).round();
    if (verticalSteps != currentVerticalSteps) {
      currentVerticalSteps = verticalSteps;
    }

    int horizontalSteps = 0;
    Duration horizontalDurationDelta = const Duration();
    if (widget.horizontalStep != null) {
      horizontalSteps = (cursorOffset.dx / widget.horizontalStep!).round();
      if (horizontalSteps != currentHorizontalSteps) {
        currentHorizontalSteps = horizontalSteps;
      }
      horizontalDurationDelta =
          widget.horizontalDurationStep! * horizontalSteps;
    }

    DateTime newStart = initialDateTimeRange.start
        .add(horizontalDurationDelta)
        .add(widget.verticalDurationStep * verticalSteps);

    DateTime newEnd = initialDateTimeRange.end
        .add(horizontalDurationDelta)
        .add(widget.verticalDurationStep * verticalSteps);

    int startIndex = snapPoints.indexWhere(
      (DateTime element) =>
          element.difference(newStart).abs() <= const Duration(minutes: 15),
    );

    int endIndex = snapPoints.indexWhere(
      (DateTime element) =>
          element.difference(newEnd).abs() <= const Duration(minutes: 15),
    );

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

  void _onVerticalDragEnd(DragEndDetails details) {
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
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
            element.difference(newStart).abs() <= const Duration(minutes: 15),
      );

      if (scope.eventsController.chaningEvent == null) return;

      if (index != -1) {
        scope.eventsController.chaningEvent!.start = snapPoints[index];
      } else {
        if (newStart.isBefore(scope.eventsController.chaningEvent!.end)) {
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
            element.difference(newEnd).abs() <= const Duration(minutes: 15),
      );

      if (scope.eventsController.chaningEvent == null) return;

      if (index != -1) {
        scope.eventsController.chaningEvent!.end = snapPoints[index];
      } else {
        if (newEnd.isAfter(scope.eventsController.chaningEvent!.start)) {
          scope.eventsController.chaningEvent!.end = newEnd;
        }
      }

      currentVerticalSteps = steps;
    }
  }
}
