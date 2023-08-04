import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/month_cells.dart';
import 'package:kalender/src/components/general/month_grid.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/view_configurations/view_confiuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class MonthViewContent<T> extends StatelessWidget {
  const MonthViewContent({
    super.key,
    required this.controller,
    required this.viewConfiguration,
    required this.cellWidth,
  });

  final MonthViewConfiguration viewConfiguration;

  final double cellWidth;

  final CalendarController<T> controller;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);

    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double cellHeight = constraints.maxHeight / 5;

          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: PageView.builder(
              key: Key(viewConfiguration.hashCode.toString()),
              controller: scope.state.pageController,
              itemCount: scope.state.numberOfPages,
              onPageChanged: (int index) {
                DateTimeRange newVisibleDateTimeRange =
                    viewConfiguration.calculateVisibleDateRangeForIndex(
                  index: index,
                  calendarStart: scope.state.adjustedDateTimeRange.start,
                  firstDayOfWeek: viewConfiguration.firstDayOfWeek,
                );

                scope.state.visibleDateTimeRange.value = newVisibleDateTimeRange;
                controller.selectedDate = newVisibleDateTimeRange.start;
              },
              itemBuilder: (BuildContext context, int index) {
                DateTimeRange visibleDateRange =
                    viewConfiguration.calculateVisibleDateRangeForIndex(
                  calendarStart: scope.state.adjustedDateTimeRange.start,
                  index: index,
                  firstDayOfWeek: viewConfiguration.firstDayOfWeek,
                );

                log(visibleDateRange.toString());

                return Stack(
                  children: <Widget>[
                    MonthGrid(
                      pageHeight: constraints.maxHeight,
                      cellHeight: cellHeight,
                      cellWidth: cellWidth,
                    ),
                    MonthCells<T>(
                      cellHeight: cellHeight,
                      cellWidth: cellWidth,
                      pageWidth: constraints.maxWidth,
                      visibleDateRange: visibleDateRange,
                    )
                  ],
                );

                // return GridView.builder(
                //   physics: const ClampingScrollPhysics(),
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 7,
                //     childAspectRatio: cellWidth / cellHeight,
                //   ),
                //   itemCount: 42,
                //   padding: EdgeInsets.zero,
                //   itemBuilder: (BuildContext context, int index) {
                //     DateTime date = visibleDateRange.start.add(Duration(days: index));
                //     return MonthCell(
                //       child: Column(
                //         children: <Widget>[
                //           DateIconButton(
                //             date: date,
                //             onTapped: (DateTime date) => scope.functions.onDateTapped?.call(date),
                //             visualDensity: VisualDensity.compact,
                //           ),
                //           Expanded(
                //             child: MonthCellStack<T>(
                //               viewConfiguration: viewConfiguration,
                //               date: date,
                //               cellHeight: cellHeight,
                //               cellWidth: cellWidth,
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // );
              },
            ),
          );
        },
      ),
    );
  }
}
