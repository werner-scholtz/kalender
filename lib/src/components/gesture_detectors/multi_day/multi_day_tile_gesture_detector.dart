import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

///A widget that detects gestures on a multiday tile.
/// TODO: Create a builder for a [MultiDayTileGestureDetector].
class MultiDayTileGestureDetector<T> extends StatefulWidget {
  const MultiDayTileGestureDetector({
    super.key,
    required this.horizontalStep,
    required this.horizontalDurationStep,
    required this.tileData,
    required this.visibleDateRange,
    required this.isMobileDevice,
    required this.isChanging,
  });

  final double horizontalStep;
  final Duration horizontalDurationStep;
  final PositionedMultiDayTileData<T> tileData;
  final DateTimeRange visibleDateRange;
  final bool isMobileDevice;
  final bool isChanging;

  @override
  State<MultiDayTileGestureDetector<T>> createState() =>
      _MultiDayTileGestureDetectorState<T>();
}

class _MultiDayTileGestureDetectorState<T>
    extends State<MultiDayTileGestureDetector<T>> {
  CalendarScope<T> get scope => CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => scope.eventsController;
  CalendarEventHandlers<T> get functions => scope.functions;

  late PositionedMultiDayTileData<T> tileData;
  late DateTimeRange initialDateTimeRange;
  late bool continuesBefore;
  late bool continuesAfter;

  late bool isMobileDevice;
  late bool useMobileGestures;
  late bool useDesktopGestures;

  bool get canModify => tileData.event.canModify;

  double cursorOffset = 0;
  int currentSteps = 0;

  @override
  void initState() {
    super.initState();
    tileData = widget.tileData;
    initialDateTimeRange = tileData.event.dateTimeRange;
    continuesBefore = tileData.continuesBefore;
    continuesAfter = tileData.continuesAfter;
    isMobileDevice = widget.isMobileDevice;
    useMobileGestures = isMobileDevice && tileData.event.canModify;
    useDesktopGestures = !isMobileDevice && tileData.event.canModify;
  }

  @override
  void didUpdateWidget(covariant MultiDayTileGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (tileData.event != widget.tileData.event) {
      tileData = widget.tileData;
      initialDateTimeRange = widget.tileData.event.dateTimeRange;
      continuesBefore = widget.tileData.continuesBefore;
      continuesAfter = widget.tileData.continuesAfter;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMoving = controller.selectedEvent == tileData.event;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onHorizontalDragStart:
                useDesktopGestures ? _onRescheduleStart : null,
            onHorizontalDragUpdate:
                useDesktopGestures ? _onRescheduleUpdate : null,
            onHorizontalDragEnd: useDesktopGestures ? _onRescheduleEnd : null,
            onTap: _onTap,
            child: scope.tileComponents.multiDayTileBuilder!(
              tileData.event,
              MultiDayTileConfiguration(
                tileType: widget.isChanging
                    ? TileType.selected
                    : isMoving
                        ? TileType.ghost
                        : TileType.normal,
                continuesBefore: continuesBefore,
                continuesAfter: continuesAfter,
              ),
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
    await functions.onEventTapped?.call(tileData.event);
    controller.updateUI();
  }

  void _onRescheduleStart(DragStartDetails details) {
    cursorOffset = 0;
    currentSteps = 0;
    initialDateTimeRange = widget.tileData.event.dateTimeRange;
    controller.setSelectedEvent(tileData.event);
    scope.functions.onEventChangeStart?.call(tileData.event);
  }

  Future<void> _onRescheduleEnd(DragEndDetails details) async {
    await functions.onEventChanged?.call(
      initialDateTimeRange,
      controller.selectedEvent!,
    );
    // controller.deselectEvent();
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
    initialDateTimeRange = tileData.event.dateTimeRange;
    controller.isResizing = true;
    controller.setSelectedEvent(tileData.event);
    scope.functions.onEventChangeStart?.call(tileData.event);
  }

  void _onHorizontalDragUpdateStart(DragUpdateDetails details) {
    cursorOffset += details.delta.dx;
    int steps = (cursorOffset / widget.horizontalStep).round();
    if (steps != currentSteps) {
      DateTime newStart =
          initialDateTimeRange.start.add(widget.horizontalDurationStep * steps);

      if (controller.selectedEvent == null) return;
      if (newStart.isBefore(initialDateTimeRange.end)) {
        controller.selectedEvent?.start = newStart;
      }
      currentSteps = steps;
    }
  }

  void _onHorizontalDragUpdateEnd(DragUpdateDetails details) {
    cursorOffset += details.delta.dx;
    int steps = (cursorOffset / widget.horizontalStep).round();
    if (steps != currentSteps) {
      DateTime newEnd =
          initialDateTimeRange.end.add(widget.horizontalDurationStep * steps);
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
