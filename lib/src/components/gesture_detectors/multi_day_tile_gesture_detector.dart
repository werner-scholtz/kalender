import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

/// TODO: Create a builder for a [MultiDayTileGestureDetector].
class MultiDayTileGestureDetector<T> extends StatefulWidget {
  const MultiDayTileGestureDetector({
    super.key,
    required this.child,
    required this.horizontalStep,
    required this.horizontalDurationStep,
    required this.event,
    required this.visibleDateRange,
  });

  final Widget child;
  final double horizontalStep;
  final Duration horizontalDurationStep;
  final CalendarEvent<T> event;
  final DateTimeRange visibleDateRange;

  @override
  State<MultiDayTileGestureDetector<T>> createState() =>
      _MultiDayTileGestureDetectorState<T>();
}

class _MultiDayTileGestureDetectorState<T>
    extends State<MultiDayTileGestureDetector<T>> {
  late Widget child;

  late CalendarEvent<T> event;
  late DateTimeRange initialDateTimeRange;

  CalendarScope<T> get scope => CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => scope.eventsController;
  CalendarEventHandlers<T> get functions => scope.functions;

  double cursorOffset = 0;
  int currentSteps = 0;

  @override
  void initState() {
    super.initState();
    child = widget.child;
    event = widget.event;
    initialDateTimeRange = event.dateTimeRange;
  }

  @override
  void didUpdateWidget(covariant MultiDayTileGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    child = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onHorizontalDragStart: _onRescheduleStart,
            onHorizontalDragUpdate: _onRescheduleUpdate,
            onHorizontalDragEnd: _onRescheduleEnd,
            onTap: _onTap,
            child: child,
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
      ),
    );
  }

  void _onTap() async {
    controller.isMultidayEvent = true;
    controller.chaningEvent = event;
    await functions.onEventTapped?.call(controller.chaningEvent!);
    controller.chaningEvent = null;
    controller.isMultidayEvent = false;
  }

  void _onRescheduleStart(DragStartDetails details) {
    event = widget.event;
    initialDateTimeRange = event.dateTimeRange;
    cursorOffset = 0;
    currentSteps = 0;
    controller.isMultidayEvent = true;
    controller.chaningEvent = event;
  }

  void _onRescheduleEnd(DragEndDetails details) {
    functions.onEventChanged
        ?.call(event.dateTimeRange, controller.chaningEvent!);
    controller.chaningEvent = null;
    controller.isMultidayEvent = false;
  }

  void _onRescheduleUpdate(DragUpdateDetails details) {
    cursorOffset += details.delta.dx;
    int steps = (cursorOffset / widget.horizontalStep).round();
    if (steps != currentSteps) {
      DateTimeRange newDateTimeRange = DateTimeRange(
        start: initialDateTimeRange.start
            .add(widget.horizontalDurationStep * steps),
        end:
            initialDateTimeRange.end.add(widget.horizontalDurationStep * steps),
      );

      if (controller.chaningEvent == null) return;

      if (newDateTimeRange.start.isWithin(widget.visibleDateRange) ||
          newDateTimeRange.end.isWithin(widget.visibleDateRange)) {
        controller.chaningEvent?.dateTimeRange = newDateTimeRange;
      }
      currentSteps = steps;
    }
  }

  void _onResizeStart(DragStartDetails details) {
    event = widget.event;
    initialDateTimeRange = event.dateTimeRange;
    cursorOffset = 0;
    currentSteps = 0;
    controller.isMultidayEvent = true;
    controller.chaningEvent = event;
  }

  void _onResizeEnd(DragEndDetails details) async {
    event = widget.event;
    await functions.onEventChanged
        ?.call(event.dateTimeRange, controller.chaningEvent!);
    controller.chaningEvent = null;
    controller.isMultidayEvent = false;
  }

  void _resizeStart(DragUpdateDetails details) {
    cursorOffset += details.delta.dx;
    int steps = (cursorOffset / widget.horizontalStep).round();
    if (steps != currentSteps) {
      DateTime newStart =
          initialDateTimeRange.start.add(widget.horizontalDurationStep * steps);

      if (controller.chaningEvent == null) return;
      if (newStart.isBefore(initialDateTimeRange.end)) {
        controller.chaningEvent?.start = newStart;
      }
      currentSteps = steps;
    }
  }

  void _resizeEnd(DragUpdateDetails details) {
    cursorOffset += details.delta.dx;
    int steps = (cursorOffset / widget.horizontalStep).round();
    if (steps != currentSteps) {
      DateTime newEnd =
          initialDateTimeRange.end.add(widget.horizontalDurationStep * steps);
      if (controller.chaningEvent == null) return;
      if (newEnd.isAfter(initialDateTimeRange.start)) {
        controller.chaningEvent?.end = newEnd;
      }

      currentSteps = steps;
    }
  }
}
