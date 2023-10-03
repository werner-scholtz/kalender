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

  ValueNotifier<bool> canResizeTop = ValueNotifier(true);
  ValueNotifier<bool> canResizeBottom = ValueNotifier(true);

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

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTap: _onTap,
                onPanStart: useDesktopGestures ? _onPanStart : null,
                onPanUpdate: useDesktopGestures ? _onPanUpdate : null,
                onPanEnd: useDesktopGestures
                    ? (details) async => _onPanEnd(details)
                    : null,
                onLongPressStart: useMobileGestures ? _onLongPressStart : null,
                onLongPressMoveUpdate:
                    useMobileGestures ? _onLongPressMoveUpdate : null,
                onLongPressEnd: useMobileGestures
                    ? (details) async => _onLongPressEnd(details)
                    : null,
                child: scope.tileComponents.tileBuilder!(
                  widget.event,
                  widget.tileConfiguration,
                ),
              ),
              if (widget.event.canModify &&
                  !widget.tileConfiguration.continuesBefore)
                useMobileGestures && widget.isChanging
                    ? Positioned(
                        top: 0,
                        right: 0,
                        height: handleSize,
                        width: handleSize,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onVerticalDragStart: (details) {
                            _onVerticalDragStart(details);
                            canResizeBottom.value = false;
                          },
                          onVerticalDragUpdate: _onVerticalDragUpdateStart,
                          onVerticalDragEnd: (details) async {
                            _onVerticalDragEnd(details);
                            canResizeBottom.value = true;
                          },
                          child: ValueListenableBuilder(
                            valueListenable: canResizeTop,
                            builder: (context, value, child) {
                              return scope.components.tileHandleBuilder(value);
                            },
                          ),
                        ),
                      )
                    : useDesktopGestures
                        ? Positioned(
                            top: 0,
                            height: 16,
                            left: 0,
                            right: 0,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeRow,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onVerticalDragStart: _onVerticalDragStart,
                                onVerticalDragUpdate:
                                    _onVerticalDragUpdateStart,
                                onVerticalDragEnd: (details) async =>
                                    _onVerticalDragEnd(details),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
              if (widget.event.canModify &&
                  !widget.tileConfiguration.continuesAfter)
                useMobileGestures && widget.isChanging
                    ? Positioned(
                        bottom: 0,
                        left: 0,
                        height: handleSize,
                        width: handleSize,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onVerticalDragStart: (details) {
                            _onVerticalDragStart(details);
                            canResizeTop.value = false;
                          },
                          onVerticalDragUpdate: _onVerticalDragUpdateEnd,
                          onVerticalDragEnd: (details) async {
                            _onVerticalDragEnd(details);
                            canResizeTop.value = true;
                          },
                          child: ValueListenableBuilder(
                            valueListenable: canResizeBottom,
                            builder: (context, value, child) {
                              return scope.components.tileHandleBuilder(value);
                            },
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
                                onVerticalDragEnd: (details) async =>
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
    await scope.functions.onEventTapped?.call(widget.event);

    // controller.forceUpdate();
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
    initialDateTimeRange = widget.event.dateTimeRange;
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    controller.selectEvent(widget.event);
  }

  /// Handles the onVerticalDragUpdate event (Start).
  void _onVerticalDragUpdateStart(DragUpdateDetails details) {
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
  void _onVerticalDragUpdateEnd(DragUpdateDetails details) {
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

  /// Handles the onRescheduleUpdate event.
  Future<void> _onRescheduleEnd() async {
    final selectedEvent = scope.eventsController.selectedEvent!;
    controller.deselectEvent();

    await scope.functions.onEventChanged?.call(
      initialDateTimeRange,
      selectedEvent,
    );
  }
}
