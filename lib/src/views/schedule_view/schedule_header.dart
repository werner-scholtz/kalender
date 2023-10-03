import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/general/material_header/material_header.dart';
import 'package:kalender/src/models/calendar/calendar_view_state.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class ScheduleHeader<T> extends StatelessWidget {
  const ScheduleHeader({
    super.key,
    required this.viewConfiguration,
    required this.viewState,
  });

  final ScheduleViewConfiguration viewConfiguration;
  final ScheduleViewState viewState;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    return CalendarHeaderBackground(
      child: ValueListenableBuilder<DateTimeRange>(
        valueListenable: viewState.visibleDateTimeRangeNotifier,
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
