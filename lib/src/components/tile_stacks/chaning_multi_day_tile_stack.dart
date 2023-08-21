import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/multi_day/multi_day_tile_gesture_detector.dart';
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
        PositionedMultiDayTileData<T> positionedEvent =
            multiDayEventLayout.layoutTile(
          scope.eventsController.selectedEvent!,
        );
        return MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: positionedEvent.top,
                left: positionedEvent.left,
                width: positionedEvent.width,
                height: positionedEvent.height,
                child: MultiDayTileGestureDetector<T>(
                  horizontalDurationStep: horizontalDurationStep,
                  horizontalStep: dayWidth,
                  tileData: positionedEvent,
                  visibleDateRange: visibleDateRange,
                  isChanging: true,
                  isMobileDevice: scope.platformData.isMobileDevice,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
