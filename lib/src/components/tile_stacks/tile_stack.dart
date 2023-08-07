import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/day_tile_gesture_detector.dart';
import 'package:kalender/src/components/tile_stacks/chaning_tile_stack.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/tile_layout_controllers/tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/typedefs.dart';

class PositionedTileStack<T> extends StatelessWidget {
  const PositionedTileStack({
    super.key,
    required this.pageVisibleDateRange,
    required this.tileLayoutController,
    required this.dayWidth,
    required this.verticalStep,
    required this.verticalDurationStep,
    required this.eventSnapping,
    required this.timeIndicatorSnapping,
    this.horizontalStep,
    this.horizontalDurationStep,
  });

  final TileLayoutController<T> tileLayoutController;
  final DateTimeRange pageVisibleDateRange;
  final double dayWidth;
  final double verticalStep;
  final Duration verticalDurationStep;
  final double? horizontalStep;
  final Duration? horizontalDurationStep;
  final bool eventSnapping;
  final bool timeIndicatorSnapping;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of<T>(context);

    return ListenableBuilder(
      listenable: scope.eventsController,
      builder: (BuildContext context, Widget? child) {
        Iterable<CalendarEvent<T>> events = scope.eventsController.getDayEventsFromDateRange(
          pageVisibleDateRange,
        );

        // genrate the list of tile groups.
        Iterable<TileGroup<T>> tileGroups = tileLayoutController.generateTileGroups(
          events,
        );

        // Get a list of snap points.
        List<DateTime> snapPoints = <DateTime>[];

        if (eventSnapping) {
          // Add the snap points from other events.
          snapPoints.addAll(
            scope.eventsController.getSnapPointsFromDateTimeRange(pageVisibleDateRange),
          );
        }

        if (timeIndicatorSnapping) {
          // Add the snap point from the time indicator.
          snapPoints.add(DateTime.now());
        }

        // Build the stack.
        return Stack(
          children: <Widget>[
            ...tileGroups
                .map(
                  (TileGroup<T> tileGroup) => TileGroupStack<T>(
                    tileGroup: tileGroup,
                    dayWidth: dayWidth,
                    verticalStep: verticalStep,
                    horizontalStep: horizontalStep,
                    verticalDurationStep: verticalDurationStep,
                    horizontalDurationStep: horizontalDurationStep,
                    visibleDateRange: scope.state.visibleDateTimeRange.value,
                    snapPoints: snapPoints,
                  ),
                )
                .toList(),
            if (shouldDisplayTile(scope.eventsController))
              ChangingTileStack<T>(
                tileLayoutController: tileLayoutController,
              ),
          ],
        );
      },
    );
  }

  bool shouldDisplayTile(CalendarEventsController<T> controller) =>
      controller.hasChaningEvent &&
      (controller.isMoving || controller.isResizing || controller.isNewEvent);
}

class TileGroupStack<T> extends StatelessWidget {
  const TileGroupStack({
    super.key,
    required this.tileGroup,
    required this.dayWidth,
    required this.verticalDurationStep,
    required this.verticalStep,
    required this.horizontalDurationStep,
    required this.horizontalStep,
    required this.visibleDateRange,
    required this.snapPoints,
  });

  /// The visible [DateTimeRange].
  final DateTimeRange visibleDateRange;

  /// The width of each day.
  final double dayWidth;

  /// The duration of the vertical step when dragging/resizing an event.
  final Duration verticalDurationStep;
  final double verticalStep;

  /// The duration of the horizontal step when dragging an event.
  final Duration? horizontalDurationStep;
  final double? horizontalStep;

  final TileGroup<T> tileGroup;
  final List<DateTime> snapPoints;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> internals = CalendarScope.of<T>(context);
    CalendarEventHandlers<T> functions = internals.functions;
    CalendarEventsController<T> controller = internals.eventsController;
    return Positioned(
      left: tileGroup.tileGroupLeft,
      top: tileGroup.tileGroupTop,
      width: tileGroup.tileGroupWidth,
      height: tileGroup.tileGroupHeight,
      child: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ...tileGroup.tilePositionData.map(
              (PositionedTileData<T> positionedTileData) => PositionedTile<T>(
                controller: controller,
                onEventChanged: functions.onEventChanged,
                onEventTapped: functions.onEventTapped,
                positionedTileData: positionedTileData,
                dayWidth: dayWidth,
                verticalDurationStep: verticalDurationStep,
                verticalStep: verticalStep,
                horizontalDurationStep: horizontalDurationStep,
                horizontalStep: horizontalStep,
                visibleDateRange: visibleDateRange,
                pointsOfInterest: snapPoints,
                initialDateTimeRange: positionedTileData.event.dateTimeRange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PositionedTile<T> extends StatelessWidget {
  const PositionedTile({
    super.key,
    required this.controller,
    required this.onEventChanged,
    required this.onEventTapped,
    required this.positionedTileData,
    required this.dayWidth,
    required this.verticalDurationStep,
    required this.verticalStep,
    required this.horizontalDurationStep,
    required this.horizontalStep,
    required this.visibleDateRange,
    required this.pointsOfInterest,
    required this.initialDateTimeRange,
  });

  /// The [CalendarController] used by the [PositionedTile].
  final CalendarEventsController<T> controller;

  /// The [Function] called when the event is changed.
  final Function(DateTimeRange initialDateTimeRange, CalendarEvent<T> event)? onEventChanged;

  /// The [Function] called when the event is tapped.
  final Function(CalendarEvent<T> event)? onEventTapped;

  /// The visible [DateTimeRange].
  final DateTimeRange visibleDateRange;

  /// The [PositionedTileData] used by the [PositionedTile] to display the event.
  final PositionedTileData<T> positionedTileData;

  final DateTimeRange initialDateTimeRange;

  /// The width of each day.
  final double dayWidth;

  /// The duration of the vertical step when dragging/resizing an event.
  final Duration verticalDurationStep;
  final double verticalStep;

  /// The duration of the horizontal step when dragging an event.
  final Duration? horizontalDurationStep;
  final double? horizontalStep;

  final List<DateTime> pointsOfInterest;

  @override
  Widget build(BuildContext context) {
    TileBuilder<T> tileBuilder = CalendarScope.of<T>(context).tileComponents.tileBuilder!;
    bool isMoving = controller.chaningEvent == positionedTileData.event;

    bool continuesBefore = positionedTileData.event.continuesBefore(positionedTileData.date);
    bool continuesAfter = positionedTileData.event.continuesAfter(positionedTileData.date);

    return Positioned(
      left: positionedTileData.left,
      top: positionedTileData.top,
      width: positionedTileData.width,
      height: positionedTileData.height,
      child: DayTileGestureDetector<T>(
        event: positionedTileData.event,
        horizontalDurationStep: horizontalDurationStep,
        verticalDurationStep: verticalDurationStep,
        verticalStep: verticalStep,
        horizontalStep: horizontalStep,
        visibleDateTimeRange: visibleDateRange,
        snapPoints: pointsOfInterest,
        eventSnapping: pointsOfInterest.isNotEmpty,
        continuesBefore: continuesBefore,
        continuesAfter: continuesAfter,
        child: tileBuilder(
          positionedTileData.event,
          isMoving ? TileType.ghost : TileType.normal,
          positionedTileData.drawOutline,
          continuesBefore,
          continuesAfter,
        ),
      ),
    );
  }

  void onTap() async {
    // Set the changing event.
    controller.chaningEvent = positionedTileData.event;
    controller.isMoving = true;

    // Call the onEventTapped function.
    await onEventTapped?.call(controller.chaningEvent!);

    // Reset the changing event.
    controller.isMoving = false;
    controller.chaningEvent = null;
  }

  void onLongPressStart() {
    controller.isMoving = true;
    controller.chaningEvent = positionedTileData.event;
  }

  void onLongPressEnd() async {
    await onEventChanged?.call(initialDateTimeRange, controller.chaningEvent!);
    controller.chaningEvent = null;
    controller.isMoving = false;
  }

  void onPanStart() {
    controller.isMoving = true;
    controller.chaningEvent = positionedTileData.event;
  }

  void onPanEnd() async {
    await onEventChanged?.call(initialDateTimeRange, controller.chaningEvent!);
    controller.chaningEvent = null;
    controller.isMoving = false;
  }

  void onResizeStart() {
    controller.isResizing = true;
    controller.chaningEvent = positionedTileData.event;
  }

  void onResizeEnd() async {
    await onEventChanged?.call(initialDateTimeRange, controller.chaningEvent!);
    controller.chaningEvent = null;
    controller.isResizing = false;
  }

  void onReschedhuleEvent(DateTimeRange newDateTimeRange) {
    if (controller.chaningEvent == null) return;
    if (newDateTimeRange.start.isWithin(visibleDateRange) ||
        newDateTimeRange.end.isWithin(visibleDateRange)) {
      controller.chaningEvent!.dateTimeRange = newDateTimeRange;
    }
  }
}
