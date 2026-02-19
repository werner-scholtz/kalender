import 'package:flutter/material.dart';

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

  /// Generates a list of [TimeOfDayRange] segments from the current [TimeOfDayRange].
  ///
  /// The list of [TimeOfDayRange] is generated based on the provided [segmentLength] in minutes.
  ///
  /// The last segment might not be of the same length as [segmentLength].
  ///
  /// Example:
  /// ```dart
  /// final range = TimeOfDayRange(start: TimeOfDay(hour: 10, minute: 0), end: TimeOfDay(hour: 11, minute: 30));
  /// final segments = range.splitIntoSegments(30);
  /// print(segments);
  /// ```
  /// Output:
  /// ```
  /// [10:00 - 10:29, 10:30 - 10:59, 11:00 - 11:29, 11:30 - 11:30]
  /// ```
  ///
  /// The segments are inclusive of the start and end times.
  List<TimeOfDayRange> splitIntoSegments(int segmentLength) {
    final segments = <TimeOfDayRange>[];
    final rangeStartMinutes = start.hour * 60 + start.minute;
    final rangeEndMinutes = end.hour * 60 + end.minute;

    var currentMinutes = rangeStartMinutes;
    while (currentMinutes <= rangeEndMinutes) {
      final startOfSegment = TimeOfDay(
        hour: currentMinutes ~/ 60,
        minute: currentMinutes % 60,
      );

      var endOfSegmentMinutes = currentMinutes + segmentLength - 1;
      if (endOfSegmentMinutes > rangeEndMinutes) {
        endOfSegmentMinutes = rangeEndMinutes;
      }

      final endOfSegment = TimeOfDay(
        hour: endOfSegmentMinutes ~/ 60,
        minute: endOfSegmentMinutes % 60,
      );

      segments.add(TimeOfDayRange(start: startOfSegment, end: endOfSegment));
      currentMinutes += segmentLength;
    }
    return segments;
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
