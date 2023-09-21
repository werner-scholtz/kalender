// import 'package:flutter/material.dart';
// import 'package:kalender/src/extensions.dart';
// import 'package:kalender/src/models/calendar/calendar_event.dart';
// import 'package:kalender/src/models/tile_layout_controllers/multi_day_layout_controller/multi_day_layout_controller.dart';

// class DefaultMultidayLayoutController<T>
//     extends MultiDayTileLayoutController<T> {
//   DefaultMultidayLayoutController({
//     required super.visibleDateRange,
//     required super.dayWidth,
//     required super.tileHeight,
//   });

//   @override
//   PositionedMultiDayTileData<T> layoutSelectedTile(CalendarEvent<T> event) {
//     final left = calculateLeft(event.start);
//     final width = calculateWidth(event.dateTimeRange);

//     return positionMultidayEvent(
//       event: event,
//       left: left,
//       width: width,
//       top: 0,
//     );
//   }

//   @override
//   MultiDayLayoutData<T> layoutTiles(
//     Iterable<CalendarEvent<T>> events,
//   ) {
//     var stackHeight = 0.0;
//     void updateStackHeight(double top) {
//       if (stackHeight < top + tileHeight) {
//         stackHeight = top + tileHeight;
//       }
//     }

//     final layedOutTiles = <PositionedMultiDayTileData<T>>[];
//     void addArrangedEvent(PositionedMultiDayTileData<T> arragnedEvent) {
//       if (layedOutTiles.contains(arragnedEvent)) return;
//       layedOutTiles.add(arragnedEvent);
//     }

//     final eventsToArrange = events.toList()
//       // Sort events by start dateTime
//       ..sort(
//         (a, b) => a.start.compareTo(b.start),
//       );

//     for (var event in eventsToArrange) {
//       final left = calculateLeft(event.start);
//       final width = calculateWidth(event.dateTimeRange);

//       final datesFilled = event.datesSpanned;

//       // Find events that fill the same dates as the current event.
//       final arragedEventsAbove = layedOutTiles.where(
//         (arragnedEvent) {
//           return arragnedEvent.event.datesSpanned.any(datesFilled.contains);
//         },
//       ).toList()
//         ..sort(
//           (a, b) => a.top.compareTo(b.top),
//         );

//       var top = 0.0;
//       if (arragedEventsAbove.isNotEmpty) {
//         top = arragedEventsAbove.last.top + tileHeight;
//       }

//       updateStackHeight(top);

//       addArrangedEvent(
//         positionMultidayEvent(
//           event: event,
//           left: left,
//           top: top,
//           width: width,
//         ),
//       );
//     }

//     return MultiDayLayoutData<T>(
//       layedOutTiles: layedOutTiles,
//       stackHeight: stackHeight,
//     );
//   }

//   PositionedMultiDayTileData<T> positionMultidayEvent({
//     required CalendarEvent<T> event,
//     required double left,
//     required double top,
//     required double width,
//   }) {
//     var checkedWidth = width;

//     var checkedleft = left;
//     var continuesBefore = false;
//     if (checkedleft < 0) {
//       checkedleft = 0;
//       checkedWidth = width + left;
//       continuesBefore = true;
//     }

//     final checkedRight = left + width;
//     var continuesAfter = false;
//     if (checkedRight > maxWidth) {
//       checkedWidth = maxWidth - left;
//       continuesAfter = true;
//     }

//     return PositionedMultiDayTileData<T>(
//       event: event,
//       dateRange: event.dateTimeRange,
//       left: checkedleft,
//       top: top,
//       width: checkedWidth,
//       height: tileHeight,
//       continuesBefore: continuesBefore,
//       continuesAfter: continuesAfter,
//     );
//   }

//   /// Calculates the top position of the event.
//   double calculateTop(int numberOfEventsAbove) =>
//       tileHeight * numberOfEventsAbove;

//   /// Calculates the left position of the event.
//   double calculateLeft(DateTime date) =>
//       (date.startOfDay.difference(visibleDateRange.start).inDays * dayWidth);

//   /// Calculates the width of the event.
//   double calculateWidth(DateTimeRange dateRange) =>
//       (dateRange.dayDifference * dayWidth);
// }
