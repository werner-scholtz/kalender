import 'package:example/extentions.dart';

import 'package:kalender/kalender.dart';

class ExampleDayTileLayoutController<Event>
    extends DayTileLayoutController<Event> {
  ExampleDayTileLayoutController({
    required super.visibleDateRange,
    required super.visibleDates,
    required super.heightPerMinute,
    required super.dayWidth,
  });

  @override
  List<PositionedTileData<Event>> layoutSelectedEvent(
    CalendarEvent<Event> event,
  ) {
    return event.datesSpanned.map(
      (DateTime e) {
        double left = calculateLeft(e);

        double top = calculateTop(
          event.dateTimeRangeOnDate(e).start.difference(e.startOfDay),
        );

        double height = calculateTileHeight(event.durationOnDate(e));

        return PositionedTileData<Event>(
          event: event,
          date: e,
          left: left,
          top: top,
          width: dayWidth,
          height: height,
          drawOutline: false,
          continuesBefore: event.continuesBefore(e),
          continuesAfter: event.continuesAfter(e),
        );
      },
    ).toList();
  }

  @override
  List<TileGroup<Event>> generateTileGroups(
    Iterable<CalendarEvent<Event>> events,
  ) {
    List<TileGroup<Event>> tileGroups = [];

    // Loop through visible Dates.
    for (DateTime date in visibleDates) {
      // Get a list of events that are visible on the current date.
      List<CalendarEvent<Event>> eventsOnDate = findEventsOnDate(
        events,
        date,
      );

      // Sort the eventsOnDate by start time.
      eventsOnDate.sort(
        (CalendarEvent<Event> a, CalendarEvent<Event> b) =>
            a.start.compareTo(b.start),
      );

      // Group the events into TileGroups.
      List<TileGroup<Event>> tileGroupsOnDate = generateTileGroupsOnDate(
        date,
        eventsOnDate,
      );

      // Add the tileGroupsOnDate to the tileGroups list.
      tileGroups.addAll(tileGroupsOnDate);
    }

    return tileGroups;
  }

  /// Create Tile groups for a specific date.
  List<TileGroup<Event>> generateTileGroupsOnDate(
    DateTime date,
    List<CalendarEvent<Event>> eventsOnDate,
  ) {
    // Create a list of tile groups.
    List<TileGroup<Event>> tileGroupsOnDate = [];

    // Calculate the left value of the group tile.
    double tileGroupLeft = calculateLeft(date);

    // Loop through events on date.
    for (CalendarEvent<Event> event in eventsOnDate) {
      // If the event is already in a group, skip it.
      if (tileGroupsOnDate.any(
        (TileGroup<Event> element) => element.events.contains(event),
      )) {
        continue;
      }

      // Get a list of events that overlap with the initial event
      // and all events that overlap with those events.
      List<CalendarEvent<Event>> groupedEvents = findOverlappingEvents(
        initialEvent: event,
        otherEvents: eventsOnDate,
      );

      TileGroup<Event> tileGroup;

      if (groupedEvents.length == 1) {
        // If there is only one event in the group, directly create the tile group.
        tileGroup = createTileGroupFromEvent(
          groupedEvents,
          event,
          date,
          tileGroupLeft,
        );
      } else {
        // If there is more than one event in the group, create the tile group from the grouped events.
        tileGroup = createTileGroupFromEvents(
          groupedEvents,
          date,
          tileGroupLeft,
        );
      }

      tileGroupsOnDate.add(
        tileGroup,
      );
    }
    return tileGroupsOnDate;
  }

  /// Create a tile group from a list of grouped events.
  TileGroup<Event> createTileGroupFromEvents(
    List<CalendarEvent<Event>> groupedEvents,
    DateTime date,
    double tileGroupLeft,
  ) {
    // Sort the groupedEvents by duration if the start times are the same.
    // This is to ensure that the longest event is first in the list and that it is aligned to the left of the tilegroup.
    groupedEvents.sort(
      (CalendarEvent<Event> a, CalendarEvent<Event> b) =>
          (a.start == b.start) ? a.duration.compareTo(b.duration) * -1 : 0,
    );

    // The number of events in the group.
    int numberOftiles = groupedEvents.length;
    double tileWidth = dayWidth / numberOftiles;

    // Determine the Start DateTime of the tile group.
    DateTime tileGroupStart = groupedEvents.first.start;
    DateTime tileGroupEnd = groupedEvents.first.end;

    List<PositionedTileData<Event>> positionedTileDatas = [];

    for (int i = 0; i < groupedEvents.length; i++) {
      // Get the event from the current index.
      CalendarEvent<Event> currentEvent = groupedEvents.elementAt(i);

      // Update the tileGroup end if the current event ends later.
      if (tileGroupEnd.isBefore(currentEvent.end)) {
        tileGroupEnd = currentEvent.end;
      }

      // Calculate the top value of the tile.
      double top = calculateTop(
        currentEvent.dateTimeRangeOnDate(date).start.difference(tileGroupStart),
      );

      // Calculate the height value of the tile.
      double height = calculateTileHeight(currentEvent.durationOnDate(date));

      PositionedTileData<Event> positionedTileData = PositionedTileData<Event>(
        event: currentEvent,
        date: date,
        left: tileWidth * i,
        top: top,
        width: tileWidth,
        height: height,
        drawOutline: false,
        continuesBefore: currentEvent.continuesBefore(date),
        continuesAfter: currentEvent.continuesAfter(date),
      );

      positionedTileDatas.add(positionedTileData);
    }

    // Calculate the top of the tile group.
    double tileGroupTop =
        calculateTop(tileGroupStart.difference(date.startOfDay));

    // Calculate the height of the tile group.
    double tileGroupHeight =
        calculateTileHeight(tileGroupEnd.difference(tileGroupStart));

    return TileGroup(
      date: date,
      tileGroupLeft: tileGroupLeft,
      tileGroupTop: tileGroupTop,
      tileGroupWidth: dayWidth,
      tileGroupHeight: tileGroupHeight,
      tilePositionData: positionedTileDatas,
      events: groupedEvents,
    );
  }

  /// Create a tile group from a single event.
  TileGroup<Event> createTileGroupFromEvent(
    List<CalendarEvent<Event>> groupedEvents,
    CalendarEvent<Event> event,
    DateTime date,
    double tileGroupLeft,
  ) {
    // Determine the Start DateTime of the tile group.
    DateTime tileGroupStart = event.dateTimeRangeOnDate(date).start;

    // Calculate the width of the event.
    double eventWidth = dayWidth;

    // Calculate the position data for the event.
    PositionedTileData<Event> positionedTileData = PositionedTileData<Event>(
      event: event,
      date: date,
      left: 0,
      top: calculateTop(
        event.dateTimeRangeOnDate(date).start.difference(tileGroupStart),
      ),
      width: eventWidth,
      height: calculateTileHeight(event.durationOnDate(date)),
      drawOutline: false,
      continuesBefore: event.continuesBefore(date),
      continuesAfter: event.continuesAfter(date),
    );

    // Create the tile group.
    return TileGroup<Event>(
      date: date,
      events: groupedEvents,
      tileGroupTop: calculateTop(tileGroupStart.difference(date.startOfDay)),
      tileGroupLeft: tileGroupLeft,
      tileGroupWidth: dayWidth,
      tileGroupHeight: positionedTileData.height,
      tilePositionData: [positionedTileData],
    );
  }

  /// Finds events that overlap with the [initialEvent] from the [otherEvents], and all events that overlap with those events etc..
  /// you get the idea...
  List<CalendarEvent<Event>> findOverlappingEvents({
    required CalendarEvent<Event> initialEvent,
    required Iterable<CalendarEvent<Event>> otherEvents,
    int maxIterations = 50,
  }) {
    Set<CalendarEvent<Event>> overlappingEvents = <CalendarEvent<Event>>{
      initialEvent
    };
    int previousLength = 0;
    int iteration = 0;
    while (previousLength != overlappingEvents.length &&
        iteration <= maxIterations) {
      List<CalendarEvent<Event>> newOverlappingEvents =
          <CalendarEvent<Event>>[];
      for (CalendarEvent<Event> event in overlappingEvents) {
        newOverlappingEvents.addAll(
          otherEvents.where(
            (CalendarEvent<Event> element) =>
                ((element.start.isWithin(event.dateTimeRange) ||
                        element.end.isWithin(event.dateTimeRange)) ||
                    element.start == event.start ||
                    element.end == event.end),
          ),
        );
      }
      previousLength = overlappingEvents.length;
      overlappingEvents.addAll(newOverlappingEvents);
      iteration++;
    }
    return overlappingEvents.toList();
  }

  /// Checks if the current event's title overlaps with the previous event's tile
  bool overlapsWithPreviousTitle(
    double currentTop,
    double previousTop,
    double safeSpace,
  ) {
    return previousTop + safeSpace > currentTop &&
        previousTop - safeSpace < currentTop;
  }

  /// Returns a list of [CalendarEvent]'s that are visible on the [date].
  List<CalendarEvent<Event>> findEventsOnDate(
    Iterable<CalendarEvent<Event>> events,
    DateTime date,
  ) {
    return events
        .where(
          (CalendarEvent<Event> element) =>
              element.start.isSameDay(date) || element.end.isSameDay(date),
        )
        .toList();
  }

  /// Calculate the left value of the group tile.
  ///
  /// The [date] passed in is the date that the groupedTile is displayed on.
  double calculateLeft(DateTime date) {
    return (date.difference(visibleDateRange.start).inDays * dayWidth);
  }

  /// Calculate the top value of the tile.
  ///
  /// The [timeBeforeStart] is the difference between the start of the event and the start of the day.
  double calculateTop(Duration timeBeforeStart) {
    return timeBeforeStart.inMinutes * heightPerMinute;
  }

  /// Calculate the height value of the tile.
  ///
  /// The [eventDuration] is the duration of the event.
  double calculateTileHeight(Duration eventDuration) {
    return eventDuration.inMinutes * heightPerMinute;
  }
}
