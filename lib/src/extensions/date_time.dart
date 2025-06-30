import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Useful extensions for working with [DateTime] objects.
extension DateTimeExtensions on DateTime {
  /// Check if the [DateTime] is today in the current time zone.
  ///
  /// This method compares the year, month, and day of this [DateTime] object
  /// with the current date. It returns `true` if the dates match.
  ///
  /// The comparison is done in the same time zone as the calling object.
  /// - This means that the [DateTime.now] is converted to the same time zone
  ///   as the calling object before the comparison.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime.now();
  /// print(date.isToday); // Output: true (if called today)
  ///
  /// final otherDate = DateTime(2024, 1, 1);
  /// print(otherDate.isToday); // Output: false (if not called on Jan 1, 2024)
  /// ```
  bool get isToday => isSameDay(DateTime.now());

  /// Checks if the [DateTime] is the same day as the calling object.
  ///
  /// This method compares the year, month, and day of this [DateTime] object
  /// with the given [date]. It returns `true` if the dates match.
  ///
  /// The [date] parameter can be in either local or UTC time, and the comparison
  /// will be done in the same time zone as the calling object.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15);
  /// print(date.isSameDay(DateTime(2024, 1, 15))); // Output: true
  /// print(date.isSameDay(DateTime(2024, 1, 16))); // Output: false
  /// ```
  bool isSameDay(DateTime date) {
    final other = isUtc != date.isUtc
        ? isUtc
            ? date.toUtc()
            : date.toLocal()
        : date;
    return year == other.year && month == other.month && day == other.day;
  }

  /// Gets the start of the date.
  ///
  /// This returns a new [DateTime] object representing the start of the day
  /// (midnight) in the same time zone as the original [DateTime].
  ///
  /// Example (local):
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final start = date.startOfDay;
  /// print(start); // Output: 2024-01-15 00:00:00.000
  /// ```
  ///
  /// Example (utc):
  /// ```dart
  /// final date = DateTime.utc(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final start = date.startOfDay;
  /// print(start); // Output: 2024-01-15 00:00:00.000Z
  /// ```
  DateTime get startOfDay {
    return copyWith(year: year, month: month, day: day, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  }

  /// Gets the end of the date. (aka the start of the next day).
  ///
  /// This returns a new [DateTime] object representing the end of the date
  /// (midnight of the next day), in the same time zone as the original [DateTime].
  ///
  /// Example (local):
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final end = date.endOfDay;
  /// print(end); // Output: 2024-01-16 00:00:00.000
  /// ```
  ///
  /// Example (utc):
  /// ```dart
  /// final date = DateTime.utc(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final end = date.endOfDay;
  /// print(end); // Output: 2024-01-16 00:00:00.000Z
  /// ```
  DateTime get endOfDay => startOfDay.copyWith(day: day + 1);

  /// Gets the [DateTimeRange] representing the entire day in which this
  /// [DateTime] falls.
  ///
  /// The returned [DateTimeRange] starts at the beginning of the day (midnight)
  /// and ends at the beginning of the next day, both in the same
  /// time zone as this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final range = date.dayRange;
  /// print(range.start); // Output: 2024-01-15 00:00:00.000
  /// print(range.end);   // Output: 2024-01-16 00:00:00.000
  /// ```
  DateTimeRange get dayRange => DateTimeRange(start: startOfDay, end: endOfDay);

  /// Gets the start of the month.
  ///
  /// This returns a new [DateTime] object representing the first day of the
  /// month (midnight) in the same time zone as the original [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final start = date.startOfMonth;
  /// print(start); // Output: 2024-01-01 00:00:00.000
  /// ```
  DateTime get startOfMonth => (isUtc ? DateTime.utc : DateTime.new)(year, month);

  /// Gets the end of the month. (aka start of the next month)
  ///
  /// This returns a new [DateTime] object representing the last day of the
  /// month, (midnight of the start of the next month) in the same time zone
  /// as the original [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final start = date.startOfMonth;
  /// print(start); // Output: 2024-01-01 00:00:00.000
  /// ```
  DateTime get endOfMonth => (isUtc ? DateTime.utc : DateTime.new)(year, month + 1);

  /// Gets a [DateTimeRange] representing the entire month in which this [DateTime] occurs.
  ///
  /// The returned [DateTimeRange] starts at the beginning of the month (midnight of the first day)
  /// and ends at the beginning of the next month, both in the same time zone as this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final range = date.monthRange;
  /// print(range.start); // Output: 2024-01-01 00:00:00.000
  /// print(range.end);   // Output: 2024-02-01 00:00:00.000
  /// ```
  DateTimeRange get monthRange => DateTimeRange(start: startOfMonth, end: endOfMonth);

  /// Gets the start of the year.
  ///
  /// This returns a new [DateTime] object representing the first day of the year
  /// (midnight) in the same time zone as the original [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final start = date.startOfYear;
  /// print(start); // Output: 2024-01-01 00:00:00.000
  /// ```
  DateTime get startOfYear => (isUtc ? DateTime.utc : DateTime.new)(year);

  /// Gets the end of the year. (aka start of the next year)
  ///
  /// This returns a new [DateTime] object representing the last day of the year
  /// (midnight of the start of the next year) in the same time zone as the original [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final start = date.endOfYear;
  /// print(start); // Output: 2025-01-01 00:00:00.000
  /// ```
  DateTime get endOfYear => (isUtc ? DateTime.utc : DateTime.new)(year + 1);

  /// Gets a [DateTimeRange] representing the entire year in which this [DateTime] occurs.
  ///
  /// The returned [DateTimeRange] starts at the beginning of the year (midnight of the first day)
  /// and ends at the beginning of the next year, both in the same time zone as this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final range = date.yearRange;
  /// print(range.start); // Output: 2024-01-01 00:00:00.000
  /// print(range.end);   // Output: 2025-01-01 00:00:00.000
  /// ```
  DateTimeRange get yearRange => DateTimeRange(start: startOfYear, end: endOfYear);

  /// Checks if this [DateTime] occurs during the given [DateTimeRange].
  ///
  /// By default, the start time is included in the range, but the end time is not.
  /// This behavior can be changed by setting the `includeStart` and `includeEnd` parameters.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
  /// print(date.isWithin(range)); // Output: true
  ///
  /// final date2 = DateTime(2024, 1, 1); // January 1, 2024, 12:00 AM
  /// print(date2.isWithin(range)); // Output: true
  /// print(date2.isWithin(range, includeStart: false)); // Output: false
  ///
  /// final date3 = DateTime(2024, 1, 31); // January 31, 2024, 12:00 AM
  /// print(date3.isWithin(range)); // Output: false
  /// print(date3.isWithin(range, includeEnd: true)); // Output: true
  /// ```
  bool isWithin(DateTimeRange dateTimeRange, {bool includeStart = true, bool includeEnd = false}) {
    final isWithin = isAfter(dateTimeRange.start) && isBefore(dateTimeRange.end);
    late final isAtStart = isAtSameMomentAs(dateTimeRange.start);
    late final isAtEnd = isAtSameMomentAs(dateTimeRange.end);

    if (includeStart && includeEnd) {
      // If both are included, the date must be within or at the start or end.
      return isWithin || isAtStart || isAtEnd;
    } else if (includeStart) {
      // If only the start is included, the date must be within or at the start.
      return isWithin || isAtStart;
    } else if (includeEnd) {
      // If only the end is included, the date must be within or at the end.
      return isWithin || isAtEnd;
    } else {
      // If neither are included, the date must be strictly within the range.
      return isWithin;
    }
  }

  /// Gets the start of the week.
  ///
  /// The start of the week is determined by [firstDayOfWeek] parameter, it defaults to [DateTime.monday].
  ///
  /// The calculation of the start of the week involves determining how many days to subtract
  /// from the current date to reach the desired [firstDayOfWeek]. If the current day of the week
  /// [weekday] is earlier in the week than the [firstDayOfWeek], 7 days are added to ensure
  /// the subtraction wraps around to the previous week.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final start = date.startOfWeek();
  /// print(start); // Output: 2024-01-15 00:00:00.000
  ///
  /// final date2 = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final start2 = date2.startOfWeek(firstDayOfWeek: DateTime.sunday);
  /// print(start2); // Output: 2024-01-14 00:00:00.000
  /// ```
  DateTime startOfWeek({int firstDayOfWeek = DateTime.monday}) {
    // Calculate the number of days to subtract to reach the start of the week.
    // If the current weekday is less than the first day of the week, add 7 to wrap around to the previous week.
    final daysToSubtract = (weekday < firstDayOfWeek ? 7 : 0) + weekday - firstDayOfWeek;
    return subtractDays(daysToSubtract).startOfDay;
  }

  /// Gets the end of the week.
  /// The end of the week is calculated as the start of the next week,
  /// which is midnight of the next corresponding [firstDayOfWeek].
  ///
  /// The [firstDayOfWeek] parameter determines the starting day of the week
  /// (e.g., Monday, Sunday, etc.) and defaults to [DateTime.monday].
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final end = date.endOfWeek();
  /// print(end); // Output: 2024-01-22 00:00:00.000
  ///
  /// final endWithSunday = date.endOfWeek(firstDayOfWeek: DateTime.sunday);
  /// print(endWithSunday); // Output: 2024-01-21 00:00:00.000
  /// ```
  DateTime endOfWeek({int firstDayOfWeek = DateTime.monday}) {
    return startOfWeek(firstDayOfWeek: firstDayOfWeek).addDays(7);
  }

  /// Get the week range.
  ///
  /// The week range is a [DateTimeRange] that starts at the beginning of the week
  /// (determined by [firstDayOfWeek], which defaults to [DateTime.monday])
  /// and ends at the beginning of the next week.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final range = date.weekRange();
  /// print(range.start); // Output: 2024-01-15 00:00:00.000
  /// print(range.end);   // Output: 2024-01-22 00:00:00.000
  ///
  /// final rangeWithSunday = date.weekRange(firstDayOfWeek: DateTime.sunday);
  /// print(rangeWithSunday.start); // Output: 2024-01-14 00:00:00.000
  /// print(rangeWithSunday.end);   // Output: 2024-01-21 00:00:00.000
  /// ```
  DateTimeRange weekRange({int firstDayOfWeek = DateTime.monday}) {
    return DateTimeRange(
      start: startOfWeek(firstDayOfWeek: firstDayOfWeek),
      end: endOfWeek(firstDayOfWeek: firstDayOfWeek),
    );
  }

  /// Get the work week range.
  ///
  /// The work week range is a [DateTimeRange] that starts at the beginning of the week
  /// (Monday) and ends at the end of the work week (Saturday) at 00:00:00.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final range = date.workWeekRange;
  /// print(range.start); // Output: 2024-01-15 00:00:00.000
  /// print(range.end);   // Output: 2024-01-20 00:00:00.000
  /// ```
  DateTimeRange get workWeekRange => DateTimeRange(start: startOfWeek(), end: endOfWeek().subtractDays(2));

  /// Add specific amount of [days] (ignoring DST)
  ///
  /// This method adds the given number of [days] to the [DateTime] object.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final newDate = date.addDays(5);
  /// print(newDate); // Output: 2024-01-20 10:30:00.000
  /// ```
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
  ///
  /// This method subtracts the given number of [days] from the [DateTime] object.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final newDate = date.subtractDays(5);
  /// print(newDate); // Output: 2024-01-10 10:30:00.000
  /// ```
  DateTime subtractDays(int days) => addDays(-days);

  /// Returns a [DateTimeRange] with the [DateTime] as the start that spans the given number of days.
  ///
  /// The [numberOfDays] parameter cannot be zero.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final range = date.customDateTimeRange(5);
  /// print(range.start); // Output: 2024-01-15 10:30:00.000
  /// print(range.end);   // Output: 2024-01-20 10:30:00.000
  ///
  /// final range2 = date.customDateTimeRange(-5);
  /// print(range2.start); // Output: 2024-01-10 10:30:00.000
  /// print(range2.end);   // Output: 2024-01-15 10:30:00.000
  /// ```
  DateTimeRange customDateTimeRange(int numberOfDays) {
    assert(numberOfDays != 0, 'The number of days cannot be zero.');
    final start = numberOfDays.isNegative ? addDays(numberOfDays) : this;
    final end = numberOfDays.isNegative ? this : addDays(numberOfDays);
    return DateTimeRange(start: start, end: end);
  }

  /// Returns a [DateTime] as a UTC value without converting it.
  ///
  /// This method returns a new [DateTime] object with the same date and time
  /// as the original, but with the time zone set to UTC.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final utcDate = date.asUtc;
  /// print(utcDate); // Output: 2024-01-15 10:30:00.000Z
  /// ```
  DateTime get asUtc => DateTime.utc(year, month, day, hour, minute, second, millisecond, microsecond);

  /// Returns a [DateTime] as a local value without converting it.
  ///
  /// This method returns a new [DateTime] object with the same date and time
  /// as the original, but with the time zone set to the local time zone.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime.utc(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final localDate = date.asLocal;
  /// print(localDate); // Output: 2024-01-15 10:30:00.000
  /// ```
  DateTime get asLocal => DateTime(year, month, day, hour, minute, second, millisecond, microsecond);

  /// TODO: Proposal depend on the intl package so this can be removed.
  /// If we do start depending on the intl package, then we might as well
  /// look into allowing the calendar to display events for different timezones.
  /// This will open a lot of possibilities for the calendar package.
  ///
  /// But first lets sort out all current tests, and make sure the package is stable.
  ///
  /// UPDATE: The intl package is now included! These methods provide both
  /// internationalized and customizable options for date formatting.

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

  /// Gets the day name in a specific locale.
  ///
  /// The [locale] parameter allows you to specify the desired locale.
  /// If not provided, it uses the system locale.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // Monday
  /// print(date.dayNameLocalized('en')); // Output: "Monday"
  /// print(date.dayNameLocalized('fr')); // Output: "lundi"
  /// print(date.dayNameLocalized('es')); // Output: "lunes"
  /// ```
  String dayNameLocalized([dynamic locale]) => DateFormat.EEEE(locale).format(this);

  /// Gets the abbreviated day name in a specific locale.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // Monday
  /// print(date.dayNameShortLocalized('en')); // Output: "Mon"
  /// print(date.dayNameShortLocalized('fr')); // Output: "lun"
  /// ```
  String dayNameShortLocalized([dynamic locale]) => DateFormat.E(locale).format(this);

  /// Gets the month name in a specific locale.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // January
  /// print(date.monthNameLocalized('en')); // Output: "January"
  /// print(date.monthNameLocalized('fr')); // Output: "janvier"
  /// print(date.monthNameLocalized('es')); // Output: "enero"
  /// ```
  String monthNameLocalized([dynamic locale]) => DateFormat.MMMM(locale).format(this);

  /// Gets the abbreviated month name in a specific locale.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // January
  /// print(date.monthNameShortLocalized('en')); // Output: "Jan"
  /// print(date.monthNameShortLocalized('fr')); // Output: "janv."
  /// ```
  String monthNameShortLocalized([dynamic locale]) => DateFormat.MMM(locale).format(this);

  /// Gets the month name in English (backwards compatibility).
  ///
  /// This method is kept for backwards compatibility but it's recommended
  /// to use [monthName] or [monthNameLocalized] for better internationalization.
  @Deprecated('Use monthName or monthNameLocalized or monthNameShortLocalized instead.')
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

  /// Gets the day name in English (backwards compatibility).
  ///
  /// This method is kept for backwards compatibility but it's recommended
  /// to use [dayName] or [dayNameLocalized] for better internationalization.
  @Deprecated('Use dayName or dayNameLocalized or dayNameShortLocalized instead.')
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
}
