import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

export 'package:timezone/timezone.dart';

/// A [DateTimeRange] that uses [InternalDateTime] for timezone-safe display and layout.
///
/// Both [start] and [end] are stored as [InternalDateTime] values, so all
/// helpers on this range (dates, overlaps, week numbers, etc.) are DST-safe.
/// Use [forLocation] to convert back to wall-clock [DateTimeRange].
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

  /// Converts to a wall-clock [DateTimeRange] in the given [location] (or local if `null`).
  DateTimeRange forLocation({Location? location}) {
    return DateTimeRange(start: start.forLocation(location: location), end: end.forLocation(location: location));
  }

  /// Returns the list of calendar dates covered by this range (at midnight each).
  ///
  /// By default the end date is excluded (half-open). Set [inclusive] to `true`
  /// to include the end date itself.
  List<InternalDateTime> dates({bool inclusive = false}) {
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

  /// Returns the sub-range of this range that falls on [date], or `null` if
  /// [date] is outside the range.
  ///
  /// * If [date] is on the start day → `[start, endOfDay)`.
  /// * If [date] is on the end day → `[startOfDay, end)`.
  /// * If [date] is in between → the full day `[startOfDay, endOfDay)`.
  /// * If start and end are the same day → returns [this].
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

  /// Whether this range shares any time with [other].
  ///
  /// Ranges that only touch at a boundary (e.g. one ends where the other starts)
  /// return `false` by default. Set [touching] to `true` to treat those as overlapping.
  bool overlaps(DateTimeRange other, {bool touching = false}) {
    // Check if the ranges overlap.
    final overlap = start.isBefore(other.end) && end.isAfter(other.start);
    if (!touching) return overlap;

    // Check if the start or end times are touching.
    final startTouching = other.start.isAtSameMomentAs(end);
    final endTouching = other.end.isAtSameMomentAs(start);
    return startTouching || endTouching;
  }

  /// The number of calendar months between [start] and [end].
  int get monthDifference {
    var months = ((start.year - end.year).abs() - 1) * 12;
    months += end.month + (12 - start.month);
    return months;
  }

  /// The first day of the month that contains the most days in this range.
  ///
  /// When two months have equal counts, the earlier month wins.
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

  /// The ISO 8601 week number(s) this range spans.
  ///
  /// Returns `(weekNumber, null)` for a single-week range, or
  /// `(firstWeek, lastWeek)` when the range crosses a week boundary.
  /// A midnight end is treated as the previous day.
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
      second = end.subtract(const Duration(days: 1)).weekNumber;
    }

    if (first == second) {
      return (first, null);
    } else {
      return (first, second);
    }
  }
}
