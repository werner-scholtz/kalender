import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/month/month_tile_gesture_detector.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/tile_configurations/tile_configuration_export.dart';
import 'package:kalender/src/models/tile_layout_controllers/month_tile_layout_controller/month_tile_layout_controller.dart';
import 'package:kalender/src/models/view_configurations/month_configurations/month_view_configuration.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

/// The [ChaningMonthTileStack] displays a single [PositionedMultiDayTileData] that is being modified.
class ChaningMonthTileStack<T> extends StatelessWidget {
  const ChaningMonthTileStack({
    super.key,
    required this.monthEventLayout,
    required this.viewConfiguration,
    required this.monthVisibleDateRange,
    required this.horizontalStep,
    required this.horizontalDurationStep,
    required this.verticalStep,
    required this.verticalDurationStep,
  });

  final MonthTileLayoutController<T> monthEventLayout;
  final MonthViewConfiguration viewConfiguration;
  final DateTimeRange monthVisibleDateRange;

  final double horizontalStep;
  final Duration horizontalDurationStep;

  final double verticalStep;
  final Duration verticalDurationStep;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);

    return ListenableBuilder(
      listenable: scope.eventsController.selectedEvent!,
      builder: (BuildContext context, Widget? child) {
        PositionedMonthTileData<T> positionedTile = monthEventLayout.layoutTile(
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
                child: MonthTileGestureDetector<T>(
                  horizontalDurationStep: horizontalDurationStep,
                  tileData: positionedTile,
                  horizontalStep: horizontalStep,
                  verticalDurationStep: verticalDurationStep,
                  verticalStep: verticalStep,
                  visibleDateRange: monthVisibleDateRange,
                  enableResizing: viewConfiguration.enableRezising,
                  isSelected: true,
                  child: scope.tileComponents.monthTileBuilder!(
                    positionedTile.event,
                    MonthTileConfiguration(
                      tileType: TileType.selected,
                      date: positionedTile.dateRange.start,
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
