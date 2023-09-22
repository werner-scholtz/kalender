import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/kalender_scope.dart';
import 'package:kalender/src/components/general/material_header/material_header.dart';

class ScheduleHeader<T> extends StatelessWidget {
  const ScheduleHeader({
    super.key,
    required this.viewConfiguration,
  });

  final ScheduleViewConfiguration viewConfiguration;

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
            ],
          );
        },
      ),
    );
  }
}
