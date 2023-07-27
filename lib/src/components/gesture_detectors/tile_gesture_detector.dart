import 'package:flutter/material.dart';

class TileGestureDetector extends StatefulWidget {
  const TileGestureDetector({
    super.key,
    required this.child,
    required this.initialDateTimeRange,
    required this.verticalDurationStep,
    required this.verticalStep,
    required this.horizontalDurationStep,
    required this.horizontalStep,
    required this.onTap,
    required this.onPanStart,
    required this.onPanEnd,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.onRescheduleEvent,
    required this.snapPoints,
    required this.isMobileDevice,
    required this.eventSnapping,
  });
  final Widget child;

  final DateTimeRange initialDateTimeRange;

  /// The duration of the vertical step when dragging/resizing an event.
  final Duration verticalDurationStep;
  final double verticalStep;

  /// The duration of the horizontal step when dragging an event.
  final Duration? horizontalDurationStep;
  final double? horizontalStep;

  /// The [Function] called when the event is tapped.
  final VoidCallback? onTap;

  /// The [Function] called when a pan starts.
  ///
  /// Only used on desktop devices.
  final VoidCallback? onPanStart;

  /// The [Function] called when a pan ends.
  ///
  /// Only used on desktop devices.
  final VoidCallback? onPanEnd;

  /// The [Function] called when a long press starts.
  ///
  /// Only used on mobile devices.
  final VoidCallback? onLongPressStart;

  /// The [Function] called when a long press ends.
  ///
  /// Only used on mobile devices.
  final VoidCallback? onLongPressEnd;

  final Function(DateTimeRange newDateTimeRange) onRescheduleEvent;

  final List<DateTime> snapPoints;
  final bool isMobileDevice;
  final bool eventSnapping;

  @override
  State<TileGestureDetector> createState() => _TileGestureDetectorState();
}

class _TileGestureDetectorState extends State<TileGestureDetector> {
  late DateTimeRange initialDateTimeRange = widget.initialDateTimeRange;
  late List<DateTime> snapPoints;
  late bool eventSnapping;
  late bool isMobileDevice;

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  @override
  void initState() {
    super.initState();
    snapPoints = widget.snapPoints;
    isMobileDevice = widget.isMobileDevice;
  }

  @override
  void didUpdateWidget(covariant TileGestureDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    snapPoints = widget.snapPoints;
    eventSnapping = widget.eventSnapping;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onPanStart: isMobileDevice ? null : _onPanStart,
        onPanUpdate: isMobileDevice ? null : _onPanUpdate,
        onPanEnd: isMobileDevice ? null : _onPanEnd,
        onLongPressStart: isMobileDevice ? _onLongPressStart : null,
        onLongPressMoveUpdate: isMobileDevice ? _onLongPressMoveUpdate : null,
        onLongPressEnd: isMobileDevice ? _onLongPressEnd : null,
        onTap: widget.onTap,
        child: widget.child,
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _onRescheduleStart();
    widget.onPanStart?.call();
  }

  void _onPanEnd(DragEndDetails details) {
    _onRescheduleEnd();
    widget.onPanEnd?.call();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _onReschedule(cursorOffset += details.delta);
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _onRescheduleStart();
    widget.onLongPressStart?.call();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _onRescheduleEnd();
    widget.onLongPressEnd?.call();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _onReschedule(details.offsetFromOrigin);
  }

  void _onRescheduleStart() {
    initialDateTimeRange = widget.initialDateTimeRange;
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
      horizontalDurationDelta = widget.horizontalDurationStep! * horizontalSteps;
    }

    DateTime newStart = initialDateTimeRange.start
        .add(horizontalDurationDelta)
        .add(widget.verticalDurationStep * verticalSteps);

    DateTime newEnd = initialDateTimeRange.end
        .add(horizontalDurationDelta)
        .add(widget.verticalDurationStep * verticalSteps);

    int startIndex = snapPoints.indexWhere(
      (DateTime element) => element.difference(newStart).abs() <= const Duration(minutes: 15),
    );

    int endIndex = snapPoints.indexWhere(
      (DateTime element) => element.difference(newEnd).abs() <= const Duration(minutes: 15),
    );

    if (startIndex != -1) {
      newStart = snapPoints[startIndex];
      newEnd = newStart.add(initialDateTimeRange.duration);
    } else if (endIndex != -1) {
      newEnd = snapPoints[endIndex];
      newStart = newEnd.subtract(initialDateTimeRange.duration);
    }

    widget.onRescheduleEvent(
      DateTimeRange(
        start: newStart,
        end: newEnd,
      ),
    );
  }
}
