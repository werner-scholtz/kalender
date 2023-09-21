// import 'package:flutter/material.dart';
// import 'package:kalender/src/extensions.dart';
// import 'package:kalender/src/models/calendar/calendar_event.dart';
// import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
// import 'package:kalender/src/models/calendar/calendar_functions.dart';
// import 'package:kalender/src/providers/calendar_scope.dart';

// /// A widget that detects gestures on the multiday area.
// /// TODO: Create a builder for a [MultiDayGestureDetector].
// class MultiDayGestureDetector<T> extends StatefulWidget {
//   const MultiDayGestureDetector({
//     super.key,
//     required this.dayWidth,
//     required this.multidayEventHeight,
//     required this.visibleDates,
//   });

//   final double dayWidth;
//   final double multidayEventHeight;
//   final List<DateTime> visibleDates;

//   @override
//   State<MultiDayGestureDetector<T>> createState() =>
//       _MultiDayGestureDetectorState<T>();
// }

// class _MultiDayGestureDetectorState<T>
//     extends State<MultiDayGestureDetector<T>> {
//   CalendarScope<T> get scope => CalendarScope.of<T>(context);
//   CalendarEventsController<T> get controller => scope.eventsController;
//   CalendarEventHandlers<T> get functions => scope.functions;
//   bool get isMobileDevice => scope.platformData.isMobileDevice;

//   late double dayWidth;
//   late int numberOfColumns;
//   late List<DateTime> visibleDates;

//   double cursorOffset = 0;
//   int numberOfSlotsSelected = 0;

//   @override
//   void initState() {
//     super.initState();
//     dayWidth = widget.dayWidth;
//     visibleDates = widget.visibleDates;
//     numberOfColumns = visibleDates.length;
//   }

//   @override
//   void didUpdateWidget(covariant MultiDayGestureDetector<T> oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     dayWidth = widget.dayWidth;
//     visibleDates = widget.visibleDates;
//     numberOfColumns = visibleDates.length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         for (int r = 0; r < numberOfColumns; r++)
//           Positioned(
//             left: r * dayWidth,
//             width: dayWidth,
//             top: 0,
//             bottom: 0,
//             child: MouseRegion(
//               cursor: SystemMouseCursors.click,
//               child: GestureDetector(
//                 onTap: () => _onTap(visibleDates[r].dayRange),
//                 onHorizontalDragStart: isMobileDevice
//                     ? null
//                     : (details) => _onHorizontalDragStart(
//                           details,
//                           visibleDates[r].dayRange,
//                         ),
//                 onHorizontalDragUpdate: isMobileDevice
//                     ? null
//                     : (details) => _onHorizontalDragUpdate(
//                           details,
//                           visibleDates[r].dayRange,
//                         ),
//                 onHorizontalDragEnd:
//                     isMobileDevice ? null : _onHorizontalDragEnd,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   void _onTap(DateTimeRange dateTimeRange) async {
//     if (controller.selectedEvent != null) {
//       controller.deselectEvent();
//       return;
//     }

//     final newCalendarEvent = CalendarEvent<T>(
//       dateTimeRange: dateTimeRange,
//     );

//     // Set the chaning event to the new event.
//     controller.selectEvent(newCalendarEvent);

//     await functions.onCreateEvent?.call(controller.selectedEvent!);

//     controller.deselectEvent();
//   }

//   void _onHorizontalDragStart(
//     DragStartDetails details,
//     DateTimeRange dateTimeRange,
//   ) {
//     cursorOffset = 0;
//     final displayEvent = CalendarEvent<T>(
//       dateTimeRange: dateTimeRange,
//     );
//     controller.selectEvent(displayEvent);
//   }

//   void _onHorizontalDragUpdate(
//     DragUpdateDetails details,
//     DateTimeRange initialDateTimeRange,
//   ) {
//     cursorOffset += details.delta.dx;

//     final newNumberOfSlotsSelected = cursorOffset ~/ dayWidth;

//     if (newNumberOfSlotsSelected != numberOfSlotsSelected) {
//       numberOfSlotsSelected = newNumberOfSlotsSelected;
//       DateTimeRange dateTimeRange;
//       if (numberOfSlotsSelected.isNegative) {
//         dateTimeRange = DateTimeRange(
//           start: initialDateTimeRange.start
//               .add(Duration(days: 1 * numberOfSlotsSelected)),
//           end: initialDateTimeRange.end,
//         );
//       } else {
//         dateTimeRange = DateTimeRange(
//           start: initialDateTimeRange.start,
//           end: initialDateTimeRange.end
//               .add(Duration(days: 1 * numberOfSlotsSelected)),
//         );
//       }

//       controller.selectedEvent?.dateTimeRange = dateTimeRange;
//     }
//   }

//   void _onHorizontalDragEnd(DragEndDetails details) async {
//     cursorOffset = 0;

//     await functions.onCreateEvent?.call(controller.selectedEvent!);

//     controller.deselectEvent();
//   }
// }
