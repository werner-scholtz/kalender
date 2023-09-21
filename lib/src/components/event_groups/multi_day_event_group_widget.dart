import 'package:flutter/material.dart';
import 'package:kalender/kalendar_scope.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/layout_delegates/multi_day_event_group_layout.dart';
import 'package:kalender/src/components/tiles/multi_day_event_tile.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/event_group_controllers/multi_day_event_group_controller.dart';

class MultiDayEventGroupWidget<T> extends StatelessWidget {
  const MultiDayEventGroupWidget({
    super.key,
    required this.isChanging,
    required this.visibleDateRange,
    required this.multiDayEventGroup,
    required this.multiDayTileHeight,
  });

  final bool isChanging;
  final DateTimeRange visibleDateRange;
  final MultiDayEventGroup<T> multiDayEventGroup;
  final double multiDayTileHeight;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    final children = <LayoutId>[];
    for (var i = 0; i < multiDayEventGroup.events.length; i++) {
      final event = multiDayEventGroup.events[i];

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
              continuesBefore: event.start.isBefore(visibleDateRange.start),
              continuesAfter: event.end.isAfter(visibleDateRange.end.endOfDay),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: multiDayTileHeight * multiDayEventGroup.maxNumberOfStackedEvents,
      child: CustomMultiChildLayout(
        delegate: MultiDayEventGroupDefaultLayoutDelegate(
          events: multiDayEventGroup.events,
          visibleDateRange: visibleDateRange,
          multiDayTileHeight: multiDayTileHeight,
        ),
        children: children,
      ),
    );
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return duration.inMinutes * heightPerMinute;
  }
}
