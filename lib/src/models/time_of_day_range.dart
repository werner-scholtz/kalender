import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';

/// Encapsulates a start and end [TimeOfDay] that represents a day time range.
///
/// - The range includes the [start] and [end] times.
/// - The [start] time must be before to the [end] time.
class TimeOfDayRange {
  TimeOfDayRange({
    required this.start,
    required this.end,
  })  : assert(start.hour <= end.hour),
        assert(start.hour == end.hour ? start.minute <= end.minute : true);

  /// Creates a [TimeOfDayRange] that represents an entire day.
  factory TimeOfDayRange.allDay() {
    return TimeOfDayRange(
      start: const TimeOfDay(hour: 0, minute: 0),
      end: const TimeOfDay(hour: 23, minute: 59),
    );
  }

  /// Creates a [TimeOfDayRange] that represents the given [hour].
  factory TimeOfDayRange.forHour(int hour) {
    return TimeOfDayRange(
      start: TimeOfDay(hour: hour, minute: 0),
      end: TimeOfDay(hour: hour, minute: 59),
    );
  }

  /// Creates a [TimeOfDayRange] from the given [DateTimeRange].
  factory TimeOfDayRange.fromDateTimeRange(DateTimeRange dateTimeRange) {
    assert(
      dateTimeRange.start.isSameDay(dateTimeRange.end),
      'The DateTimeRange start and end must be on the same day.',
    );

    return TimeOfDayRange(
      start: TimeOfDay.fromDateTime(dateTimeRange.start),
      end: TimeOfDay.fromDateTime(dateTimeRange.end),
    );
  }

  /// The start time of the range.
  final TimeOfDay start;

  /// The end time of the range.
  final TimeOfDay end;

  /// Whether the [TimeOfDayRange] is an all day range.
  bool get isAllDay => start.hour == 0 && end.hour == 23 && end.minute == 59;

  /// Returns a [Duration] representing the time difference between the [start] and [end].
  /// * Note we need to add 1 minute to the duration to include the end time.
  Duration get duration {
    return Duration(
      hours: end.hour - start.hour,
      minutes: (end.minute - start.minute) + 1,
    );
  }

  /// Returns a list of [TimeOfDayRange] that represents the time [TimeOfDayRange] between hours.
  ///
  /// * The first item might not always be 1 hour long.
  /// * The last item might not always be 1 hour long.
  List<TimeOfDayRange> get hourRanges {
    final ranges = <TimeOfDayRange>[];

    for (var i = start.hour; i <= end.hour; i++) {
      if (i == start.hour) {
        final end = TimeOfDay(hour: i, minute: 59);
        ranges.add(TimeOfDayRange(start: start, end: end));
        continue;
      }

      if (i == end.hour) {
        final start = TimeOfDay(hour: i, minute: 0);
        ranges.add(TimeOfDayRange(start: start, end: end));
        break;
      }

      ranges.add(
        TimeOfDayRange.forHour(i),
      );
    }

    return ranges;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is TimeOfDayRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() {
    return '$start - $end';
  }
}
