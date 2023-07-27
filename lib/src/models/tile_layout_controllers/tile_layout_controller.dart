import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

/// The [TileLayoutController] is used to arrange [EventTile]'s.
class TileLayoutController<T extends Object?> {
  /// The [DateTimeRange] that is visible on the calendar.
  final DateTimeRange visibleDateRange;

  /// The [DateTime]s that are visible on the calendar.
  late final List<DateTime> visibleDates = visibleDateRange.datesSpanned;

  /// The [Duration] of a vertical duration step.
  ///
  /// This is used to estimate the height of the event title.
  final Duration verticalDurationStep;

  /// The height of each minute.
  ///
  /// This is used to calculate the [top] and [height] of the events.
  final double heightPerMinute;

  /// The width of each day.
  ///
  /// This is used to calculate the [left] and [width] of the event.
  final double dayWidth;

  /// The offset on the left of that page.
  ///
  /// This is used to adjust the [left] of the event so it lines up with the correct day.
  final double leftPageOffset;

  TileLayoutController({
    required this.visibleDateRange,
    required this.heightPerMinute,
    required this.dayWidth,
    required this.verticalDurationStep,
    required this.leftPageOffset,
  });

  /// Generate tile groups from the [events].
  List<TileGroup<T>> generateTileGroups(
    Iterable<CalendarEvent<T>> events,
  ) {
    List<TileGroup<T>> tileGroups = <TileGroup<T>>[];

    // Loop through visible Dates.
    for (DateTime date in visibleDates) {
      // Get a list of events that are visible on the current date.
      List<CalendarEvent<T>> eventsOnDate = findEventsOnDate(events, date).toList();

      // Sort the eventsOnDate by start time.
      eventsOnDate.sort((CalendarEvent<T> a, CalendarEvent<T> b) => a.start.compareTo(b.start));

      // Group the events into TileGroups.
      List<TileGroup<T>> tileGroupsOnDate = generateTileGroupsOnDate(date, eventsOnDate);

      // Add the tileGroupsOnDate to the tileGroups list.
      tileGroups.addAll(tileGroupsOnDate);
    }

    return tileGroups;
  }

  List<TileGroup<T>> generateTileGroupsOnDate(DateTime date, List<CalendarEvent<T>> eventsOnDate) {
    List<TileGroup<T>> tileGroupsOnDate = <TileGroup<T>>[];

    // Calculate the left value of the group tile.
    double tileGroupLeft = calculateLeft(date);

    // Loop through events on date.
    for (CalendarEvent<T> event in eventsOnDate) {
      // If the event is already in a group, skip it.
      if (tileGroupsOnDate.any((TileGroup<T> element) => element.events.contains(event))) {
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
        // log(date.toString(), name: 'Date');

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

        List<PositionedTileData<T>> positionedTileDatas = <PositionedTileData<T>>[];
        void addTileData(PositionedTileData<T> positionedTileData) {
          if (positionedTileDatas
              .any((PositionedTileData<T> element) => element.event == positionedTileData.event)) {
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
              currentEvent.dateTimeRangeOnDate(date).start.difference(tileGroupStart),
            );
            double height = calculateTileHeight(currentEvent.durationOnDate(date));
            double eventWidth = dayWidth - (dayWidth / 10);
            PositionedTileData<T> positionedTileData = PositionedTileData<T>(
              event: currentEvent,
              date: date,
              left: 0,
              top: top,
              width: eventWidth,
              height: height,
              drawOutline: false,
            );
            addTileData(positionedTileData);
            updateGroupHeight(positionedTileData.height + positionedTileData.top);
            continue;
          }

          // Check if the current event has already been added to the tile group.
          if (positionedTileDatas
              .any((PositionedTileData<T> element) => element.event == currentEvent)) {
            continue;
          }
          // Calculate the top value of the tile to check if it overlaps with the previous tile's title.
          double top =
              calculateTop(currentEvent.dateTimeRangeOnDate(date).start.difference(tileGroupStart));
          double tileLeftOffset;
          double eventWidth;
          if (overlapsWithPreviousTitle(top, positionedTileDatas[i - 1].top, 15)) {
            PositionedTileData<T>? eventBehind = positionedTileDatas
                .where(
                  (PositionedTileData<T> element) =>
                      currentEvent.start.isWithin(element.event.dateTimeRange) ||
                      currentEvent.start == element.event.start ||
                      currentEvent.end == element.event.end,
                )
                .lastOrNull;

            tileLeftOffset =
                eventBehind != null ? eventBehind.left + (dayWidth / 4) : i * (dayWidth / 10);
            eventWidth = dayWidth - (dayWidth / 20);
          } else {
            eventWidth = dayWidth - (dayWidth / 10);
            PositionedTileData<T>? eventBehind = positionedTileDatas
                .where(
                  (PositionedTileData<T> element) =>
                      currentEvent.start.isWithin(element.event.dateTimeRange),
                )
                .toList()
                .lastOrNull;

            tileLeftOffset = (eventBehind?.left ?? 0) + (dayWidth / 10);
          }

          double height = calculateTileHeight(currentEvent.durationOnDate(date));
          bool drawOutline = true;

          PositionedTileData<T> positionedTileData = PositionedTileData<T>(
            event: currentEvent,
            date: date,
            left: tileLeftOffset,
            top: top,
            width: eventWidth - tileLeftOffset,
            height: height,
            drawOutline: drawOutline,
          );

          addTileData(positionedTileData);
          updateGroupHeight(positionedTileData.height + positionedTileData.top);
        }

        tileGroup = TileGroup<T>(
          date: date,
          events: groupedEvents,
          tileGroupLeft: tileGroupLeft,
          tileGroupTop: calculateTop(tileGroupStart.difference(date.startOfDay)),
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
      top: calculateTop(event.dateTimeRangeOnDate(date).start.difference(tileGroupStart)),
      width: eventWidth,
      height: calculateTileHeight(event.durationOnDate(date)),
      drawOutline: false,
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
    while (previousLength != overlappingEvents.length && iteration <= maxIterations) {
      List<CalendarEvent<T>> newOverlappingEvents = <CalendarEvent<T>>[];
      for (CalendarEvent<T> event in overlappingEvents) {
        newOverlappingEvents.addAll(
          otherEvents.where(
            (CalendarEvent<T> element) => ((element.start.isWithin(event.dateTimeRange) ||
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

  /// Positioned a single event on the calendar.
  ///
  /// This is mainly used for the chaning event.
  List<PositionedTileData<T>> positionSingleEvent(CalendarEvent<T> event) {
    return event.datesSpanned
        .map(
          (DateTime e) => PositionedTileData<T>(
            event: event,
            date: e,
            left: calculateLeft(e),
            top: calculateTop(event.dateTimeRangeOnDate(e).start.difference(e.startOfDay)),
            width: dayWidth,
            height: calculateTileHeight(event.durationOnDate(e)),
            drawOutline: false,
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
    return previousTop + safeSpace > currentTop && previousTop - safeSpace < currentTop;
  }

  /// Returns a list of [CalendarEvent]'s that are visible on the [date].
  Iterable<CalendarEvent<T>> findEventsOnDate(Iterable<CalendarEvent<T>> events, DateTime date) {
    return events.where(
      (CalendarEvent<T> element) => element.start.isSameDay(date) || element.end.isSameDay(date),
    );
  }

  /// Calculate the left value of the group tile.
  ///
  /// The [date] passed in is the date that the groupedTile is displayed on.
  double calculateLeft(DateTime date) {
    return (date.difference(visibleDateRange.start).inDays * dayWidth) + leftPageOffset;
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

class TileGroup<T extends Object?> {
  /// The date that the tile's will be displayed on.
  final DateTime date;

  /// The tile group's left value.
  final double tileGroupLeft;

  /// The tile group's top value.
  final double tileGroupTop;

  /// The initial width of the tiles.
  final double tileGroupWidth;

  /// The height of the tile group.
  final double tileGroupHeight;

  /// The [PositionedTileData] that are used to position the tiles in this group.
  final List<PositionedTileData<T>> tilePositionData;

  /// The [CalendarEvent]'s that are in this group.
  final Iterable<CalendarEvent<T>> events;

  TileGroup({
    required this.date,
    required this.tileGroupLeft,
    required this.tileGroupTop,
    required this.tileGroupWidth,
    required this.tileGroupHeight,
    required this.tilePositionData,
    required this.events,
  });
}

class PositionedTileData<T extends Object?> {
  /// The event that the tile represents.
  final CalendarEvent<T> event;

  /// The date that the tile is displayed on.
  final DateTime date;

  /// The distance that the tile's left edge is inset from the left of the stack.
  final double left;

  /// The distance that the tile's top edge is inset from the top of the stack.
  final double top;

  /// The tile's height.
  final double height;

  /// The tile's width.
  final double width;

  /// If the tile should draw an outline.
  final bool drawOutline;

  PositionedTileData({
    required this.event,
    required this.date,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.drawOutline,
  });

  @override
  bool operator ==(Object other) {
    return other is PositionedTileData<T> &&
        other.date == date &&
        other.left == left &&
        other.top == top &&
        other.height == height &&
        other.width == width &&
        other.event == event &&
        other.drawOutline == drawOutline;
  }

  @override
  int get hashCode => Object.hash(date, top, left, height, width, event, drawOutline);
}
