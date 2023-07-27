import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/time_indicator.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar_components.dart';
import 'package:kalender/src/models/calendar_configuration.dart';
import 'package:kalender/src/models/calendar_functions.dart';
import 'package:kalender/src/models/calendar_state.dart';
import 'package:kalender/src/models/tile_layout_controllers/tile_layout_controller.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

class SingleDayContent<T extends Object?> extends StatelessWidget {
  const SingleDayContent({
    super.key,
    required this.dayWidth,
    required this.viewConfiguration,
  });
  final double dayWidth;
  final SingleDayViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    CalendarInternals<T> internalData = CalendarInternals.of<T>(context);
    CalendarComponents<T> components = internalData.components;
    CalendarFunctions<T> functions = internalData.functions;
    CalendarViewState state = internalData.state;
    CalendarConfiguration configuration = internalData.configuration;

    return ValueListenableBuilder<double>(
      valueListenable: state.heightPerMinute,
      builder: (BuildContext context, double heightPerMinute, Widget? child) {
        double hourHeight = heightPerMinute * minutesAnHour;
        double pageHeight = hourHeight * hoursADay;
        double pageWidth = dayWidth + viewConfiguration.hourlineTimelineOverlap;

        return Expanded(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                components.timelineBuilder(
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
                      key: Key(viewConfiguration.name),
                      controller: state.pageController,
                      itemCount: state.numberOfPages,
                      onPageChanged: functions.onPageChanged,
                      itemBuilder: (BuildContext context, int index) {
                        DateTimeRange pageVisibleDateRange =
                            viewConfiguration.calculateVisibleDateRangeForIndex(
                          index,
                          state.dateTimeRange.start,
                          configuration.firstDayOfWeek,
                        );

                        TileLayoutController<T> tileLayoutController = TileLayoutController(
                          visibleDateRange: pageVisibleDateRange,
                          heightPerMinute: heightPerMinute,
                          dayWidth: dayWidth,
                          verticalDurationStep: const Duration(minutes: 15),
                          leftPageOffset: 0,
                        );

                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: dayWidth + viewConfiguration.hourlineTimelineOverlap,
                                height: pageHeight,
                                child: components.hourlineBuilder(
                                  pageWidth,
                                  hourHeight,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: pageWidth,
                                height: pageHeight,
                                child: components.daySepratorBuilder(
                                  pageHeight,
                                  dayWidth,
                                  pageVisibleDateRange.dayDifference,
                                ),
                              ),
                            ),
                            // DayGestureDetector(
                            //   controller: controller,
                            //   heightPerMinute: heightPerMinuteValue,
                            //   pageWidth: pageWidth,
                            //   height: pageHeight,
                            //   dayWidth: dayWidth,
                            //   minuteSlotSize: pageTypeConfig.minuteSlotSize,
                            //   visibleDateRange: pageVisibleDateRange,
                            // ),
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: SizedBox(
                            //     width: pageWidth,
                            //     height: pageHeight,
                            //     child: PositionedTileStack<T>(
                            //       controller: controller,
                            //       tileLayoutController: tileLayoutController,
                            //       dayPageContentConfiguration: PositionedTileStackConfiguration(
                            //         visibleDateRange: pageVisibleDateRange,
                            //         dayWidth: dayWidth,
                            //         heightPerMinute: heightPerMinuteValue,
                            //         verticalDurationStep: pageTypeConfig.verticalDurationStep,
                            //         horizontalDurationStep: pageTypeConfig.horizontalDurationStep,
                            //         horizontalStep: dayWidth,
                            //         eventSnapping: pageTypeConfig.eventSnapping,
                            //         timeIndicatorSnapping: pageTypeConfig.timeIndicatorSnapping,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: SizedBox(
                            //     width: pageWidth,
                            //     height: pageHeight,
                            //     child: ChangingEventStack(
                            //       controller: controller,
                            //       tileLayoutController: tileLayoutController,
                            //     ),
                            //   ),
                            // ),
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
