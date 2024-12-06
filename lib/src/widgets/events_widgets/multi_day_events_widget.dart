import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_event_tile.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';

/// This widget is renders all the multi-day event tiles that are visible on the provided dateTimeRange.
///
/// It fetches the events that need to be rendered from the [EventsController],
/// the [EventsController] is also listened to in-case events are added or updated.
///
/// This widget also takes responsibility for updating the [CalendarController.visibleEvents],
/// unlike the DayEventsWidget that can clear the visibleEvents it only adds the events that are visible.
///
/// To render the event tiles it uses [CustomMultiChildLayout],
/// along with a [defaultMultiDayLayoutStrategy] or custom strategy defined by the user.
///
/// * Note: When a event is being modified by the user it renders that event in a separate [CustomMultiChildLayout],
///         This is somewhat expensive computationally as it lays out all the events again to determine the position
///         of the event being modified. See todo for a possible solution.
class MultiDayEventWidget<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> controller;

  final DateTimeRange visibleDateTimeRange;
  final TileComponents<T> tileComponents;
  final CalendarCallbacks<T>? callbacks;
  final MultiDayEventLayoutStrategy layoutStrategy;
  final double dayWidth;
  final bool allowResizing;
  final bool allowRescheduling;
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
    required this.allowRescheduling,
    required this.showAllEvents,
    required this.callbacks,
    required this.tileHeight,
    required this.layoutStrategy,
  });

  ValueNotifier<Set<CalendarEvent<T>>> get visibleEventsNotifier => controller.visibleEvents;

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

        // Add the events to the visible events.
        visibleEventsNotifier.value = {
          ...visibleEventsNotifier.value,
          ...visibleEvents,
        };

        final sortedEvents = visibleEvents.toList();

        final children = sortedEvents.indexed.map((item) {
          final (id, event) = item;
          return LayoutId(
            id: id,
            child: MultiDayEventTile<T>(
              event: event,
              eventsController: eventsController,
              controller: controller,
              callbacks: callbacks,
              tileComponents: tileComponents,
              allowResizing: allowResizing,
              allowRescheduling: allowRescheduling,
              dateTimeRange: visibleDateTimeRange,
            ),
          );
        });

        final multiDayEventsWidget = CustomMultiChildLayout(
          delegate: DefaultMultiDayLayoutDelegate(
            events: sortedEvents,
            dateTimeRange: visibleDateTimeRange,
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

            final events = sortedEvents.toList()
              ..removeWhere((e) => e.id == controller.selectedEventId)
              ..add(event);

            final children = events.indexed.map((item) {
              final (id, event) = item;
              return LayoutId(
                id: id,
                child: event.id == -1 || event.id == controller.selectedEventId
                    ? tileComponents.dropTargetTile?.call(event) ?? const SizedBox()
                    : const SizedBox(),
              );
            });

            return CustomMultiChildLayout(
              delegate: DefaultMultiDayLayoutDelegate(
                events: events,
                dateTimeRange: visibleDateTimeRange,
                multiDayTileHeight: tileHeight,
              ),
              children: children.toList(),
            );
          },
        );

        return Stack(
          children: [
            multiDayEventsWidget,
            PassThroughPointer(child: dropTargetWidget),
          ],
        );
      },
    );
  }
}
