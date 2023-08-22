import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/day/day_tile_gesture_detector.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/tile_configurations/tile_configuration_export.dart';
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
            tileLayoutController.positionSingleEvent(
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
