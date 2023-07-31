import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/gesture_detectors/month_tile_gesture_detector.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

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
    CalendarInternals<T> internals = CalendarInternals.of<T>(context);

    return ListenableBuilder(
      listenable: internals.controller,
      builder: (BuildContext context, Widget? child) {
        List<CalendarEvent<T>> events = internals.controller.getEventsFromDate(date).toList()
          ..sort((CalendarEvent<T> a, CalendarEvent<T> b) => a.duration.compareTo(b.duration))
          ..sort((CalendarEvent<T> a, CalendarEvent<T> b) => a.isSplitAcrossDays ? 0 : 1);

        return Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: events.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                CalendarEvent<T> event = events.elementAt(index);
                bool isMoving = internals.controller.chaningEvent == event;

                return MonthTileGestureDetector<T>(
                  event: event,
                  visibleDateRange: internals.state.visibleDateRange.value,
                  verticalDurationStep: viewConfiguration.verticalDurationStep,
                  verticalStep: cellHeight,
                  horizontalDurationStep: viewConfiguration.horizontalDurationStep,
                  horizontalStep: cellWidth,
                  child: internals.components.monthEventTileBuilder(
                    event,
                    isMoving ? TileType.ghost : TileType.normal,
                    date,
                    event.continuesBefore(date),
                    event.continuesAfter(date),
                  ),
                );
              },
            ),
            if (internals.controller.hasChaningEvent)
              ListenableBuilder(
                listenable: internals.controller.chaningEvent!,
                builder: (BuildContext context, Widget? child) {
                  CalendarEvent<T> event = internals.controller.chaningEvent!;
                  if (event.isOnDate(date)) {
                    return SizedBox(
                      width: cellWidth,
                      child: internals.components.monthEventTileBuilder(
                        internals.controller.chaningEvent!,
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
