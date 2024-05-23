// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_group_layout_delegate.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';

import 'package:kalender/src/models/groups/event_group.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_event_tile.dart';

class MultiDayEventWidget<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final ViewController<T> viewController;
  final DateTimeRange visibleDateTimeRange;
  final TileComponents<T> tileComponents;
  final CalendarCallbacks<T>? callbacks;
  final double dayWidth;
  final bool allowResizing;
  final bool showAllEvents;
  final double tileHeight;

  const MultiDayEventWidget({
    super.key,
    required this.visibleDateTimeRange,
    required this.eventsController,
    required this.tileComponents,
    required this.viewController,
    required this.dayWidth,
    required this.allowResizing,
    required this.showAllEvents,
    required this.callbacks,
    required this.tileHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: eventsController,
      builder: (context, child) {
        final visibleEvents = eventsController.eventsFromDateTimeRange(
          visibleDateTimeRange,
          includeDayEvents: showAllEvents,
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
            child: MultiDayEventTile<T>(
              event: event,
              eventsController: eventsController,
              viewController: viewController,
              tileComponents: tileComponents,
              dayWidth: dayWidth,
              allowResizing: allowResizing,
              callbacks: callbacks,
            ),
          );
        });

        final multiDayEventsWidget = CustomMultiChildLayout(
          delegate: MultiDayEventsDefaultLayoutDelegate(
            group: group,
            multiDayTileHeight: tileHeight,
          ),
          children: [...children],
        );

        final dropTarget = ValueListenableBuilder(
          valueListenable: viewController.eventBeingDragged,
          builder: (context, event, child) {
            if (event == null) return const SizedBox();
            if (!showAllEvents && !event.isMultiDayEvent) {
              return const SizedBox();
            }

            if (!event.occursDuringDateTimeRange(visibleDateTimeRange)) {
              return const SizedBox();
            }

            final group = MultiDayEventGroup(
              events: [event],
              dateTimeRange: visibleDateTimeRange,
            );

            return CustomMultiChildLayout(
              delegate: MultiDayEventsDefaultLayoutDelegate(
                group: group,
                multiDayTileHeight: tileHeight,
              ),
              children: [
                LayoutId(
                  id: 0,
                  child: tileComponents.dropTargetTile.call(event),
                ),
              ],
            );
          },
        );

        return Stack(
          children: [
            multiDayEventsWidget,
            dropTarget,
          ],
        );
      },
    );
  }
}
