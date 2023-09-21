import 'package:flutter/material.dart';
import 'package:kalender/kalendar_scope.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/tile_configurations/multi_day_tile_configuration.dart';

class MultiDayEventTile<T> extends StatefulWidget {
  const MultiDayEventTile({
    super.key,
    required this.event,
    required this.tileConfiguration,
    required this.visibleDateRange,
    required this.horizontalStep,
    required this.horizontalStepDuration,
  });

  final CalendarEvent<T> event;
  final MultiDayTileConfiguration tileConfiguration;
  final DateTimeRange visibleDateRange;
  final double horizontalStep;
  final Duration horizontalStepDuration;

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
  late DateTimeRange initialDateTimeRange;

  double cursorOffset = 0;
  int currentSteps = 0;

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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Stack(
        children: [
          GestureDetector(
            onHorizontalDragStart:
                useDesktopGestures ? _onRescheduleStart : null,
            onHorizontalDragUpdate:
                useDesktopGestures ? _onRescheduleUpdate : null,
            onHorizontalDragEnd: useDesktopGestures ? _onRescheduleEnd : null,
            onTap: _onTap,
            child: scope.tileComponents.multiDayTileBuilder!(
              widget.event,
              widget.tileConfiguration,
            ),
          ),
          if (useDesktopGestures)
            Positioned(
              left: 0,
              width: 8,
              top: 0,
              bottom: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragStart: _onHorizontalDragStart,
                  onHorizontalDragUpdate: _onHorizontalDragUpdateStart,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                ),
              ),
            ),
          if (useDesktopGestures)
            Positioned(
              right: 0,
              width: 8,
              top: 0,
              bottom: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragStart: _onHorizontalDragStart,
                  onHorizontalDragUpdate: _onHorizontalDragUpdateEnd,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onTap() async {
    await functions.onEventTapped?.call(widget.event);
    controller.forceUpdate();
  }

  void _onRescheduleStart(DragStartDetails details) {
    cursorOffset = 0;
    currentSteps = 0;
    initialDateTimeRange = widget.event.dateTimeRange;
    controller.selectEvent(widget.event);
    scope.functions.onEventChangeStart?.call(widget.event);
  }

  Future<void> _onRescheduleEnd(DragEndDetails details) async {
    await functions.onEventChanged?.call(
      initialDateTimeRange,
      controller.selectedEvent!,
    );
  }

  void _onRescheduleUpdate(DragUpdateDetails details) {
    cursorOffset += details.delta.dx;
    final steps = (cursorOffset / widget.horizontalStep).round();
    if (steps != currentSteps) {
      final newDateTimeRange = DateTimeRange(
        start: initialDateTimeRange.start
            .add(widget.horizontalStepDuration * steps),
        end:
            initialDateTimeRange.end.add(widget.horizontalStepDuration * steps),
      );

      if (controller.selectedEvent == null) return;

      if (newDateTimeRange.start.isWithin(widget.visibleDateRange) ||
          newDateTimeRange.end.isWithin(widget.visibleDateRange)) {
        controller.selectedEvent?.dateTimeRange = newDateTimeRange;
      }
      currentSteps = steps;
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    cursorOffset = 0;
    currentSteps = 0;
    initialDateTimeRange = widget.event.dateTimeRange;
    controller.isResizing = true;
    controller.selectEvent(widget.event);
    scope.functions.onEventChangeStart?.call(widget.event);
  }

  void _onHorizontalDragUpdateStart(DragUpdateDetails details) {
    cursorOffset += details.delta.dx;
    final steps = (cursorOffset / widget.horizontalStep).round();
    if (steps != currentSteps) {
      final newStart =
          initialDateTimeRange.start.add(widget.horizontalStepDuration * steps);

      if (controller.selectedEvent == null) return;
      if (newStart.isBefore(initialDateTimeRange.end)) {
        controller.selectedEvent?.start = newStart;
      }
      currentSteps = steps;
    }
  }

  void _onHorizontalDragUpdateEnd(DragUpdateDetails details) {
    cursorOffset += details.delta.dx;
    final steps = (cursorOffset / widget.horizontalStep).round();
    if (steps != currentSteps) {
      final newEnd =
          initialDateTimeRange.end.add(widget.horizontalStepDuration * steps);
      if (controller.selectedEvent == null) return;
      if (newEnd.isAfter(initialDateTimeRange.start)) {
        controller.selectedEvent?.end = newEnd;
      }

      currentSteps = steps;
    }
  }

  Future<void> _onHorizontalDragEnd(DragEndDetails details) async {
    await functions.onEventChanged?.call(
      initialDateTimeRange,
      controller.selectedEvent!,
    );

    controller.isResizing = false;
  }
}
