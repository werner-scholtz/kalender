import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/material_header.dart';
import 'package:kalender/src/components/tile_stacks/multi_day_tile_stack.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_internals.dart';
import 'package:kalender/src/models/view_configurations/single_day_configurations/single_day_view_configuration.dart';

class SingleDayHeader<T extends Object?> extends StatelessWidget {
  const SingleDayHeader({
    super.key,
    required this.dayWidth,
    required this.viewConfiguration,
  });

  final double dayWidth;
  final SingleDayViewConfiguration viewConfiguration;

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: viewConfiguration.timelineWidth,
                        child: internalData.components.dayHeaderBuilder(
                          visibleDateTimeRange.start,
                          null,
                        ),
                      ),
                    ],
                  ),
                  PositionedMultiDayTileStack<T>(
                    pageWidth: dayWidth,
                    dayWidth: dayWidth,
                    multiDayEventLayout: MultiDayLayoutController<T>(
                      dayWidth: dayWidth,
                      visibleDateRange: visibleDateTimeRange,
                      tileHeight: viewConfiguration.multidayTileHeight,
                      isMobileDevice: internalData.configuration.isMobileDevice,
                      isMultidayView: false,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
