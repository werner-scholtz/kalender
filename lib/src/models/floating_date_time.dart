import 'package:kalender/kalender.dart';

/// A date and time with no timezone, used for calendar layout.
///
/// The components are stored through [DateTime.utc], so [add] and [subtract] step calendar units and a value renders
/// the same in every timezone. It is not a UTC instant.
///
/// Use [fromExternal] to convert a zoned [DateTime] or [TZDateTime] into a [FloatingDateTime], and [forLocation] to
/// convert back.
class FloatingDateTime extends DateTime {
  /// Creates a [FloatingDateTime] instance.
  FloatingDateTime(
    super.year, [
    super.month,
    super.day,
    super.hour,
    super.minute,
    super.second,
    super.millisecond,
    super.microsecond,
  ]) : super.utc();

  /// Creates a [FloatingDateTime] from an existing [DateTime].
  FloatingDateTime.fromDateTime(DateTime dateTime)
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

  /// Converts a [DateTime] or [TZDateTime] into an [FloatingDateTime].
  ///
  /// Returns [dateTime] unchanged if it is already an [FloatingDateTime].
  /// Otherwise converts to UTC first, then resolves to the target timezone
  /// ([location] if provided, or the system's local timezone) before
  /// storing the resulting components.
  static FloatingDateTime fromExternal(DateTime dateTime, {Location? location}) {
    if (dateTime is FloatingDateTime) return dateTime;
    final utc = dateTime.toUtc();
    final date = location != null ? TZDateTime.from(utc, location) : utc.toLocal();
    return FloatingDateTime.fromDateTime(date);
  }

  /// Returns midnight (00:00:00) of this date.
  FloatingDateTime get startOfDay => FloatingDateTime(year, month, day);

  /// Returns midnight (00:00:00) of the **next** day (exclusive upper bound).
  ///
  /// This is an exclusive boundary — it represents the start of the following day,
  /// not the last instant of the current day. Useful for half-open `[start, end)` ranges.
  FloatingDateTime get endOfDay => FloatingDateTime(year, month, day + 1);

  /// Returns a half-open `[start, end)` range covering this entire day.
  FloatingDateTimeRange get dayRange => FloatingDateTimeRange(start: startOfDay, end: endOfDay);

  /// Returns the first day of this date's month at midnight.
  FloatingDateTime get startOfMonth => FloatingDateTime(year, month, 1);

  /// Returns the first day of the **next** month at midnight (exclusive upper bound).
  FloatingDateTime get endOfMonth => FloatingDateTime(year, month + 1, 1);

  /// Returns a half-open `[start, end)` range covering this entire month.
  FloatingDateTimeRange get monthRange => FloatingDateTimeRange(start: startOfMonth, end: endOfMonth);

  /// Returns January 1st of this date's year at midnight.
  FloatingDateTime get startOfYear => FloatingDateTime(year, 1, 1);

  /// Returns January 1st of the **next** year at midnight (exclusive upper bound).
  FloatingDateTime get endOfYear => FloatingDateTime(year + 1, 1, 1);

  /// Returns a half-open `[start, end)` range covering this entire year.
  FloatingDateTimeRange get yearRange => FloatingDateTimeRange(start: startOfYear, end: endOfYear);

  /// Whether this date is exactly at midnight (all time components are zero).
  bool get isStartOfDay => hour == 0 && minute == 0 && second == 0 && millisecond == 0 && microsecond == 0;

  /// Returns midnight of the first day of this date's week.
  ///
  /// The [firstDayOfWeek] parameter controls which day starts the week
  /// (defaults to [DateTime.monday] per ISO 8601).
  FloatingDateTime startOfWeek({int firstDayOfWeek = DateTime.monday}) {
    final daysToSubtract = (weekday - firstDayOfWeek) % 7;
    return FloatingDateTime(year, month, day - daysToSubtract);
  }

  /// Returns midnight of the day **after** the last day of this date's week (exclusive upper bound).
  ///
  /// The [firstDayOfWeek] parameter controls which day starts the week
  /// (defaults to [DateTime.monday] per ISO 8601).
  FloatingDateTime endOfWeek({int firstDayOfWeek = DateTime.monday}) {
    final daysToAdd = (firstDayOfWeek - weekday - 1) % 7;
    return FloatingDateTime(year, month, day + daysToAdd + 1);
  }

  /// Returns a half-open `[start, end)` range covering this entire week.
  ///
  /// The [firstDayOfWeek] parameter controls which day starts the week
  /// (defaults to [DateTime.monday] per ISO 8601).
  FloatingDateTimeRange weekRange({int firstDayOfWeek = DateTime.monday}) {
    return FloatingDateTimeRange(
      start: startOfWeek(firstDayOfWeek: firstDayOfWeek),
      end: endOfWeek(firstDayOfWeek: firstDayOfWeek),
    );
  }

  /// Converts this [FloatingDateTime] to a [DateTime] for the specified [location].
  DateTime forLocation({Location? location}) {
    if (location == null) {
      return DateTime(year, month, day, hour, minute, second, millisecond, microsecond);
    } else {
      return TZDateTime(location, year, month, day, hour, minute, second, millisecond, microsecond);
    }
  }

  /// Checks if this [FloatingDateTime] represents the current day in the specified [location].
  ///
  /// Both `now` and this date are converted to the same target timezone before
  /// comparing year, month, and day. This is necessary because comparing in UTC
  /// can yield incorrect results near midnight — for example, 11:30 PM in New York
  /// (UTC-5) is already the next day in UTC.
  ///
  /// If [now] is provided, it is used as the reference time instead of
  /// computing the current time from [location] or the system clock.
  /// The wall-clock components of [now] are compared directly against this date's
  /// wall-clock components (via [isSameDay]), so the caller is responsible for
  /// ensuring [now] is in the desired timezone.
  ///
  /// If [location] is `null` and [now] is `null`, the system's local timezone is used.
  ///
  /// Example:
  /// ```dart
  /// final date = FloatingDateTime.fromDateTime(DateTime.now());
  ///
  /// // Check using system timezone
  /// print(date.isToday()); // true
  ///
  /// // Check using a specific timezone
  /// final location = getLocation('America/New_York');
  /// print(date.isToday(location: location)); // true (if today in New York)
  ///
  /// // Check using an explicit 'now' value
  /// final customNow = DateTime(2024, 1, 15, 14, 30);
  /// print(date.isToday(now: customNow)); // true only if date is Jan 15
  /// ```
  bool isToday({Location? location, DateTime? now}) {
    if (now != null) {
      return isSameDay(FloatingDateTime.fromDateTime(now));
    }
    final currentTime = location != null ? TZDateTime.now(location) : DateTime.now();
    final localDate = forLocation(location: location);
    return localDate.year == currentTime.year &&
        localDate.month == currentTime.month &&
        localDate.day == currentTime.day;
  }

  /// Checks if [date] falls on the same calendar day as this [FloatingDateTime].
  ///
  /// Compares year, month, and day components only; time-of-day is ignored.
  ///
  /// Example:
  /// ```dart
  /// final date = FloatingDateTime(2024, 1, 15);
  /// print(date.isSameDay(FloatingDateTime(2024, 1, 15))); // Output: true
  /// print(date.isSameDay(FloatingDateTime(2024, 1, 16))); // Output: false
  /// ```
  bool isSameDay(FloatingDateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  /// Checks if this [FloatingDateTime] occurs during the given [FloatingDateTimeRange].
  ///
  /// By default, the start time is included in the range, but the end time is not.
  /// This behavior can be changed by setting the `includeStart` and `includeEnd` parameters.
  ///
  /// Example:
  /// ```dart
  /// final date = FloatingDateTime(2024, 1, 15, 10, 30); // January 15, 2024, 10:30 AM
  /// final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2024, 1, 31));
  /// print(date.isWithin(range)); // Output: true
  ///
  /// final date2 = FloatingDateTime(2024, 1, 1); // January 1, 2024, 12:00 AM
  /// print(date2.isWithin(range)); // Output: true
  /// print(date2.isWithin(range, includeStart: false)); // Output: false
  ///
  /// final date3 = FloatingDateTime(2024, 1, 31); // January 31, 2024, 12:00 AM
  /// print(date3.isWithin(range)); // Output: false
  /// print(date3.isWithin(range, includeEnd: true)); // Output: true
  /// ```
  bool isWithin(FloatingDateTimeRange range, {bool includeStart = true, bool includeEnd = false}) {
    final isWithin = isAfter(range.start) && isBefore(range.end);
    late final isAtStart = isAtSameMomentAs(range.start);
    late final isAtEnd = isAtSameMomentAs(range.end);

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
      return FloatingDateTime(year - 1, 12, 28).weekNumber;
    }

    // If the week number equals 53, one must check that the date is not actually in week 1 of the following year
    if (woy == 53 &&
        FloatingDateTime(year, 1, 1).weekday != DateTime.thursday &&
        FloatingDateTime(year, 12, 31).weekday != DateTime.thursday) {
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

  /// Adds a [Duration] to this [FloatingDateTime] and returns a new [FloatingDateTime].
  ///
  /// Note because [FloatingDateTime] is stored in UTC, it is unaffected by DST changes,
  /// so adding a duration will always yield the expected result without any surprises.
  @override
  FloatingDateTime add(Duration duration) {
    final result = super.add(duration);
    return FloatingDateTime.fromDateTime(result);
  }

  /// Subtracts a [Duration] from this [FloatingDateTime] and returns a new [FloatingDateTime].
  ///
  /// Note because [FloatingDateTime] is stored in UTC, it is unaffected by DST changes,
  /// so subtracting a duration will always yield the expected result without any surprises.
  @override
  FloatingDateTime subtract(Duration duration) {
    final result = super.subtract(duration);
    return FloatingDateTime.fromDateTime(result);
  }

  /// Returns the [Duration] between this and [other].
  ///
  /// Because both values are stored as UTC, the result is free from
  /// DST-related surprises.
  @override
  Duration difference(DateTime other) => super.difference(other);

  /// Returns a new [FloatingDateTime] with the given fields replaced.
  ///
  /// Unspecified fields are copied from this instance.
  FloatingDateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return FloatingDateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
