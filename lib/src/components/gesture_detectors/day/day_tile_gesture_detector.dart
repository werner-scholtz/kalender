import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class DayTileGestureDetector<T> extends StatelessWidget {
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
    required this.timelineSnapping,
    required this.continuesBefore,
    required this.continuesAfter,
    required this.verticalSnapRange,
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

  final Duration verticalSnapRange;
  final List<DateTime> snapPoints;
  final bool timelineSnapping;

  final bool continuesBefore;
  final bool continuesAfter;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of<T>(context);
    if (scope.platformData.isMobileDevice) {
      return MobileDayTileGestureDetector<T>(
        event: event,
        visibleDateTimeRange: visibleDateTimeRange,
        verticalDurationStep: verticalDurationStep,
        verticalStep: verticalStep,
        horizontalDurationStep: horizontalDurationStep,
        horizontalStep: horizontalStep,
        snapPoints: snapPoints,
        eventSnapping: timelineSnapping,
        continuesBefore: continuesBefore,
        continuesAfter: continuesAfter,
        verticalSnapRange: verticalSnapRange,
        child: child,
      );
    } else {
      return DesktopDayTileGestureDetector<T>(
        event: event,
        visibleDateTimeRange: visibleDateTimeRange,
        verticalDurationStep: verticalDurationStep,
        verticalStep: verticalStep,
        horizontalDurationStep: horizontalDurationStep,
        horizontalStep: horizontalStep,
        snapPoints: snapPoints,
        timeIndicatorSnapping: timelineSnapping,
        continuesBefore: continuesBefore,
        continuesAfter: continuesAfter,
        verticalSnapRange: verticalSnapRange,
        child: child,
      );
    }
  }
}

class MobileDayTileGestureDetector<T> extends StatefulWidget {
  const MobileDayTileGestureDetector({
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
    required this.verticalSnapRange,
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

  final Duration verticalSnapRange;
  final List<DateTime> snapPoints;
  final bool eventSnapping;

  final bool continuesBefore;
  final bool continuesAfter;

  @override
  State<MobileDayTileGestureDetector<T>> createState() =>
      _MobileDayTileGestureDetectorState<T>();
}

class _MobileDayTileGestureDetectorState<T>
    extends State<MobileDayTileGestureDetector<T>> {
  late CalendarEvent<T> event;
  late DateTimeRange initialDateTimeRange;
  late List<DateTime> snapPoints;
  late bool timelineSnapping;

  CalendarScope<T> get scope => CalendarScope.of<T>(context);

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  bool get modifyable => event.modifyable;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    initialDateTimeRange = event.dateTimeRange;
    snapPoints = widget.snapPoints;
  }

  @override
  void didUpdateWidget(covariant MobileDayTileGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    event = widget.event;
    snapPoints = widget.snapPoints;
    timelineSnapping = widget.eventSnapping;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double height = constraints.maxHeight < 16 ? constraints.maxHeight : 16;
        double width = constraints.maxHeight < 16 ? constraints.maxHeight : 16;
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onLongPressStart: modifyable ? _onLongPressStart : null,
              onLongPressMoveUpdate: modifyable ? _onLongPressMoveUpdate : null,
              onLongPressEnd: modifyable
                  ? (LongPressEndDetails details) async =>
                      _onLongPressEnd(details)
                  : null,
              onTap: _onTap,
              child: widget.child,
            ),
            if (modifyable && scope.eventsController.chaningEvent == event)
              widget.continuesBefore
                  ? const SizedBox.shrink()
                  : Positioned(
                      top: 0,
                      right: 0,
                      height: height,
                      width: width,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragStart: _onVerticalDragStart,
                        onVerticalDragUpdate: _resizeStart,
                        onVerticalDragEnd: (DragEndDetails details) async =>
                            _onVerticalDragEnd(details),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
            if (modifyable && scope.eventsController.chaningEvent == event)
              widget.continuesAfter
                  ? const SizedBox.shrink()
                  : Positioned(
                      bottom: 0,
                      left: 0,
                      height: height,
                      width: width,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragStart: _onVerticalDragStart,
                        onVerticalDragUpdate: _resizeEnd,
                        onVerticalDragEnd: (DragEndDetails details) async =>
                            _onVerticalDragEnd(details),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
          ],
        );
      },
    );
  }

  /// Trigger the [onEventTapped] function.
  void _onTap() async {
    if (scope.eventsController.chaningEvent == event) {
      // Call the onEventTapped function.
      await scope.functions.onEventTapped?.call(
        scope.eventsController.chaningEvent!,
      );

      // Reset the changing event.
      scope.eventsController.isMoving = false;
      scope.eventsController.chaningEvent = null;
    } else {
      // Set the changing event.
      scope.eventsController.chaningEvent = event;
      scope.eventsController.isMoving = true;

      // Call the onEventTapped function.
      await scope.functions.onEventTapped
          ?.call(scope.eventsController.chaningEvent!);
    }
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
    scope.eventsController.chaningEvent = event;
    scope.eventsController.isMoving = true;
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

    // Find the index of the snap point that is within a duration of 15 minutes of the startTime.
    int startIndex = snapPoints.indexWhere(
      (DateTime element) =>
          element.difference(newStart).abs() <= widget.verticalSnapRange,
    );

    // Find the index of the snap point that is within a duration of 15 minutes of the endTime.
    int endIndex = snapPoints.indexWhere(
      (DateTime element) =>
          element.difference(newEnd).abs() <= widget.verticalSnapRange,
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
    scope.eventsController.chaningEvent = event;
    scope.eventsController.isMoving = true;
  }

  void _resizeStart(DragUpdateDetails details) {
    cursorOffset += details.delta;

    int steps = (cursorOffset.dy / widget.verticalStep).round();
    if (steps != currentVerticalSteps) {
      DateTime newStart =
          initialDateTimeRange.start.add(widget.verticalDurationStep * steps);

      int index = snapPoints.indexWhere(
        (DateTime element) =>
            element.difference(newStart).abs() <= widget.verticalSnapRange,
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
            element.difference(newEnd).abs() <= widget.verticalSnapRange,
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

class DesktopDayTileGestureDetector<T> extends StatefulWidget {
  const DesktopDayTileGestureDetector({
    super.key,
    required this.child,
    required this.event,
    required this.visibleDateTimeRange,
    required this.verticalDurationStep,
    required this.verticalStep,
    required this.horizontalDurationStep,
    required this.horizontalStep,
    required this.snapPoints,
    required this.timeIndicatorSnapping,
    required this.continuesBefore,
    required this.continuesAfter,
    required this.verticalSnapRange,
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

  final Duration verticalSnapRange;
  final List<DateTime> snapPoints;
  final bool timeIndicatorSnapping;

  final bool continuesBefore;
  final bool continuesAfter;

  @override
  State<DesktopDayTileGestureDetector<T>> createState() =>
      _DesktopDayTileGestureDetectorState<T>();
}

class _DesktopDayTileGestureDetectorState<T>
    extends State<DesktopDayTileGestureDetector<T>> {
  late CalendarEvent<T> event;
  late DateTimeRange initialDateTimeRange;
  late List<DateTime> snapPoints;
  late bool timeIndicatorSnapping;

  CalendarScope<T> get scope => CalendarScope.of<T>(context);

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  bool get modifyable => event.modifyable;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    initialDateTimeRange = event.dateTimeRange;
    snapPoints = widget.snapPoints;
  }

  @override
  void didUpdateWidget(covariant DesktopDayTileGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    event = widget.event;
    snapPoints = widget.snapPoints;
    timeIndicatorSnapping = widget.timeIndicatorSnapping;
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
            onPanStart: modifyable ? _onPanStart : null,
            onPanUpdate: modifyable ? _onPanUpdate : null,
            onPanEnd: modifyable
                ? (DragEndDetails details) async => _onPanEnd(details)
                : null,
            onTap: _onTap,
            child: widget.child,
          ),
          if (modifyable)
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
                            modifyable ? _onVerticalDragStart : null,
                        onVerticalDragUpdate: modifyable ? _resizeStart : null,
                        onVerticalDragEnd: modifyable
                            ? (DragEndDetails details) async =>
                                _onVerticalDragEnd(details)
                            : null,
                      ),
                    ),
                  ),
          if (modifyable)
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
                            modifyable ? _onVerticalDragStart : null,
                        onVerticalDragUpdate: modifyable ? _resizeEnd : null,
                        onVerticalDragEnd: modifyable
                            ? (DragEndDetails details) async =>
                                _onVerticalDragEnd(details)
                            : null,
                      ),
                    ),
                  ),
        ],
      ),
    );
  }

  /// Trigger the [onEventTapped] function.
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

    DateTime now = DateTime.now();
    if (timeIndicatorSnapping) {
      snapPoints.add(now);
    }

    // Find the index of the snap point that is within a duration of 15 minutes of the startTime.
    int startIndex = snapPoints.indexWhere(
      (DateTime element) =>
          element.difference(newStart).abs() <= widget.verticalSnapRange,
    );

    // Find the index of the snap point that is within a duration of 15 minutes of the endTime.
    int endIndex = snapPoints.indexWhere(
      (DateTime element) =>
          element.difference(newEnd).abs() <= widget.verticalSnapRange,
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

    if (timeIndicatorSnapping) {
      snapPoints.remove(now);
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

      DateTime now = DateTime.now();
      if (timeIndicatorSnapping) {
        snapPoints.add(now);
      }

      int index = snapPoints.indexWhere(
        (DateTime element) =>
            element.difference(newStart).abs() <= widget.verticalSnapRange,
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

      if (timeIndicatorSnapping) {
        snapPoints.remove(now);
      }
    }
  }

  void _resizeEnd(DragUpdateDetails details) {
    cursorOffset += details.delta;
    int steps = (cursorOffset.dy / widget.verticalStep).round();
    if (steps != currentVerticalSteps) {
      DateTime newEnd =
          initialDateTimeRange.end.add(widget.verticalDurationStep * steps);
      DateTime now = DateTime.now();
      if (timeIndicatorSnapping) {
        snapPoints.add(now);
      }

      int index = snapPoints.indexWhere(
        (DateTime element) =>
            element.difference(newEnd).abs() <= widget.verticalSnapRange,
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

      if (timeIndicatorSnapping) {
        snapPoints.remove(now);
      }
    }
  }
}
