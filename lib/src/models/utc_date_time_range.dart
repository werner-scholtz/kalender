import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

/// TODO: this still needs some testing.

/// A specialized [DateTimeRange] that enforces UTC storage for consistent time calculations.
///
/// This class extends [DateTimeRange] and ensures that all date times are stored
/// in UTC format, providing timezone-safe operations for calendar events. It's primarily
/// used internally by the kalender package to handle time range calculations that need
/// to be consistent across different timezones.
///
/// ```dart
/// // Internal usage example
/// final utcRange = UtcDateTimeRange(
///   start: DateTime.utc(2024, 1, 15, 10, 0),
///   end: DateTime.utc(2024, 1, 15, 11, 0),
/// );
///
/// // Convert to local time for display
/// final localRange = utcRange.toLocal(null); // System timezone
///
/// // Convert to specific timezone
/// final nyLocation = getLocation('America/New_York');
/// final nyRange = utcRange.toLocal(nyLocation);
/// ```
///
/// See also:
/// - [`CalendarEvent`](../calendar_events/calendar_event.dart) for high-level event time management
/// - [`DateTimeRange`] for the base Flutter class
/// - [timezone package](https://pub.dev/packages/timezone) for location support
class UtcDateTimeRange extends DateTimeRange {
  /// Creates a UTC date time range from any DateTime objects.
  ///
  /// This constructor converts the provided [start] and [end] times to UTC
  /// while preserving their time values (not converting between timezones).
  /// This is useful when you have local DateTime objects but want to store
  /// them as UTC for consistent calculations.
  ///
  /// Example:
  /// ```dart
  /// // Convert local times to UTC storage
  /// final localStart = DateTime(2024, 1, 15, 10, 0);
  /// final localEnd = DateTime(2024, 1, 15, 11, 0);
  ///
  /// final utcRange = UtcDateTimeRange.from(
  ///   start: localStart,
  ///   end: localEnd,
  /// );
  /// // Now stored as UTC with same time values
  /// ```
  UtcDateTimeRange.from({
    required DateTime start,
    required DateTime end,
  }) : super(
          start: DateTime.fromMicrosecondsSinceEpoch(start.microsecondsSinceEpoch, isUtc: true),
          end: DateTime.fromMicrosecondsSinceEpoch(end.microsecondsSinceEpoch, isUtc: true),
        );

  /// The total duration of the [UtcDateTimeRange].
  ///
  /// Because [start] and [end] are required to be in UTC, this calculation is safe.
  @override
  Duration get duration => end.difference(start);

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
  DateTimeRange toLocal(Location? location) {
    if (location == null) {
      return DateTimeRange(start: start.toLocal(), end: end.toLocal());
    } else {
      final localStart = TZDateTime.from(start, location);
      final localEnd = TZDateTime.from(end, location);
      return DateTimeRange(start: localStart, end: localEnd);
    }
  }

  /// Converts the start time to local time for the specified [location].
  ///
  /// If [location] is `null`, converts to the system's local timezone.
  /// Otherwise, converts to the specified timezone.
  ///
  /// Example:
  /// ```dart
  /// final utcRange = UtcDateTimeRange(
  ///   start: DateTime.utc(2024, 1, 15, 15, 0),
  ///   end: DateTime.utc(2024, 1, 15, 16, 0),
  /// );
  ///
  /// final tokyoLocation = getLocation('Asia/Tokyo');
  /// final localStart = utcRange.startToLocal(tokyoLocation);
  /// // Returns: 2024-01-16 00:00 (UTC+9)
  /// ```
  DateTime startToLocal(Location? location) {
    if (location == null) {
      return start.toLocal();
    } else {
      final localStart = TZDateTime.from(start, location);
      return localStart;
    }
  }

  /// Converts the end time to local time for the specified [location].
  ///
  /// If [location] is `null`, converts to the system's local timezone.
  /// Otherwise, converts to the specified timezone.
  ///
  /// Example:
  /// ```dart
  /// final utcRange = UtcDateTimeRange(
  ///   start: DateTime.utc(2024, 1, 15, 15, 0),
  ///   end: DateTime.utc(2024, 1, 15, 16, 0),
  /// );
  ///
  /// final londonLocation = getLocation('Europe/London');
  /// final localEnd = utcRange.endToLocal(londonLocation);
  /// // Returns: 2024-01-15 16:00 (UTC+0 in winter)
  /// ```
  DateTime endToLocal(Location? location) {
    if (location == null) {
      return end.toLocal();
    } else {
      final localEnd = TZDateTime.from(end, location);
      return localEnd;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UtcDateTimeRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}
