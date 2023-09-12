import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/month/month_cell_gesture_detector.dart';

import 'package:kalender/src/components/gesture_detectors/month/month_tile_gesture_detector.dart';
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

    return ListenableBuilder(
      listenable: scope.eventsController,
      builder: (BuildContext context, Widget? child) {
        /// Arrange the events.
        List<PositionedMonthTileData<T>> arragedEvents =
            monthEventLayout.layoutTiles(
          scope.eventsController.getMonthEventsFromDateRange(visibleDateRange),
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
                  return PositionedMonthTile<T>(
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
    );
  }
}

/// The [PositionedMonthTile] displays a single [PositionedMonthTileData].
class PositionedMonthTile<T> extends StatelessWidget {
  const PositionedMonthTile({
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
    return Positioned(
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
    );
  }
}

/// The [ChaningMonthTileStack] displays a single [PositionedMonthTileData] that is being modified.
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
        PositionedMonthTileData<T> positionedTile =
            monthEventLayout.layoutSelectedTile(
          scope.eventsController.selectedEvent!,
        );
        log(scope.eventsController.isResizing.toString());

        return MouseRegion(
          cursor: scope.eventsController.isResizing
              ? SystemMouseCursors.resizeColumn
              : SystemMouseCursors.move,
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
