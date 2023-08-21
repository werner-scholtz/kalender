import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_layout_controller/multi_day_layout_controller.dart';

class DefaultMultidayLayoutController<T>
    extends MultiDayTileLayoutController<T> {
  DefaultMultidayLayoutController({
    required super.visibleDateRange,
    required super.dayWidth,
    required super.tileHeight,
    required super.isMobileDevice,
    required super.isMultidayView,
  });

  @override
  PositionedMultiDayTileData<T> layoutTile(CalendarEvent<T> event) {
    double left = calculateLeft(event.start);
    double width = calculateWidth(event.dateTimeRange);

    return positionMultidayEvent(
      event: event,
      left: left,
      width: width,
      top: 0,
    );
  }

  @override
  List<PositionedMultiDayTileData<T>> layoutTiles(
    Iterable<CalendarEvent<T>> events,
  ) {
    stackHeight = 0;

    void updateStackHeight(double top) {
      if (stackHeight < top + tileHeight) {
        stackHeight = top + tileHeight;
      }
    }

    List<PositionedMultiDayTileData<T>> layedOutTiles =
        <PositionedMultiDayTileData<T>>[];
    void addArrangedEvent(PositionedMultiDayTileData<T> arragnedEvent) {
      if (layedOutTiles.contains(arragnedEvent)) return;
      layedOutTiles.add(arragnedEvent);
    }

    List<CalendarEvent<T>> eventsToArrange = events.toList()
      // Sort events by start dateTime
      ..sort(
        (CalendarEvent<T> a, CalendarEvent<T> b) => a.start.compareTo(b.start),
      );

    for (CalendarEvent<T> event in eventsToArrange) {
      double left = calculateLeft(event.start);
      double width = calculateWidth(event.dateTimeRange);

      List<DateTime> datesFilled = event.datesSpanned;

      // Find events that fill the same dates as the current event.
      List<PositionedMultiDayTileData<T>> arragedEventsAbove = layedOutTiles
          .where(
        (PositionedMultiDayTileData<T> arragnedEvent) {
          return arragnedEvent.event.datesSpanned
              .any((DateTime date) => datesFilled.contains(date));
        },
      ).toList()
        ..sort(
          (PositionedMultiDayTileData<T> a, PositionedMultiDayTileData<T> b) =>
              a.top.compareTo(b.top),
        );

      double top = 0;
      if (arragedEventsAbove.isNotEmpty) {
        top = arragedEventsAbove.last.top + tileHeight;
      }

      updateStackHeight(top);

      addArrangedEvent(
        positionMultidayEvent(
          event: event,
          left: left,
          top: top,
          width: width,
        ),
      );
    }

    // if (selectedEvent != null) {
    //   List<PositionedMultiDayTileData<T>> selectedArrangedEvent = layedOutTiles
    //       .where(
    //         (PositionedMultiDayTileData<T> element) =>
    //             element.event == selectedEvent,
    //       )
    //       .toList();
    //   if (selectedArrangedEvent.isNotEmpty) {
    //     layedOutTiles.removeWhere(
    //       (PositionedMultiDayTileData<T> element) =>
    //           element.event == selectedEvent,
    //     );
    //     layedOutTiles.addAll(selectedArrangedEvent);
    //   }
    // }

    numberOfRows = stackHeight ~/ tileHeight;

    if (numberOfRows == 0 && isMultidayView && isMobileDevice) {
      numberOfRows = 1;
      stackHeight = tileHeight * numberOfRows;
    } else if (numberOfRows == 0 && !isMultidayView && isMobileDevice) {
      numberOfRows = 3;
      stackHeight = tileHeight * numberOfRows;
    } else if (numberOfRows == 0) {
      numberOfRows = 1;
      stackHeight = tileHeight * numberOfRows;
    }

    return layedOutTiles;
  }

  PositionedMultiDayTileData<T> positionMultidayEvent({
    required CalendarEvent<T> event,
    required double left,
    required double top,
    required double width,
  }) {
    double checkedWidth = width;

    double checkedleft = left;
    bool continuesBefore = false;
    if (checkedleft < 0) {
      checkedleft = 0;
      checkedWidth = width + left;
      continuesBefore = true;
    }

    double checkedRight = left + width;
    bool continuesAfter = false;
    if (checkedRight > maxWidth) {
      checkedWidth = maxWidth - left;
      continuesAfter = true;
    }

    return PositionedMultiDayTileData<T>(
      event: event,
      dateRange: event.dateTimeRange,
      left: checkedleft,
      top: top,
      width: checkedWidth,
      height: tileHeight,
      continuesBefore: continuesBefore,
      continuesAfter: continuesAfter,
    );
  }

  /// Calculates the top position of the event.
  double calculateTop(int numberOfEventsAbove) =>
      tileHeight * numberOfEventsAbove;

  /// Calculates the left position of the event.
  double calculateLeft(DateTime date) =>
      (date.startOfDay.difference(visibleDateRange.start).inDays * dayWidth);

  /// Calculates the width of the event.
  double calculateWidth(DateTimeRange dateRange) =>
      (dateRange.dayDifference * dayWidth);
}
