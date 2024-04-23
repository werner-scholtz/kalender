import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// [DateTimeRange] extensions.
extension DateTimeRangeExtensions on DateTimeRange {
  /// The difference of days between the [start] and [end] of the [DateTimeRange].
  int get dayDifference {
    final startDate = start.toUtc();
    final endDate = end.toUtc();

    final difference = startDate.difference(endDate).inDays.abs();

    return difference;
  }

  /// The difference of months between the [start] and [end] of the [DateTimeRange].
  int get monthDifference {
    var months = ((start.year - end.year).abs() - 1) * 12;
    months += end.month + (12 - start.month);
    return months;
  }

  /// A list of [DateTime]s that the [DateTimeRange] spans.
  List<DateTime> get datesSpanned {
    final start = this.start.toUtc();
    final end = this.end.toUtc();

    final utcDates = <DateTime>[start.toUtc()];
    final dates = <DateTime>[this.start.startOfDay];

    while (utcDates.last.isBefore(end)) {
      final newDate = utcDates.last.add(const Duration(days: 1));
      if (newDate.isBefore(end)) {
        utcDates.add(newDate);
        dates.add(newDate.toLocal().startOfDay);
      } else {
        break;
      }
    }

    return dates;
  }

  /// The number of years spanned by the [DateTimeRange].
  int get numberOfYears => end.year - start.year;

  /// Returns a new [DateTimeRange] with the start and end dates offset by the given [duration].
  DateTimeRange rescheduleDateTime(Duration duration) {
    return DateTimeRange(start: start.add(duration), end: end.add(duration));
  }

  /// The center [DateTime] of the [DateTimeRange].
  DateTime get centerDateTime =>
      start.add(Duration(days: (dayDifference / 2).floor()));

  /// The visible month of the [DateTimeRange].
  DateTime get visibleMonth {
    return DateTime(centerDateTime.year, centerDateTime.month);
  }

  /// Checks if the [DateTimeRange] overlaps with another [DateTimeRange].
  bool overlaps(DateTimeRange other) {
    return start.isBefore(other.end) && end.isAfter(other.start);
  }

  /// Returns the weekNumber(s) that the [DateTimeRange] spans.
  (int weekNumber, int? secondWeekNumber) get weekNumbers {
    if (start.year != end.year) {
      // When changing years we show both.
      return (start.weekNumber, end.weekNumber);
    }

    final datesSpanned = this.datesSpanned;

    final isSingleWeek = datesSpanned.length <= 7;
    final spansOneWeek = isSingleWeek &&
        (start.weekday == 1 || start.weekday == 6 || start.weekday == 7);

    if (!spansOneWeek) {
      // When its spans multiple weeks show both.
      return (start.weekNumber, end.weekNumber);
    } else {
      final dateToUse = datesSpanned.firstWhere(
        (date) => date.weekday == 1, // Find the first monday.
        orElse: () => start, // If there is not a monday use the start.
      );

      return (dateToUse.weekNumber, null);
    }
  }
}

/// [DateTime] extensions.
extension DateTimeExtensions on DateTime {
  /// Gets the start of the day.
  DateTime get startOfDay => DateTime(year, month, day);

  /// Gets the end of the day.
  /// [end] of day == [start] of next day.
  DateTime get endOfDay => DateTime(year, month, day + 1);

  /// Add specific amount of [days] (ignoring DST)
  DateTime addDays(int days) {
    return DateTime(year, month, day + days, hour, minute, second);
  }

  /// Subtract specific amount of [days] (ignoring DST)
  DateTime subtractDays(int days) {
    return addDays(-days);
  }

  /// Gets the start of the week with an offset.
  DateTime startOfWeekWithOffset(int firstDayOfWeek) {
    assert(
      firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
      'firstDayOfWeek must be between 1 and 7',
    );
    return subtractDays(weekday - firstDayOfWeek).startOfDay;
  }

  /// Gets the start of the week.
  DateTime get startOfWeek => startOfWeekWithOffset(1);

  /// Gets the end of the week with an offset.
  DateTime endOfWeekWithOffset(int firstDayOfWeek) {
    return startOfWeekWithOffset(firstDayOfWeek).addDays(7).startOfDay;
  }

  /// Gets the end of the week.
  DateTime get endOfWeek => endOfWeekWithOffset(1);

  /// Gets the start of the month.
  DateTime get startOfMonth => DateTime(year, month);

  /// Gets the end of the month.
  DateTime get endOfMonth => DateTime(year, month + 1);

  /// Gets the start of the year.
  DateTime get startOfYear => DateTime(year);

  /// Gets the end of the year.
  DateTime get endOfYear => DateTime(year + 1);

  /// Gets the day range in which the [DateTime] is in.
  DateTimeRange get dayRange => DateTimeRange(start: startOfDay, end: endOfDay);

  /// Gets the four day range with the [DateTime] as the first day.
  DateTimeRange get threeDayRange => DateTimeRange(
        start: startOfDay,
        end: endOfDay.addDays(2),
      );

  /// Gets the four day range with the [DateTime] as the first day.
  DateTimeRange get fourDayRange => DateTimeRange(
        start: startOfDay,
        end: endOfDay.addDays(3),
      );

  /// Gets the week range in which the [DateTime] is in with an offset.
  DateTimeRange weekRangeWithOffset(int firstDayOfWeek) => DateTimeRange(
        start: startOfWeekWithOffset(firstDayOfWeek),
        end: endOfWeekWithOffset(firstDayOfWeek),
      );

  /// Gets the week range in which the [DateTime] is in.
  DateTimeRange get weekRange => weekRangeWithOffset(1);

  /// Gets the month range in which the [DateTime] is in.
  DateTimeRange get monthRange => DateTimeRange(
        start: startOfMonth,
        end: endOfMonth,
      );

  /// Gets the year range in which the [DateTime] is in.
  DateTimeRange get yearRange => DateTimeRange(
        start: DateTime(year, month),
        end: DateTime(year + 1, month),
      );

  /// Checks if the [DateTime] is the same day as the calling object.
  bool isSameDay(DateTime date) =>
      year == date.year && month == date.month && day == date.day;

  /// Checks if the [DateTime] is within the [DateTimeRange].
  bool isWithin(DateTimeRange range) =>
      isAfter(range.start) && isBefore(range.end);

  /// Checks if the [DateTime] is today.
  bool get isToday => isSameDay(DateTime.now());

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int get weekNumber {
    final dayOfYear = int.parse(DateFormat('D').format(this));
    return ((dayOfYear - weekday + 10) / 7).floor();
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
  TimeOfDay difference(TimeOfDay other) {
    final hourDifference = hour - other.hour;
    final minuteDifference = minute - other.minute;

    return TimeOfDay(hour: hourDifference, minute: minuteDifference);
  }
}
