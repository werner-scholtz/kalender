import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/schedule_configurations/schedule_view_configuration.dart';

class ScheduleConfiguration extends ScheduleViewConfiguration {
  ScheduleConfiguration({
    this.showHeader = true,
  });

  @override
  String get name => 'Schedule';

  @override
  bool showHeader;

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
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
