// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_group_layout_delegate.dart';

import 'package:kalender/src/models/groups/event_group.dart';
import 'package:kalender/src/models/providers/multi_day_provider.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_event_tile.dart';

class MultiDayEventWidget<T extends Object?> extends StatelessWidget {
  const MultiDayEventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = MultiDayProvider.of<T>(context);
    final eventsController = provider.eventsController;
    final tileComponents = provider.tileComponents;

    return ListenableBuilder(
      listenable: eventsController,
      builder: (context, child) {
        return ValueListenableBuilder(
          valueListenable: provider.visibleDateTimeRange,
          builder: (context, visibleDateTimeRange, child) {
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
                child: MultiDayEventTile<T>(
                  event: event,
                ),
              );
            });
            final multiDayEventsWidget = CustomMultiChildLayout(
              delegate: MultiDayEventsDefaultLayoutDelegate(
                group: group,
                multiDayTileHeight: 24,
              ),
              children: [...children],
            );

            final dropTarget = ValueListenableBuilder(
              valueListenable: provider.eventBeingDragged,
              builder: (context, event, child) {
                if (event == null || !event.isMultiDayEvent) {
                  return const SizedBox();
                }

                final group = MultiDayEventGroup(
                  events: [event],
                  dateTimeRange: visibleDateTimeRange,
                );
                return CustomMultiChildLayout(
                  delegate: MultiDayEventsDefaultLayoutDelegate(
                    group: group,
                    multiDayTileHeight: 24,
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
      },
    );
  }
}
