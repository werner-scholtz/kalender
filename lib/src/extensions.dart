import 'package:flutter/material.dart';

/// [DateTimeRange] extensions.
extension DateTimeRangeExtensions on DateTimeRange {
  /// The difference of days between the [start] and [end] of the [DateTimeRange].
  int get dayDifference {
    final startDate = start.toUtc();
    final endDate = end.toUtc();

    final difference = endDate.difference(startDate).inDays;

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
      dates.add(localStartOfDate.addDays(i));
    }

    return dates.toSet().toList();
  }

  /// The number of years spanned by the [DateTimeRange].
  int get numberOfYears => end.year - start.year;

  /// Returns a new [DateTimeRange] with the start and end dates offset by the given [duration].
  DateTimeRange rescheduleDateTime(Duration duration) {
    return DateTimeRange(start: start.add(duration), end: end.add(duration));
  }

  /// The center [DateTime] of the [DateTimeRange].
  DateTime get centerDateTime =>
      start.addDays((dayDifference / 2).floor());

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
    final datesSpanned = this.datesSpanned;
    final isSingleWeek = datesSpanned.length <= 7;

    if (start.year != end.year && isSingleWeek) {
      // When changing years we show both.

      final firstDayOfYear = datesSpanned.firstWhere(
        (element) => element.year == end.year,
        orElse: () => start,
      );

      return (start.weekNumber, firstDayOfYear.weekNumber);
    }

    // This is custom so that if the user sets firstDayOfWeek to
    // monday, sunday or saturday we only show one week number.
    final showOnlyOneWeekNumber = isSingleWeek &&
        (start.weekday == 1 || start.weekday == 6 || start.weekday == 7);

    if (!showOnlyOneWeekNumber) {
      if (datesSpanned.first.weekNumber == datesSpanned.last.weekNumber) {
        // If the first and last day have the same week number return the start.weekNumber.
        return (start.weekNumber, null);
      } else {
        // When its spans multiple weeks show both.
        return (start.weekNumber, end.weekNumber);
      }
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

  /// Returns a [DateTimeRange] with the [DateTime] as the start that spans the given number of days.
  DateTimeRange multiDayDateTimeRange(int numberOfDays) {
    return DateTimeRange(
      start: startOfDay,
      end: endOfDay.addDays(numberOfDays - 1),
    );
  }

  String get englishDayName {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  String get englishMonthName {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay difference(TimeOfDay other) {
    final hourDifference = hour - other.hour;
    final minuteDifference = minute - other.minute;

    return TimeOfDay(hour: hourDifference, minute: minuteDifference);
  }
}
