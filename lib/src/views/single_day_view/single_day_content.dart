import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/time_indicator.dart';
import 'package:kalender/src/components/gesture_detectors/day_gesture_detector.dart';
import 'package:kalender/src/components/tile_stacks/chaning_tile_stack.dart';
import 'package:kalender/src/components/tile_stacks/positioned_tile_stack.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_components.dart';
import 'package:kalender/src/models/calendar/calendar_configuration.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/calendar/calendar_state.dart';
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
    CalendarInternals<T> internals = CalendarInternals.of<T>(context);
    CalendarComponents<T> components = internals.components;
    CalendarFunctions<T> functions = internals.functions;
    CalendarViewState state = internals.state;
    CalendarConfiguration configuration = internals.configuration;

    return ValueListenableBuilder<double>(
      valueListenable: state.heightPerMinute,
      builder: (BuildContext context, double heightPerMinute, Widget? child) {
        double hourHeight = heightPerMinute * minutesAnHour;
        double pageHeight = hourHeight * hoursADay;
        double pageWidth = dayWidth + viewConfiguration.hourlineTimelineOverlap;
        double verticalStep = heightPerMinute * viewConfiguration.verticalDurationStep.inMinutes;

        return Expanded(
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
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

                        TileLayoutController<T> tileLayoutController = TileLayoutController<T>(
                          visibleDateRange: pageVisibleDateRange,
                          heightPerMinute: heightPerMinute,
                          dayWidth: dayWidth,
                          verticalDurationStep: const Duration(minutes: 15),
                          leftPageOffset: 0,
                        );

                        return Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: pageWidth,
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
                                width: dayWidth,
                                height: pageHeight,
                                child: components.daySepratorBuilder(
                                  pageHeight,
                                  dayWidth,
                                  pageVisibleDateRange.dayDifference,
                                ),
                              ),
                            ),
                            DayGestureDetector<T>(
                              controller: internals.controller,
                              height: pageHeight,
                              dayWidth: dayWidth,
                              heightPerMinute: heightPerMinute,
                              visibleDateRange: pageVisibleDateRange,
                              minuteSlotSize: viewConfiguration.minuteSlotSize,
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
                                  verticalDurationStep: viewConfiguration.verticalDurationStep,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: dayWidth,
                                height: pageHeight,
                                child: ChangingTileStack<T>(
                                  tileLayoutController: tileLayoutController,
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
