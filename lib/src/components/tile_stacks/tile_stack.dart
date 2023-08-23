import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/day/day_tile_gesture_detector.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/tile_configurations/tile_configuration_export.dart';
import 'package:kalender/src/models/tile_layout_controllers/day_tile_layout_controller/day_tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

/// The [DayTileStack] is used to display [PositionedTileData]'s of the events in a [TileGroup].
class DayTileStack<T> extends StatelessWidget {
  const DayTileStack({
    super.key,
    required this.pageVisibleDateRange,
    required this.tileLayoutController,
    required this.dayWidth,
    required this.verticalStep,
    required this.verticalDurationStep,
    required this.verticalSnapRange,
    required this.eventSnapping,
    required this.snapToTimeIndicator,
    this.horizontalStep,
    this.horizontalDurationStep,
  });

  final DayTileLayoutController<T> tileLayoutController;
  final DateTimeRange pageVisibleDateRange;
  final double dayWidth;
  final double verticalStep;
  final Duration verticalDurationStep;
  final Duration verticalSnapRange;
  final double? horizontalStep;
  final Duration? horizontalDurationStep;
  final bool eventSnapping;
  final bool snapToTimeIndicator;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of<T>(context);

    return ListenableBuilder(
      listenable: scope.eventsController,
      builder: (BuildContext context, Widget? child) {
        // genrate the list of tile groups.
        Iterable<TileGroup<T>> tileGroups =
            tileLayoutController.generateTileGroups(
          scope.eventsController.getDayEventsFromDateRange(
            pageVisibleDateRange,
          ),
        );

        // Get a list of snap points.
        List<DateTime> snapPoints = <DateTime>[];

        if (eventSnapping) {
          // Add the snap points from other events.
          snapPoints.addAll(
            scope.eventsController
                .getSnapPointsFromDateTimeRange(pageVisibleDateRange),
          );
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
                    verticalSnapRange: verticalSnapRange,
                    snapToTimeIndicator: snapToTimeIndicator,
                  ),
                )
                .toList(),
            if (showSelectedTile(scope.eventsController))
              ChangingTileStack<T>(
                tileLayoutController: tileLayoutController,
                verticalStep: verticalStep,
                horizontalStep: horizontalStep,
                verticalDurationStep: verticalDurationStep,
                horizontalDurationStep: horizontalDurationStep,
                visibleDateRange: scope.state.visibleDateTimeRange.value,
                snapPoints: snapPoints,
                verticalSnapRange: verticalSnapRange,
                snapToTimeIndicator: snapToTimeIndicator,
              ),
          ],
        );
      },
    );
  }

  bool showSelectedTile(CalendarEventsController<T> controller) =>
      controller.hasChaningEvent && !controller.isSelectedEventMultiday;
}

/// The [TileGroupStack] is used to display [PositionedTileData]'s of the events in a [TileGroup].
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
    required this.verticalSnapRange,
    required this.snapToTimeIndicator,
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
  final bool snapToTimeIndicator;
  final Duration verticalSnapRange;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of<T>(context);

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
              (PositionedTileData<T> e) {
                bool isMoving = scope.eventsController.selectedEvent == e.event;
                return Positioned(
                  top: e.top,
                  left: e.left,
                  width: e.width,
                  height: e.height,
                  child: DayTileGestureDetector<T>(
                    tileData: e,
                    visibleDateTimeRange: visibleDateRange,
                    verticalDurationStep: verticalDurationStep,
                    verticalStep: verticalStep,
                    horizontalDurationStep: horizontalDurationStep,
                    horizontalStep: horizontalStep,
                    snapPoints: snapPoints,
                    snapToTimeIndicator: snapToTimeIndicator,
                    verticalSnapRange: verticalSnapRange,
                    isSelected: false,
                    child: scope.tileComponents.tileBuilder!(
                      e.event,
                      TileConfiguration(
                        tileType: isMoving ? TileType.ghost : TileType.normal,
                        drawOutline: e.drawOutline,
                        continuesBefore: e.continuesBefore,
                        continuesAfter: e.continuesAfter,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// The [ChangingTileStack] is used to display [PositionedTileData]'s of the event being modified.
class ChangingTileStack<T> extends StatelessWidget {
  const ChangingTileStack({
    super.key,
    required this.tileLayoutController,
    required this.visibleDateRange,
    required this.verticalDurationStep,
    required this.verticalStep,
    required this.horizontalDurationStep,
    required this.horizontalStep,
    required this.snapPoints,
    required this.verticalSnapRange,
    required this.snapToTimeIndicator,
  });

  final DayTileLayoutController<T> tileLayoutController;

  /// The visible [DateTimeRange].
  final DateTimeRange visibleDateRange;

  /// The duration of the vertical step when dragging/resizing an event.
  final Duration verticalDurationStep;
  final double verticalStep;

  /// The duration of the horizontal step when dragging an event.
  final Duration? horizontalDurationStep;
  final double? horizontalStep;

  final List<DateTime> snapPoints;
  final Duration verticalSnapRange;
  final bool snapToTimeIndicator;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);
    return ListenableBuilder(
      listenable: scope.eventsController.selectedEvent!,
      builder: (BuildContext context, Widget? child) {
        List<PositionedTileData<T>> positionedTiles =
            tileLayoutController.layoutSelectedEvent(
          scope.eventsController.selectedEvent!,
        );

        return Stack(
          children: positionedTiles
              .map(
                (PositionedTileData<T> e) => Positioned(
                  top: e.top,
                  left: e.left,
                  width: e.width,
                  height: e.height,
                  child: DayTileGestureDetector<T>(
                    tileData: e,
                    visibleDateTimeRange: visibleDateRange,
                    verticalDurationStep: verticalDurationStep,
                    verticalStep: verticalStep,
                    horizontalDurationStep: horizontalDurationStep,
                    horizontalStep: horizontalStep,
                    snapPoints: snapPoints,
                    snapToTimeIndicator: snapToTimeIndicator,
                    verticalSnapRange: verticalSnapRange,
                    isSelected: true,
                    child: scope.tileComponents.tileBuilder!(
                      e.event,
                      TileConfiguration(
                        tileType: TileType.selected,
                        drawOutline: e.drawOutline,
                        continuesBefore: e.continuesBefore,
                        continuesAfter: e.continuesAfter,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
