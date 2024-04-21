import 'package:flutter/material.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/view_state/multi_day_view_state.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/providers/calendar_style.dart';
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
    final components = CalendarStyleProvider.of(context).components;

    final state = scope.state as MultiDayViewState;

    return ValueListenableBuilder<double>(
      valueListenable: state.heightPerMinute,
      builder: (context, heightPerMinute, child) {
        final hourHeight = heightPerMinute * minutesAnHour;
        final pageHeight = hourHeight * hoursADay;

        state.pageHeight = pageHeight;

        // The height of the content after clipping.
        final clippedHeight = (viewConfiguration.endHour * hourHeight) -
            viewConfiguration.startHour * hourHeight;

        return components.calendarZoomDetector(
          controller,
          ValueListenableBuilder<ScrollPhysics>(
            valueListenable: state.scrollPhysics,
            builder: (context, value, child) {
              final hourLine = Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: pageHeight.roundToDouble(),
                child: components.hourLineBuilder(
                  hourHeight,
                  viewConfiguration.hourLineLeftMargin,
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
                top: 0,
                height: pageHeight.roundToDouble(),
                width: viewConfiguration.timelineWidth,
                child: components.timelineBuilder(
                  hourHeight,
                  viewConfiguration.startHour,
                  viewConfiguration.endHour,
                ),
              );

              return SingleChildScrollView(
                controller: state.scrollController,
                physics: value,
                child: ClipRect(
                  child: SizedBox(
                    height: clippedHeight,
                    child: Stack(
                      children: [
                        Positioned(
                          top: -viewConfiguration.startHour * hourHeight,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: (viewConfiguration.endHour) * hourHeight,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                hourLine,
                                pageView,
                                timeline,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
