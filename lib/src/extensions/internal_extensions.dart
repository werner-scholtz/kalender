import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

extension InternalDateTimeUtils on DateTime {
  DateTime get asUtc => DateTime.utc(year, month, day, hour, minute, second, millisecond, microsecond);

  /// TODO: I need something like this.
  DateTime asLocalForLocation(Location? location) {
    if (location == null) {
      return DateTime(year, month, day, hour, minute, second, millisecond, microsecond);
    } else {
      return TZDateTime(location, year, month, day, hour, minute, second, millisecond, microsecond);
    }
  }
}

extension InternalDateTimeRangeUtils on DateTimeRange {
  DateTimeRange get asUtc => DateTimeRange(start: start.asUtc, end: end.asUtc);

  /// TODO: Document
  DateTimeRange asLocalForLocation(Location? location) => DateTimeRange(
        start: start.asLocalForLocation(location),
        end: end.asLocalForLocation(location),
      );
}
