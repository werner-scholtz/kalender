import 'package:flutter/material.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// This is the base class for all [ScheduleViewConfiguration]s.
abstract class ScheduleViewConfiguration extends ViewConfiguration {
  ScheduleViewConfiguration({
    this.showHeader = true,
  });

  @override
  bool showHeader;

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    throw UnimplementedError();
  }

  @override
  int calculateNumberOfPages(DateTimeRange calendarDateTimeRange) {
    throw UnimplementedError();
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
  }) {
    throw UnimplementedError();
  }
}
