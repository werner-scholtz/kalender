import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

/// TODO: improve the wording and naming here.

/// The idea here is to construct a DateTimeRange that acts as a utc DateTimeRange.
class InternalDateTimeRange extends DateTimeRange {
  @override
  InternalDateTime get start => super.start as InternalDateTime;

  @override
  InternalDateTime get end => super.end as InternalDateTime;

  /// The original range of this [InternalDateTimeRange].
  DateTimeRange get originalDateTimeRange => DateTimeRange(start: start.originalDateTime, end: end.originalDateTime);

  /// Creates a new [InternalDateTimeRange] from a [DateTimeRange].
  InternalDateTimeRange.from(DateTimeRange dateTimeRange)
      : assert(
          dateTimeRange.start is! InternalDateTime && dateTimeRange.end is! InternalDateTime,
          'Cannot create InternalDateTimeRange from another InternalDateTimeRange',
        ),
        super(
          start: InternalDateTime.from(dateTimeRange.start),
          end: InternalDateTime.from(dateTimeRange.end),
        );

  /// Converts this [InternalDateTimeRange] to a local [DateTimeRange].
  DateTimeRange asLocal(Location? location) {
    if (location != null) {
      return DateTimeRange(start: TZDateTime.from(start, location), end: TZDateTime.from(end, location));
    } else {
      return DateTimeRange(start: start.asLocal(null), end: end.asLocal(null));
    }
  }
}

/// A DateTime that is always in utc internally.
///
/// This DateTime has the same values as the input DateTime but is always in utc.
///
/// `ex. 2024-06-01 12:00:00 will be 2024-06-01 12:00:00Z`
class InternalDateTime extends DateTime {
  /// The original [DateTime] in utc.
  final DateTime originalDateTime;

  /// Creates a new [InternalDateTime] instance from a [DateTime].
  InternalDateTime.from(DateTime dateTime)
      : originalDateTime = dateTime.toUtc(),
        assert(dateTime is! InternalDateTime, 'Cannot create InternalDateTime from another InternalDateTime'),
        super.utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        );

  /// Converts this [InternalDateTime] to a local [DateTime].
  DateTime asLocal(Location? location) {
    if (location != null) {
      return TZDateTime(location, year, month, day, hour, minute, second, millisecond, microsecond);
    } else {
      return DateTime(year, month, day, hour, minute, second, millisecond, microsecond);
    }
  }
}
