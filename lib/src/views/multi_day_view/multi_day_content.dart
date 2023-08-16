import 'package:flutter/material.dart';
import 'package:kalender/src/components/gesture_detectors/day/day_gesture_detector.dart';
import 'package:kalender/src/components/tile_stacks/tile_stack.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/day_tile_layout_controller/day_tile_layout_controller.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class MultiDayContent<T> extends StatelessWidget {
  const MultiDayContent({
    super.key,
    required this.viewConfiguration,
    required this.pageWidth,
    required this.dayWidth,
    required this.controller,
  });

  final MultiDayViewConfiguration viewConfiguration;
  final double pageWidth;
  final double dayWidth;
  final CalendarController<T> controller;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);

    return ValueListenableBuilder<double>(
      valueListenable: scope.state.heightPerMinute!,
      builder: (BuildContext context, double heightPerMinute, Widget? child) {
        double hourHeight = heightPerMinute * minutesAnHour;
        double pageHeight = hourHeight * hoursADay;
        double verticalStep =
            heightPerMinute * viewConfiguration.verticalStepDuration.inMinutes;

        return Expanded(
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                scope.components.timelineBuilder(
                  viewConfiguration.timelineWidth,
                  pageHeight,
                  hourHeight,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: pageHeight,
                    width:
                        pageWidth + viewConfiguration.hourlineTimelineOverlap,
                    child: PageView.builder(
                      key: Key(viewConfiguration.hashCode.toString()),
                      controller: scope.state.pageController,
                      itemCount: scope.state.numberOfPages,
                      onPageChanged: (int index) {
                        DateTimeRange newVisibleDateTimeRange =
                            viewConfiguration.calculateVisibleDateRangeForIndex(
                          index: index,
                          calendarStart:
                              scope.state.adjustedDateTimeRange.start,
                        );
                        scope.state.visibleDateTimeRange.value =
                            newVisibleDateTimeRange;
                        controller.selectedDate = newVisibleDateTimeRange.start;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        DateTimeRange pageVisibleDateRange =
                            viewConfiguration.calculateVisibleDateRangeForIndex(
                          index: index,
                          calendarStart:
                              scope.state.adjustedDateTimeRange.start,
                        );

                        DayTileLayoutController<T> tileLayoutController =
                            scope.layoutControllers.dayTileLayoutController(
                          visibleDateRange: pageVisibleDateRange,
                          visibleDates: pageVisibleDateRange.datesSpanned,
                          heightPerMinute: heightPerMinute,
                          dayWidth: dayWidth,
                          verticalDurationStep: const Duration(minutes: 15),
                        );

                        return Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: pageWidth +
                                    viewConfiguration.hourlineTimelineOverlap,
                                height: pageHeight,
                                child: scope.components.hourlineBuilder(
                                  pageWidth +
                                      viewConfiguration.hourlineTimelineOverlap,
                                  hourHeight,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: pageWidth,
                                height: pageHeight,
                                child: scope.components.daySepratorBuilder(
                                  pageHeight,
                                  dayWidth,
                                  pageVisibleDateRange.dayDifference,
                                ),
                              ),
                            ),
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
                                  minuteSlotSize: viewConfiguration.slotSize,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: pageWidth,
                                height: pageHeight,
                                child: PositionedTileStack<T>(
                                  pageVisibleDateRange: pageVisibleDateRange,
                                  tileLayoutController: tileLayoutController,
                                  dayWidth: dayWidth,
                                  verticalStep: verticalStep,
                                  verticalDurationStep:
                                      viewConfiguration.verticalStepDuration,
                                  horizontalStep: dayWidth,
                                  horizontalDurationStep:
                                      viewConfiguration.horizontalDurationStep,
                                  eventSnapping:
                                      viewConfiguration.eventSnapping,
                                  timeIndicatorSnapping:
                                      viewConfiguration.timeIndicatorSnapping,
                                  verticalSnapRange:
                                      viewConfiguration.verticalSnapRange,
                                ),
                              ),
                            ),
                            if (DateTime.now().isWithin(pageVisibleDateRange))
                              scope.components.timeIndicatorBuilder(
                                dayWidth,
                                pageHeight,
                                pageVisibleDateRange,
                                heightPerMinute,
                                viewConfiguration.timelineWidth,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
