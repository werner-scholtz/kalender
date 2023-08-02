import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/gesture_detectors/month_cell_gesture_detector.dart';
import 'package:kalender/src/components/gesture_detectors/month_tile_gesture_detector.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class MonthCellStack<T extends Object?> extends StatelessWidget {
  const MonthCellStack({
    super.key,
    required this.viewConfiguration,
    required this.date,
    required this.cellHeight,
    required this.cellWidth,
  });

  final MonthViewConfiguration viewConfiguration;

  final double cellHeight;

  final double cellWidth;

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);

    return ListenableBuilder(
      listenable: scope.eventController,
      builder: (BuildContext context, Widget? child) {
        List<CalendarEvent<T>> events = scope.eventController.getEventsFromDate(date).toList()
          ..sort((CalendarEvent<T> a, CalendarEvent<T> b) => a.duration.compareTo(b.duration))
          ..sort((CalendarEvent<T> a, CalendarEvent<T> b) => a.isSplitAcrossDays ? 0 : 1);

        return Stack(
          fit: StackFit.loose,
          children: <Widget>[
            MonthCellGestureDetector<T>(
              date: date,
              visibleDateRange: scope.state.visibleDateTimeRange.value,
              verticalDurationStep: viewConfiguration.verticalDurationStep,
              verticalStep: cellHeight,
              horizontalDurationStep: viewConfiguration.horizontalDurationStep,
              horizontalStep: cellWidth,
            ),
            ListView.builder(
              itemCount: events.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                CalendarEvent<T> event = events.elementAt(index);
                bool isMoving = scope.eventController.chaningEvent == event;

                return MonthTileGestureDetector<T>(
                  event: event,
                  visibleDateRange: scope.state.visibleDateTimeRange.value,
                  verticalDurationStep: viewConfiguration.verticalDurationStep,
                  verticalStep: cellHeight,
                  horizontalDurationStep: viewConfiguration.horizontalDurationStep,
                  horizontalStep: cellWidth,
                  child: scope.tileComponents.monthEventTileBuilder!(
                    event,
                    isMoving ? TileType.ghost : TileType.normal,
                    date,
                    event.continuesBefore(date),
                    event.continuesAfter(date),
                  ),
                );
              },
            ),
            if (scope.eventController.hasChaningEvent)
              ListenableBuilder(
                listenable: scope.eventController.chaningEvent!,
                builder: (BuildContext context, Widget? child) {
                  CalendarEvent<T> event = scope.eventController.chaningEvent!;
                  if (event.isOnDate(date)) {
                    return SizedBox(
                      width: cellWidth,
                      child: scope.tileComponents.monthEventTileBuilder!(
                        scope.eventController.chaningEvent!,
                        TileType.selected,
                        date,
                        event.continuesBefore(date),
                        event.continuesAfter(date),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
          ],
        );
      },
    );
  }
}
