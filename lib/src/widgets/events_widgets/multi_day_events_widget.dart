import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_event_tile.dart';


// TODO: document this.
class MultiDayEventWidget<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> controller;

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
    required this.controller,
    required this.tileComponents,
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
          events: visibleEvents,
          dateTimeRange: visibleDateTimeRange,
        );

        final children = group.sortedEvents.indexed.map((item) {
          final (id, event) = item;
          return LayoutId(
            id: id,
            child: MultiDayEventTile<T>(
              event: event,
              eventsController: eventsController,
              controller: controller,
              tileComponents: tileComponents,
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

        // TODO: investigate a more efficient way to do this.
        final dropTargetWidget = ValueListenableBuilder(
          valueListenable: controller.selectedEvent,
          builder: (context, event, child) {
            if (event == null) return const SizedBox();
            if (!showAllEvents && !event.isMultiDayEvent) return const SizedBox();
            if (!event.occursDuringDateTimeRange(visibleDateTimeRange)) return const SizedBox();

            final events = visibleEvents.toList()
              ..removeWhere((e) => e.id == controller.selectedEventId)
              ..add(event);
            final group = MultiDayEventGroup(events: events, dateTimeRange: visibleDateTimeRange);

            final children = group.sortedEvents.indexed.map((item) {
              final (id, event) = item;
              return LayoutId(
                id: id,
                child: event.id == -1 || event.id == controller.selectedEventId
                    ? tileComponents.dropTargetTile?.call(event) ?? const SizedBox()
                    : const SizedBox(),
              );
            });

            return CustomMultiChildLayout(
              delegate: MultiDayEventsDefaultLayoutDelegate(
                group: group,
                multiDayTileHeight: tileHeight,
              ),
              children: children.toList(),
            );
          },
        );

        return Stack(
          children: [
            dropTargetWidget,
            multiDayEventsWidget,
          ],
        );
      },
    );
  }
}
