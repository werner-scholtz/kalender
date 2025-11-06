import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

/// The idea is to refactor these extensions so they work with TZDateTime and Locations.

extension InternalDateTimeExtensions on DateTime {
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

  /// TODO: DOCUMENTATION
  DateTime forLocation(Location? location) {
    if (location == null) {
      return toLocal();
    } else {
      return TZDateTime.from(this, location);
    }
  }
}

extension InternalDateTimeRangeExtensions on DateTimeRange<DateTime> {
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
    if (location == null) {
      return DateTimeRange(start: start.toLocal(), end: end.toLocal());
    } else {
      return DateTimeRange<TZDateTime>(
        start: TZDateTime.from(start, location),
        end: TZDateTime.from(end, location),
      );
    }
  }
}

/// This is a DateTime class used for internal display purposes only.
class InternalDateTime extends DateTime {
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
}

/// This is a DateTimeRange class used for internal display purposes only.
class InternalDateTimeRange extends DateTimeRange<InternalDateTime> {
  InternalDateTimeRange({
    required DateTime start,
    required DateTime end,
  }) : super(
          start: InternalDateTime.fromDateTime(start),
          end: InternalDateTime.fromDateTime(end),
        );

  InternalDateTimeRange.fromDateTimeRange(DateTimeRange dateTimeRange)
      : super(
          start: InternalDateTime.fromDateTime(dateTimeRange.start),
          end: InternalDateTime.fromDateTime(dateTimeRange.end),
        );
}
