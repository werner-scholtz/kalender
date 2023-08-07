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

  @override
  State<MonthTileGestureDetector<T>> createState() => _MonthTileGestureDetectorState<T>();
}

class _MonthTileGestureDetectorState<T> extends State<MonthTileGestureDetector<T>> {
  late CalendarEvent<T> event;
  late DateTimeRange initialDateTimeRange;

  CalendarScope<T> get internals => CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => internals.eventsController;
  CalendarEventHandlers<T> get functions => internals.functions;

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    initialDateTimeRange = event.dateTimeRange;
  }

  @override
  void didUpdateWidget(covariant MonthTileGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
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
            cursor: SystemMouseCursors.resizeLeftRight,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: _onResizeStart,
              onHorizontalDragUpdate: _resizeStart,
              onHorizontalDragEnd: _onResizeEnd,
            ),
          ),
        ),
        Positioned(
          right: 0,
          width: 8,
          top: 0,
          bottom: 0,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: _onResizeStart,
              onHorizontalDragUpdate: _resizeEnd,
              onHorizontalDragEnd: _onResizeEnd,
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
    initialDateTimeRange = event.dateTimeRange;
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;
    controller.chaningEvent = event;
  }

  void _onPanEnd(DragEndDetails details) async {
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;
    await functions.onEventChanged?.call(initialDateTimeRange, event);
    controller.chaningEvent = null;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    cursorOffset += details.delta;

    int verticalSteps = (cursorOffset.dy / widget.verticalStep).round();
    if (verticalSteps != currentVerticalSteps) {
      currentVerticalSteps = verticalSteps;
    }

    int horizontalSteps = (cursorOffset.dx / widget.horizontalStep).round();
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
    await functions.onEventChanged?.call(event.dateTimeRange, controller.chaningEvent!);
    controller.chaningEvent = null;
  }

  void _resizeStart(DragUpdateDetails details) {
    cursorOffset += details.delta;
    int steps = (cursorOffset.dx / widget.horizontalStep).round();
    if (steps != currentHorizontalSteps) {
      DateTime newStart = initialDateTimeRange.start.add(widget.horizontalDurationStep * steps);

      if (controller.chaningEvent == null) return;
      if (newStart.isBefore(initialDateTimeRange.end)) {
        controller.chaningEvent?.start = newStart;
      }

      currentHorizontalSteps = steps;
    }
  }

  void _resizeEnd(DragUpdateDetails details) {
    cursorOffset += details.delta;
    int steps = (cursorOffset.dx / widget.horizontalStep).round();
    if (steps != currentHorizontalSteps) {
      DateTime newEnd = initialDateTimeRange.end.add(widget.horizontalDurationStep * steps);
      if (controller.chaningEvent == null) return;
      if (newEnd.isAfter(initialDateTimeRange.start)) {
        controller.chaningEvent?.end = newEnd;
      }

      currentHorizontalSteps = steps;
    }
  }
}
