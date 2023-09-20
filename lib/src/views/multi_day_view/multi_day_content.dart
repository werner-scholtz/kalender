import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/day/day_gesture_detector_dep.dart';
import 'package:kalender/src/components/tile_stacks/day_tile_stack_dep.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class MultiDayContent<T> extends StatelessWidget {
  const MultiDayContent({
    super.key,
    required this.viewConfiguration,
    required this.controller,
    required this.pageWidth,
    required this.dayWidth,
  });

  final MultiDayViewConfiguration viewConfiguration;
  final CalendarController<T> controller;
  final double pageWidth;
  final double dayWidth;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    return ValueListenableBuilder<double>(
      valueListenable: scope.state.heightPerMinute!,
      builder: (context, heightPerMinute, child) {
        final hourHeight = heightPerMinute * minutesAnHour;
        final pageHeight = hourHeight * hoursADay;
        final verticalStep =
            heightPerMinute * viewConfiguration.verticalStepDuration.inMinutes;

        return Expanded(
          child: ValueListenableBuilder<ScrollPhysics>(
            valueListenable: scope.state.scrollPhysics,
            builder: (context, value, child) {
              return SingleChildScrollView(
                physics: value,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: viewConfiguration.timelineWidth,
                        child: scope.components.timelineBuilder(
                          hourHeight,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: pageHeight,
                        width: pageWidth +
                            viewConfiguration.hourLineTimelineOverlap,
                        child: PageView.builder(
                          key: Key(viewConfiguration.hashCode.toString()),
                          controller: scope.state.pageController,
                          itemCount: scope.state.numberOfPages,
                          onPageChanged: (index) {
                            final newVisibleDateTimeRange = viewConfiguration
                                .calculateVisibleDateRangeForIndex(
                              index: index,
                              calendarStart:
                                  scope.state.adjustedDateTimeRange.start,
                            );
                            // Update the visible date range.
                            scope.state.visibleDateTimeRange =
                                newVisibleDateTimeRange;

                            // Update the selected date.
                            controller.selectedDate =
                                newVisibleDateTimeRange.start;

                            // Call the onPageChanged function.
                            scope.functions.onPageChanged?.call(
                              newVisibleDateTimeRange,
                            );
                          },
                          itemBuilder: (context, index) {
                            final pageVisibleDateRange = viewConfiguration
                                .calculateVisibleDateRangeForIndex(
                              index: index,
                              calendarStart:
                                  scope.state.adjustedDateTimeRange.start,
                            );

                            final tileLayoutController =
                                scope.layoutControllers.dayTileLayoutController(
                              visibleDateRange: pageVisibleDateRange,
                              visibleDates: pageVisibleDateRange.datesSpanned,
                              heightPerMinute: heightPerMinute,
                              dayWidth: dayWidth,
                            );

                            return Stack(
                              fit: StackFit.passthrough,
                              children: <Widget>[
                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child: SizedBox(
                                //     width: pageWidth +
                                //         viewConfiguration
                                //             .hourLineTimelineOverlap,
                                //     height: pageHeight,
                                //     child: scope.components.hourLineBuilder(
                                //       pageWidth +
                                //           viewConfiguration
                                //               .hourLineTimelineOverlap,
                                //       hourHeight,
                                //     ),
                                //   ),
                                // ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: pageWidth,
                                    height: pageHeight,
                                    child: scope.components.daySeparatorBuilder(
                                        viewConfiguration.numberOfDays),
                                  ),
                                ),
                                if (scope
                                    .state.viewConfiguration.createNewEvents)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      width: pageWidth,
                                      height: pageHeight,
                                      child: DayGestureDetector<T>(
                                        height: pageHeight,
                                        width: dayWidth,
                                        heightPerMinute: heightPerMinute,
                                        visibleDateRange: pageVisibleDateRange,
                                        minuteSlotSize:
                                            viewConfiguration.newEventDuration,
                                      ),
                                    ),
                                  ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: pageWidth,
                                    height: pageHeight,
                                    child: DayTileStack<T>(
                                      pageVisibleDateRange:
                                          pageVisibleDateRange,
                                      tileLayoutController:
                                          tileLayoutController,
                                      dayWidth: dayWidth,
                                      verticalStep: verticalStep,
                                      verticalDurationStep: viewConfiguration
                                          .verticalStepDuration,
                                      horizontalStep: dayWidth,
                                      horizontalDurationStep: viewConfiguration
                                          .horizontalStepDuration,
                                      eventSnapping:
                                          viewConfiguration.eventSnapping,
                                      snapToTimeIndicator: viewConfiguration
                                          .timeIndicatorSnapping,
                                      verticalSnapRange:
                                          viewConfiguration.verticalSnapRange,
                                    ),
                                  ),
                                ),
                                if (DateTime.now()
                                    .isWithin(pageVisibleDateRange))
                                  scope.components.timeIndicatorBuilder(
                                    dayWidth,
                                    pageVisibleDateRange,
                                    heightPerMinute,
                                    viewConfiguration.hourLineTimelineOverlap,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
