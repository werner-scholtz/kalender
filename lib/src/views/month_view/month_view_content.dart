import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/month_cells/month_cells.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class MonthViewContent<T> extends StatelessWidget {
  const MonthViewContent({
    super.key,
    required this.viewConfiguration,
    required this.controller,
    required this.cellWidth,
  });

  final MonthViewConfiguration viewConfiguration;
  final CalendarController<T> controller;
  final double cellWidth;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellHeight = constraints.maxHeight / 5;

          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: PageView.builder(
              key: Key(viewConfiguration.hashCode.toString()),
              controller: scope.state.pageController,
              itemCount: scope.state.numberOfPages,
              onPageChanged: (index) {
                final newVisibleDateTimeRange =
                    viewConfiguration.calculateVisibleDateRangeForIndex(
                  index: index,
                  calendarStart: scope.state.adjustedDateTimeRange.start,
                );

                // Update the visible date range.
                scope.state.visibleDateTimeRange = newVisibleDateTimeRange;

                // Update the selected date.
                controller.selectedDate = newVisibleDateTimeRange.start;

                // Call the onPageChanged function.
                scope.functions.onPageChanged?.call(
                  newVisibleDateTimeRange,
                );
              },
              itemBuilder: (context, index) {
                final visibleDateRange =
                    viewConfiguration.calculateVisibleDateRangeForIndex(
                  index: index,
                  calendarStart: scope.state.adjustedDateTimeRange.start,
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
                    ),
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
