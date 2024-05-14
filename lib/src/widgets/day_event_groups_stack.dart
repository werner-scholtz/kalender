import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/layout_delegates/event_group_layout_delegate.dart';
import 'package:kalender/src/models/groups/event_group.dart';
import 'package:kalender/src/models/providers/multi_day_body_provider.dart';
import 'package:kalender/src/widgets/components/event_tile.dart';

/// A [StatelessWidget] that positions a list of [EventGroup]s in a stack.
///
/// The [EventGroup]s events are then rendered using the [EventTile].
class DayEventGroupsStack<T extends Object?> extends StatelessWidget {
  final DateTimeRange visibleDateTimeRange;
  final Iterable<CalendarEvent<T>> visibleEvents;
  final DayTileComponents<T> components;
  final CalendarCallbacks<T>? callbacks;
  final ValueNotifier<CalendarEvent<T>?> eventBeingDragged;
  final EventsController<T> eventsController;
  final DayEventLayoutStrategy layoutStrategy;

  /// Creates a [DayEventGroupsStack].
  const DayEventGroupsStack({
    super.key,
    required this.eventBeingDragged,
    required this.visibleEvents,
    required this.components,
    required this.visibleDateTimeRange,
    required this.callbacks,
    required this.eventsController,
    required this.layoutStrategy,
  });

  @override
  Widget build(BuildContext context) {
    final provider = MultiDayBodyProvider.of(context);
    final dayWidth = provider.dayWidth;
    final heightPerMinute = provider.heightPerMinuteValue;
    final timeOfDayRange = provider.timeOfDayRange;
    final visibleDates = visibleDateTimeRange.datesSpanned;

    // Create the widget that displays the event being dragged.
    final dropTargetWidget = ValueListenableBuilder(
      valueListenable: eventBeingDragged,
      builder: (context, event, child) {
        // If there is no event being dragged, return an empty widget.
        if (event == null) return const SizedBox();

        // Create a list of event groups that will be used to render the event.
        final chainingEventGroups = _createEventGroups(visibleDates, [event]);
        final eventGroups = _generateEventGroups(
          groups: chainingEventGroups,
          dayWidth: dayWidth,
          heightPerMinute: heightPerMinute,
          timeOfDayRange: timeOfDayRange,
          visibleDates: visibleDates,
          child: components.dropTargetTile.call,
          layoutStrategy: layoutStrategy,
        );

        return Stack(
          fit: StackFit.expand,
          children: [...eventGroups],
        );
      },
    );

    // Create the event groups for the visible events.
    final eventGroups = _createEventGroups(visibleDates, visibleEvents);
    final eventGroupWidgets = _generateEventGroups(
      groups: eventGroups,
      dayWidth: dayWidth,
      heightPerMinute: heightPerMinute,
      timeOfDayRange: timeOfDayRange,
      visibleDates: visibleDates,
      layoutStrategy: layoutStrategy,
      child: (event) {
        return EventTile(
          event: event,
          tileComponents: components,
          callbacks: callbacks,
          eventBeingDragged: eventBeingDragged,
          eventsController: eventsController,
        );
      },
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        ...eventGroupWidgets,
        dropTargetWidget,
      ],
    );
  }

  Iterable<Positioned> _generateEventGroups({
    required Iterable<EventGroup<T>> groups,
    required Widget Function(CalendarEvent<T> event) child,
    required List<DateTime> visibleDates,
    required double dayWidth,
    required double heightPerMinute,
    required TimeOfDayRange timeOfDayRange,
    required DayEventLayoutStrategy layoutStrategy,
  }) {
    // Map the event groups to widgets.
    return groups.map((group) {
      final dayIndex = visibleDates.indexOf(group.date);

      // Calculate the left value of the group.
      final groupWidth = dayWidth - 1;
      final left = (groupWidth * dayIndex) + (dayIndex + 1);

      // Calculate the height of the group.
      final duration = group.dateTimeRange.duration;
      final height = heightPerMinute * duration.inMinutes;

      // Calculate the top value of the group.
      final startOfDay = timeOfDayRange.start.toDateTime(group.date);
      final timeAfterStart = group.start.difference(startOfDay);
      final top = heightPerMinute * timeAfterStart.inMinutes;

      // TODO: how to handle errors when event is outside of the TimeOfDayRange.

      // Map the events to tiles.
      final tiles = group.events.indexed.map((element) {
        final (id, event) = element;
        return LayoutId(
          id: id,
          child: child.call(event),
        );
      });

      return Positioned(
        left: left,
        width: groupWidth,
        height: height,
        top: top,
        child: CustomMultiChildLayout(
          delegate: layoutStrategy.call(group, heightPerMinute, timeOfDayRange),
          children: [...tiles],
        ),
      );
    });
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
