import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/general/material_header/material_header.dart';
import 'package:kalender/src/models/calendar/view_state/schedule_view_state.dart';
import 'package:kalender/src/providers/calendar_style.dart';

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
    final components = CalendarStyleProvider.of(context).components;

    return CalendarHeaderBackground(
      child: ValueListenableBuilder<DateTimeRange>(
        valueListenable: viewState.visibleDateTimeRangeNotifier,
        builder: (context, visibleDateTimeRange, child) {
          return Column(
            children: <Widget>[
              RepaintBoundary(
                child: components.calendarHeaderBuilder?.call(
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
