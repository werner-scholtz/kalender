import 'package:flutter/material.dart';
import 'package:kalender/kalender_scope.dart';
import 'package:kalender/kalender.dart';
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
    required this.horizontalStep,
    required this.horizontalStepDuration,
    this.verticalStep,
    this.verticalStepDuration,
    this.rescheduleDateRange,
  });

  final bool isChanging;
  final DateTimeRange visibleDateRange;

  final DateTimeRange? rescheduleDateRange;
  final MultiDayEventGroup<T> multiDayEventGroup;
  final double multiDayTileHeight;
  final double horizontalStep;
  final Duration horizontalStepDuration;
  final double? verticalStep;
  final Duration? verticalStepDuration;

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
            rescheduleDateRange: rescheduleDateRange ?? visibleDateRange,
            horizontalStep: horizontalStep,
            horizontalStepDuration: horizontalStepDuration,
            verticalStep: verticalStep,
            verticalStepDuration: verticalStepDuration,
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

    return CustomMultiChildLayout(
      delegate: MultiDayEventGroupDefaultLayoutDelegate(
        events: multiDayEventGroup.events,
        visibleDateRange: visibleDateRange,
        multiDayTileHeight: multiDayTileHeight,
      ),
      children: children,
    );
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return duration.inMinutes * heightPerMinute;
  }
}
