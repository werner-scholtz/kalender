import 'package:flutter/material.dart';

import 'package:kalender/src/components/gesture_detectors/multi_day/multi_day_gesture_detector.dart';
import 'package:kalender/src/components/gesture_detectors/multi_day/multi_day_tile_gesture_detector.dart';
import 'package:kalender/src/components/tile_stacks/chaning_multi_day_tile_stack.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/tile_configurations/tile_configuration_export.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_layout_controller/multi_day_layout_controller.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class PositionedMultiDayTileStack<T> extends StatelessWidget {
  const PositionedMultiDayTileStack({
    super.key,
    required this.pageWidth,
    required this.dayWidth,
    required this.multiDayEventLayout,
  });

  /// The width of the page.
  final double pageWidth;

  /// The width a single day.
  final double dayWidth;

  /// The [MultiDayTileLayoutController]
  final MultiDayTileLayoutController<T> multiDayEventLayout;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);

    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: scope.eventsController,
        builder: (BuildContext context, Widget? child) {
          /// Arrange the events.
          List<PositionedMultiDayTileData<T>> arragedEvents =
              multiDayEventLayout.layoutTiles(
            scope.eventsController.getMultidayEventsFromDateRange(
              scope.state.visibleDateTimeRange.value,
            ),
          );

          return SizedBox(
            width: pageWidth,
            height: multiDayEventLayout.stackHeight,
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        scope.components.daySepratorBuilder(
                          15,
                          dayWidth,
                          scope
                              .state.visibleDateTimeRange.value.duration.inDays,
                        ),
                      ],
                    ),
                  ],
                ),
                MultiDayGestureDetector<T>(
                  pageWidth: pageWidth,
                  height: multiDayEventLayout.stackHeight,
                  cellWidth: dayWidth,
                  multidayEventHeight: multiDayEventLayout.tileHeight,
                  numberOfRows: multiDayEventLayout.numberOfRows,
                  visibleDates:
                      scope.state.visibleDateTimeRange.value.datesSpanned,
                ),
                ...arragedEvents.map(
                  (PositionedMultiDayTileData<T> e) {
                    return MultidayTileStack<T>(
                      visibleDateRange: scope.state.visibleDateTimeRange.value,
                      positionedTileData: e,
                      dayWidth: dayWidth,
                      horizontalDurationStep: const Duration(days: 1),
                    );
                  },
                ).toList(),
                if (scope.eventsController.hasChaningEvent &&
                    scope.eventsController.isSelectedEventMultiday)
                  ChaningMultiDayTileStack<T>(
                    multiDayEventLayout: multiDayEventLayout,
                    visibleDateRange: scope.state.visibleDateTimeRange.value,
                    dayWidth: dayWidth,
                    horizontalDurationStep: const Duration(days: 1),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MultidayTileStack<T> extends StatelessWidget {
  const MultidayTileStack({
    super.key,
    required this.visibleDateRange,
    required this.positionedTileData,
    required this.dayWidth,
    required this.horizontalDurationStep,
  });

  final DateTimeRange visibleDateRange;
  final PositionedMultiDayTileData<T> positionedTileData;
  final double dayWidth;
  final Duration horizontalDurationStep;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);
    bool isMoving =
        scope.eventsController.selectedEvent == positionedTileData.event;
    return Stack(
      children: <Widget>[
        Positioned(
          top: positionedTileData.top,
          left: positionedTileData.left,
          width: positionedTileData.width,
          height: positionedTileData.height,
          child: MultiDayTileGestureDetector<T>(
            horizontalDurationStep: horizontalDurationStep,
            horizontalStep: dayWidth,
            tileData: positionedTileData,
            visibleDateRange: visibleDateRange,
            isSelected: false,
            child: scope.tileComponents.multiDayTileBuilder!(
              positionedTileData.event,
              MultiDayTileConfiguration(
                tileType: isMoving ? TileType.ghost : TileType.normal,
                continuesBefore: positionedTileData.continuesBefore,
                continuesAfter: positionedTileData.continuesAfter,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
