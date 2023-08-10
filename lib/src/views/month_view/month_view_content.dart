import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/month_cells.dart';
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
                );

                scope.state.visibleDateTimeRange.value =
                    newVisibleDateTimeRange;
                controller.selectedDate = newVisibleDateTimeRange.start;
              },
              itemBuilder: (BuildContext context, int index) {
                DateTimeRange visibleDateRange =
                    viewConfiguration.calculateVisibleDateRangeForIndex(
                  calendarStart: scope.state.adjustedDateTimeRange.start,
                  index: index,
                );

                return Stack(
                  children: <Widget>[
                    scope.components.monthGridBuilder(
                      constraints.maxHeight,
                      cellHeight,
                      cellWidth,
                    ),
                    MonthCells<T>(
                      cellHeight: cellHeight,
                      cellWidth: cellWidth,
                      pageWidth: constraints.maxWidth,
                      visibleDateRange: visibleDateRange,
                      viewConfiguration: viewConfiguration,
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
