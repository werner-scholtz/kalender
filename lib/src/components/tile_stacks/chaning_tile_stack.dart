import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/day/selected_mobile_gesture_detector.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/tile_configurations/tile_configuration.dart';
import 'package:kalender/src/models/tile_layout_controllers/day_tile_layout_controller/day_tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

/// The [ChangingTileStack] is used to display [PositionedTileData]'s of the event being modified..
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
    required this.timeIndicatorSnapping,
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
  final bool timeIndicatorSnapping;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);

    if (scope.platformData.isMobileDevice) {
      return MobileChaningTile<T>(
        tileLayoutController: tileLayoutController,
        visibleDateRange: visibleDateRange,
        verticalDurationStep: verticalDurationStep,
        verticalStep: verticalStep,
        horizontalDurationStep: horizontalDurationStep,
        horizontalStep: horizontalStep,
        snapPoints: snapPoints,
        verticalSnapRange: verticalSnapRange,
        snapToTimeIndicator: timeIndicatorSnapping,
      );
    } else {
      return DesktopChaningTile<T>(
        scope: scope,
        tileLayoutController: tileLayoutController,
      );
    }
  }
}

class DesktopChaningTile<T> extends StatelessWidget {
  const DesktopChaningTile({
    super.key,
    required this.scope,
    required this.tileLayoutController,
  });

  final CalendarScope<T> scope;
  final DayTileLayoutController<T> tileLayoutController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: scope.eventsController.chaningEvent!,
      builder: (BuildContext context, Widget? child) {
        List<PositionedTileData<T>> arragnedEvents =
            tileLayoutController.positionSingleEvent(
          scope.eventsController.chaningEvent!,
        );
        return MouseRegion(
          cursor: scope.eventsController.isResizing
              ? SystemMouseCursors.resizeRow
              : SystemMouseCursors.move,
          child: Stack(
            children: arragnedEvents
                .map(
                  (PositionedTileData<T> e) => Positioned(
                    top: e.top,
                    left: e.left,
                    width: e.width,
                    height: e.height,
                    child: scope.tileComponents.tileBuilder!(
                      e.event,
                      TileConfiguration(
                        tileType: TileType.selected,
                        drawOutline: false,
                        continuesBefore: e.event.isSplitAcrossDays &&
                            !e.date.isSameDay(e.event.start),
                        continuesAfter: e.event.isSplitAcrossDays &&
                            e.date.isSameDay(e.event.start),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class MobileChaningTile<T> extends StatelessWidget {
  const MobileChaningTile({
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
  final bool snapToTimeIndicator;
  final Duration verticalSnapRange;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);
    return ListenableBuilder(
      listenable: scope.eventsController.chaningEvent!,
      builder: (BuildContext context, Widget? child) {
        List<PositionedTileData<T>> arragnedEvents =
            tileLayoutController.positionSingleEvent(
          scope.eventsController.chaningEvent!,
        );

        return Stack(
          children: arragnedEvents
              .map(
                (PositionedTileData<T> e) => Positioned(
                  top: e.top,
                  left: e.left,
                  width: e.width,
                  height: e.height,
                  child: MobileDayTileGestureDetector<T>(
                    verticalSnapRange: verticalSnapRange,
                    event: e.event,
                    horizontalDurationStep: horizontalDurationStep,
                    verticalDurationStep: verticalDurationStep,
                    verticalStep: verticalStep,
                    horizontalStep: horizontalStep,
                    visibleDateTimeRange: visibleDateRange,
                    snapPoints: snapPoints,
                    snapToTimeIndicator: snapToTimeIndicator,
                    continuesBefore: e.event.continuesBefore(e.date),
                    continuesAfter: e.event.continuesAfter(e.date),
                    child: scope.tileComponents.tileBuilder!(
                      e.event,
                      TileConfiguration(
                        tileType: TileType.selected,
                        drawOutline: false,
                        continuesBefore: e.event.isSplitAcrossDays &&
                            !e.date.isSameDay(e.event.start),
                        continuesAfter: e.event.isSplitAcrossDays &&
                            e.date.isSameDay(e.event.start),
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
