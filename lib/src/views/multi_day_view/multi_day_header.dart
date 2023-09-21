import 'package:flutter/material.dart';
import 'package:kalender/kalendar_scope.dart';
import 'package:kalender/src/components/event_groups/multi_day_event_group_widget.dart';
import 'package:kalender/src/components/general/material_header/material_header.dart';
import 'package:kalender/src/models/event_group_controllers/multi_day_event_group_controller.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class MultiDayHeader<T> extends StatelessWidget {
  const MultiDayHeader({
    super.key,
    required this.viewConfiguration,
  });

  final MultiDayViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    return CalendarHeaderBackground(
      child: ValueListenableBuilder<DateTimeRange>(
        valueListenable: scope.state.visibleDateTimeRangeNotifier,
        builder: (context, visibleDateTimeRange, child) {
          return Column(
            children: <Widget>[
              RepaintBoundary(
                child: scope.components.calendarHeaderBuilder?.call(
                  visibleDateTimeRange,
                ),
              ),

              if (viewConfiguration.numberOfDays == 1)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: viewConfiguration.timelineWidth,
                          child: scope.components.dayHeaderBuilder(
                            visibleDateTimeRange.start,
                            null,
                          ),
                        ),
                      ],
                    ),

                    // MultiDayTileStack<T>(
                    //   pageWidth: dayWidth,
                    //   dayWidth: dayWidth,
                    //   multiDayEventLayout:
                    //       scope.layoutControllers.multiDayTileLayoutController(
                    //     dayWidth: dayWidth,
                    //     visibleDateRange: visibleDateTimeRange,
                    //     tileHeight: viewConfiguration.multidayTileHeight,
                    //   ),
                    // ),
                  ],
                )
              else
                Row(
                  children: [
                    SizedBox(
                      width: viewConfiguration.timelineWidth,
                      child: Center(
                        child: viewConfiguration.paintWeekNumber
                            ? scope.components
                                .weekNumberBuilder(visibleDateTimeRange)
                            : null,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ...List.generate(
                                viewConfiguration.numberOfDays,
                                (index) => scope.components.dayHeaderBuilder(
                                  visibleDateTimeRange.start
                                      .add(Duration(days: index)),
                                  (date) =>
                                      scope.functions.onDateTapped?.call(date),
                                ),
                              ),
                            ],
                          ),
                          ListenableBuilder(
                            listenable: scope.eventsController,
                            builder: (context, child) {
                              final events = scope.eventsController
                                  .getMultiDayEventsFromDateRange(
                                scope.state.visibleDateTimeRangeNotifier.value,
                              );

                              final multiDayEventGroup =
                                  MultiDayEventGroupController<T>()
                                      .generateMultiDayEventGroup(
                                events: events,
                              );

                              return MultiDayEventGroupWidget<T>(
                                multiDayEventGroup: multiDayEventGroup,
                                visibleDateRange: visibleDateTimeRange,
                                isChanging: false,
                                multiDayTileHeight:
                                    viewConfiguration.multiDayTileHeight,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              // AnimatedSize(
              //   curve: Curves.easeIn,
              //   duration: const Duration(milliseconds: 200),
              //   child: Row(
              //     children: <Widget>[
              //       SizedBox(
              //         width: viewConfiguration.timelineWidth,
              //       ),
              //       MultiDayTileStack<T>(
              //         pageWidth: pageWidth,
              //         dayWidth: dayWidth,
              //         multiDayEventLayout:
              //             scope.layoutControllers.multiDayTileLayoutController(
              //           dayWidth: dayWidth,
              //           visibleDateRange: visibleDateTimeRange,
              //           tileHeight: viewConfiguration.multidayTileHeight,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
