import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/material_header.dart';
import 'package:kalender/src/components/tile_stacks/multi_day_tile_stack.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_tile_layout_controller.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

class MultiDayHeader<T extends Object?> extends StatelessWidget {
  const MultiDayHeader({
    super.key,
    required this.viewConfiguration,
    required this.pageWidth,
    required this.dayWidth,
  });

  final MultiDayViewConfiguration viewConfiguration;
  final double pageWidth;
  final double dayWidth;

  @override
  Widget build(BuildContext context) {
    CalendarInternals<T> internalData = CalendarInternals.of<T>(context);

    return CalendarHeaderBackground(
      child: ValueListenableBuilder<DateTimeRange>(
        valueListenable: CalendarInternals.of<T>(context).state.visibleDateRange,
        builder: (BuildContext context, DateTimeRange visibleDateTimeRange, Widget? child) {
          return Column(
            children: <Widget>[
              RepaintBoundary(
                child: internalData.components.calendarHeaderBuilder(
                  visibleDateTimeRange,
                  viewConfiguration,
                  internalData.configuration.viewConfigurations,
                  internalData.functions.onConfigurationChanged,
                  internalData.functions.onDateSelectorPressed,
                  internalData.functions.onLeftArrowPressed,
                  internalData.functions.onRightArrowPressed,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: viewConfiguration.timelineWidth,
                        child: Center(
                          child: viewConfiguration.paintWeekNumber
                              ? CalendarInternals.of<T>(context)
                                  .components
                                  .weekNumberBuilder(visibleDateTimeRange)
                              : null,
                        ),
                      ),
                      ...List<Widget>.generate(
                        visibleDateTimeRange.duration.inDays,
                        (int index) => SizedBox(
                          width: dayWidth,
                          child: CalendarInternals.of<T>(context).components.dayHeaderBuilder(
                                visibleDateTimeRange.start.add(Duration(days: index)),
                                (DateTime date) => CalendarInternals.of<T>(context)
                                    .functions
                                    .onDateTapped
                                    ?.call(date),
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AnimatedSize(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: viewConfiguration.timelineWidth,
                    ),
                    PositionedMultiDayTileStack<T>(
                      pageWidth: pageWidth,
                      dayWidth: dayWidth,
                      multiDayEventLayout: MultiDayLayoutController<T>(
                        dayWidth: dayWidth,
                        visibleDateRange: visibleDateTimeRange,
                        tileHeight: viewConfiguration.multidayTileHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
