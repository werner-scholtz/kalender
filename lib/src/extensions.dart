import 'package:flutter/material.dart';

extension DateTimeRangeExtensions on DateTimeRange {
  /// The difference in days between the [start] and [end] of the [DateTimeRange].
  ///
  /// - Converts the start and end to utc before calculation.
  int get dayDifference {
    final startDate = start.toUtc();
    final endDate = end.toUtc();
    final difference = endDate.difference(startDate).inDays;
    return difference;
  }

  /// The month difference between the [start] and [end] of the [DateTimeRange].
  int get monthDifference {
    var months = ((start.year - end.year).abs() - 1) * 12;
    months += end.month + (12 - start.month);
    return months;
  }

  /// Returns a new [DateTimeRange] with the [start] and [end] offset by the given [duration].
  DateTimeRange rescheduleDateTime(Duration duration) {
    return DateTimeRange(start: start.add(duration), end: end.add(duration));
  }

  /// A list of [DateTime]s that the [DateTimeRange] spans.
  ///
  /// Includes the [start] date.
  /// Includes the [end] date only if it is not the start of the day. (after 00:00:00)
  List<DateTime> get datesSpanned {
    // Check if the start and end is equal.
    if (start == end) return [start.startOfDay];

    final localStartOfDate = start.startOfDay;
    final utcStartOfDate = localStartOfDate.toUtc();

    final localEndOfDate = end.startOfDay;
    // Check if the local end date is the startOfDay.
    final isLocalEndOfDateStartOfDay = localEndOfDate.toUtc() == end.toUtc();

    // If the localEndDate is the startOfDay
    //   Use the localEndOfDate in utc.
    // else
    //   Use the localEndOfDate endOfDay in utc.
    final utcEndOfDate = isLocalEndOfDateStartOfDay
        ? localEndOfDate.toUtc()
        : localEndOfDate.endOfDay.toUtc();

    // Calculate the dayDifference.
    final dayDifference = utcEndOfDate.difference(utcStartOfDate).inDays;

    final dates = <DateTime>[];
    for (var i = 0; i < dayDifference; i++) {
      dates.add(localStartOfDate.add(Duration(days: i)));
    }

    return dates;
  }

  /// The [DateTimeRange] of the [CalendarEvent] on a specific date.
  DateTimeRange dateTimeRangeOnDate(DateTime date) {
    if (start.isSameDay(end)) {
      // The start and end are on same day.
      return this;
    } else {
      if (date.isSameDay(start)) {
        // The date is the same as the start.
        return DateTimeRange(start: start, end: start.endOfDay);
      } else if (date.isSameDay(end)) {
        // The date is the same as the end.
        return DateTimeRange(start: end.startOfDay, end: end);
      } else {
        // The date is between the start and end.
        return DateTimeRange(
          start: date.startOfDay,
          end: date.endOfDay,
        );
      }
    }
  }
}

extension DateTimeExtensions on DateTime {
  /// Checks if the [DateTime] is within the [DateTimeRange].
  bool isWithin(DateTimeRange dateTimeRange) {
    return isAfter(dateTimeRange.start) && isBefore(dateTimeRange.end);
  }

  /// Checks if the [DateTime] is the same day as the calling object.
  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  /// Check if the [DateTime] is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Gets the start of the date.
  ///
  /// * DateTime(year, month, day)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Gets the end of the date.
  ///
  /// * DateTime(year, month, day + 1)
  /// * Same as the start of next day
  DateTime get endOfDay => DateTime(year, month, day + 1);

  /// Gets the day range in which the [DateTime] is in.
  DateTimeRange get dayRange => DateTimeRange(start: startOfDay, end: endOfDay);

  /// Gets the year range in which the [DateTime] is in.
  DateTimeRange get yearRange {
    return DateTimeRange(
      start: DateTime(year, 1, 1),
      end: DateTime(year + 1, 1, 1),
    );
  }

  /// Add specific amount of [days] (ignoring DST)
  DateTime addDays(int days) {
    return DateTime(
      year,
      month,
      day + days,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// Subtract specific amount of [days] (ignoring DST)
  DateTime subtractDays(int days) {
    return addDays(-days);
  }

  /// Get the start of the week with an offset.
  DateTime startOfWeekWithOffset(int firstDayOfWeek) {
    assert(
      firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
      'firstDayOfWeek must be between 1 and 7',
    );

    return subtractDays(weekday - firstDayOfWeek).startOfDay;
  }

  /// Gets the end of the week with an offset.
  DateTime endOfWeekWithOffset(int firstDayOfWeek) {
    return startOfWeekWithOffset(firstDayOfWeek).addDays(7).startOfDay;
  }

  /// Find a [DateTimeRange] spanning 7 days that contains this date.
  ///
  /// Starting on the [firstDayOfWeek]
  DateTimeRange weekRangeWithOffset(int firstDayOfWeek) {
    var startOfWeek = subtractDays(weekday - firstDayOfWeek).startOfDay;
    if (startOfWeek.isAfter(this)) {
      startOfWeek = startOfWeek.subtractDays(7);
    }

    return DateTimeRange(
      start: startOfWeek,
      end: startOfWeek.addDays(7),
    );
  }

  /// Returns a [DateTimeRange] with the [DateTime] as the start that spans the given number of days.
  DateTimeRange multiDayDateTimeRange(int numberOfDays) {
    return DateTimeRange(
      start: startOfDay,
      end: endOfDay.addDays(numberOfDays - 1),
    );
  }
}

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, hour, minute);
  }
}
