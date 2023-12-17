import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/tiles/event_tile.dart';
import 'package:kalender/src/models/event_group_controllers/event_group_controller.dart';

/// A widget that displays a group of events as [EventGestureDetector]s using the [CustomMultiChildLayout] widget.
class EventGroupWidget<T> extends StatelessWidget {
  const EventGroupWidget({
    super.key,
    required this.eventGroup,
    required this.isChanging,
    required this.heightPerMinute,
    required this.visibleDateTimeRange,
    required this.verticalStep,
    required this.horizontalStep,
    required this.snapPoints,
  });

  final EventGroup<T> eventGroup;
  final bool isChanging;
  final double heightPerMinute;
  final DateTimeRange visibleDateTimeRange;
  final double verticalStep;
  final double horizontalStep;
  final List<DateTime> snapPoints;

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

      final eventTile = scope.tileComponents.eventTileBuilder?.call(
            event,
            tileConfiguration,
            heightPerMinute,
            isChanging,
            visibleDateTimeRange,
            verticalStep,
            horizontalStep,
            snapPoints,
          ) ??
          EventGestureDetector(
            event: event,
            tileConfiguration: tileConfiguration,
            heightPerMinute: heightPerMinute,
            isChanging: isChanging,
            visibleDateTimeRange: visibleDateTimeRange,
            verticalStep: verticalStep,
            horizontalStep: horizontalStep,
            snapPoints: snapPoints,
          );

      children.add(
        LayoutId(
          id: i,
          child: eventTile,
        ),
      );
    }

    final startHour =
        (scope.state.viewConfiguration as MultiDayViewConfiguration).startHour;

    final endHour =
        (scope.state.viewConfiguration as MultiDayViewConfiguration).endHour;

    return CustomMultiChildLayout(
      delegate: scope.layoutDelegates.tileLayoutDelegate.call(
        date: eventGroup.date,
        events: eventGroup.events,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        endHour: endHour,
      ),
      children: children,
    );
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return duration.inMinutes * heightPerMinute;
  }
}
