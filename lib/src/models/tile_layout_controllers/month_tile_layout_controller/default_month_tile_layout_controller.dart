import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/tile_layout_controllers/month_tile_layout_controller/month_tile_layout_controller.dart';

class DefaultMonthTileLayoutController<T> extends MonthTileLayoutController<T> {
  DefaultMonthTileLayoutController({
    required super.visibleDateRange,
    required super.cellWidth,
    required super.tileHeight,
  });

  @override
  PositionedMonthTileData<T> layoutSelectedTile(CalendarEvent<T> event) {
    final left = calculateLeft(event.start);
    final width = calculateWidth(event.dateTimeRange);

    return positionMultiDayTile(
      event: event,
      left: left,
      width: width,
      top: 0,
    );
  }

  @override
  List<PositionedMonthTileData<T>> layoutTiles(
    Iterable<CalendarEvent<T>> events, {
    CalendarEvent<T>? selectedEvent,
  }) {
    stackHeight = 0;

    void updateStackHeight(double top) {
      if (stackHeight < top + tileHeight) {
        stackHeight = top + tileHeight;
      }
    }

    final layedOutTiles = <PositionedMonthTileData<T>>[];
    void addArrangedEvent(PositionedMonthTileData<T> arragnedEvent) {
      if (layedOutTiles.contains(arragnedEvent)) return;
      layedOutTiles.add(arragnedEvent);
    }

    final eventsToArrange = events.toList()
      // Sort events by start dateTime
      ..sort(
        (a, b) => a.start.compareTo(b.start),
      );

    for (var event in eventsToArrange) {
      final left = calculateLeft(event.start);
      final width = calculateWidth(event.dateTimeRange);

      final datesFilled = event.datesSpanned;

      // Find events that fill the same dates as the current event.
      final arragedEventsAbove = layedOutTiles.where(
        (arragnedEvent) {
          return arragnedEvent.event.datesSpanned.any(datesFilled.contains);
        },
      ).toList()
        ..sort(
          (a, b) => a.top.compareTo(b.top),
        );

      var top = 0.0;
      if (arragedEventsAbove.isNotEmpty) {
        top = arragedEventsAbove.last.top + tileHeight;
      }

      updateStackHeight(top);

      addArrangedEvent(
        positionMultiDayTile(
          event: event,
          left: left,
          top: top,
          width: width,
        ),
      );
    }

    if (selectedEvent != null) {
      final selectedArrangedEvent = layedOutTiles
          .where(
            (element) => element.event == selectedEvent,
          )
          .toList();
      if (selectedArrangedEvent.isNotEmpty) {
        layedOutTiles.removeWhere(
          (element) => element.event == selectedEvent,
        );
        layedOutTiles.addAll(selectedArrangedEvent);
      }
    }

    numberOfRows = stackHeight ~/ tileHeight;

    if (numberOfRows < 1) {
      numberOfRows = 1;
      stackHeight = tileHeight * numberOfRows;
    }

    return layedOutTiles;
  }

  PositionedMonthTileData<T> positionMultiDayTile({
    required CalendarEvent<T> event,
    required double left,
    required double top,
    required double width,
  }) {
    var checkedWidth = width;

    var checkedleft = left;
    var continuesBefore = false;
    if (checkedleft < 0) {
      checkedleft = 0;
      checkedWidth = width + left;
      continuesBefore = true;
    }

    final checkedRight = left + width;
    var continuesAfter = false;
    if (checkedRight > maxWidth) {
      checkedWidth = maxWidth - left;
      continuesAfter = true;
    }

    return PositionedMonthTileData<T>(
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
      (date.startOfDay.difference(visibleDateRange.start).inDays * cellWidth);

  /// Calculates the width of the event.
  double calculateWidth(DateTimeRange dateRange) =>
      (dateRange.dayDifference * cellWidth);
}
