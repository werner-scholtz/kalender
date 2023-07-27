import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/general/material_header.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

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
                    children: [
                      SizedBox(
                        width: viewConfiguration.timelineWidth,
                        child: internalData.components.dayHeaderBuilder(
                          visibleDateTimeRange.start,
                          null,
                        ),
                      ),
                    ],
                  ),
                  // PositionedMultiDayTileStack<T>(
                  //   controller: controller,
                  //   pageWidth: pageWidth,
                  //   dayWidth: dayWidth,
                  //   multiDayEventLayout: MultiDayLayoutController<T>(
                  //     dayWidth: dayWidth,
                  //     visibleDateRange: value,
                  //     eventHeight: pageTypeConfig.multiDayEventHeight,
                  //   ),
                  // ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
