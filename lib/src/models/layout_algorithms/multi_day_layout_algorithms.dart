// import 'package:flutter/material.dart';
// import 'package:kalender/src/extentions.dart';
// import 'package:kalender/src/models/calendar/calendar_event.dart';
// import 'package:kalender/src/models/tile_layout_controllers/multi_day_layout_controller/multi_day_layout_controller.dart';

// /// Calculates the top value of the tile.
// double calculateTop(double tileHeight, int numberOfEventsAbove) {
//   return tileHeight * numberOfEventsAbove;
// }

// /// Calculates the left value of the tile.
// double calculateLeft(
//   double dayWidth,
//   DateTimeRange visibleDateRange,
//   DateTime date,
// ) {
//   return (date.startOfDay.difference(visibleDateRange.start).inDays * dayWidth);
// }

// /// Calculates the width of the tile.
// double calculateWidth(double dayWidth, DateTimeRange dateRange) {
//   return (dateRange.dayDifference * dayWidth);
// }

// PositionedMultiDayTileData<dynamic> generateTileData({
//   required CalendarEvent<dynamic> event,
//   required double left,
//   required double top,
//   required double width,
//   required double tileHeight,
//   required double maxWidth,
// }) {
//   double checkedWidth = width;

//   double checkedleft = left;
//   bool continuesBefore = false;
//   if (checkedleft < 0) {
//     checkedleft = 0;
//     checkedWidth = width + left;
//     continuesBefore = true;
//   }

//   double checkedRight = left + width;
//   bool continuesAfter = false;
//   if (checkedRight > maxWidth) {
//     checkedWidth = maxWidth - left;
//     continuesAfter = true;
//   }

//   return PositionedMultiDayTileData<dynamic>(
//     event: event,
//     dateRange: event.dateTimeRange,
//     left: checkedleft,
//     top: top,
//     width: checkedWidth,
//     height: tileHeight,
//     continuesBefore: continuesBefore,
//     continuesAfter: continuesAfter,
//   );
// }

// /// Layout multiple [events].
// MultiDayLayoutData<Object> layoutMultiDayEvents({
//   required Iterable<CalendarEvent<dynamic>> events,
//   required double tileHeight,
//   required double dayWidth,
//   required DateTimeRange visibleDateRange,
// }) {
//   double stackHeight = 0;
//   void updateStackHeight(double top) {
//     if (stackHeight < top + tileHeight) {
//       stackHeight = top + tileHeight;
//     }
//   }

//   List<PositionedMultiDayTileData<Object>> layedOutTiles =
//       <PositionedMultiDayTileData<Object>>[];

//   void addLayedOutTile(PositionedMultiDayTileData<Object> arragnedEvent) {
//     if (layedOutTiles.contains(arragnedEvent)) return;
//     layedOutTiles.add(arragnedEvent);
//   }

//   List<CalendarEvent<dynamic>> eventsToArrange = events.toList()
//     // Sort events by start dateTime
//     ..sort(
//       (CalendarEvent<dynamic> a, CalendarEvent<dynamic> b) =>
//           a.start.compareTo(b.start),
//     );

//   for (CalendarEvent<dynamic> event in eventsToArrange) {
//     double left = calculateLeft(dayWidth, visibleDateRange, event.start);
//     double width = calculateWidth(dayWidth, event.dateTimeRange);

//     List<DateTime> datesFilled = event.datesSpanned;

//     // Find events that fill the same dates as the current event.
//     List<PositionedMultiDayTileData<dynamic>> arragedEventsAbove =
//         layedOutTiles.where(
//       (PositionedMultiDayTileData<dynamic> arragnedEvent) {
//         return arragnedEvent.event.datesSpanned
//             .any((DateTime date) => datesFilled.contains(date));
//       },
//     ).toList()
//           ..sort(
//             (PositionedMultiDayTileData<dynamic> a,
//                     PositionedMultiDayTileData<dynamic> b) =>
//                 a.top.compareTo(b.top),
//           );

//     double top = 0;
//     if (arragedEventsAbove.isNotEmpty) {
//       top = arragedEventsAbove.last.top + tileHeight;
//     }

//     updateStackHeight(top);

//     addLayedOutTile(
//       generateTileData(
//         event: event,
//         left: left,
//         top: top,
//         width: width,
//         tileHeight: tileHeight,
//         maxWidth: dayWidth * (visibleDateRange.duration.inDays),
//       ),
//     );
//   }

//   return MultiDayLayoutData<Object>(
//     layedOutTiles: layedOutTiles,
//     stackHeight: stackHeight,
//   );
// }

// /// Layout a single [event].
// PositionedMultiDayTileData<Object> layoutSingleMultiDayEvent({
//   required CalendarEvent<dynamic> event,
//   required double tileHeight,
//   required double dayWidth,
//   required DateTimeRange visibleDateRange,
// }) {
//   double left = calculateLeft(dayWidth, visibleDateRange, event.start);
//   double width = calculateWidth(dayWidth, event.dateTimeRange);

//   return generateTileData(
//     event: event,
//     left: left,
//     width: width,
//     top: 0,
//     maxWidth: dayWidth,
//     tileHeight: tileHeight,
//   );
// }
