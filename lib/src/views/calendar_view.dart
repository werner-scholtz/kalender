// import 'package:flutter/material.dart';
// import 'package:kalender/kalender.dart';
// import 'package:kalender/src/models/calendar/calendar_components.dart';
// import 'package:kalender/src/models/calendar/calendar_controller.dart';
// import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
// import 'package:kalender/src/models/calendar/calendar_functions.dart';
// import 'package:kalender/src/models/view_configurations/view_confiuration_export.dart';
// import 'package:kalender/src/typedefs.dart';

// class CalendarView<T> extends StatefulWidget {
//   const CalendarView.singleDay({
//     super.key,
//     required this.controller,
//     required this.eventsController,
//     required this.singleDayViewConfiguration,
//     required this.tileComponents,
//     required this.functions,
//     required this.components,
//   })  : multiDayViewConfiguration = null,
//         monthViewConfiguration = null,
//         scheduleViewConfiguration = null;

//   const CalendarView.multiDay({
//     super.key,
//     required this.controller,
//     required this.eventsController,
//     required this.multiDayViewConfiguration,
//     required this.tileComponents,
//     this.functions,
//     this.components,
//   })  : singleDayViewConfiguration = null,
//         monthViewConfiguration = null,
//         scheduleViewConfiguration = null;

//   // const CalendarView.month({
//   //   super.key,
//   //   required this.controller,
//   //   required this.eventsController,
//   //   required this.functions,
//   //   required this.components,
//   //   required this.monthViewConfiguration,
//   // })  : singleDayViewConfiguration = null,
//   //       multiDayViewConfiguration = null,
//   //       scheduleViewConfiguration = null;

//   const CalendarView.schedule({
//     super.key,
//     required this.controller,
//     required this.eventsController,
//     required this.functions,
//     required this.components,
//     required this.tileComponents,
//     required this.scheduleViewConfiguration,
//   })  : singleDayViewConfiguration = null,
//         multiDayViewConfiguration = null,
//         monthViewConfiguration = null;

//   final CalendarController controller;
//   final CalendarEventsController<T> eventsController;
//   final CalendarComponents? components;
//   final CalendarTileComponents<T> tileComponents;
//   final CalendarFunctions<T>? functions;

//   final SingleDayViewConfiguration? singleDayViewConfiguration;
//   final MultiDayViewConfiguration? multiDayViewConfiguration;
//   final MonthViewConfiguration? monthViewConfiguration;
//   final ScheduleViewConfiguration? scheduleViewConfiguration;

//   @override
//   State<CalendarView<T>> createState() => _CalendarViewState<T>();
// }

// class _CalendarViewState<T extends Object?> extends State<CalendarView<T>> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// class CalendarViewV2<T> extends StatelessWidget {
//   /// Creates a calendar single day [CalendarView]
//   ///
//   /// [controller] is the [CalendarController] that controls the calendar's viewport.
//   ///
//   /// [eventsController] is the [CalendarEventsController] that controls the calendar's events.
//   ///
//   /// [viewConfiguration] is the [SingleDayViewConfiguration] that configures the [SingleDayView].
//   /// * This has to be a [SingleDayViewConfiguration] because this is a single day view.
//   ///
//   /// [tileComponents] is the [CalendarTileComponents] that defines the tiles displayed.
//   ///
//   /// [functions] is the [CalendarFunctions] that defines the functions used by the calendar.
//   ///
//   /// [components] is the [CalendarComponents] that defines the components used by the calendar.
//   ///
//   const CalendarViewV2.singleDay({
//     super.key,
//     required this.controller,
//     required this.eventsController,
//     required this.viewConfiguration,
//     required this.eventTileBuilder,
//     required this.multiDayEventTileBuilder,
//     this.functions,
//     this.components,
//   })  : assert(
//           viewConfiguration is SingleDayViewConfiguration,
//           'viewConfiguration must be a SingleDayViewConfiguration',
//         ),
//         assert(
//           eventTileBuilder != null,
//           'eventTileBuilder must not be null',
//         ),
//         assert(
//           multiDayEventTileBuilder != null,
//           'multiDayEventTileBuilder must not be null',
//         );

//   /// Creates a calendar single day [CalendarView]
//   ///
//   /// [controller] is the [CalendarController] that controls the calendar's viewport.
//   ///
//   /// [eventsController] is the [CalendarEventsController] that controls the calendar's events.
//   ///
//   /// [viewConfiguration] is the [MultiDayViewConfiguration] that configures the [MultiDayView].
//   /// * This has to be a [MultiDayViewConfiguration] because this is a single day view.
//   ///
//   /// [tileComponents] is the [CalendarTileComponents] that defines the tiles displayed.
//   ///
//   /// [functions] is the [CalendarFunctions] that defines the functions used by the calendar.
//   ///
//   /// [components] is the [CalendarComponents] that defines the components used by the calendar.
//   ///
//   const CalendarViewV2.multiDay({
//     super.key,
//     required this.controller,
//     required this.eventsController,
//     required this.viewConfiguration,
//     required this.eventTileBuilder,
//     required this.multiDayEventTileBuilder,
//     this.functions,
//     this.components,
//   })  : assert(
//           viewConfiguration is MultiDayViewConfiguration,
//           'viewConfiguration must be a MultiDayViewConfiguration',
//         ),
//         assert(
//           eventTileBuilder != null,
//           'eventTileBuilder must not be null',
//         ),
//         assert(
//           multiDayEventTileBuilder != null,
//           'multiDayEventTileBuilder must not be null',
//         );

//   final CalendarController controller;
//   final CalendarEventsController<T> eventsController;
//   final CalendarComponents? components;
//   final CalendarFunctions<T>? functions;

//   final EventTileBuilder<T>? eventTileBuilder;
//   final MultiDayEventTileBuilder<T>? multiDayEventTileBuilder;

//   final ViewConfiguration viewConfiguration;
//   // final SingleDayViewConfiguration? singleDayViewConfiguration;
//   // final MultiDayViewConfiguration? multiDayViewConfiguration;
//   // final MonthViewConfiguration? monthViewConfiguration;
//   // final ScheduleViewConfiguration? scheduleViewConfiguration;

//   @override
//   Widget build(BuildContext context) {
//     switch (viewConfiguration.runtimeType) {
//       case SingleDayViewConfiguration:
//         return SingleDayView<T>(
//           controller: controller,
//           eventsController: eventsController,
//           eventTileBuilder: eventTileBuilder!,
//           multiDayEventTileBuilder: multiDayEventTileBuilder!,
//         );
//       case MultiDayViewConfiguration:
//         return MultiDayView<T>(
//           controller: controller,
//           eventController: eventsController,
//           eventsTileBuilder: eventTileBuilder!,
//           multiDayEventTileBuilder: multiDayEventTileBuilder!,
//         );
//       case MonthViewConfiguration:
//         return Container();
//       case ScheduleViewConfiguration:
//         return Container();
//       default:
//         return Container();
//     }
//   }
// }
