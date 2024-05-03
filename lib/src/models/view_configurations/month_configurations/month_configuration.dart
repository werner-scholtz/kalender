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

    var start = monthRange.start.startOfWeekWithOffset(firstDayOfWeek);
    if (start.isAfter(monthRange.start)) {
      start = start.subtractDays(7);
    }
    final end = start.addDays(7 * 5);

    return DateTimeRange(
      start: start,
      end: end,
    );
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
  }) {
    final start = dateTimeRange.start.startOfMonth;
    var end = dateTimeRange.end;
    if (end != end.startOfMonth) {
      end = end.endOfMonth;
    }

    return DateTimeRange(
      start: start,
      end: end,
    );
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    final index = DateTimeRange(
      start: startDate,
      end: date,
    ).monthDifference;
    return index;
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

    var start = monthRange.start.startOfWeekWithOffset(firstDayOfWeek);
    if (start.isAfter(monthRange.start)) {
      start = start.subtractDays(7);
    }
    final end = start.addDays(7 * 5);

    return DateTimeRange(
      start: start,
      end: end,
    );
  }
}
