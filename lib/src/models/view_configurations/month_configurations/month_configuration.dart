import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';

class MonthConfiguration extends MonthViewConfiguration {
  MonthConfiguration({
    this.name = 'Month',
    super.firstDayOfWeek = 1,
    super.enableResizing = true,
    super.enableRescheduling = true,
    super.createMultiDayEvents = true,
    super.multiDayTileHeight = 24,
    super.verticalStepDuration = const Duration(days: 7),
    super.horizontalStepDuration = const Duration(days: 1),
    super.showHeader,
    super.createEventTrigger,
  });

  @override
  final String name;

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    final monthRange = date.monthRange;
    return DateTimeRange(
      start: monthRange.start.startOfWeekWithOffset(firstDayOfWeek),
      end: monthRange.end.endOfWeekWithOffset(firstDayOfWeek),
    );
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
  }) {
    final start = dateTimeRange.start.startOfMonth.startOfWeekWithOffset(
      firstDayOfWeek,
    );
    final end = dateTimeRange.end.endOfMonth.endOfWeekWithOffset(
      firstDayOfWeek,
    );
    return DateTimeRange(
      start: start,
      end: end,
    );
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    return DateTimeRange(start: startDate, end: date).monthDifference;
  }

  @override
  int calculateNumberOfPages(DateTimeRange adjustedDateTimeRange) {
    return adjustedDateTimeRange.monthDifference;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
  }) {
    final monthRange = DateTime(
      calendarStart.year,
      calendarStart.month + index,
    ).monthRange;

    return DateTimeRange(
      start: monthRange.start.startOfWeekWithOffset(firstDayOfWeek),
      end: monthRange.end.endOfWeekWithOffset(firstDayOfWeek),
    );
  }
}
