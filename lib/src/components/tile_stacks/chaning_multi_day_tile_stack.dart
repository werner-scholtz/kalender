import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/multi_day/multi_day_tile_gesture_detector.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/tile_configurations/tile_configuration_export.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_layout_controller/multi_day_layout_controller.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

/// The [ChaningMultiDayTileStack] displays a single [PositionedMultiDayTileData] that is being modified.
class ChaningMultiDayTileStack<T> extends StatelessWidget {
  const ChaningMultiDayTileStack({
    super.key,
    required this.multiDayEventLayout,
    required this.horizontalDurationStep,
    required this.dayWidth,
    required this.visibleDateRange,
  });

  final MultiDayTileLayoutController<T> multiDayEventLayout;
  final Duration horizontalDurationStep;
  final double dayWidth;
  final DateTimeRange visibleDateRange;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);
    return ListenableBuilder(
      listenable: scope.eventsController.selectedEvent!,
      builder: (BuildContext context, Widget? child) {
        PositionedMultiDayTileData<T> positionedTile =
            multiDayEventLayout.layoutTile(
          scope.eventsController.selectedEvent!,
        );
        return MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: positionedTile.top,
                left: positionedTile.left,
                width: positionedTile.width,
                height: positionedTile.height,
                child: MultiDayTileGestureDetector<T>(
                  horizontalDurationStep: horizontalDurationStep,
                  horizontalStep: dayWidth,
                  tileData: positionedTile,
                  visibleDateRange: visibleDateRange,
                  isSelected: true,
                  child: scope.tileComponents.multiDayTileBuilder!(
                    positionedTile.event,
                    MultiDayTileConfiguration(
                      tileType: TileType.selected,
                      continuesBefore: positionedTile.continuesBefore,
                      continuesAfter: positionedTile.continuesAfter,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
