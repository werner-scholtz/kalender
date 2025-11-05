import 'package:flutter/material.dart';
import 'package:kalender/src/extensions/date_time.dart';
import 'package:timezone/timezone.dart';

/// An extension on the [DateTimeRange] class that provides helpful methods.
extension DateTimeRangeExtensions on DateTimeRange {
  /// Check if both the [start] and [end] times are in utc.
  bool get isUtc => start.isUtc && end.isUtc;

  /// Converts the [start] and [end] times to local time.
  ///
  /// This method returns a new [DateTimeRange] with the [start] and [end] times
  /// converted to local time.  The original [DateTimeRange] is not modified.
  DateTimeRange toLocal() => DateTimeRange(start: start.toLocal(), end: end.toLocal());

  /// Converts the [start] and [end] times to UTC.
  DateTimeRange toUtc() => DateTimeRange(start: start.toUtc(), end: end.toUtc());

  /// The difference in months between the [start] and [end] dates of this range.
  ///
  /// This calculates the absolute difference in years, multiplies by 12, and then
  /// adds the difference in months.  It handles cases where the start and end
  /// dates are in different years or have different days of the month.
  ///
  /// Example:
  /// ```dart
  /// final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2025, 6, 1));
  /// print(range.monthDifference); // Output: 17
  /// ```
  int get monthDifference {
    var months = ((start.year - end.year).abs() - 1) * 12;
    months += end.month + (12 - start.month);
    return months;
  }

  /// Returns the ISO week number(s) that this [DateTimeRange] spans.
  ///
  /// This method returns a tuple containing one or two week numbers, depending
  /// on whether the range spans a single week or multiple weeks, following the
  /// ISO 8601 standard where Monday is the first day of the week.
  ///
  /// *   If the range spans a single week, the tuple contains the week number
  ///     and `null` as the second value.
  /// *   If the range spans multiple weeks, the tuple contains the week number
  ///     of the first day and the week number of the last day.
  /// *   If the range spans across two years and is less than a week long, then both week numbers are returned.
  ///
  /// Example (single week):
  /// ```dart
  /// final range = DateTimeRange(start: DateTime(2025, 1, 6), end: DateTime(2025, 1, 12));
  /// final (weekNumber, secondWeekNumber) = range.weekNumbers;
  /// print(weekNumber); // Output: 2 (ISO week 2)
  /// print(secondWeekNumber); // Output: null
  /// ```
  ///
  /// Example (multiple weeks):
  /// ```dart
  /// final range = DateTimeRange(start: DateTime(2025, 1, 6), end: DateTime(2025, 1, 13));
  /// final (weekNumber, secondWeekNumber) = range.weekNumbers;
  /// print(weekNumber); // Output: 2 (ISO week 2)
  /// print(secondWeekNumber); // Output: 3 (ISO week 3)
  /// ```
  (int first, int? last) get weekNumbers {
    final days = dates(inclusive: false);
    final isSingleWeek = days.length <= 7;

    if (start.year != end.year && !isSingleWeek) {
      return (start.weekNumber, end.weekNumber);
    }

    final first = start.weekNumber;
    var second = end.weekNumber;

    // If the end is the start of the day, then it should be considered as the previous day.
    if (end == end.startOfDay) {
      second = end.subtractDays(1).weekNumber;
    }

    if (first == second) {
      return (first, null);
    } else {
      return (first, second);
    }
  }



  /// TODO: check this extension it seems a but iffy.
  /// Generates a list of [DateTime] objects representing the dates within this [DateTimeRange].
  ///
  /// The [inclusive] parameter controls whether the end date is included in the list. (The function will always return at least one date)
  ///
  /// **Important Considerations:**
  ///
  /// * **Time Zone Consistency:** The start and end [DateTime] of the [DateTimeRange]
  ///   must be in the same time zone. An assertion will be thrown if they are not.
  ///   This is crucial for accurate date calculations.
  /// * **Daylight Saving Time (DST):** This function handles DST transitions correctly.
  ///   It uses date components (year, month, day) for incrementing to avoid DST-related
  ///   issues.
  ///
  /// Example:
  ///
  /// ```dart
  /// final startDate = DateTime(2024, 10, 26);
  /// final endDate = DateTime(2024, 10, 29);
  /// final range = DateTimeRange(start: startDate, end: endDate);
  /// final dates = range.dates(inclusive: true);
  /// print(dates); // Output: [2024-10-26, 2024-10-27, 2024-10-28, 2024-10-29]
  /// final dates2 = range.dates(inclusive: false);
  /// print(dates); // Output: [2024-10-26, 2024-10-27, 2024-10-28]
  /// ```
  ///
  List<DateTime> dates({bool inclusive = false}) {
    assert(
      start.isUtc == end.isUtc,
      'This calculation requires the start and end DateTime objects to be in the same timezone. '
      'Start: $start, End: $end',
    );

    // Start with the beginning of the start date.
    final dates = [start];

    // Handle the case where the start and end dates are the same.
    if (start.isSameDay(end)) return dates;

    // Iterate through the dates, incrementing by one day at a time.
    var current = dates.last;
    while (current.isBefore(end) || (inclusive && current.isAtSameMomentAs(end))) {
      // Increment using date components (DST-safe)
      final next = current.copyWith(day: current.day + 1);

      // Add the next date to the list if it's within the range.
      if (next.isBefore(end) || (inclusive && next.isAtSameMomentAs(end))) {
        dates.add(next);
        current = next;
      } else if (inclusive && next.isAtSameMomentAs(end)) {
        dates.add(next);
        current = next;
      } else {
        break;
      }
    }

    return dates;
  }

  /// TODO: Document
  DateTimeRange? dateTimeRangeDuring(DateTimeRange range) {
    // Check if the given range is outside this range. If so, return null.
    if ((!range.start.isWithin(this) && !range.end.isWithin(this))) return null;

    // find the start time.
    final startDateTime = range.start.isBefore(start) ? start : range.start;
    // find the end time.
    final endDateTime = range.end.isAfter(end) ? end : range.end;

    return DateTimeRange(start: startDateTime, end: endDateTime);
  }

  /// Checks if this [DateTimeRange] overlaps with another [DateTimeRange].
  ///
  /// Two [DateTimeRange] objects overlap if they share any common time interval.
  /// This method checks if the start of one range is before the end of the other,
  /// AND the end of the first range is after the start of the second.  This
  /// determines a true overlap, where the ranges have some period in common.
  ///
  /// By default, ranges that only "touch" at their start or end times are *not*
  /// considered to overlap. This behavior can be changed by setting the
  /// `touching` parameter to `true`.
  ///
  /// Example (non-touching overlap):
  /// ```dart
  /// final range1 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
  /// final range2 = DateTimeRange(start: DateTime(2024, 1, 5), end: DateTime(2024, 1, 15));
  /// print(range1.overlaps(range2)); // Output: true
  ///
  /// final range3 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 5));
  /// final range4 = DateTimeRange(start: DateTime(2024, 1, 5), end: DateTime(2024, 1, 10));
  /// print(range3.overlaps(range4)); // Output: false (only touching)
  /// ```
  ///
  /// Example (touching overlap):
  /// ```dart
  /// final range3 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 5));
  /// final range4 = DateTimeRange(start: DateTime(2024, 1, 5), end: DateTime(2024, 1, 10));
  /// print(range3.overlaps(range4, touching: true)); // Output: true (touching considered overlap)
  /// ```
  bool overlaps(DateTimeRange other, {bool touching = false}) {
    // Check if the ranges overlap.
    final overlap = start.isBefore(other.end) && end.isAfter(other.start);
    if (!touching) return overlap;

    // Check if the start or end times are touching.
    final startTouching = other.start.isAtSameMomentAs(end);
    final endTouching = other.end.isAtSameMomentAs(start);
    return startTouching || endTouching;
  }

  /// Returns the [DateTime] that has the most days in the [dates] of this [DateTimeRange].
  ///
  /// This method returns the [DateTime] that has the most days in the [dates] of this [DateTimeRange].
  ///
  /// Example:
  /// ```dart
  /// final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
  /// final range2 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 2, 28));
  /// final dominantMonth = range.dominantMonthDate;
  /// print(dominantMonth); // Output: 2024-01-01
  /// final dominantMonth2 = range2.dominantMonthDate;
  /// print(dominantMonth2); // Output: 2024-01-01
  /// ```
  DateTime get dominantMonthDate {
    final monthCounts = <(int year, int month), int>{};

    for (final date in dates()) {
      final key = (date.year, date.month);
      monthCounts[key] = (monthCounts[key] ?? 0) + 1;
    }

    final dominant = monthCounts.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );

    return start.isUtc
        ? DateTime.utc(dominant.key.$1, dominant.key.$2, 1)
        : DateTime(dominant.key.$1, dominant.key.$2, 1);
  }

  /// Converts this UTC range to a local [DateTimeRange] for the specified [location].
  ///
  /// If [location] is `null`, converts to the system's local timezone.
  /// If [location] is provided, converts to that specific timezone using
  /// the [timezone package](https://pub.dev/packages/timezone).
  ///
  /// This method is essential for displaying times to users in their
  /// preferred timezone while maintaining UTC storage internally.
  ///
  /// Parameters:
  /// - [location]: Target timezone location, or `null` for system timezone
  ///
  /// Returns a new [DateTimeRange] with times converted to the target timezone.
  ///
  /// Example:
  /// ```dart
  /// final utcRange = UtcDateTimeRange(
  ///   start: DateTime.utc(2024, 1, 15, 15, 0), // 3 PM UTC
  ///   end: DateTime.utc(2024, 1, 15, 16, 0),   // 4 PM UTC
  /// );
  ///
  /// // Convert to system timezone
  /// final localRange = utcRange.toLocal(null);
  ///
  /// // Convert to New York timezone
  /// final nyLocation = getLocation('America/New_York');
  /// final nyRange = utcRange.toLocal(nyLocation);
  /// // Start: 10 AM EST, End: 11 AM EST (UTC-5)
  /// ```
  DateTimeRange forLocation(Location? location) {
    assert(isUtc, 'The DateTimeRange must be in UTC to convert to a specific location. Current isUtc: $isUtc');
    if (location == null) {
      return DateTimeRange(start: start.toLocal(), end: end.toLocal());
    } else {
      return DateTimeRange<TZDateTime>(
        start: TZDateTime.from(start, location),
        end: TZDateTime.from(end, location),
      );
    }
  }

  // /// Converts the start time to local time for the specified [location].
  // ///
  // /// If [location] is `null`, converts to the system's local timezone.
  // /// Otherwise, converts to the specified timezone.
  // ///
  // /// Example:
  // /// ```dart
  // /// final utcRange = UtcDateTimeRange(
  // ///   start: DateTime.utc(2024, 1, 15, 15, 0),
  // ///   end: DateTime.utc(2024, 1, 15, 16, 0),
  // /// );
  // ///
  // /// final tokyoLocation = getLocation('Asia/Tokyo');
  // /// final localStart = utcRange.startToLocal(tokyoLocation);
  // /// // Returns: 2024-01-16 00:00 (UTC+9)
  // /// ```
  // DateTime startForLocation(Location? location) {
  //   if (location == null) {
  //     return start.toLocal();
  //   } else {
  //     return TZDateTime.from(start, location);
  //   }
  // }

  // /// Converts the end time to local time for the specified [location].
  // ///
  // /// If [location] is `null`, converts to the system's local timezone.
  // /// Otherwise, converts to the specified timezone.
  // ///
  // /// Example:
  // /// ```dart
  // /// final utcRange = UtcDateTimeRange(
  // ///   start: DateTime.utc(2024, 1, 15, 15, 0),
  // ///   end: DateTime.utc(2024, 1, 15, 16, 0),
  // /// );
  // ///
  // /// final londonLocation = getLocation('Europe/London');
  // /// final localEnd = utcRange.endToLocal(londonLocation);
  // /// // Returns: 2024-01-15 16:00 (UTC+0 in winter)
  // /// ```
  // DateTime endForLocation(Location? location) {
  //   if (location == null) {
  //     return end.toLocal();
  //   } else {
  //     return TZDateTime.from(end, location);
  //   }
  // }
}
