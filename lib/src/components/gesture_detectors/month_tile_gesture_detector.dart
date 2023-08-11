import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class MonthTileGestureDetector<T> extends StatefulWidget {
  const MonthTileGestureDetector({
    super.key,
    required this.event,
    required this.visibleDateRange,
    required this.verticalDurationStep,
    required this.verticalStep,
    required this.horizontalDurationStep,
    required this.horizontalStep,
    required this.enableResizing,
    required this.child,
  });

  final Widget child;

  /// The event.
  final CalendarEvent<T> event;

  /// The visible date range.
  final DateTimeRange visibleDateRange;

  /// The duration of the vertical step when dragging/resizing an event.
  final Duration verticalDurationStep;

  /// The pixel value of the vertical step.
  final double verticalStep;

  /// The duration of the horizontal step when dragging an event.
  final Duration horizontalDurationStep;

  /// The pixel value of the horizontal step.
  final double horizontalStep;

  /// Whether resizing is enabled.
  final bool enableResizing;

  @override
  State<MonthTileGestureDetector<T>> createState() =>
      _MonthTileGestureDetectorState<T>();
}

class _MonthTileGestureDetectorState<T>
    extends State<MonthTileGestureDetector<T>> {
  late CalendarEvent<T> event;
  late DateTimeRange initialDateTimeRange;
  late bool enableResizing;

  CalendarScope<T> get internals => CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => internals.eventsController;
  CalendarEventHandlers<T> get functions => internals.functions;
  bool get isMobileDevice => internals.platformData.isMobileDevice;

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    initialDateTimeRange = event.dateTimeRange;
    enableResizing = widget.enableResizing;
  }

  @override
  void didUpdateWidget(covariant MonthTileGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    event = widget.event;
    enableResizing = widget.enableResizing;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onPanStart: isMobileDevice ? null : _onPanStart,
            onPanUpdate: isMobileDevice ? null : _onPanUpdate,
            onPanEnd: isMobileDevice ? null : _onPanEnd,
            onLongPressStart: isMobileDevice ? _onLongPressStart : null,
            onLongPressEnd: isMobileDevice ? _onLongPressEnd : null,
            onLongPressMoveUpdate:
                isMobileDevice ? _onLongPressMoveUpdate : null,
            onTap: _onTap,
            child: widget.child,
          ),
        ),
        Positioned(
          left: 0,
          width: 8,
          top: 0,
          bottom: 0,
          child: MouseRegion(
            cursor: enableResizing
                ? SystemMouseCursors.resizeLeftRight
                : SystemMouseCursors.basic,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart:
                  isMobileDevice || !enableResizing ? null : _onResizeStart,
              onHorizontalDragUpdate:
                  isMobileDevice || !enableResizing ? null : _resizeStart,
              onHorizontalDragEnd:
                  isMobileDevice || !enableResizing ? null : _onResizeEnd,
            ),
          ),
        ),
        Positioned(
          right: 0,
          width: 8,
          top: 0,
          bottom: 0,
          child: MouseRegion(
            cursor: enableResizing
                ? SystemMouseCursors.resizeLeftRight
                : SystemMouseCursors.basic,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart:
                  isMobileDevice || !enableResizing ? null : _onResizeStart,
              onHorizontalDragUpdate:
                  isMobileDevice || !enableResizing ? null : _resizeEnd,
              onHorizontalDragEnd:
                  isMobileDevice || !enableResizing ? null : _onResizeEnd,
            ),
          ),
        ),
      ],
    );
  }

  void _onTap() async {
    controller.chaningEvent = event;
    await functions.onEventTapped?.call(event);
    controller.chaningEvent = null;
  }

  void _onPanStart(DragStartDetails details) {
    cursorOffset = Offset.zero;
    _onRescheduleStart();
  }

  void _onPanEnd(DragEndDetails details) async {
    await _onRescheduleEnd();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    cursorOffset += details.delta;
    _onRescheduleUpdate(cursorOffset);
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _onRescheduleStart();
  }

  void _onLongPressEnd(LongPressEndDetails details) async {
    await _onRescheduleEnd();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _onRescheduleUpdate(details.offsetFromOrigin);
  }

  void _onRescheduleStart() {
    initialDateTimeRange = event.dateTimeRange;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;
    controller.chaningEvent = event;
  }

  Future<void> _onRescheduleEnd() async {
    await functions.onEventChanged?.call(initialDateTimeRange, event);
    controller.chaningEvent = null;
  }

  void _onRescheduleUpdate(Offset offset) {
    int verticalSteps = (offset.dy / widget.verticalStep).round();
    if (verticalSteps != currentVerticalSteps) {
      currentVerticalSteps = verticalSteps;
    }

    int horizontalSteps = (offset.dx / widget.horizontalStep).round();
    if (horizontalSteps != currentHorizontalSteps) {
      currentHorizontalSteps = horizontalSteps;
    }

    DateTimeRange newDateTimeRange = DateTimeRange(
      start: initialDateTimeRange.start
          .add(widget.horizontalDurationStep * horizontalSteps)
          .add(widget.verticalDurationStep * verticalSteps),
      end: initialDateTimeRange.end
          .add(widget.horizontalDurationStep * horizontalSteps)
          .add(widget.verticalDurationStep * verticalSteps),
    );

    if ((newDateTimeRange.start.isWithin(widget.visibleDateRange) ||
        newDateTimeRange.end.isWithin(widget.visibleDateRange))) {
      controller.chaningEvent!.dateTimeRange = newDateTimeRange;
    }
  }

  void _onResizeStart(DragStartDetails details) {
    event = widget.event;
    initialDateTimeRange = event.dateTimeRange;
    cursorOffset = Offset.zero;
    currentHorizontalSteps = 0;
    controller.chaningEvent = event;
  }

  void _onResizeEnd(DragEndDetails details) async {
    event = widget.event;
    await functions.onEventChanged
        ?.call(event.dateTimeRange, controller.chaningEvent!);
    controller.chaningEvent = null;
  }

  /// TODO: If the event starts at a time other than 00:00, then the event might not allow resizing
  void _resizeStart(DragUpdateDetails details) {
    cursorOffset += details.delta;
    int steps = (cursorOffset.dx / widget.horizontalStep).round();
    if (steps != currentHorizontalSteps) {
      DateTime newStart =
          initialDateTimeRange.start.add(widget.horizontalDurationStep * steps);

      if (controller.chaningEvent == null) return;
      if (newStart.isBefore(initialDateTimeRange.end)) {
        controller.chaningEvent?.start = newStart;
      }

      currentHorizontalSteps = steps;
    }
  }

  /// TODO: If the event ends at a time other than 00:00, then the event might not allow resizing
  void _resizeEnd(DragUpdateDetails details) {
    cursorOffset += details.delta;
    int steps = (cursorOffset.dx / widget.horizontalStep).round();
    if (steps != currentHorizontalSteps) {
      DateTime newEnd =
          initialDateTimeRange.end.add(widget.horizontalDurationStep * steps);
      if (controller.chaningEvent == null) return;
      if (newEnd.isAfter(initialDateTimeRange.start)) {
        controller.chaningEvent?.end = newEnd;
      }

      currentHorizontalSteps = steps;
    }
  }
}
