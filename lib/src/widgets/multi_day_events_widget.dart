// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_group_layout_delegate.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/groups/event_group.dart';

class MultiDayEventWidget<T extends Object?> extends StatelessWidget {
  final DateTimeRange visibleDateTimeRange;

  final ValueNotifier<CalendarEvent<T>?> eventBeingDragged;
  final EventsController<T> eventsController;

  const MultiDayEventWidget({
    super.key,
    required this.visibleDateTimeRange,
    required this.eventBeingDragged,
    required this.eventsController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: eventsController!,
      builder: (context, child) {
        final visibleEvents = eventsController.eventsFromDateTimeRange(
          visibleDateTimeRange,
          includeDayEvents: false,
          includeMultiDayEvents: true,
        );

        final group = MultiDayEventGroup(
          events: visibleEvents.toList(),
          dateTimeRange: visibleDateTimeRange,
        );

        final children = group.sortedEvents.indexed.map((item) {
          final (id, event) = item;
          return LayoutId(
            id: id,
            child: Container(
              color: Colors.red,
            ),
          );
        });

        return CustomMultiChildLayout(
          delegate: MultiDayEventsDefaultLayoutDelegate(
            group: group,
            multiDayTileHeight: 24,
          ),
          children: [...children],
        );
      },
    );
  }
}
