// import 'package:flutter/material.dart';

// import 'package:kalender/src/components/general/month_cell_scroll_view.dart';
// import 'package:kalender/src/_remove/month_tile_stack.dart';
// import 'package:kalender/src/models/view_configurations/month_configurations/month_view_configuration.dart';
// import 'package:kalender/src/providers/calendar_scope.dart';
// import 'package:kalender/src/providers/calendar_style.dart';

// /// A widget that displays the month cells for a one week period.
// class MonthCells<T> extends StatelessWidget {
//   const MonthCells({
//     super.key,
//     required this.viewConfiguration,
//     required this.cellHeight,
//     required this.cellWidth,
//     required this.visibleDateRange,
//     required this.pageWidth,
//   });

//   final MonthViewConfiguration viewConfiguration;
//   final DateTimeRange visibleDateRange;
//   final double cellHeight;
//   final double cellWidth;
//   final double pageWidth;

//   @override
//   Widget build(BuildContext context) {
//     final style = CalendarStyleProvider.of(context).style;
//     final scope = CalendarScope.of<T>(context);
//     return Stack(
//       children: <Widget>[
//         for (int c = 0; c < 5; c++)
//           Positioned(
//             top: c * cellHeight,
//             left: 0,
//             right: 0,
//             child: Column(
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     for (int r = 0; r < 7; r++)
//                       SizedBox(
//                         width: cellWidth,
//                         height: style.monthCellsStyle?.cellHeaderHeight ?? 32,
//                         child: Center(
//                           child: scope.components.monthCellHeaderBuilder(
//                             visibleDateRange.start
//                                 .add(Duration(days: (c * 7) + r)),
//                             (date) =>
//                                 scope.functions.onDateTapped?.call(date),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 Builder(
//                   builder: (context) {
//                     final weekDateRange = DateTimeRange(
//                       start: visibleDateRange.start.add(Duration(days: c * 7)),
//                       end: visibleDateRange.start
//                           .add(Duration(days: (c * 7) + 7)),
//                     );
//                     final contentHeight = cellHeight -
//                         (style.monthCellsStyle?.cellHeaderHeight ?? 32);
//                     return SizedBox(
//                       width: pageWidth,
//                       height: contentHeight,
//                       child: MonthCellScrollView(
//                         child: PositionedMonthTileStack<T>(
//                           viewConfiguration: viewConfiguration,
//                           pageWidth: pageWidth,
//                           cellWidth: cellWidth,
//                           cellHeight: contentHeight,
//                           visibleDateRange: weekDateRange,
//                           monthVisibleDateRange: visibleDateRange,
//                           monthEventLayout:
//                               scope.layoutControllers.monthTileLayoutController(
//                             visibleDateRange: weekDateRange,
//                             cellWidth: cellWidth,
//                             tileHeight: 24,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }
