import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';

class CustomMultiDayConfiguration extends MultiDayViewConfiguration {
  CustomMultiDayConfiguration({
    required this.name,
    super.numberOfDays = 3,
    super.timelineWidth = 56,
    super.daySeparatorLeftOffset = 8,
    super.multiDayTileHeight = 24,
    super.paintWeekNumber = true,
    super.eventSnapping = false,
    super.timeIndicatorSnapping = false,
    super.createEvents = true,
    super.createMultiDayEvents = true,
    super.verticalStepDuration = const Duration(minutes: 15),
    super.verticalSnapRange = const Duration(minutes: 15),
    super.horizontalStepDuration = const Duration(days: 1),
    super.newEventDuration = const Duration(minutes: 15),
    super.enableRescheduling = true,
    super.enableResizing = true,
    super.startHour = 0,
    super.endHour = 24,
    super.useLongPressForCreateEvent = false,
  });

  @override
  final String name;

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    return getMultiDayRange(date);
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
    int? firstDayOfWeek,
  }) {
    return DateTimeRange(
      start: visibleStart.startOfDay.subtract(
        Duration(
          days: (visibleStart.difference(dateTimeRange.start).inDays ~/
                      numberOfDays)
                  .ceil() *
              numberOfDays,
        ),
      ),
      end: visibleStart.startOfDay.add(
        Duration(
          days: (dateTimeRange.end.difference(visibleStart).inDays ~/
                      numberOfDays)
                  .ceil() *
              numberOfDays,
        ),
      ),
    );
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    return date.difference(startDate).inDays ~/ numberOfDays;
  }

  @override
  int calculateNumberOfPages(DateTimeRange calendarDateTimeRange) {
    return calendarDateTimeRange.dayDifference ~/ numberOfDays;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
    int? firstDayOfWeek,
  }) {
    return getMultiDayRange(
      DateTime(
        calendarStart.year,
        calendarStart.month,
        calendarStart.day + (index * numberOfDays),
      ),
    );
  }

  /// Gets the four day range with the [DateTime] as the first day.
  DateTimeRange getMultiDayRange(DateTime date) {
    return DateTimeRange(
      start: date.startOfDay,
      end: date.endOfDay.add(
        Duration(days: numberOfDays - 1),
      ),
    );
  }
}
