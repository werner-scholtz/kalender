import 'package:flutter/material.dart';

class MultiDayTileGestureDetector extends StatefulWidget {
  const MultiDayTileGestureDetector({
    super.key,
    required this.child,
    required this.initialDateTimeRange,
    required this.dayWidth,
    required this.horizontalDurationStep,
    required this.onTap,
    required this.onHorizontalDragStart,
    required this.onHorizontalDragEnd,
    required this.rescheduleEvent,
  });

  final Widget child;
  final double dayWidth;
  final Duration horizontalDurationStep;
  final DateTimeRange initialDateTimeRange;

  final VoidCallback onTap;
  final VoidCallback onHorizontalDragStart;
  final VoidCallback onHorizontalDragEnd;
  final Function(DateTimeRange newDateTimeRange) rescheduleEvent;

  @override
  State<MultiDayTileGestureDetector> createState() => _MultiDayTileGestureDetectorState();
}

class _MultiDayTileGestureDetectorState extends State<MultiDayTileGestureDetector> {
  late Widget child;
  late DateTimeRange initialDateTimeRange;

  double cursorOffset = 0;
  int currentSteps = 0;

  @override
  void initState() {
    super.initState();
    child = widget.child;
    initialDateTimeRange = widget.initialDateTimeRange;
  }

  @override
  void didUpdateWidget(covariant MultiDayTileGestureDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    child = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onHorizontalDragStart: _onHorizontalDragStart,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        onTap: widget.onTap,
        child: child,
      ),
    );
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    initialDateTimeRange = widget.initialDateTimeRange;
    cursorOffset = 0;
    currentSteps = 0;
    widget.onHorizontalDragStart();
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    cursorOffset = 0;
    currentSteps = 0;
    widget.onHorizontalDragEnd();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    cursorOffset += details.delta.dx;
    int steps = (cursorOffset / widget.dayWidth).round();
    if (steps != currentSteps) {
      widget.rescheduleEvent(
        DateTimeRange(
          start: initialDateTimeRange.start.add(widget.horizontalDurationStep * steps),
          end: initialDateTimeRange.end.add(widget.horizontalDurationStep * steps),
        ),
      );
      currentSteps = steps;
    }
  }
}
