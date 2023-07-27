import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/tile_gesture_detector.dart';
import 'package:kalender/src/components/gesture_detectors/tile_resize_detector.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_configuration.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/calendar/calendar_state.dart';
import 'package:kalender/src/models/tile_layout_controllers/tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_internals.dart';
import 'package:kalender/src/typedefs.dart';

class PositionedTileStack<T extends Object?> extends StatelessWidget {
  const PositionedTileStack({
    super.key,
    required this.pageVisibleDateRange,
    required this.tileLayoutController,
    required this.dayWidth,
    required this.verticalStep,
    required this.verticalDurationStep,
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

  @override
  Widget build(BuildContext context) {
    CalendarInternals<T> internals = CalendarInternals.of<T>(context);
    CalendarViewState state = internals.state;
    CalendarConfiguration configuration = internals.configuration;
    CalendarController<T> controller = internals.controller;

    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        Iterable<CalendarEvent<T>> events = controller.getDayEventsFromDateRange(
          pageVisibleDateRange,
        );

        // The list of tile groups.
        Iterable<TileGroup<T>> tileGroups = tileLayoutController.generateTileGroups(
          events,
        );

        // The list of snap points.
        List<DateTime> snapPoints = <DateTime>[];
        if (configuration.eventSnapping) {
          snapPoints.addAll(
            controller.getSnapPointsFromDateTimeRange(pageVisibleDateRange),
          );
        }
        if (configuration.timeIndicatorSnapping) {
          snapPoints.add(DateTime.now());
        }

        // Build the stack.
        return Stack(
          children: tileGroups
              .map(
                (TileGroup<T> tileGroup) => TileGroupStack<T>(
                  tileGroup: tileGroup,
                  dayWidth: dayWidth,
                  verticalStep: verticalStep,
                  horizontalStep: horizontalStep,
                  verticalDurationStep: verticalDurationStep,
                  horizontalDurationStep: horizontalDurationStep,
                  visibleDateRange: state.visibleDateRange.value,
                  snapPoints: snapPoints,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class TileGroupStack<T extends Object?> extends StatelessWidget {
  const TileGroupStack({
    super.key,
    required this.tileGroup,
    // required this.onEventChanged,
    // required this.onEventTapped,
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
    CalendarInternals<T> internals = CalendarInternals.of<T>(context);
    CalendarFunctions<T> functions = internals.functions;
    CalendarController<T> controller = internals.controller;
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

class PositionedTile<T extends Object?> extends StatelessWidget {
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
  final CalendarController<T> controller;

  /// The [Function] called when the event is changed.
  final Function(DateTimeRange initialDateTimeRange, CalendarEvent<T> event)? onEventChanged;

  /// The [Function] called when the event is tapped.
  final Function(CalendarEvent<T> event)? onEventTapped;

  /// The visible [DateTimeRange].
  final DateTimeRange visibleDateRange;

  /// The [ArragnedEvent] used by the [PositionedTile].
  ///
  /// This is used to display the:
  /// [eventTileBuilder] and [ghostEventTileBuilder]
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
    EventTileBuilder<T> tileBuilder = CalendarInternals.of<T>(context).components.eventTileBuilder;
    bool isMobileDevice = CalendarInternals.of<T>(context).configuration.isMobileDevice;
    bool isMoving = controller.chaningEvent == positionedTileData.event;

    return Positioned(
      left: positionedTileData.left,
      top: positionedTileData.top,
      width: positionedTileData.width,
      height: positionedTileData.height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          TileGestureDetector(
            horizontalDurationStep: horizontalDurationStep,
            verticalDurationStep: verticalDurationStep,
            verticalStep: verticalStep,
            horizontalStep: horizontalStep,
            onTap: onTap,
            onLongPressStart: onLongPressStart,
            onLongPressEnd: onLongPressEnd,
            onPanStart: onPanStart,
            onPanEnd: onPanEnd,
            onRescheduleEvent: onReschedhuleEvent,
            initialDateTimeRange: positionedTileData.event.dateTimeRange,
            snapPoints: pointsOfInterest,
            isMobileDevice: isMobileDevice,
            eventSnapping: pointsOfInterest.isNotEmpty,
            child: tileBuilder(
              positionedTileData.event,
              isMoving ? TileType.ghost : TileType.normal,
              positionedTileData.drawOutline,
              positionedTileData.event.isSplitAcrossDays &&
                  !positionedTileData.date.isSameDay(positionedTileData.event.start),
              positionedTileData.event.isSplitAcrossDays &&
                  positionedTileData.date.isSameDay(positionedTileData.event.start),
            ),
          ),
          TileResizeDetector(
            height: positionedTileData.height,
            width: positionedTileData.width,
            verticalStep: verticalStep,
            verticalDurationStep: verticalDurationStep,
            onVerticalDragStart: isMobileDevice ? null : onResizeStart,
            onVerticalDragEnd: isMobileDevice ? null : onResizeEnd,
            resizeStart: isMobileDevice ? null : _resizeStart,
            resizeEnd: isMobileDevice ? null : _resizeEnd,
            initialDateTimeRange: positionedTileData.event.dateTimeRange,
            snapPoints: pointsOfInterest,
            disableTop: positionedTileData.event.isSplitAcrossDays &&
                !positionedTileData.event.start.isSameDay(positionedTileData.date),
            disableBottom: positionedTileData.event.isSplitAcrossDays &&
                !positionedTileData.event.end.isSameDay(positionedTileData.date),
          ),
        ],
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

  void _resizeStart(DateTime newStart) {
    if (controller.chaningEvent == null) return;
    controller.chaningEvent!.start = newStart;
  }

  void _resizeEnd(DateTime newEnd) {
    if (controller.chaningEvent == null) return;
    controller.chaningEvent!.end = newEnd;
  }
}
