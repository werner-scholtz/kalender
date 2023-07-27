import 'package:flutter/material.dart';

class TileResizeDetector extends StatefulWidget {
  const TileResizeDetector({
    super.key,
    required this.height,
    required this.width,
    required this.verticalStep,
    required this.verticalDurationStep,
    required this.onVerticalDragStart,
    required this.onVerticalDragEnd,
    required this.resizeStart,
    required this.resizeEnd,
    required this.initialDateTimeRange,
    required this.snapPoints,
    required this.disableTop,
    required this.disableBottom,
  });

  final double height;
  final double width;
  final Duration verticalDurationStep;
  final double verticalStep;
  final bool disableTop;
  final bool disableBottom;
  final DateTimeRange initialDateTimeRange;

  final VoidCallback? onVerticalDragStart;
  final VoidCallback? onVerticalDragEnd;
  final Function(DateTime duration)? resizeStart;
  final Function(DateTime duration)? resizeEnd;

  final List<DateTime> snapPoints;

  @override
  State<TileResizeDetector> createState() => _TileResizeDetectorState();
}

class _TileResizeDetectorState extends State<TileResizeDetector> {
  late DateTimeRange initialDateTimeRange = widget.initialDateTimeRange;
  late List<DateTime> snapPoints;
  double cursorVerticalOffset = 0;
  int currentSteps = 0;

  @override
  void initState() {
    super.initState();
    snapPoints = widget.snapPoints;
  }

  @override
  void didUpdateWidget(covariant TileResizeDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    snapPoints = widget.snapPoints;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          widget.disableTop
              ? const SizedBox.shrink()
              : MouseRegion(
                  cursor: SystemMouseCursors.resizeRow,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragStart: _onVerticalDragStart,
                    onVerticalDragUpdate: _resizeStart,
                    onVerticalDragEnd: _onVerticalDragEnd,
                    child: Container(
                      height: 5,
                      width: widget.width,
                      color: Colors.transparent,
                    ),
                  ),
                ),
          widget.disableBottom
              ? const SizedBox.shrink()
              : MouseRegion(
                  cursor: SystemMouseCursors.resizeRow,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragStart: _onVerticalDragStart,
                    onVerticalDragUpdate: _resizeEnd,
                    onVerticalDragEnd: _onVerticalDragEnd,
                    child: Container(
                      height: 5,
                      width: widget.width,
                      color: Colors.transparent,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  void _onVerticalDragStart(DragStartDetails details) {
    initialDateTimeRange = widget.initialDateTimeRange;
    cursorVerticalOffset = 0;
    currentSteps = 0;
    widget.onVerticalDragStart?.call();
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    initialDateTimeRange = widget.initialDateTimeRange;
    cursorVerticalOffset = 0;
    currentSteps = 0;
    widget.onVerticalDragEnd?.call();
  }

  void _resizeStart(DragUpdateDetails details) {
    cursorVerticalOffset += details.delta.dy;

    int steps = (cursorVerticalOffset / widget.verticalStep).round();
    if (steps != currentSteps) {
      DateTime newStart = initialDateTimeRange.start.add(widget.verticalDurationStep * steps);

      int index = snapPoints.indexWhere(
        (element) => element.difference(newStart).abs() <= const Duration(minutes: 15),
      );

      if (index != -1) {
        widget.resizeStart?.call(snapPoints[index]);
      } else {
        widget.resizeStart?.call(newStart);
      }

      currentSteps = steps;
    }
  }

  void _resizeEnd(DragUpdateDetails details) {
    cursorVerticalOffset += details.delta.dy;
    int steps = (cursorVerticalOffset / widget.verticalStep).round();
    if (steps != currentSteps) {
      DateTime newEnd = initialDateTimeRange.end.add(widget.verticalDurationStep * steps);

      int index = snapPoints.indexWhere(
        (element) => element.difference(newEnd).abs() <= const Duration(minutes: 15),
      );

      if (index != -1) {
        widget.resizeEnd?.call(snapPoints[index]);
      } else {
        widget.resizeEnd?.call(newEnd);
      }

      currentSteps = steps;
    }
  }
}
