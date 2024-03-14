import 'package:flutter/material.dart';
import 'package:kalender/src/models/view_configurations/month_configurations/month_view_configuration.dart';

import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/tile_configurations/multi_day_tile_configuration.dart';

class MultiDayEventGestureDetector<T> extends StatefulWidget {
  const MultiDayEventGestureDetector({
    super.key,
    required this.event,
    required this.tileConfiguration,
    required this.rescheduleDateRange,
    required this.horizontalStep,
    required this.horizontalStepDuration,
    this.verticalStepDuration,
    this.verticalStep,
  });

  final CalendarEvent<T> event;
  final MultiDayTileConfiguration tileConfiguration;
  final DateTimeRange rescheduleDateRange;

  final double horizontalStep;
  final Duration horizontalStepDuration;

  final Duration? verticalStepDuration;
  final double? verticalStep;

  @override
  State<MultiDayEventGestureDetector<T>> createState() =>
      _MultiDayEventGestureDetectorState<T>();
}

class _MultiDayEventGestureDetectorState<T>
    extends State<MultiDayEventGestureDetector<T>> {
  CalendarScope<T> get scope => CalendarScope.of<T>(context);
  CalendarEventsController<T> get eventsController => scope.eventsController;
  CalendarEventHandlers<T> get functions => scope.functions;
  bool get isMobileDevice => scope.platformData.isMobileDevice;
  bool get useMobileGestures => isMobileDevice && widget.event.canModify;
  bool get useDesktopGestures => !isMobileDevice && widget.event.canModify;
  bool get canModify => widget.event.canModify;

  bool get canResize {
    final viewConfig = scope.state.viewConfiguration;
    if (viewConfig is MultiDayViewConfiguration) {
      return viewConfig.enableResizing;
    } else if (viewConfig is MonthViewConfiguration) {
      return viewConfig.enableResizing;
    } else {
      return true;
    }
  }

  bool get canReschedule {
    final viewConfig = scope.state.viewConfiguration;
    if (viewConfig is MultiDayViewConfiguration) {
      return viewConfig.enableRescheduling;
    } else if (viewConfig is MonthViewConfiguration) {
      return viewConfig.enableRescheduling;
    } else {
      return true;
    }
  }

  late DateTimeRange initialDateTimeRange;

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  @override
  void initState() {
    super.initState();
    initialDateTimeRange = widget.event.dateTimeRange;
  }

  @override
  void didUpdateWidget(covariant MultiDayEventGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.event != oldWidget.event) {
      initialDateTimeRange = widget.event.dateTimeRange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final onTap = _onTap;

    // Get the onPanStart, onPanUpdate, and onPanEnd functions.
    void Function(DragStartDetails details)? onPanStart;
    void Function(DragUpdateDetails details)? onPanUpdate;
    Future<void> Function(DragEndDetails details)? onPanEnd;
    if (useDesktopGestures && canReschedule) {
      onPanStart = _onRescheduleStart;
      onPanUpdate = _onRescheduleUpdate;
      onPanEnd = _onRescheduleEnd;
    }

    Widget? resizeLeft;
    Widget? resizeRight;

    if (useDesktopGestures && canResize) {
      resizeLeft = resizeLeftWidget();
      resizeRight = resizeRightWidget();
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onPanStart: onPanStart,
            onPanUpdate: onPanUpdate,
            onPanEnd: (details) async => await onPanEnd?.call(details),
            onTap: onTap,
            child: scope.tileComponents.multiDayTileBuilder!(
              widget.event,
              widget.tileConfiguration,
            ),
          ),
          if (resizeLeft != null) resizeLeft,
          if (resizeRight != null) resizeRight,
        ],
      ),
    );
  }

  /// Handles the onTap event.
  Future<void> _onTap() async {
    await functions.onEventTapped?.call(widget.event);

    scope.eventsController.forceUpdate();
  }

  /// Handles the onPanStart event.
  void _onRescheduleStart(DragStartDetails details) {
    // Reset the cursor offset and steps.
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;

    // Set the initial date time range.
    initialDateTimeRange = widget.event.dateTimeRange;

    // Set is rescheduling to true.
    eventsController.isRescheduling = true;

    // Select the event.
    eventsController.selectEvent(widget.event);

    // Call the onEventChangeStart function.
    scope.functions.onEventChangeStart?.call(widget.event);
  }

  /// Handles the onPanEnd event.
  Future<void> _onRescheduleEnd(DragEndDetails details) async {
    // Get the selected event.
    final selectedEvent = scope.eventsController.selectedEvent!;

    // Set is rescheduling to false.
    eventsController.isRescheduling = false;

    // Deselect the event.
    eventsController.deselectEvent();

    // Call the onEventChanged function.
    await functions.onEventChanged?.call(
      initialDateTimeRange,
      selectedEvent,
    );
  }

  /// Handles the onPanUpdate event.
  void _onRescheduleUpdate(DragUpdateDetails details) {
    // Add the delta to the cursor offset.
    cursorOffset += details.delta;

    // Calculate the horizontal and vertical steps.
    final horizontalSteps = (cursorOffset.dx / widget.horizontalStep).round();
    final verticalSteps = widget.verticalStep != null
        ? (cursorOffset.dy / widget.verticalStep!).round()
        : 0;

    // If the steps are the same as the current steps, return.
    if (widget.verticalStep != null &&
        currentHorizontalSteps == horizontalSteps &&
        currentVerticalSteps == verticalSteps) {
      return;
    } else if (widget.verticalStep == null &&
        currentHorizontalSteps == horizontalSteps) {
      return;
    }

    // Calculate the duration deltas.
    final horizontalDurationDelta =
        widget.horizontalStepDuration * horizontalSteps;
    final verticalDurationDelta =
        (widget.verticalStepDuration ?? Duration.zero) * verticalSteps;

    // Calculate the new date time range.
    final newDateTimeRange = DateTimeRange(
      start: initialDateTimeRange.start
          .add(horizontalDurationDelta)
          .add(verticalDurationDelta),
      end: initialDateTimeRange.end
          .add(horizontalDurationDelta)
          .add(verticalDurationDelta),
    );

    // Calculate the delta duration.
    final deltaDuration = newDateTimeRange.start.difference(
      eventsController.selectedEvent!.start,
    );

    // Check if the new date time range is within the reschedule date range.
    if ((newDateTimeRange.start.isWithin(widget.rescheduleDateRange) ||
        newDateTimeRange.end.isWithin(widget.rescheduleDateRange))) {
      eventsController.rescheduleSelectedEvent(deltaDuration);
    }

    // Set the current steps.
    currentHorizontalSteps = horizontalSteps;
    currentVerticalSteps = verticalSteps;
  }

  /// Handles the onHorizontalDragStart event. (Left)
  void _onHorizontalDragStartLeft(DragStartDetails details) {
    // Set is isResizingTop to true.
    eventsController.isResizingTop = true;

    _onHorizontalDragStart(details);
  }

  /// Handles the onHorizontalDragStart event. (Right)
  void _onHorizontalDragStartRight(DragStartDetails details) {
    // Set is isResizingBottom to true.
    eventsController.isResizingBottom = true;

    _onHorizontalDragStart(details);
  }

  /// Handles the _onHorizontalDragStartLeft && _onHorizontalDragStartRight events.
  void _onHorizontalDragStart(DragStartDetails details) {
    // Reset the cursor offset and steps.
    cursorOffset = Offset.zero;
    currentHorizontalSteps = 0;

    // Set the initial date time range.
    initialDateTimeRange = widget.event.dateTimeRange;

    // Select the event.
    eventsController.selectEvent(widget.event);

    // Call the onEventChangeStart function.
    scope.functions.onEventChangeStart?.call(widget.event);
  }

  void _onHorizontalDragUpdateLeft(DragUpdateDetails details) {
    // Add the delta to the cursor offset.
    cursorOffset += details.delta;

    // Calculate the horizontal steps.
    final steps = (cursorOffset.dx / widget.horizontalStep).round();

    // If the steps are the same as the current steps, return.
    if (steps == currentHorizontalSteps) return;

    // Calculate the new start.
    final newStart = initialDateTimeRange.start.add(
      widget.horizontalStepDuration * steps,
    );

    // Calculate the delta duration.
    final deltaDuration = newStart.difference(
      eventsController.selectedEvent!.start,
    );

    // Check that the new start is before the initial end.
    if (newStart.isBefore(initialDateTimeRange.end)) {
      eventsController.rescheduleSelectedEventStart(deltaDuration);
    }

    // Set the current horizontal steps.
    currentHorizontalSteps = steps;
  }

  void _onHorizontalDragUpdateRight(DragUpdateDetails details) {
    // Add the delta to the cursor offset.
    cursorOffset += details.delta;

    // Calculate the horizontal steps.
    final steps = (cursorOffset.dx / widget.horizontalStep).round();

    // If the steps are the same as the current steps, return.
    if (steps == currentHorizontalSteps) return;

    // Calculate the new end.
    final newEnd = initialDateTimeRange.end.add(
      widget.horizontalStepDuration * steps,
    );

    // Calculate the delta duration.
    final deltaDuration = newEnd.difference(
      eventsController.selectedEvent!.end,
    );

    // Check that the new end is after the initial start.
    if (newEnd.isAfter(initialDateTimeRange.start)) {
      eventsController.rescheduleSelectedEventEnd(deltaDuration);
    }

    // Set the current horizontal steps.
    currentHorizontalSteps = steps;
  }

  Future<void> _onHorizontalDragEnd(DragEndDetails details) async {
    // Get the selected event.
    final selectedEvent = scope.eventsController.selectedEvent!;

    // Deselect the event.
    eventsController.deselectEvent();

    // Set is isResizingTop and is isResizingBottom to false.
    eventsController.isResizingTop = false;
    eventsController.isResizingBottom = false;

    // Call the onEventChanged function.
    await functions.onEventChanged?.call(
      initialDateTimeRange,
      selectedEvent,
    );
  }

  Positioned resizeLeftWidget() {
    return Positioned(
      left: 0,
      width: 8,
      top: 0,
      bottom: 0,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: _onHorizontalDragStartLeft,
          onHorizontalDragUpdate: _onHorizontalDragUpdateLeft,
          onHorizontalDragEnd: (details) async => await _onHorizontalDragEnd(
            details,
          ),
        ),
      ),
    );
  }

  Positioned resizeRightWidget() {
    return Positioned(
      right: 0,
      width: 8,
      top: 0,
      bottom: 0,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: _onHorizontalDragStartRight,
          onHorizontalDragUpdate: _onHorizontalDragUpdateRight,
          onHorizontalDragEnd: (details) async =>
              await _onHorizontalDragEnd(details),
        ),
      ),
    );
  }
}
