import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/view_state/month_view_state.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/views/month_view/month_view_page_content.dart';

class MonthViewContent<T> extends StatelessWidget {
  const MonthViewContent({
    super.key,
    required this.viewConfiguration,
    required this.controller,
  });

  final MonthViewConfiguration viewConfiguration;
  final CalendarController<T> controller;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);
    final state = scope.state as MonthViewState;

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalStep = constraints.maxWidth / 7;
          final verticalStep = constraints.maxHeight / 5;

          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: PageView.builder(
              key: Key(viewConfiguration.hashCode.toString()),
              controller: state.pageController,
              itemCount: state.numberOfPages,
              onPageChanged: (index) {
                final newVisibleDateTimeRange =
                    viewConfiguration.calculateVisibleDateRangeForIndex(
                  index: index,
                  calendarStart: scope.state.adjustedDateTimeRange.start,
                );

                // Update the visible date range.
                scope.state.visibleDateTimeRange = newVisibleDateTimeRange;

                // Update the selected date.
                controller.selectedDate =
                    newVisibleDateTimeRange.centerDateTime;

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

                return MonthViewPageContent<T>(
                  viewConfiguration: viewConfiguration,
                  visibleDateRange: visibleDateRange,
                  horizontalStep: horizontalStep,
                  verticalStep: verticalStep,
                  controller: controller,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
