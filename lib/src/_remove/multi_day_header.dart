// import 'package:flutter/material.dart';
// import 'package:kalender/src/components/general/material_header/material_header.dart';
// import 'package:kalender/src/components/tile_stacks/multi_day_tile_stack.dart';
// import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';
// import 'package:kalender/src/providers/calendar_scope.dart';

// class MultiDayHeaderOLD<T> extends StatelessWidget {
//   const MultiDayHeaderOLD({
//     super.key,
//     required this.viewConfiguration,
//     required this.pageWidth,
//     required this.dayWidth,
//   });

//   final MultiDayViewConfiguration viewConfiguration;
//   final double pageWidth;
//   final double dayWidth;

//   @override
//   Widget build(BuildContext context) {
//     final scope = CalendarScope.of<T>(context);

//     return CalendarHeaderBackground(
//       child: ValueListenableBuilder<DateTimeRange>(
//         valueListenable: scope.state.visibleDateTimeRangeNotifier,
//         builder: (context, visibleDateTimeRange, child) {
//           return Column(
//             children: <Widget>[
//               RepaintBoundary(
//                 child: scope.components.calendarHeaderBuilder?.call(
//                   visibleDateTimeRange,
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       SizedBox(
//                         width: viewConfiguration.timelineWidth,
//                         child: Center(
//                           child: viewConfiguration.paintWeekNumber
//                               ? scope.components
//                                   .weekNumberBuilder(visibleDateTimeRange)
//                               : null,
//                         ),
//                       ),
//                       ...List<Widget>.generate(
//                         visibleDateTimeRange.duration.inDays,
//                         (index) => SizedBox(
//                           width: dayWidth,
//                           child: scope.components.dayHeaderBuilder(
//                             visibleDateTimeRange.start
//                                 .add(Duration(days: index)),
//                             (date) => scope.functions.onDateTapped?.call(date),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               AnimatedSize(
//                 curve: Curves.easeIn,
//                 duration: const Duration(milliseconds: 200),
//                 child: Row(
//                   children: <Widget>[
//                     SizedBox(
//                       width: viewConfiguration.timelineWidth,
//                     ),
//                     MultiDayTileStack<T>(
//                       pageWidth: pageWidth,
//                       dayWidth: dayWidth,
//                       multiDayEventLayout:
//                           scope.layoutControllers.multiDayTileLayoutController(
//                         dayWidth: dayWidth,
//                         visibleDateRange: visibleDateTimeRange,
//                         tileHeight: viewConfiguration.multiDayTileHeight,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
