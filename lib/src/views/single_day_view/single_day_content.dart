import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/time_indicator.dart';
import 'package:kalender/src/components/gesture_detectors/day_gesture_detector.dart';
import 'package:kalender/src/components/tile_stacks/tile_stack.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/tile_layout_controller.dart';
import 'package:kalender/src/models/view_configurations/view_confiuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class SingleDayContent<T> extends StatelessWidget {
  const SingleDayContent({
    super.key,
    required this.dayWidth,
    required this.viewConfiguration,
    required this.controller,
  });

  final double dayWidth;
  final SingleDayViewConfiguration viewConfiguration;
  final CalendarController<T> controller;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of<T>(context);

    return ValueListenableBuilder<double>(
      valueListenable: scope.state.heightPerMinute!,
      builder: (BuildContext context, double heightPerMinute, Widget? child) {
        double hourHeight = heightPerMinute * minutesAnHour;
        double pageHeight = hourHeight * hoursADay;
        double pageWidth = dayWidth + viewConfiguration.hourlineTimelineOverlap;
        double verticalStep = heightPerMinute * viewConfiguration.slotSize.minutes;

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
                    width: pageWidth,
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

                        scope.state.visibleDateTimeRange.value = newVisibleDateTimeRange;
                        controller.selectedDate = newVisibleDateTimeRange.start;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        DateTimeRange pageVisibleDateRange =
                            viewConfiguration.calculateVisibleDateRangeForIndex(
                          index: index,
                          calendarStart: scope.state.adjustedDateTimeRange.start,
                        );

                        TileLayoutController<T> tileLayoutController = TileLayoutController<T>(
                          visibleDateRange: pageVisibleDateRange,
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
                                width: pageWidth,
                                height: pageHeight,
                                child: scope.components.hourlineBuilder(
                                  pageWidth,
                                  hourHeight,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: dayWidth,
                                height: pageHeight,
                                child: scope.components.daySepratorBuilder(
                                  pageHeight,
                                  dayWidth,
                                  pageVisibleDateRange.dayDifference,
                                ),
                              ),
                            ),
                            DayGestureDetector<T>(
                              height: pageHeight,
                              width: dayWidth,
                              heightPerMinute: heightPerMinute,
                              visibleDateRange: pageVisibleDateRange,
                              minuteSlotSize: viewConfiguration.slotSize,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: dayWidth,
                                height: pageHeight,
                                child: PositionedTileStack<T>(
                                  pageVisibleDateRange: pageVisibleDateRange,
                                  tileLayoutController: tileLayoutController,
                                  dayWidth: dayWidth,
                                  verticalStep: verticalStep,
                                  verticalDurationStep: viewConfiguration.slotSize.duration,
                                  eventSnapping: viewConfiguration.eventSnapping,
                                  timeIndicatorSnapping: viewConfiguration.timeIndicatorSnapping,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: DateTime.now().isWithin(pageVisibleDateRange),
                              child: TimeIndicator(
                                width: dayWidth,
                                height: pageHeight,
                                visibleDateRange: pageVisibleDateRange,
                                heightPerMinute: heightPerMinute,
                              ),
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
