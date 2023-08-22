import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/month/month_cell_gesture_detector.dart';

import 'package:kalender/src/components/gesture_detectors/month/month_tile_gesture_detector.dart';
import 'package:kalender/src/components/tile_stacks/chaning_month_tile_stack.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/tile_configurations/tile_configuration_export.dart';
import 'package:kalender/src/models/tile_layout_controllers/month_tile_layout_controller/month_tile_layout_controller.dart';
import 'package:kalender/src/models/view_configurations/month_configurations/month_view_configuration.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class PositionedMonthTileStack<T> extends StatelessWidget {
  const PositionedMonthTileStack({
    super.key,
    required this.pageWidth,
    required this.cellWidth,
    required this.cellHeight,
    required this.monthEventLayout,
    required this.visibleDateRange,
    required this.monthVisibleDateRange,
    required this.viewConfiguration,
  });

  /// The width of the page.
  final double pageWidth;

  /// The width a single day.
  final double cellWidth;

  final double cellHeight;

  /// The [MonthTileLayoutController]
  final MonthTileLayoutController<T> monthEventLayout;

  final DateTimeRange visibleDateRange;

  final DateTimeRange monthVisibleDateRange;

  final MonthViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);

    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: scope.eventsController,
        builder: (BuildContext context, Widget? child) {
          /// Arrange the events.
          List<PositionedMonthTileData<T>> arragedEvents =
              monthEventLayout.layoutTiles(
            scope.eventsController.getEventsFromDateRange(visibleDateRange),
            selectedEvent: scope.eventsController.selectedEvent,
          );

          return SizedBox(
            width: pageWidth,
            height: monthEventLayout.stackHeight < cellHeight
                ? cellHeight
                : monthEventLayout.stackHeight,
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    for (int r = 0; r < 7; r++)
                      if (scope.state.viewConfiguration.createNewEvents)
                        SizedBox(
                          width: cellWidth,
                          height: cellHeight,
                          child: MonthCellGestureDetector<T>(
                            date: visibleDateRange.start.add(Duration(days: r)),
                            visibleDateRange: visibleDateRange,
                            verticalDurationStep: const Duration(days: 7),
                            verticalStep: cellHeight,
                            horizontalDurationStep: const Duration(days: 1),
                            horizontalStep: cellWidth,
                          ),
                        ),
                  ],
                ),
                ...arragedEvents.map(
                  (PositionedMonthTileData<T> e) {
                    return MonthTileStack<T>(
                      controller: scope.eventsController,
                      visibleDateRange: scope.state.visibleDateTimeRange.value,
                      viewConfiguration: viewConfiguration,
                      monthEventLayout: monthEventLayout,
                      monthVisibleDateRange: monthVisibleDateRange,
                      positionedTileData: e,
                      horizontalStep: cellWidth,
                      horizontalDurationStep: const Duration(days: 1),
                      verticalStep: cellHeight,
                      verticalDurationStep: const Duration(days: 7),
                    );
                  },
                ).toList(),
                if (scope.eventsController.hasChaningEvent)
                  ChaningMonthTileStack<T>(
                    monthEventLayout: monthEventLayout,
                    viewConfiguration: viewConfiguration,
                    monthVisibleDateRange: monthVisibleDateRange,
                    horizontalStep: cellWidth,
                    horizontalDurationStep: const Duration(days: 1),
                    verticalStep: cellHeight,
                    verticalDurationStep: const Duration(days: 7),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MonthTileStack<T> extends StatelessWidget {
  const MonthTileStack({
    super.key,
    required this.controller,
    required this.viewConfiguration,
    required this.visibleDateRange,
    required this.monthEventLayout,
    required this.monthVisibleDateRange,
    required this.positionedTileData,
    required this.horizontalStep,
    required this.horizontalDurationStep,
    required this.verticalStep,
    required this.verticalDurationStep,
  });

  final CalendarEventsController<T> controller;

  final MonthViewConfiguration viewConfiguration;

  final DateTimeRange visibleDateRange;
  final DateTimeRange monthVisibleDateRange;
  final MonthTileLayoutController<T> monthEventLayout;
  final PositionedMonthTileData<T> positionedTileData;

  final double horizontalStep;
  final Duration horizontalDurationStep;

  final double verticalStep;
  final Duration verticalDurationStep;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);
    bool isMoving = controller.selectedEvent == positionedTileData.event;
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: <Widget>[
            Positioned(
              top: positionedTileData.top,
              left: positionedTileData.left,
              width: positionedTileData.width,
              height: positionedTileData.height,
              child: MonthTileGestureDetector<T>(
                horizontalDurationStep: horizontalDurationStep,
                tileData: positionedTileData,
                horizontalStep: horizontalStep,
                verticalDurationStep: verticalDurationStep,
                verticalStep: verticalStep,
                visibleDateRange: monthVisibleDateRange,
                enableResizing: viewConfiguration.enableRezising,
                isSelected: false,
                child: scope.tileComponents.monthTileBuilder!(
                  positionedTileData.event,
                  MonthTileConfiguration(
                    tileType: isMoving ? TileType.ghost : TileType.normal,
                    date: positionedTileData.dateRange.start,
                    continuesBefore: positionedTileData.continuesBefore,
                    continuesAfter: positionedTileData.continuesAfter,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
