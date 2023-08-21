import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class DayTileGestureDetector<T> extends StatefulWidget {
  const DayTileGestureDetector({
    super.key,
    required this.positionedTileData,
    required this.visibleDateTimeRange,
    required this.verticalDurationStep,
    required this.verticalStep,
    required this.horizontalDurationStep,
    required this.horizontalStep,
    required this.snapPoints,
    required this.snapToTimeIndicator,
    required this.verticalSnapRange,
    required this.isMobileDevice,
    required this.isChanging,
  });

  /// The visible [DateTimeRange].
  final DateTimeRange visibleDateTimeRange;

  /// The event that is wrapped by the [DayTileGestureDetector].
  final PositionedTileData<T> positionedTileData;

  /// The duration of the vertical step when dragging/resizing an event.
  final Duration verticalDurationStep;

  /// The pixel step of the a vertical step.
  final double verticalStep;

  /// The duration of the horizontal step when dragging an event.
  final Duration? horizontalDurationStep;

  /// The pixel step of the a horizontal step.
  final double? horizontalStep;

  /// The snap range of the vertical snapping.
  final Duration verticalSnapRange;

  /// The snap points of the vertical snapping.
  final List<DateTime> snapPoints;

  /// Whether to snap to the timeindicator.
  final bool snapToTimeIndicator;

  /// Whether the device is a mobile device.
  final bool isMobileDevice;

  /// Whether the event is changing.
  final bool isChanging;

  @override
  State<DayTileGestureDetector<T>> createState() =>
      _DayTileGestureDetectorState<T>();
}

class _DayTileGestureDetectorState<T> extends State<DayTileGestureDetector<T>> {
  CalendarScope<T> get scope => CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => scope.eventsController;

  late bool isMobileDevice;

  late PositionedTileData<T> tileData;
  late DateTimeRange initialDateTimeRange;
  late List<DateTime> snapPoints;
  late bool snapToTimeIndicator;
  late bool continuesBefore;
  late bool continuesAfter;

  late bool useMobileGestures;
  late bool useDesktopGestures;

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  @override
  void initState() {
    super.initState();
    tileData = widget.positionedTileData;
    continuesBefore = tileData.event.continuesBefore(tileData.date);
    continuesAfter = tileData.event.continuesAfter(tileData.date);
    isMobileDevice = widget.isMobileDevice;
    useMobileGestures = isMobileDevice && tileData.event.canModify;
    useDesktopGestures = !isMobileDevice && tileData.event.canModify;
    initialDateTimeRange = tileData.event.dateTimeRange;
    snapPoints = widget.snapPoints;
    snapToTimeIndicator = widget.snapToTimeIndicator;
  }

  @override
  void didUpdateWidget(covariant DayTileGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (tileData.event != widget.positionedTileData.event) {
      tileData = widget.positionedTileData;
      continuesBefore = tileData.event.continuesBefore(tileData.date);
      continuesAfter = tileData.event.continuesAfter(tileData.date);
      initialDateTimeRange = tileData.event.dateTimeRange;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMoving = controller.selectedEvent == tileData.event;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double height = constraints.maxHeight < 16 ? constraints.maxHeight : 16;
        double width = constraints.maxHeight < 16 ? constraints.maxHeight : 16;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              GestureDetector(
                onTap: _onTap,
                onPanStart: useDesktopGestures ? _onPanStart : null,
                onPanUpdate: useDesktopGestures ? _onPanUpdate : null,
                onPanEnd: useDesktopGestures
                    ? (DragEndDetails details) async => _onPanEnd(details)
                    : null,
                onLongPressStart: useMobileGestures ? _onLongPressStart : null,
                onLongPressMoveUpdate:
                    useMobileGestures ? _onLongPressMoveUpdate : null,
                onLongPressEnd: useMobileGestures
                    ? (LongPressEndDetails details) async =>
                        _onLongPressEnd(details)
                    : null,
                child: scope.tileComponents.tileBuilder!(
                  tileData.event,
                  TileConfiguration(
                    tileType: widget.isChanging
                        ? TileType.selected
                        : isMoving
                            ? TileType.ghost
                            : TileType.normal,
                    drawOutline: tileData.drawOutline,
                    continuesBefore: continuesBefore,
                    continuesAfter: continuesAfter,
                  ),
                ),
              ),
              if (tileData.event.canModify)
                useMobileGestures && widget.isChanging
                    ? Positioned(
                        top: 0,
                        right: 0,
                        height: height,
                        width: width,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onVerticalDragStart: _onVerticalDragStart,
                          onVerticalDragUpdate: _onVerticalDragUpdateStart,
                          onVerticalDragEnd: (DragEndDetails details) async =>
                              _onVerticalDragEnd(details),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      )
                    : useDesktopGestures
                        ? Positioned(
                            top: 0,
                            height: 8,
                            left: 0,
                            right: 0,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeRow,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onVerticalDragStart: _onVerticalDragStart,
                                onVerticalDragUpdate:
                                    _onVerticalDragUpdateStart,
                                onVerticalDragEnd:
                                    (DragEndDetails details) async =>
                                        _onVerticalDragEnd(details),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
              if (tileData.event.canModify)
                useMobileGestures && widget.isChanging
                    ? Positioned(
                        bottom: 0,
                        left: 0,
                        height: height,
                        width: width,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onVerticalDragStart: _onVerticalDragStart,
                          onVerticalDragUpdate: _onVerticalDragUpdateEnd,
                          onVerticalDragEnd: (DragEndDetails details) async =>
                              _onVerticalDragEnd(details),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      )
                    : useDesktopGestures
                        ? Positioned(
                            bottom: 0,
                            height: 8,
                            left: 0,
                            right: 0,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeRow,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onVerticalDragStart: _onVerticalDragStart,
                                onVerticalDragUpdate: _onVerticalDragUpdateEnd,
                                onVerticalDragEnd:
                                    (DragEndDetails details) async =>
                                        _onVerticalDragEnd(details),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  /// Handles the onTap event.
  Future<void> _onTap() async {
    // Call the onEventTapped function.
    await scope.functions.onEventTapped?.call(
      tileData.event,
    );

    controller.updateUI();
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

  /// Handles the onVerticalDragStart event.
  void _onVerticalDragStart(DragStartDetails details) {
    initialDateTimeRange = tileData.event.dateTimeRange;
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    controller.isResizing = true;
    controller.setSelectedEvent(tileData.event);
  }

  /// Handles the onVerticalDragUpdate event (Start).
  void _onVerticalDragUpdateStart(DragUpdateDetails details) {
    cursorOffset += details.delta;

    int steps = (cursorOffset.dy / widget.verticalStep).round();
    if (steps != currentVerticalSteps) {
      DateTime newStart = initialDateTimeRange.start.add(
        widget.verticalDurationStep * steps,
      );

      // Add now to the snap points if applicable.
      DateTime now = DateTime.now();
      if (snapToTimeIndicator) {
        snapPoints.add(now);
      }

      int index = snapPoints.indexWhere(
        (DateTime element) =>
            element.difference(newStart).abs() <= widget.verticalSnapRange,
      );

      if (scope.eventsController.selectedEvent == null) return;

      if (index != -1 && snapPoints[index].isBefore(tileData.event.end)) {
        scope.eventsController.selectedEvent!.start = snapPoints[index];
      } else {
        if (newStart.isBefore(tileData.event.end)) {
          scope.eventsController.selectedEvent!.start = newStart;
        }
      }

      currentVerticalSteps = steps;

      // Remove now from the snap points if applicable.
      if (snapToTimeIndicator) {
        snapPoints.remove(now);
      }
    }
  }

  /// Handles the onVerticalDragUpdate event (End).
  void _onVerticalDragUpdateEnd(DragUpdateDetails details) {
    cursorOffset += details.delta;
    // Calculate the new vertical steps.
    int steps = (cursorOffset.dy / widget.verticalStep).round();

    if (steps != currentVerticalSteps) {
      // Calculate the new end time.
      DateTime newEnd = initialDateTimeRange.end.add(
        widget.verticalDurationStep * steps,
      );

      // Add now to the snap points if applicable.
      DateTime now = DateTime.now();
      if (snapToTimeIndicator) {
        snapPoints.add(now);
      }

      int index = snapPoints.indexWhere(
        (DateTime element) =>
            element.difference(newEnd).abs() <= widget.verticalSnapRange,
      );

      if (scope.eventsController.selectedEvent == null) return;

      if (index != -1 && snapPoints[index].isAfter(tileData.event.start)) {
        scope.eventsController.selectedEvent!.end = snapPoints[index];
      } else {
        if (newEnd.isAfter(tileData.event.start)) {
          scope.eventsController.selectedEvent!.end = newEnd;
        }
      }

      currentVerticalSteps = steps;

      // Remove now from the snap points if applicable.
      if (snapToTimeIndicator) {
        snapPoints.remove(now);
      }
    }
  }

  /// Handles the onVerticalDragEnd event.
  Future<void> _onVerticalDragEnd(DragEndDetails details) async {
    CalendarEvent<T> selectedEvent = scope.eventsController.selectedEvent!;
    controller.isResizing = false;
    await scope.functions.onEventChanged?.call(
      initialDateTimeRange,
      selectedEvent,
    );
  }

  /// Handles the onRescheduleStart event.
  void _onRescheduleStart() {
    initialDateTimeRange = widget.visibleDateTimeRange;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;

    controller.isMoving = true;
    controller.setSelectedEvent(tileData.event);
    initialDateTimeRange = tileData.event.dateTimeRange;

    scope.functions.onEventChangeStart?.call(tileData.event);
  }

  /// Reschedules the [CalendarEvent] to the the [cursorOffset] or the nearest snap point.
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
    if (snapToTimeIndicator) {
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
      scope.eventsController.selectedEvent!.dateTimeRange = newDateTimeRange;
    }

    if (snapToTimeIndicator) {
      snapPoints.remove(now);
    }
  }

  /// Handles the onRescheduleUpdate event.
  Future<void> _onRescheduleEnd() async {
    await scope.functions.onEventChanged?.call(
      initialDateTimeRange,
      scope.eventsController.selectedEvent!,
    );
    controller.isMoving = false;
  }
}
