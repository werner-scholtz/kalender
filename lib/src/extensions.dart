import 'package:flutter/material.dart';

extension DateTimeRangeExtensions on DateTimeRange {
  /// The time difference in days between the [start] and [end] of the [DateTimeRange].
  int get dayDifference {
    final startDate = start.asUtc;
    final endDate = end.asUtc;
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
  List<DateTime> get days {
    final start = this.start.asUtc;
    final end = this.end.asUtc;

    if (start.isSameDay(end)) return [this.start.startOfDay];

    final dateTimeRange = DateTimeRange(
      start: start.startOfDay,
      end: end.startOfDay == end ? end.startOfDay : end.endOfDay,
    );

    final numberOfDays = dateTimeRange.dayDifference;
    final dates = <DateTime>[];
    for (var i = 0; i < numberOfDays; i++) {
      dates.add(this.start.startOfDay.add(Duration(days: i)));
    }
    return dates;
  }

  /// The [DateTimeRange] of the [DateTime] on a specific date.
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

  /// Returns the weekNumber(s) that the [DateTimeRange] spans.
  (int weekNumber, int? secondWeekNumber) get weekNumbers {
    final days = this.days;
    final isSingleWeek = days.length <= 7;

    if (start.year != end.year && isSingleWeek) {
      // When changing years we show both.

      final firstDayOfYear = days.firstWhere(
        (element) => element.year == end.year,
        orElse: () => start,
      );

      return (start.weekNumber, firstDayOfYear.weekNumber);
    }

    // This is custom so that if the user sets firstDayOfWeek to
    // monday, sunday or saturday we only show one week number.
    final showOnlyOneWeekNumber = isSingleWeek && (start.weekday == 1 || start.weekday == 6 || start.weekday == 7);

    if (!showOnlyOneWeekNumber) {
      if (days.first.weekNumber == days.last.weekNumber) {
        // If the first and last day have the same week number return the start.weekNumber.
        return (start.weekNumber, null);
      } else {
        // When its spans multiple weeks show both.
        return (start.weekNumber, end.weekNumber);
      }
    } else {
      final dateToUse = days.firstWhere(
        (date) => date.weekday == 1, // Find the first monday.
        orElse: () => start, // If there is not a monday use the start.
      );

      return (dateToUse.weekNumber, null);
    }
  }

  /// Checks if the [DateTimeRange] overlaps with another [DateTimeRange].
  bool overlaps(DateTimeRange other) {
    return start.isBefore(other.end) && end.isAfter(other.start);
  }

  /// Check if the [dateTimeRange] occurs during this.
  bool occursDuring(DateTimeRange dateTimeRange) {
    final rangeStart = dateTimeRange.start;
    final rangeEnd = dateTimeRange.end;

    // Check if the event starts before the range and ends after the range.
    final startsBeforeEndsAfter = (start.isBefore(rangeStart) && end.isAfter(rangeEnd));

    // Check if the event is within the range.
    final isWithin = start.isWithin(dateTimeRange) || end.isWithin(dateTimeRange);

    // Check if the start or end of the event is equal to the start or end of the range.
    final isStartOrEndSameMoment = start.isAtSameMomentAs(rangeStart)  || end.isAtSameMomentAs(rangeEnd);

    return startsBeforeEndsAfter || isWithin || isStartOrEndSameMoment;
  }

  /// Check if the [start] and [end] times are in utc.
  bool get isUtc => start.isUtc && end.isUtc;

  /// Returns a [DateTimeRange] with the [DateTime]s as UTC values without converting them.
  DateTimeRange get asUtc => DateTimeRange(start: start.asUtc, end: end.asUtc);

  /// Returns a [DateTimeRange] with the [DateTime]s as local values without converting them.
  DateTimeRange get asLocal => DateTimeRange(start: start.asLocal, end: end.asLocal);
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

  /// Returns a [DateTime] as a UTC value without converting it.
  DateTime get asUtc {
    return DateTime.utc(year, month, day, hour, minute, second, millisecond, microsecond);
  }

  /// Returns a [DateTime] as a local value without converting it.
  DateTime get asLocal {
    return DateTime(year, month, day, hour, minute, second, millisecond, microsecond);
  }

  /// Gets the start of the date.
  ///
  /// * DateTime(year, month, day)
  DateTime get startOfDay => copyWith(
        year: year,
        month: month,
        day: day,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// Gets the end of the date.
  ///
  /// * DateTime(year, month, day + 1)
  /// * Same as the start of next day
  DateTime get endOfDay => startOfDay.copyWith(day: day + 1);

  /// Gets the day range in which the [DateTime] is in.
  DateTimeRange get dayRange => DateTimeRange(start: startOfDay, end: endOfDay);

  /// Gets the start of the month.
  DateTime get startOfMonth => DateTime(year, month);

  /// Gets the end of the month.
  DateTime get endOfMonth => DateTime(year, month + 1);

  /// Gets the month range in which the [DateTime] is in.
  DateTimeRange get monthRange {
    return DateTimeRange(
      start: startOfMonth,
      end: endOfMonth,
    );
  }

  /// Gets the year range in which the [DateTime] is in.
  DateTimeRange get yearRange {
    return DateTimeRange(
      start: DateTime(year, 1, 1),
      end: DateTime(year + 1, 1, 1),
    );
  }

  /// Add specific amount of [days] (ignoring DST)
  DateTime addDays(int days) {
    return copyWith(
      year: year,
      month: month,
      day: day + days,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
      microsecond: microsecond,
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

    final difference = weekday - firstDayOfWeek;

    if (difference < 0) {
      return subtractDays(7 + difference).startOfDay;
    } else {
      return subtractDays(difference).startOfDay;
    }
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

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int get weekNumber {
    // Add 3 to always compare with January 4th, which is always in week 1
    // Add 7 to index weeks starting with 1 instead of 0
    final woy = ((ordinalDate - weekday + 10) ~/ 7);

    // If the week number equals zero, it means that the given date belongs to the preceding (week-based) year.
    if (woy == 0) {
      // The 28th of December is always in the last week of the year
      return DateTime(year - 1, 12, 28).weekNumber;
    }

    // If the week number equals 53, one must check that the date is not actually in week 1 of the following year
    if (woy == 53 &&
        DateTime(year, 1, 1).weekday != DateTime.thursday &&
        DateTime(year, 12, 31).weekday != DateTime.thursday) {
      return 1;
    }

    return woy;
  }

  /// The ordinal date, the number of days since December 31st the previous year.
  ///
  /// January 1st has the ordinal date 1
  ///
  /// December 31st has the ordinal date 365, or 366 in leap years
  int get ordinalDate {
    const offsets = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    return offsets[month - 1] + day + (isLeapYear && month > 2 ? 1 : 0);
  }

  /// True if this date is on a leap year.
  bool get isLeapYear {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  String get dayNameEnglish => switch (weekday) {
        1 => 'Monday',
        2 => 'Tuesday',
        3 => 'Wednesday',
        4 => 'Thursday',
        5 => 'Friday',
        6 => 'Saturday',
        7 => 'Sunday',
        _ => throw Exception('Invalid weekday'),
      };

  String get monthNameEnglish => switch (month) {
        1 => 'January',
        2 => 'February',
        3 => 'March',
        4 => 'April',
        5 => 'May',
        6 => 'June',
        7 => 'July',
        8 => 'August',
        9 => 'September',
        10 => 'October',
        11 => 'November',
        12 => 'December',
        _ => throw Exception('Invalid month'),
      };
}

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime(DateTime dateTime) => dateTime.copyWith(
        year: dateTime.year,
        month: dateTime.month,
        day: dateTime.day,
        hour: hour,
        minute: minute,
      );
}
