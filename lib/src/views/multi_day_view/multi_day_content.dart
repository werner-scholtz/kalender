import 'package:flutter/material.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/view_state/multi_day_view_state.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_page_content.dart';

class MultiDayContent<T> extends StatelessWidget {
  const MultiDayContent({
    super.key,
    required this.controller,
    required this.viewConfiguration,
  });

  final CalendarController<T> controller;
  final MultiDayViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);
    final state = scope.state as MultiDayViewState;

    return ValueListenableBuilder<double>(
      valueListenable: state.heightPerMinute,
      builder: (context, heightPerMinute, child) {
        final hourHeight = heightPerMinute * minutesAnHour;
        final pageHeight = hourHeight * hoursADay;

        return scope.components.calendarZoomDetector(
          controller,
          ValueListenableBuilder<ScrollPhysics>(
            valueListenable: state.scrollPhysics,
            builder: (context, value, child) {
              final hourLine = Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: pageHeight.roundToDouble(),
                child: scope.components.hourLineBuilder(
                  hourHeight,
                ),
              );

              final pageView = Positioned.fill(
                left: viewConfiguration.timelineWidth,
                child: PageView.builder(
                  // This key is used to force the page view to rebuild when the view configuration changes.
                  key: Key(viewConfiguration.hashCode.toString()),
                  controller: state.pageController,
                  itemCount: state.numberOfPages,
                  physics: value,
                  clipBehavior: Clip.none,
                  onPageChanged: (index) {
                    // Calculate the new visible date range.
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
                    // Calculate the visible date range for the page at the given index.
                    final visibleDateRange =
                        viewConfiguration.calculateVisibleDateRangeForIndex(
                      index: index,
                      calendarStart: scope.state.adjustedDateTimeRange.start,
                    );

                    return MultiDayPageContent<T>(
                      viewConfiguration: viewConfiguration,
                      visibleDateRange: visibleDateRange,
                      controller: controller,
                      hourHeight: hourHeight,
                    );
                  },
                ),
              );

              final timeline = Positioned(
                width: viewConfiguration.timelineWidth,
                child: scope.components.timelineBuilder(
                  hourHeight,
                ),
              );

              return SingleChildScrollView(
                controller: state.scrollController,
                physics: value,
                child: SizedBox(
                  height: pageHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      hourLine,
                      pageView,
                      timeline,
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
