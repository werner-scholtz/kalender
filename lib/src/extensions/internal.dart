import 'package:flutter/material.dart';

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
}

extension InternalDateTimeRangeExtensions on DateTimeRange {
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

/// This is a DateTime class used for internal display purposes only.
class InternalDateTime {}

/// This is a DateTimeRange class used for internal display purposes only.
class InternalDateTimeRange {}
