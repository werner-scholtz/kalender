// import 'package:kalender/kalender.dart';
// import 'package:timezone/timezone.dart';

// /// TODO: this still needs some testing.

// /// A specialized DateTime that enforces UTC storage for consistent time calculations.
// ///
// /// This class extends [DateTime] and ensures it is always stored in UTC format,
// /// providing timezone-safe operations for calendar events. It's primarily used
// /// internally by the kalender package to handle time calculations that need to
// /// be consistent across different timezones.
// ///
// /// This class is typically used internally by the kalender package. Most applications
// /// should work with `CalendarEvent` and its time methods instead.
// ///
// /// ```dart
// /// // Internal usage example
// /// final utcTime = UtcDateTime(DateTime.utc(2024, 1, 15, 10, 30));
// ///
// /// // Convert to local time for display
// /// final localTime = utcTime.toLocalTime(null); // System timezone
// ///
// /// // Convert to specific timezone
// /// final nyLocation = getLocation('America/New_York');
// /// final nyTime = utcTime.toLocalTime(nyLocation);
// ///
// /// // All DateTime methods work directly since it extends DateTime
// /// print(utcTime.year);        // 2024
// /// print(utcTime.hour);        // 10
// /// print(utcTime.isUtc);       // true
// ///
// /// // Perform calculations
// /// final later = utcTime.add(Duration(hours: 2));
// /// final duration = later.difference(utcTime);
// /// ```
// ///
// /// See also:
// /// - `CalendarEvent` for high-level event time management
// /// - `UtcDateTimeRange` for UTC time ranges
// /// - [timezone package](https://pub.dev/packages/timezone) for location support
// class UtcDateTime extends DateTime {
//   /// Creates a UTC DateTime with the specified time.
//   ///
//   /// The provided DateTime must already be in UTC timezone. An assertion
//   /// error will be thrown if it is not UTC.
//   ///
//   /// Example:
//   /// ```dart
//   /// final utcTime = UtcDateTime(DateTime.utc(2024, 1, 15, 10, 30));
//   /// ```
//   UtcDateTime(DateTime dateTime)
//       : assert(dateTime.isUtc, 'DateTime must be in UTC'),
//         super.fromMicrosecondsSinceEpoch(dateTime.microsecondsSinceEpoch, isUtc: true);

//   /// Creates a UTC DateTime from any DateTime object.
//   ///
//   /// This constructor converts the provided [dateTime] to UTC while preserving
//   /// the time values (not converting between timezones). This is useful when
//   /// you have a local DateTime object but want to store it as UTC for
//   /// consistent calculations.
//   ///
//   /// Example:
//   /// ```dart
//   /// // Convert local time to UTC storage
//   /// final localTime = DateTime(2024, 1, 15, 10, 30);
//   ///
//   /// final utcTime = UtcDateTime.from(localTime);
//   /// // Now stored as UTC with same time values
//   /// ```
//   UtcDateTime.from(DateTime dateTime) : super.fromMicrosecondsSinceEpoch(dateTime.microsecondsSinceEpoch, isUtc: true);

//   DateTime asLocal(Location? location) {
//     if (location == null) {
//       return DateTime(year, month, day, hour, minute, second, millisecond, microsecond);
//     } else {
//       return TZDateTime.from(this, location);
//     }
//   }

//   /// Converts this UTC time to local time for the specified [location].
//   ///
//   /// If [location] is `null`, converts to the system's local timezone.
//   /// If [location] is provided, converts to that specific timezone using
//   /// the [timezone package](https://pub.dev/packages/timezone).
//   ///
//   /// This method is essential for displaying times to users in their
//   /// preferred timezone while maintaining UTC storage internally.
//   ///
//   /// Parameters:
//   /// - [location]: Target timezone location, or `null` for system timezone
//   ///
//   /// Returns a new DateTime converted to the target timezone.
//   ///
//   /// Example:
//   /// ```dart
//   /// final utcTime = UtcDateTime(DateTime.utc(2024, 1, 15, 15, 0)); // 3 PM UTC
//   ///
//   /// // Convert to system timezone
//   /// final localTime = utcTime.toLocalTime(null);
//   ///
//   /// // Convert to New York timezone
//   /// final nyLocation = getLocation('America/New_York');
//   /// final nyTime = utcTime.toLocalTime(nyLocation);
//   /// // Returns: 10 AM EST (UTC-5)
//   /// ```
//   DateTime toLocalTime(Location? location) {
//     if (location == null) {
//       return toLocal();
//     } else {
//       return TZDateTime.from(this, location);
//     }
//   }

//   /// Returns a new UtcDateTime with the specified duration added.
//   ///
//   /// This overrides the base DateTime.add() method to ensure the result
//   /// is always a UtcDateTime for type safety and consistency.
//   ///
//   /// Example:
//   /// ```dart
//   /// final utcTime = UtcDateTime(DateTime.utc(2024, 1, 15, 10, 0));
//   /// final later = utcTime.add(Duration(hours: 2));
//   /// // Returns: UtcDateTime for 12:00 UTC
//   /// ```
//   @override
//   UtcDateTime add(Duration duration) {
//     return UtcDateTime(super.add(duration));
//   }

//   /// Returns a new UtcDateTime with the specified duration subtracted.
//   ///
//   /// This overrides the base DateTime.subtract() method to ensure the result
//   /// is always a UtcDateTime for type safety and consistency.
//   ///
//   /// Example:
//   /// ```dart
//   /// final utcTime = UtcDateTime(DateTime.utc(2024, 1, 15, 10, 0));
//   /// final earlier = utcTime.subtract(Duration(hours: 2));
//   /// // Returns: UtcDateTime for 8:00 UTC
//   /// ```
//   @override
//   UtcDateTime subtract(Duration duration) {
//     return UtcDateTime(super.subtract(duration));
//   }

//   /// Returns the difference between this and [other] as a Duration.
//   ///
//   /// This overrides the base DateTime.difference() method to add an assertion
//   /// that ensures both DateTimes are in UTC for accurate calculations.
//   ///
//   /// Both times are guaranteed to be in UTC, ensuring accurate calculations
//   /// without timezone-related errors.
//   ///
//   /// Example:
//   /// ```dart
//   /// final start = UtcDateTime(DateTime.utc(2024, 1, 15, 10, 0));
//   /// final end = UtcDateTime(DateTime.utc(2024, 1, 15, 12, 30));
//   /// final duration = end.difference(start);
//   /// // Returns: Duration(hours: 2, minutes: 30)
//   /// ```
//   @override
//   Duration difference(DateTime other) {
//     assert(other.isUtc, 'The other DateTime must be in UTC for accurate calculations');
//     return super.difference(other);
//   }

//   /// Returns a new UtcDateTime with modified components.
//   ///
//   /// Any null parameters will use the current values. The result is always
//   /// stored as UTC with the specified time components.
//   ///
//   /// Example:
//   /// ```dart
//   /// final utcTime = UtcDateTime(DateTime.utc(2024, 1, 15, 10, 30));
//   /// final modified = utcTime.copyWith(hour: 14, minute: 0);
//   /// // Returns: UtcDateTime for 2024-01-15 14:00 UTC
//   /// ```
//   UtcDateTime copyWith({
//     int? year,
//     int? month,
//     int? day,
//     int? hour,
//     int? minute,
//     int? second,
//     int? millisecond,
//     int? microsecond,
//   }) {
//     return UtcDateTime(
//       DateTime.utc(
//         year ?? this.year,
//         month ?? this.month,
//         day ?? this.day,
//         hour ?? this.hour,
//         minute ?? this.minute,
//         second ?? this.second,
//         millisecond ?? this.millisecond,
//         microsecond ?? this.microsecond,
//       ),
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is UtcDateTime && other.microsecondsSinceEpoch == microsecondsSinceEpoch;
//   }

//   @override
//   int get hashCode => microsecondsSinceEpoch.hashCode;

//   @override
//   String toString() {
//     return 'UtcDateTime(${toIso8601String()})';
//   }
// }
