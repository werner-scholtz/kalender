import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/day_event_tile.dart';

// TODO: document this.
class DayEventsWidget<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> controller;
  final CalendarCallbacks<T>? callbacks;

  final TileComponents<T> tileComponents;
  final MultiDayBodyConfiguration configuration;
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
    required this.configuration,
    required this.dayWidth,
    required this.heightPerMinute,
    required this.visibleDateTimeRange,
    required this.timeOfDayRange,
  });

  @override
  State<DayEventsWidget<T>> createState() => _DayEventsWidgetState<T>();
}

class _DayEventsWidgetState<T extends Object?> extends State<DayEventsWidget<T>> {
  late Map<DateTime, Iterable<CalendarEvent<T>>> eventsMap;

  @override
  void initState() {
    super.initState();
    _populateEventsMap();
    widget.eventsController.addListener(_updateEventsMap);
  }

  @override
  void dispose() {
    widget.eventsController.removeListener(_updateEventsMap);
    super.dispose();
  }

  /// Update the [eventsMap].
  void _updateEventsMap() => setState(_populateEventsMap);

  /// Populate the [eventsMap].
  void _populateEventsMap() {
    final visibleDates = widget.visibleDateTimeRange.days;
    final showMultiDayEvents = widget.configuration.showMultiDayEvents;
    final layoutStrategy = widget.configuration.eventLayoutStrategy;

    final entries = visibleDates.map((date) {
      final events = widget.eventsController.eventsFromDateTimeRange(
        date.dayRange,
        includeDayEvents: true,
        includeMultiDayEvents: showMultiDayEvents,
      );
      final sortedEvents = layoutStrategy(
        [],
        date,
        TimeOfDayRange.allDay(),
        0,
      ).sortEvents(events) as List<CalendarEvent<T>>;
      return MapEntry(date, sortedEvents);
    });

    eventsMap = Map.fromEntries(entries);
  }

  @override
  Widget build(BuildContext context) {
    final layoutStrategy = widget.configuration.eventLayoutStrategy;
    final showMultiDayEvents = widget.configuration.showMultiDayEvents;
    final selectedEvent = widget.controller.selectedEvent;

    return Row(
      children: eventsMap.entries.map((entry) {
        final date = entry.key;
        final visibleEvents = entry.value.toList();

        final events = CustomMultiChildLayout(
          delegate: layoutStrategy.call(
            visibleEvents,
            date,
            widget.timeOfDayRange,
            widget.heightPerMinute,
          ),
          children: visibleEvents.indexed
              .map(
                (item) => LayoutId(
                  id: item.$1,
                  child: DayEventTile(
                    event: item.$2,
                    eventsController: widget.eventsController,
                    controller: widget.controller,
                    callbacks: widget.callbacks,
                    tileComponents: widget.tileComponents,
                    dateTimeRange: date.dayRange,
                    allowResizing: widget.configuration.allowResizing,
                    allowRescheduling: widget.configuration.allowRescheduling,
                  ),
                ),
              )
              .toList(),
        );

        // TODO: investigate a more efficient way to do this.
        // This can get computationally expensive when there a lot of events.
        // Might be worth it to store the current layout instead of re-calculating every time.
        final dropTargetWidget = ValueListenableBuilder(
          valueListenable: selectedEvent,
          builder: (context, event, child) {
            // If there is no event being dragged, return an empty widget.
            if (event == null) return const SizedBox();
            if (!event.occursDuringDateTimeRange(date.dayRange)) return const SizedBox();
            if (!showMultiDayEvents && event.isMultiDayEvent) return const SizedBox();

            final events = visibleEvents.toList()
              ..removeWhere((e) => e.id == widget.controller.selectedEventId)
              ..add(event);

            final dropTarget = widget.tileComponents.dropTargetTile;

            return CustomMultiChildLayout(
              delegate:
                  layoutStrategy.call(events, date, widget.timeOfDayRange, widget.heightPerMinute),
              children: events.indexed.map(
                (item) {
                  final event = item.$2;
                  final drawTile = dropTarget != null &&
                      (event.id == -1 || event.id == widget.controller.selectedEventId);

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
  }
}
