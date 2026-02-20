import 'package:kalender/kalender.dart';

// TODO: Read through documentation and ensure it is up to date and accurate.

/// A timezone-agnostic [DateTime] subclass used internally for display and layout purposes.
///
/// [InternalDateTime] stores date and time components (year, month, day, hour, etc.)
/// **as-is** using [DateTime.utc], without representing an actual UTC instant.
/// The UTC flag is used purely as a storage mechanism to avoid any implicit
/// timezone conversions that Dart's [DateTime] would otherwise apply.
class InternalDateTime extends DateTime {
  /// Creates a [InternalDateTime] instance.
  InternalDateTime(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : super.utc(year, month, day, hour, minute, second, millisecond, microsecond);

  /// Creates a [InternalDateTime] from an existing [DateTime].
  InternalDateTime.fromDateTime(DateTime dateTime)
      : super.utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        );

  /// Creates a [InternalDateTime] from an external [DateTime].
  static InternalDateTime fromExternal(DateTime dateTime, {Location? location}) {
    if (dateTime is InternalDateTime) return dateTime;
    final utc = dateTime.toUtc();
    final date = location != null ? TZDateTime.from(utc, location) : utc.toLocal();
    return InternalDateTime.fromDateTime(date);
  }

  InternalDateTime get startOfDay => InternalDateTime(year, month, day);
  InternalDateTime get endOfDay => InternalDateTime(year, month, day + 1);
  InternalDateTimeRange get dayRange => InternalDateTimeRange(start: startOfDay, end: endOfDay);
  InternalDateTime get startOfMonth => InternalDateTime(year, month, 1);
  InternalDateTime get endOfMonth => InternalDateTime(year, month + 1, 1);
  InternalDateTimeRange get monthRange => InternalDateTimeRange(start: startOfMonth, end: endOfMonth);
  InternalDateTime get startOfYear => InternalDateTime(year, 1, 1);
  InternalDateTime get endOfYear => InternalDateTime(year + 1, 1, 1);
  InternalDateTimeRange get yearRange => InternalDateTimeRange(start: startOfYear, end: endOfYear);
  bool get isStartOfDay => hour == 0 && minute == 0 && second == 0 && millisecond == 0 && microsecond == 0;

  InternalDateTime startOfWeek({int firstDayOfWeek = DateTime.monday}) {
    final daysToSubtract = (weekday - firstDayOfWeek) % 7;
    return InternalDateTime(year, month, day - daysToSubtract);
  }

  InternalDateTime endOfWeek({int firstDayOfWeek = DateTime.monday}) {
    final daysToAdd = (firstDayOfWeek - weekday - 1) % 7;
    return InternalDateTime(year, month, day + daysToAdd + 1);
  }

  InternalDateTimeRange weekRange({int firstDayOfWeek = DateTime.monday}) {
    return InternalDateTimeRange(
      start: startOfWeek(firstDayOfWeek: firstDayOfWeek),
      end: endOfWeek(firstDayOfWeek: firstDayOfWeek),
    );
  }

  /// Converts this [InternalDateTime] to a [DateTime] for the specified [location].
  DateTime forLocation({Location? location}) {
    if (location == null) {
      return DateTime(year, month, day, hour, minute, second, millisecond, microsecond);
    } else {
      return TZDateTime(location, year, month, day, hour, minute, second, millisecond, microsecond);
    }
  }

  /// Checks if this [InternalDateTime] represents the current day in the specified [location].
  ///
  /// Both `now` and this date are converted to the same target timezone before
  /// comparing year, month, and day. This is necessary because comparing in UTC
  /// can yield incorrect results near midnight — for example, 11:30 PM in New York
  /// (UTC-5) is already the next day in UTC.
  ///
  /// If [location] is `null`, the system's local timezone is used.
  ///
  /// Example:
  /// ```dart
  /// final date = InternalDateTime.fromDateTime(DateTime.now());
  ///
  /// // Check using system timezone
  /// print(date.isToday()); // true
  ///
  /// // Check using a specific timezone
  /// final location = getLocation('America/New_York');
  /// print(date.isToday(location: location)); // true (if today in New York)
  /// ```
  bool isToday({Location? location}) {
    final now = location != null ? TZDateTime.now(location) : DateTime.now();
    final localDate = forLocation(location: location);
    return localDate.year == now.year && localDate.month == now.month && localDate.day == now.day;
  }

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
  bool isSameDay(InternalDateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  /// Checks if this [InternalDateTime] occurs during the given [InternalDateTimeRange].
  ///
  /// By default, the start time is included in the range, but the end time is not.
  /// This behavior can be changed by setting the `includeStart` and `includeEnd` parameters.
  ///
  /// Example:
  /// ```dart
  /// final date = InternalDateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final range = InternalDateTimeRange(start: InternalDateTime(2024, 1, 1), end: InternalDateTime(2024, 1, 31));
  /// print(date.isWithin(range)); // Output: true
  ///
  /// final date2 = InternalDateTime(2024, 1, 1); // January 1, 2024, 12:00 AM
  /// print(date2.isWithin(range)); // Output: true
  /// print(date2.isWithin(range, includeStart: false)); // Output: false
  ///
  /// final date3 = InternalDateTime(2024, 1, 31); // January 31, 2024, 12:00 AM
  /// print(date3.isWithin(range)); // Output: false
  /// print(date3.isWithin(range, includeEnd: true)); // Output: true
  /// ```
  bool isWithin(InternalDateTimeRange dateTimeRange, {bool includeStart = true, bool includeEnd = false}) {
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

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int get weekNumber {
    // Add 3 to always compare with January 4th, which is always in week 1
    // Add 7 to index weeks starting with 1 instead of 0
    final woy = ((ordinalDate - weekday + 10) ~/ 7);

    // If the week number equals zero, it means that the given date belongs to the preceding (week-based) year.
    if (woy == 0) {
      // The 28th of December is always in the last week of the year
      return InternalDateTime(year - 1, 12, 28).weekNumber;
    }

    // If the week number equals 53, one must check that the date is not actually in week 1 of the following year
    if (woy == 53 &&
        InternalDateTime(year, 1, 1).weekday != DateTime.thursday &&
        InternalDateTime(year, 12, 31).weekday != DateTime.thursday) {
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

  /// Adds a [Duration] to this [InternalDateTime] and returns a new [InternalDateTime].
  ///
  /// Note because [InternalDateTime] is stored in UTC, it is unaffected by DST changes,
  /// so adding a duration will always yield the expected result without any surprises.
  @override
  InternalDateTime add(Duration duration) {
    final result = super.add(duration);
    return InternalDateTime.fromDateTime(result);
  }

  /// Subtracts a [Duration] from this [InternalDateTime] and returns a new [InternalDateTime].
  ///
  /// Note because [InternalDateTime] is stored in UTC, it is unaffected by DST changes,
  /// so subtracting a duration will always yield the expected result without any surprises.
  @override
  InternalDateTime subtract(Duration duration) {
    final result = super.subtract(duration);
    return InternalDateTime.fromDateTime(result);
  }
}
