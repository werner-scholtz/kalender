import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/day_event_tile.dart';

// TODO: Improve documentation.
class DayEventsWidget<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> controller;
  final CalendarCallbacks<T>? callbacks;

  final TileComponents<T> tileComponents;
  final MultiDayBodyConfiguration bodyConfiguration;
  final DateTimeRange visibleDateTimeRange;
  final TimeOfDayRange timeOfDayRange;
  final double dayWidth;
  final double heightPerMinute;

  /// Creates a [DayEventsWidget].
  const DayEventsWidget({
    super.key,
    required this.eventsController,
    required this.controller,
    required this.callbacks,
    required this.tileComponents,
    required this.bodyConfiguration,
    required this.dayWidth,
    required this.heightPerMinute,
    required this.visibleDateTimeRange,
    required this.timeOfDayRange,
  });

  @override
  Widget build(BuildContext context) {
    final visibleDates = visibleDateTimeRange.datesSpanned;
    final eventGroupLayoutStrategy = bodyConfiguration.eventLayoutStrategy;
    final showMultiDayEvents = bodyConfiguration.showMultiDayEvents;
    final selectedEvent = controller.selectedEvent;

    return ListenableBuilder(
      listenable: eventsController,
      builder: (context, child) {
        return Row(
          children: visibleDates.map((date) {
            final visibleEvents = eventsController
                .eventsFromDateTimeRange(
                  date.dayRange,
                  includeDayEvents: true,
                  includeMultiDayEvents: showMultiDayEvents,
                )
                .toList()
              ..sort((a, b) => b.duration.compareTo(a.duration))
              ..sort(
                (a, b) => b.duration.compareTo(a.duration) == 0 ? b.start.compareTo(a.start) : 0,
              );

            final events = CustomMultiChildLayout(
              delegate: eventGroupLayoutStrategy.call(
                visibleEvents,
                date,
                timeOfDayRange,
                heightPerMinute,
              ),
              children: visibleEvents.indexed
                  .map(
                    (item) => LayoutId(
                      id: item.$1,
                      child: DayEventTile(
                        event: item.$2,
                        eventsController: eventsController,
                        controller: controller,
                        callbacks: callbacks,
                        tileComponents: tileComponents,
                        bodyConfiguration: bodyConfiguration,
                        visibleDateTimeRange: visibleDateTimeRange,
                        timeOfDayRange: timeOfDayRange,
                        dayWidth: dayWidth,
                        heightPerMinute: heightPerMinute,
                        continuesBefore: false,
                        continuesAfter: false,
                      ),
                    ),
                  )
                  .toList(),
            );

            final dropTargetWidget = ValueListenableBuilder(
              valueListenable: selectedEvent,
              builder: (context, event, child) {
                // If there is no event being dragged, return an empty widget.
                if (event == null) return const SizedBox();
                if (!event.occursDuringDateTimeRange(date.dayRange)) return const SizedBox();
                
                if (!showMultiDayEvents && event.isMultiDayEvent) return const SizedBox();

                final events = visibleEvents.toList()
                  ..removeWhere((e) => e.id == controller.selectedEventId)
                  ..add(event);

                final dropTarget = tileComponents.dropTargetTile;

                return CustomMultiChildLayout(
                  delegate: eventGroupLayoutStrategy.call(
                    events,
                    date,
                    timeOfDayRange,
                    heightPerMinute,
                  ),
                  children: events.indexed.map(
                    (item) {
                      final event = item.$2;
                      final drawTile = dropTarget != null &&
                          (event.id == -1 || event.id == controller.selectedEventId);

                      return LayoutId(
                        id: item.$1,
                        child: drawTile ? dropTarget.call(event) : const SizedBox(),
                      );
                    },
                  ).toList(),
                );
              },
            );

            return Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(child: dropTargetWidget),
                  Positioned.fill(child: events),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
