import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/tile_layout_controllers/day_tile_layout_controller/day_tile_layout_controller.dart';

class DefaultDayTileLayoutController<T> extends DayTileLayoutController<T> {
  DefaultDayTileLayoutController({
    required super.visibleDateRange,
    required super.visibleDates,
    required super.verticalDurationStep,
    required super.heightPerMinute,
    required super.dayWidth,
  });

  @override
  List<TileGroup<T>> generateTileGroups(
    Iterable<CalendarEvent<T>> events,
  ) {
    List<TileGroup<T>> tileGroups = <TileGroup<T>>[];

    // Loop through visible Dates.
    for (DateTime date in visibleDates) {
      // Get a list of events that are visible on the current date.
      List<CalendarEvent<T>> eventsOnDate =
          findEventsOnDate(events, date).toList();

      // Sort the eventsOnDate by start time.
      eventsOnDate.sort(
        (CalendarEvent<T> a, CalendarEvent<T> b) => a.start.compareTo(b.start),
      );

      // Group the events into TileGroups.
      List<TileGroup<T>> tileGroupsOnDate =
          generateTileGroupsOnDate(date, eventsOnDate);

      // Add the tileGroupsOnDate to the tileGroups list.
      tileGroups.addAll(tileGroupsOnDate);
    }

    return tileGroups;
  }

  List<TileGroup<T>> generateTileGroupsOnDate(
    DateTime date,
    List<CalendarEvent<T>> eventsOnDate,
  ) {
    List<TileGroup<T>> tileGroupsOnDate = <TileGroup<T>>[];

    // Calculate the left value of the group tile.
    double tileGroupLeft = calculateLeft(date);

    // Loop through events on date.
    for (CalendarEvent<T> event in eventsOnDate) {
      // If the event is already in a group, skip it.
      if (tileGroupsOnDate
          .any((TileGroup<T> element) => element.events.contains(event))) {
        continue;
      }

      // Get a list of events that overlap with the initial event
      // and all events that overlap with those events.
      List<CalendarEvent<T>> groupedEvents = findOverlappingEvents(
        initialEvent: event,
        otherEvents: eventsOnDate,
      );

      TileGroup<T> tileGroup;

      if (groupedEvents.length == 1) {
        // If there is only one event in the group, directly create the tile group.
        tileGroup = createTileGroupFromSingleEvent(
          groupedEvents,
          event,
          date,
          tileGroupLeft,
        );
      } else {
        // If there is more than one event in the group, create the tile group from the grouped events.

        // Sort the groupedEvents by duration if the start times are the same.
        // This is to ensure that the longest event is displayed first and that it is aligned to the left of the tilegroup.
        groupedEvents.sort(
          (CalendarEvent<T> a, CalendarEvent<T> b) =>
              (a.start == b.start) ? a.duration.compareTo(b.duration) * -1 : 0,
        );

        List<PositionedTileData<T>> positionedTileDatas =
            <PositionedTileData<T>>[];
        void addTileData(PositionedTileData<T> positionedTileData) {
          if (positionedTileDatas.any(
            (PositionedTileData<T> element) =>
                element.event == positionedTileData.event,
          )) {
            return;
          }
          positionedTileDatas.add(positionedTileData);
        }

        // Determine the Start DateTime of the tile group.
        DateTime tileGroupStart = groupedEvents.first.start;

        // The tile group height will be calculated by looping through the groupedEvents.
        double tileGroupHeight = 0;
        void updateGroupHeight(double height) {
          if (tileGroupHeight < height) {
            tileGroupHeight = height;
          }
        }

        // Loop through the groupedEvents.
        for (int i = 0; i < groupedEvents.length; i++) {
          // Get the event from the current index.
          CalendarEvent<T> currentEvent = groupedEvents.elementAt(i);

          if (i == 0) {
            double top = calculateTop(
              currentEvent
                  .dateTimeRangeOnDate(date)
                  .start
                  .difference(tileGroupStart),
            );
            double height =
                calculateTileHeight(currentEvent.durationOnDate(date));
            double eventWidth = dayWidth - (dayWidth / 10);
            PositionedTileData<T> positionedTileData = PositionedTileData<T>(
              event: currentEvent,
              date: date,
              left: 0,
              top: top,
              width: eventWidth,
              height: height,
              drawOutline: false,
              continuesBefore: currentEvent.continuesBefore(date),
              continuesAfter: currentEvent.continuesAfter(date),
            );
            addTileData(positionedTileData);
            updateGroupHeight(
              positionedTileData.height + positionedTileData.top,
            );
            continue;
          }

          // Check if the current event has already been added to the tile group.
          if (positionedTileDatas.any(
            (PositionedTileData<T> element) => element.event == currentEvent,
          )) {
            continue;
          }
          // Calculate the top value of the tile to check if it overlaps with the previous tile's title.
          double top = calculateTop(
            currentEvent
                .dateTimeRangeOnDate(date)
                .start
                .difference(tileGroupStart),
          );
          double tileLeftOffset;
          double eventWidth;
          if (overlapsWithPreviousTitle(
            top,
            positionedTileDatas[i - 1].top,
            15,
          )) {
            Iterable<PositionedTileData<T>> eventsBehind =
                positionedTileDatas.where(
              (PositionedTileData<T> element) =>
                  currentEvent.start.isWithin(element.event.dateTimeRange) ||
                  currentEvent.start == element.event.start ||
                  currentEvent.end == element.event.end,
            );

            PositionedTileData<T>? eventBehind;
            if (eventsBehind.isNotEmpty) {
              eventBehind = eventsBehind.last;
            }

            tileLeftOffset = eventBehind != null
                ? eventBehind.left + (dayWidth / 4)
                : i * (dayWidth / 10);
            eventWidth = dayWidth - (dayWidth / 20);
          } else {
            Iterable<PositionedTileData<T>> eventsBehind =
                positionedTileDatas.where(
              (PositionedTileData<T> element) =>
                  currentEvent.start.isWithin(element.event.dateTimeRange),
            );

            PositionedTileData<T>? eventBehind;

            if (eventsBehind.isNotEmpty) {
              eventBehind = eventsBehind.last;
            }

            eventWidth = dayWidth - (dayWidth / 10);
            tileLeftOffset = (eventBehind?.left ?? 0) + (dayWidth / 10);
          }

          double height =
              calculateTileHeight(currentEvent.durationOnDate(date));
          bool drawOutline = true;

          PositionedTileData<T> positionedTileData = PositionedTileData<T>(
            event: currentEvent,
            date: date,
            left: tileLeftOffset,
            top: top,
            width: eventWidth - tileLeftOffset,
            height: height,
            drawOutline: drawOutline,
            continuesBefore: currentEvent.continuesBefore(date),
            continuesAfter: currentEvent.continuesAfter(date),
          );

          addTileData(positionedTileData);
          updateGroupHeight(positionedTileData.height + positionedTileData.top);
        }

        tileGroup = TileGroup<T>(
          date: date,
          events: groupedEvents,
          tileGroupLeft: tileGroupLeft,
          tileGroupTop:
              calculateTop(tileGroupStart.difference(date.startOfDay)),
          tileGroupWidth: dayWidth,
          tileGroupHeight: tileGroupHeight,
          tilePositionData: positionedTileDatas,
        );
      }

      tileGroupsOnDate.add(
        tileGroup,
      );
    }
    return tileGroupsOnDate;
  }

  /// Create a tile group from a single event.
  TileGroup<T> createTileGroupFromSingleEvent(
    List<CalendarEvent<T>> groupedEvents,
    CalendarEvent<T> event,
    DateTime date,
    double tileGroupLeft,
  ) {
    // Determine the Start DateTime of the tile group.
    DateTime tileGroupStart = event.dateTimeRangeOnDate(date).start;

    // Calculate the width of the event.
    double eventWidth = dayWidth - (dayWidth / 10);

    // Calculate the position data for the event.
    PositionedTileData<T> positionedTileData = PositionedTileData<T>(
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
    return TileGroup<T>(
      date: date,
      events: groupedEvents,
      tileGroupTop: calculateTop(tileGroupStart.difference(date.startOfDay)),
      tileGroupLeft: tileGroupLeft,
      tileGroupWidth: dayWidth,
      tileGroupHeight: positionedTileData.height,
      tilePositionData: <PositionedTileData<T>>[positionedTileData],
    );
  }

  /// Finds events that overlap with the [initialEvent] from the [otherEvents], and all events that overlap with those events etc..
  /// you get the idea...
  List<CalendarEvent<T>> findOverlappingEvents({
    required CalendarEvent<T> initialEvent,
    required Iterable<CalendarEvent<T>> otherEvents,
    int maxIterations = 50,
  }) {
    Set<CalendarEvent<T>> overlappingEvents = <CalendarEvent<T>>{initialEvent};
    int previousLength = 0;
    int iteration = 0;
    while (previousLength != overlappingEvents.length &&
        iteration <= maxIterations) {
      List<CalendarEvent<T>> newOverlappingEvents = <CalendarEvent<T>>[];
      for (CalendarEvent<T> event in overlappingEvents) {
        newOverlappingEvents.addAll(
          otherEvents.where(
            (CalendarEvent<T> element) =>
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

  @override
  List<PositionedTileData<T>> layoutSelectedEvent(
    CalendarEvent<T> event,
  ) {
    return event.datesSpanned
        .map(
          (DateTime e) => PositionedTileData<T>(
            event: event,
            date: e,
            left: calculateLeft(e),
            top: calculateTop(
              event.dateTimeRangeOnDate(e).start.difference(e.startOfDay),
            ),
            width: dayWidth,
            height: calculateTileHeight(event.durationOnDate(e)),
            drawOutline: false,
            continuesBefore: event.continuesBefore(e),
            continuesAfter: event.continuesAfter(e),
          ),
        )
        .toList();
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
  Iterable<CalendarEvent<T>> findEventsOnDate(
    Iterable<CalendarEvent<T>> events,
    DateTime date,
  ) {
    return events.where(
      (CalendarEvent<T> element) =>
          element.start.isSameDay(date) || element.end.isSameDay(date),
    );
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
