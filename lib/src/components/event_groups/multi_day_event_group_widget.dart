import 'package:flutter/material.dart';
import 'package:kalender/kalendar_scope.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/layout_delegates/multi_day_event_group_layout.dart';
import 'package:kalender/src/components/tiles/multi_day_event_tile.dart';
import 'package:kalender/src/extensions.dart';

class MultiDayEventGroupWidget<T> extends StatelessWidget {
  const MultiDayEventGroupWidget({
    super.key,
    required this.isChanging,
    required this.events,
    required this.visibleDateRange,
  });

  final bool isChanging;
  final List<CalendarEvent<T>> events;
  final DateTimeRange visibleDateRange;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    final children = <LayoutId>[];
    for (var i = 0; i < events.length; i++) {
      final event = events[i];

      // Check if the event is currently being moved.
      final isMoving = scope.eventsController.selectedEvent == event;
      children.add(
        LayoutId(
          id: i,
          child: MultiDayEventTile(
            event: event,
            tileConfiguration: MultiDayTileConfiguration(
              tileType: isChanging
                  ? TileType.selected
                  : isMoving
                      ? TileType.ghost
                      : TileType.normal,
              continuesBefore: event.start.isAfter(visibleDateRange.start),
              continuesAfter: event.end.isBefore(visibleDateRange.end.endOfDay),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 50,
      child: CustomMultiChildLayout(
        delegate: MultiDayEventGroupDefaultLayoutDelegate(
          events: events,
          visibleDates: visibleDateRange.datesSpanned,
        ),
        children: children,
      ),
    );
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return duration.inMinutes * heightPerMinute;
  }
}
