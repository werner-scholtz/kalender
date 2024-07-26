import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/event_group_layout_delegate.dart';
import 'package:kalender/src/widgets/event_tiles/day_event_tile.dart';

/// A [StatelessWidget] that positions a list of [EventGroup]s in a stack.
///
/// The [EventGroup]s events are then rendered using the [DayEventTile].
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
    final eventLayoutStrategy = bodyConfiguration.eventLayoutStrategy;
    final eventGroupLayoutStrategy = bodyConfiguration.eventGroupLayoutStrategy;
    final showMultiDayEvents = bodyConfiguration.showMultiDayEvents;
    final selectedEvent = controller.selectedEvent;

    return ListenableBuilder(
      listenable: eventsController,
      builder: (context, child) {
        final visibleEvents = eventsController.eventsFromDateTimeRange(
          visibleDateTimeRange,
          includeDayEvents: true,
          includeMultiDayEvents: showMultiDayEvents,
        );

        /// Set the visible events on the view controller.
        controller.visibleEvents.value = visibleEvents.toList();

        // Create the event groups for the visible events.
        final eventGroups = _createEventGroups(visibleDates, visibleEvents);
        final eventGroupWidgets = eventGroups.map((group) {
          // TODO: how to handle errors when event is outside of the TimeOfDayRange.

          // Map the events to tiles.
          final tiles = group.events.indexed.map((element) {
            final (id, event) = element;
            final continuesBefore = event.start.isBefore(group.date);
            final continuesAfter = event.end.isAfter(group.date.endOfDay);
            return LayoutId(
              id: id,
              child: DayEventTile(
                event: event,
                eventsController: eventsController,
                controller: controller,
                callbacks: callbacks,
                tileComponents: tileComponents,
                bodyConfiguration: bodyConfiguration,
                visibleDateTimeRange: visibleDateTimeRange,
                timeOfDayRange: timeOfDayRange,
                dayWidth: dayWidth,
                heightPerMinute: heightPerMinute,
                continuesBefore: continuesBefore,
                continuesAfter: continuesAfter,
              ),
            );
          });

          return CustomMultiChildLayout(
            delegate: eventLayoutStrategy.call(group, heightPerMinute, timeOfDayRange),
            children: [...tiles],
          );
        });

        final eventGroupsWidget = CustomMultiChildLayout(
          delegate: eventGroupLayoutStrategy.call(
            eventGroups.toList(),
            visibleDates,
            timeOfDayRange,
            heightPerMinute,
            dayWidth,
          ),
          children: eventGroupWidgets.indexed.map((e) {
            return LayoutId(id: e.$1, child: e.$2);
          }).toList(),
        );

        // TODO: investigate a more efficient way to do this.
        final dropTargetWidget = ValueListenableBuilder(
          valueListenable: selectedEvent,
          builder: (context, event, child) {
            // If there is no event being dragged, return an empty widget.
            if (event == null) return const SizedBox();
            if (!showMultiDayEvents && event.isMultiDayEvent) return const SizedBox();

            final events = visibleEvents.toList()
              ..removeWhere((e) => e.id == controller.selectedEventId)
              ..add(event);

            final dropTarget = tileComponents.dropTargetTile;
            final eventGroups = _createEventGroups(visibleDates, events);

            final eventGroupWidgets = eventGroups.indexed.map((item) {
              // TODO: how to handle errors when event is outside of the TimeOfDayRange.
              final (index, group) = item;

              // Map the events to tiles.
              final tiles = group.events.indexed.map((element) {
                final (id, event) = element;
                final drawTile = dropTarget != null &&
                    (event.id == -1 || event.id == controller.selectedEventId);
                    
                return LayoutId(
                  id: id,
                  child: drawTile ? dropTarget.call(event) : const SizedBox(),
                );
              });

              return LayoutId(
                id: index,
                child: CustomMultiChildLayout(
                  delegate: eventLayoutStrategy.call(group, heightPerMinute, timeOfDayRange),
                  children: [...tiles],
                ),
              );
            });

            return CustomMultiChildLayout(
              delegate: EventGroupDefaultLayoutDelegate(
                groups: eventGroups.toList(),
                heightPerMinute: heightPerMinute,
                timeOfDayRange: timeOfDayRange,
                dayWidth: dayWidth,
                visibleDates: visibleDates,
              ),
              children: eventGroupWidgets.toList(),
            );
          },
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            dropTargetWidget,
            // ...eventGroupWidgets,
            eventGroupsWidget,
          ],
        );
      },
    );
  }

  /// Creates a list of [EventGroup]s from the [visibleDates] and [events].
  Iterable<EventGroup<T>> _createEventGroups(
    List<DateTime> visibleDates,
    Iterable<CalendarEvent<T>> events,
  ) {
    final eventGroups = <EventGroup<T>>[];

    // Loop through each date.
    for (final date in visibleDates) {
      // Get a list of events that are visible on the date.
      final eventsOnDate = _findEventsOnDate(events, date);

      final eventGroupsOnDate = <EventGroup<T>>[];

      // Loop through each event on the date.
      for (final event in eventsOnDate) {
        // If the event is already in a group, skip it.
        final isInGroup = eventGroupsOnDate.any(
          (group) => group.events.any((other) => other.id == event.id),
        );
        if (isInGroup) continue;

        // Get a list of events that overlap with each other.
        final overlappingEvents = _findOverlappingEvents(
          initialEvent: event,
          events: eventsOnDate,
        );

        // Calculate the start and end of the event on the date.
        final dateTimeRangeOnDate = event.dateTimeRangeOnDate(date);
        var start = dateTimeRangeOnDate.start;
        var end = dateTimeRangeOnDate.end;

        // Loop through each overlapping event to find the start and end of the group.
        for (final event in overlappingEvents) {
          final dateTimeRange = event.dateTimeRangeOnDate(date);
          if (dateTimeRange.start.isBefore(start)) start = dateTimeRange.start;
          if (dateTimeRange.end.isAfter(end)) end = dateTimeRange.end;
        }

        // Sort the events by duration.
        final events = overlappingEvents.toList();
        events.sort((a, b) => b.duration.compareTo(a.duration));

        // Generate the event group.
        final eventGroup = EventGroup<T>(
          date: date,
          events: events,
          dateTimeRange: DateTimeRange(start: start, end: end),
        );

        // Add the event group to the tileGroups on this date.
        eventGroupsOnDate.add(eventGroup);
      }

      // Add the event groups to the list.
      eventGroups.addAll(eventGroupsOnDate);
    }

    return eventGroups;
  }

  /// Finds events that overlap with the [initialEvent] from the [events], and all events that overlap with those events etc..
  Iterable<CalendarEvent<T>> _findOverlappingEvents({
    required CalendarEvent<T> initialEvent,
    required Iterable<CalendarEvent<T>> events,
  }) {
    // Add the initial event to the list of overlapping events.
    final overlappingEvents = <CalendarEvent<T>>{initialEvent};
    var previousLength = 0;

    while (previousLength != overlappingEvents.length) {
      final newOverlappingEvents = <CalendarEvent<T>>[];
      for (final event in overlappingEvents) {
        final overlappingEvents = events.where(
          (other) => other.occursDuringDateTimeRange(event.dateTimeRange),
        );
        newOverlappingEvents.addAll(overlappingEvents);
      }
      previousLength = overlappingEvents.length;
      overlappingEvents.addAll(newOverlappingEvents);
    }

    return overlappingEvents;
  }

  /// Returns a list of [CalendarEvent]'s that are visible on the [date].
  Iterable<CalendarEvent<T>> _findEventsOnDate(
    Iterable<CalendarEvent<T>> events,
    DateTime date,
  ) {
    final eventsOnDate = events.where(
      (element) => element.occursDuringDateTimeRange(date.dayRange),
    );

    return eventsOnDate;
  }
}
