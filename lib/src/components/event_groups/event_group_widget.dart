import 'package:flutter/material.dart';
import 'package:kalender/src/components/tiles/event_tile.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar/view_state/multi_day_view_state.dart';
import 'package:kalender/src/models/event_group_controllers/event_group_controller.dart';
import 'package:kalender/src/models/tile_configurations/tile_configuration.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_page_content.dart';

/// A widget that displays a group of events as [EventTile]s using the [CustomMultiChildLayout] widget.
class EventGroupWidget<T> extends StatelessWidget {
  const EventGroupWidget({
    super.key,
    required this.eventGroup,
    required this.isChanging,
    required this.snapData,
  });

  final EventGroup<T> eventGroup;
  final MultiDayPageData snapData;
  final bool isChanging;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    final children = <LayoutId>[];
    for (var i = 0; i < eventGroup.events.length; i++) {
      final event = eventGroup.events[i];

      // Check if the event is currently being moved.
      final isMoving = scope.eventsController.selectedEvent == event;

      final tileType = isChanging
          ? TileType.selected
          : isMoving
              ? TileType.ghost
              : TileType.normal;

      final tileConfiguration = TileConfiguration(
        tileType: tileType,
        drawOutline: i >= 1,
        continuesBefore: event.start.isBefore(eventGroup.start),
        continuesAfter: event.end.isAfter(eventGroup.end),
      );

      children.add(
        LayoutId(
          id: i,
          child: EventTile(
            event: event,
            tileConfiguration: tileConfiguration,
            snapData: snapData,
            isChanging: isChanging,
          ),
        ),
      );
    }

    final heightPerMinute =
        (scope.state as MultiDayViewState).heightPerMinute.value;

    scope.layoutDelegates.tileLayoutController.call(
      date: eventGroup.date,
      events: eventGroup.events,
      heightPerMinute: heightPerMinute,
    );

    return CustomMultiChildLayout(
      delegate: scope.layoutDelegates.tileLayoutController(
        date: eventGroup.date,
        events: eventGroup.events,
        heightPerMinute: heightPerMinute,
      ),
      children: children,
    );
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return duration.inMinutes * heightPerMinute;
  }
}
