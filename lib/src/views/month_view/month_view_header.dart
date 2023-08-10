import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/material_header.dart';
import 'package:kalender/src/models/view_configurations/view_confiuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class MonthViewHeader<T> extends StatelessWidget {
  const MonthViewHeader({
    super.key,
    required this.viewConfiguration,
    required this.cellWidth,
  });

  final MonthViewConfiguration viewConfiguration;

  final double cellWidth;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);

    return CalendarHeaderBackground(
      child: ValueListenableBuilder<DateTimeRange>(
        valueListenable: scope.state.visibleDateTimeRange,
        builder: (BuildContext context, DateTimeRange visibleDateTimeRange,
            Widget? child) {
          return Column(
            children: <Widget>[
              RepaintBoundary(
                child: scope.components.calendarHeaderBuilder?.call(
                  visibleDateTimeRange,
                ),
              ),
              Row(
                children: <Widget>[
                  ...List<Widget>.generate(
                    7,
                    (int index) => scope.components.monthHeaderBuilder(
                      cellWidth,
                      visibleDateTimeRange.start.add(Duration(days: index)),
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
