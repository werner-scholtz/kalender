// import 'package:flutter/material.dart';

// import 'package:kalender/src/components/gesture_detectors/multi_day/multi_day_gesture_detector.dart';
// import 'package:kalender/src/components/gesture_detectors/multi_day/multi_day_tile_gesture_detector.dart';
// import 'package:kalender/src/enumerations.dart';
// import 'package:kalender/src/extensions.dart';
// import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
// import 'package:kalender/src/models/tile_configurations/tile_configuration_export.dart';
// import 'package:kalender/src/models/tile_layout_controllers/multi_day_layout_controller/multi_day_layout_controller.dart';
// import 'package:kalender/src/providers/calendar_scope.dart';

// class MultiDayTileStack<T> extends StatelessWidget {
//   const MultiDayTileStack({
//     super.key,
//     required this.pageWidth,
//     required this.dayWidth,
//     required this.multiDayEventLayout,
//   });

//   /// The width of the page.
//   final double pageWidth;

//   /// The width a single day.
//   final double dayWidth;

//   /// The [MultiDayTileLayoutController]
//   final MultiDayTileLayoutController<T> multiDayEventLayout;

//   @override
//   Widget build(BuildContext context) {
//     final scope = CalendarScope.of<T>(context);

//     return ListenableBuilder(
//       listenable: scope.eventsController,
//       builder: (context, child) {
//         /// Arrange the events.
//         final layedOutEvents = multiDayEventLayout.layoutTiles(
//           scope.eventsController.getMultiDayEventsFromDateRange(
//             scope.state.visibleDateTimeRangeNotifier.value,
//           ),
//         );

//         return SizedBox(
//           width: pageWidth,
//           height: layedOutEvents.stackHeight,
//           child: Stack(
//             fit: StackFit.expand,
//             children: <Widget>[
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   // Row(
//                   //   crossAxisAlignment: CrossAxisAlignment.end,
//                   //   children: <Widget>[
//                   //     scope.components.daySeparatorBuilder(
//                   //       15,
//                   //       dayWidth,
//                   //       scope.state.visibleDateTimeRangeNotifier.value.duration
//                   //           .inDays,
//                   //     ),
//                   //   ],
//                   // ),
//                 ],
//               ),
//               if (scope.state.viewConfiguration.createNewEvents)
//                 MultiDayGestureDetector<T>(
//                   dayWidth: dayWidth,
//                   multidayEventHeight: multiDayEventLayout.tileHeight,
//                   visibleDates: scope
//                       .state.visibleDateTimeRangeNotifier.value.datesSpanned,
//                 ),
//               ...layedOutEvents.layedOutTiles.map(
//                 (e) {
//                   return PositionedMultiDayTile<T>(
//                     visibleDateRange:
//                         scope.state.visibleDateTimeRangeNotifier.value,
//                     positionedTileData: e,
//                     dayWidth: dayWidth,
//                     horizontalDurationStep: const Duration(days: 1),
//                   );
//                 },
//               ).toList(),
//               if (showSelectedTile(scope.eventsController))
//                 ChaningMultiDayTileStack<T>(
//                   multiDayEventLayout: multiDayEventLayout,
//                   visibleDateRange:
//                       scope.state.visibleDateTimeRangeNotifier.value,
//                   dayWidth: dayWidth,
//                   horizontalDurationStep: const Duration(days: 1),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   bool showSelectedTile(CalendarEventsController<T> controller) =>
//       controller.hasChangingEvent && controller.isSelectedEventMultiDay;
// }

// /// The [PositionedMultiDayTile] is used to display a single [PositionedMultiDayTileData].
// class PositionedMultiDayTile<T> extends StatelessWidget {
//   const PositionedMultiDayTile({
//     super.key,
//     required this.visibleDateRange,
//     required this.positionedTileData,
//     required this.dayWidth,
//     required this.horizontalDurationStep,
//   });

//   final DateTimeRange visibleDateRange;
//   final PositionedMultiDayTileData<T> positionedTileData;
//   final double dayWidth;
//   final Duration horizontalDurationStep;

//   @override
//   Widget build(BuildContext context) {
//     final scope = CalendarScope.of<T>(context);
//     final isMoving =
//         scope.eventsController.selectedEvent == positionedTileData.event;
//     return Positioned(
//       top: positionedTileData.top,
//       left: positionedTileData.left,
//       width: positionedTileData.width,
//       height: positionedTileData.height,
//       child: MultiDayTileGestureDetector<T>(
//         horizontalDurationStep: horizontalDurationStep,
//         horizontalStep: dayWidth,
//         tileData: positionedTileData,
//         visibleDateRange: visibleDateRange,
//         isSelected: false,
//         child: scope.tileComponents.multiDayTileBuilder!(
//           positionedTileData.event,
//           MultiDayTileConfiguration(
//             tileType: isMoving ? TileType.ghost : TileType.normal,
//             continuesBefore: positionedTileData.continuesBefore,
//             continuesAfter: positionedTileData.continuesAfter,
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// The [ChaningMultiDayTileStack] displays a single [PositionedMultiDayTileData] that is being modified.
// class ChaningMultiDayTileStack<T> extends StatelessWidget {
//   const ChaningMultiDayTileStack({
//     super.key,
//     required this.multiDayEventLayout,
//     required this.horizontalDurationStep,
//     required this.dayWidth,
//     required this.visibleDateRange,
//   });

//   final MultiDayTileLayoutController<T> multiDayEventLayout;
//   final Duration horizontalDurationStep;
//   final double dayWidth;
//   final DateTimeRange visibleDateRange;

//   @override
//   Widget build(BuildContext context) {
//     final scope = CalendarScope.of<T>(context);
//     return ListenableBuilder(
//       listenable: scope.eventsController.selectedEvent!,
//       builder: (context, child) {
//         final positionedTile = multiDayEventLayout.layoutSelectedTile(
//           scope.eventsController.selectedEvent!,
//         );
//         return MouseRegion(
//           cursor: SystemMouseCursors.resizeColumn,
//           child: Stack(
//             children: <Widget>[
//               Positioned(
//                 top: positionedTile.top,
//                 left: positionedTile.left,
//                 width: positionedTile.width,
//                 height: positionedTile.height,
//                 child: MultiDayTileGestureDetector<T>(
//                   horizontalDurationStep: horizontalDurationStep,
//                   horizontalStep: dayWidth,
//                   tileData: positionedTile,
//                   visibleDateRange: visibleDateRange,
//                   isSelected: true,
//                   child: scope.tileComponents.multiDayTileBuilder!(
//                     positionedTile.event,
//                     MultiDayTileConfiguration(
//                       tileType: TileType.selected,
//                       continuesBefore: positionedTile.continuesBefore,
//                       continuesAfter: positionedTile.continuesAfter,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
