import 'package:flutter/material.dart';
import 'package:kalender/src/extensions/date_time.dart';

/// An extension on the [DateTimeRange] class that provides helpful methods.
extension DateTimeRangeExtensions on DateTimeRange {
  /// Check if both the [start] and [end] times are in utc.
  bool get isUtc => start.isUtc && end.isUtc;

  /// Converts the [start] and [end] times to utc.
  ///
  /// This method returns a new [DateTimeRange] with the [start] and [end] times
  /// converted to UTC.  The original [DateTimeRange] is not modified.
  DateTimeRange toUtc() => DateTimeRange(start: start.toUtc(), end: end.toUtc());

  /// Converts the [start] and [end] times to local time.
  ///
  /// This method returns a new [DateTimeRange] with the [start] and [end] times
  /// converted to local time.  The original [DateTimeRange] is not modified.
  DateTimeRange toLocal() => DateTimeRange(start: start.toLocal(), end: end.toLocal());

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
    final days = dates(inclusive: true);
    final isSingleWeek = days.length <= 7;

    if (start.year != end.year && !isSingleWeek) {
      return (start.weekNumber, end.weekNumber);
    }

    if (!isSingleWeek) {
      return (start.weekNumber, end.weekNumber);
    } else {
      return (start.weekNumber, null);
    }
  }

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
    final dates = [start.startOfDay];

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

  /// Returns a [DateTimeRange] representing the portion of this [DateTimeRange]
  /// that falls on the given [date], or `null` if the [date] is not within this range.
  ///
  /// This method calculates the intersection of this [DateTimeRange] with the
  /// specified [date].  It handles cases where the [date] is the same as the
  /// start or end of the range, or if it falls within the range.  If the [date]
  /// is outside the range, it returns `null`.
  ///
  /// Example:
  /// ```dart
  /// final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
  /// final date = DateTime(2024, 1, 15);
  /// final rangeOnDate = range.dateTimeRangeOnDate(date);
  /// print(rangeOnDate?.start); // Output: 2024-01-15 00:00:00.000
  /// print(rangeOnDate?.end);   // Output: 2024-01-15 23:59:59.999
  ///
  /// final range2 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 1));
  /// final date2 = DateTime(2024, 1, 1);
  /// final rangeOnDate2 = range2.dateTimeRangeOnDate(date2);
  /// print(rangeOnDate2?.start); // Output: 2024-01-01 00:00:00.000
  /// print(rangeOnDate2?.end);   // Output: 2024-01-01 23:59:59.999
  ///
  /// final dateOutsideRange = DateTime(2024, 2, 1);
  /// final rangeOnDateOutside = range.dateTimeRangeOnDate(dateOutsideRange);
  /// print(rangeOnDateOutside); // Output: null
  /// ```
  DateTimeRange? dateTimeRangeOnDate(DateTime date) {
    // Check if the given date is outside the range. If so, return null.
    if (!date.isWithin(this, includeStart: true, includeEnd: true)) return null;

    // Check if the start and end dates are the same day. If so, the entire range is on that day.
    if (start.isSameDay(end)) return this;

    // Check if the given date is the same as the start date.
    if (date.isSameDay(start)) return DateTimeRange(start: start, end: start.endOfDay);

    // Check if the given date is the same as the end date.
    if (date.isSameDay(end)) return DateTimeRange(start: end.startOfDay, end: end);

    // If none of the above conditions are met, the date must be within the range
    // but not the start or end date.
    return DateTimeRange(start: date.startOfDay, end: date.endOfDay);
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

  /// Returns a [DateTimeRange] shifted by the given number of [numberOfDays].
  ///
  /// This method returns a new [DateTimeRange] with the [start] and [end] times
  /// shifted by the given [numberOfDays].  The [numberOfDays] can be positive or negative,
  /// and the new range will be adjusted accordingly.
  ///
  /// Example:
  /// ```dart
  /// final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
  /// final shiftedRange = range.shiftByDays(5);
  /// print(shiftedRange.start); // Output: 2024-01-06 00:00:00.000
  /// print(shiftedRange.end);   // Output: 2024-01-15 00:00:00.000
  /// ```
  DateTimeRange shiftByDays(int numberOfDays) {
    return DateTimeRange(start: start.addDays(numberOfDays), end: end.addDays(numberOfDays));
  }

  /// Returns a [DateTimeRange] with the [DateTime]s as UTC values without converting them.
  ///
  /// This method returns a new [DateTimeRange] with the [start] and [end] times
  /// as UTC values without converting them.  The original [DateTimeRange] is not modified.
  ///
  /// Example:
  /// ```dart
  /// final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
  /// final utcRange = range.asUtc;
  /// print(utcRange.start); // Output: 2024-01-01 00:00:00.000Z
  /// print(utcRange.end);   // Output: 2024-01-10 00:00:00.000Z
  /// ```
  DateTimeRange get asUtc => DateTimeRange(start: start.asUtc, end: end.asUtc);

  /// Returns a [DateTimeRange] with the [DateTime]s as local values without converting them.
  ///
  /// This method returns a new [DateTimeRange] with the [start] and [end] times
  /// as local values without converting them.  The original [DateTimeRange] is not modified.
  ///
  /// Example:
  /// ```dart
  /// final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
  /// final localRange = range.asLocal;
  /// print(localRange.start); // Output: 2024-01-01 00:00:00.000
  /// print(localRange.end);   // Output: 2024-01-10 00:00:00.000
  /// ```
  DateTimeRange get asLocal => DateTimeRange(start: start.asLocal, end: end.asLocal);
}
