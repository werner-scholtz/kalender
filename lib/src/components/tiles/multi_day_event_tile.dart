import 'package:flutter/material.dart';
import 'package:kalender/src/models/view_configurations/month_configurations/month_view_configuration.dart';

import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/tile_configurations/multi_day_tile_configuration.dart';

// TODO: Add resize and reschedule for mobile.

class MultiDayEventTile<T> extends StatefulWidget {
  const MultiDayEventTile({
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
  State<MultiDayEventTile<T>> createState() => _MultiDayEventTileState<T>();
}

class _MultiDayEventTileState<T> extends State<MultiDayEventTile<T>> {
  CalendarScope<T> get scope => CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => scope.eventsController;
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
  void didUpdateWidget(covariant MultiDayEventTile<T> oldWidget) {
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

  Future<void> _onTap() async {
    await functions.onEventTapped?.call(widget.event);
    // controller.forceUpdate();
  }

  void _onRescheduleStart(DragStartDetails details) {
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;

    initialDateTimeRange = widget.event.dateTimeRange;
    controller.isRescheduling = true;
    controller.selectEvent(widget.event);
    scope.functions.onEventChangeStart?.call(widget.event);
  }

  Future<void> _onRescheduleEnd(DragEndDetails details) async {
    final selectedEvent = scope.eventsController.selectedEvent!;
    controller.isRescheduling = false;
    controller.deselectEvent();

    await functions.onEventChanged?.call(
      initialDateTimeRange,
      selectedEvent,
    );
  }

  void _onRescheduleUpdate(DragUpdateDetails details) {
    cursorOffset += details.delta;

    final horizontalSteps = (cursorOffset.dx / widget.horizontalStep).round();
    final verticalSteps = widget.verticalStep != null
        ? (cursorOffset.dy / widget.verticalStep!).round()
        : 0;

    if (widget.verticalStep != null &&
        currentHorizontalSteps == horizontalSteps &&
        currentVerticalSteps == verticalSteps) {
      return;
    } else if (widget.verticalStep == null &&
        currentHorizontalSteps == horizontalSteps) {
      return;
    }

    final dHorizontal = widget.horizontalStepDuration * horizontalSteps;
    final dVertical =
        (widget.verticalStepDuration ?? Duration.zero) * verticalSteps;

    final newDateTimeRange = DateTimeRange(
      start: initialDateTimeRange.start.add(dHorizontal).add(dVertical),
      end: initialDateTimeRange.end.add(dHorizontal).add(dVertical),
    );

    if ((newDateTimeRange.start.isWithin(widget.rescheduleDateRange) ||
        newDateTimeRange.end.isWithin(widget.rescheduleDateRange))) {
      controller.selectedEvent!.dateTimeRange = newDateTimeRange;
    }

    currentHorizontalSteps = horizontalSteps;
    currentVerticalSteps = verticalSteps;
  }

  void _onHorizontalDragStartLeft(DragStartDetails details) {
    controller.isResizingTop = true;
    _onHorizontalDragStart(details);
  }

  void _onHorizontalDragStartRight(DragStartDetails details) {
    controller.isResizingBottom = true;
    _onHorizontalDragStart(details);
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    cursorOffset = Offset.zero;
    currentHorizontalSteps = 0;
    initialDateTimeRange = widget.event.dateTimeRange;
    controller.selectEvent(widget.event);
    scope.functions.onEventChangeStart?.call(widget.event);
  }

  void _onHorizontalDragUpdateLeft(DragUpdateDetails details) {
    cursorOffset += details.delta;
    final steps = (cursorOffset.dx / widget.horizontalStep).round();
    if (steps != currentHorizontalSteps) {
      final newStart =
          initialDateTimeRange.start.add(widget.horizontalStepDuration * steps);

      if (controller.selectedEvent == null) return;
      if (newStart.isBefore(initialDateTimeRange.end)) {
        controller.selectedEvent?.start = newStart;
      }
      currentHorizontalSteps = steps;
    }
  }

  void _onHorizontalDragUpdateRight(DragUpdateDetails details) {
    cursorOffset += details.delta;
    final steps = (cursorOffset.dx / widget.horizontalStep).round();
    if (steps != currentHorizontalSteps) {
      final newEnd =
          initialDateTimeRange.end.add(widget.horizontalStepDuration * steps);
      if (controller.selectedEvent == null) return;
      if (newEnd.isAfter(initialDateTimeRange.start)) {
        controller.selectedEvent?.end = newEnd;
      }

      currentHorizontalSteps = steps;
    }
  }

  Future<void> _onHorizontalDragEnd(DragEndDetails details) async {
    final selectedEvent = scope.eventsController.selectedEvent!;
    controller.deselectEvent();
    controller.isResizingTop = false;
    controller.isResizingBottom = false;

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
