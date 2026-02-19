import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// This is a DateTimeRange class used for internal display purposes only.
class InternalDateTimeRange extends DateTimeRange<InternalDateTime> {
  /// Creates a [InternalDateTimeRange] instance.
  InternalDateTimeRange({
    required DateTime start,
    required DateTime end,
  }) : super(start: InternalDateTime.fromDateTime(start), end: InternalDateTime.fromDateTime(end));

  /// Creates a [InternalDateTimeRange] from an existing [DateTimeRange].
  InternalDateTimeRange.fromDateTimeRange(DateTimeRange dateTimeRange)
      : super(
          start: InternalDateTime.fromDateTime(dateTimeRange.start),
          end: InternalDateTime.fromDateTime(dateTimeRange.end),
        );

  /// Converts this [InternalDateTimeRange] to a [DateTimeRange] for the specified [location].
  DateTimeRange forLocation({Location? location}) {
    return DateTimeRange(start: start.forLocation(location: location), end: end.forLocation(location: location));
  }

  // TODO: Document
  List<InternalDateTime> dates({bool inclusive = false}) {
    // Start with the beginning of the start date.
    final dates = [start.startOfDay];

    // Handle the case where the start and end dates are the same.
    if (start.isSameDay(end)) return dates;

    // Iterate through the dates, incrementing by one day at a time.
    var current = dates.last;
    while (current.isBefore(end) || (inclusive && current.isAtSameMomentAs(end))) {
      // Increment using date components (DST-safe)
      final next = InternalDateTime.fromDateTime(current.copyWith(day: current.day + 1));

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
  /// print(rangeOnDate?.end);   // Output: 2024-01-16 00:00:00.000
  ///
  /// final dateOutsideRange = DateTime(2024, 2, 1);
  /// final rangeOnDateOutside = range.dateTimeRangeOnDate(dateOutsideRange);
  /// print(rangeOnDateOutside); // Output: null
  ///
  /// final range2 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 2));
  /// final date2 = DateTime(2024, 1, 1);
  /// final rangeOnDate2 = range2.dateTimeRangeOnDate(date2);
  /// print(rangeOnDate2?.start); // Output: 2024-01-01 00:00:00.000
  /// print(rangeOnDate2?.end);   // Output: 2024-01-02 00:00:00.000
  /// ```
  InternalDateTimeRange? dateTimeRangeOnDate(InternalDateTime date) {
    // Adjust the start and end times to the beginning and end of the day.
    final range = InternalDateTimeRange(start: start.startOfDay, end: end.endOfDay);

    // Check if the given date is outside the range. If so, return null.
    if (!date.isWithin(range, includeStart: true)) return null;

    // Check if the start and end dates are the same day. If so, the entire range is on that day.
    if (start.isSameDay(end)) return this;

    // Check if the given date is the same as the start date.
    if (date.isSameDay(start)) return InternalDateTimeRange(start: start, end: start.endOfDay);

    // Check if the given date is the same as the end date.
    if (date.isSameDay(end)) return InternalDateTimeRange(start: end.startOfDay, end: end);

    // If none of the above conditions are met, the date must be within the range
    // but not the start or end date.
    return InternalDateTimeRange(start: date.startOfDay, end: date.endOfDay);
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
    final days = InternalDateTimeRange(start: start, end: end).dates(inclusive: false);
    final isSingleWeek = days.length <= 7;

    if (start.year != end.year && !isSingleWeek) {
      return (start.weekNumber, end.weekNumber);
    }

    final first = start.weekNumber;
    var second = end.weekNumber;

    // If the end is the start of the day, then it should be considered as the previous day.
    if (end == end.startOfDay) {
      second = InternalDateTime.fromDateTime(end.subtract(const Duration(days: 1))).weekNumber;
    }

    if (first == second) {
      return (first, null);
    } else {
      return (first, second);
    }
  }
}
