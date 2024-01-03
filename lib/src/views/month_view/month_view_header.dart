import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/material_header/material_header.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class MonthViewHeader<T> extends StatelessWidget {
  const MonthViewHeader({
    super.key,
    required this.viewConfiguration,
  });

  final MonthViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    return CalendarHeaderBackground(
      child: ValueListenableBuilder<DateTimeRange>(
        valueListenable: scope.state.visibleDateTimeRangeNotifier,
        builder: (context, value, child) {
          final calendarHeader = RepaintBoundary(
            child: scope.components.calendarHeaderBuilder?.call(
              value,
            ),
          );

          final monthHeader = Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ...List<Widget>.generate(
                7,
                (index) => scope.components.monthHeaderBuilder(
                  value.start.add(Duration(days: index)),
                ),
              ),
            ],
          );

          return Column(
            children: <Widget>[
              calendarHeader,
              if (viewConfiguration.showHeader) monthHeader,
            ],
          );
        },
      ),
    );
  }
}
