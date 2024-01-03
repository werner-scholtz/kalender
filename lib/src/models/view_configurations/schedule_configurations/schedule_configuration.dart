import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/schedule_configurations/schedule_view_configuration.dart';

class ScheduleConfiguration extends ScheduleViewConfiguration {
  ScheduleConfiguration({
    super.showHeader,
  });

  @override
  String get name => 'Schedule';

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
  }) {
    return DateTimeRange(
      start: dateTimeRange.start.startOfMonth,
      end: dateTimeRange.end.endOfMonth,
    );
  }

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    final monthRange = date.monthRange;
    return DateTimeRange(
      start: monthRange.start,
      end: monthRange.end,
    );
  }
}
