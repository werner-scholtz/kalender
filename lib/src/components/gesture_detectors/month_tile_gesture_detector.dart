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
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: InkWell(
        onTap: _onTap,
        child: widget.child,
      ),
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
}
