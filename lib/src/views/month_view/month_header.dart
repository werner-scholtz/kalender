import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/material_header.dart';
import 'package:kalender/src/components/general/month_header.dart';
import 'package:kalender/src/models/view_configurations/view_confiuration_export.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

class MonthViewHeader<T extends Object?> extends StatelessWidget {
  const MonthViewHeader({
    super.key,
    required this.viewConfiguration,
    required this.cellWidth,
  });

  final MonthViewConfiguration viewConfiguration;

  final double cellWidth;

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
                children: <Widget>[
                  ...List<Widget>.generate(
                    7,
                    (int index) => MonthHeader(
                      dayWidth: cellWidth,
                      date: visibleDateTimeRange.start.add(
                        Duration(days: index),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
