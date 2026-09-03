import 'package:kalender/src/models/kalender_date_time_range.dart';
import 'package:kalender/src/models/kalender_time.dart';

/// Encapsulates a start and end [KalenderTime] that represents a day time range.
///
/// - The range includes the [start] and [end] times.
/// - The [start] time must be before to the [end] time.
class KalenderTimeRange {
  KalenderTimeRange({
    required this.start,
    required this.end,
  })  : assert(start.hour <= end.hour),
        assert(start.hour == end.hour ? start.minute <= end.minute : true);

  /// Creates a [KalenderTimeRange] that represents an entire day.
  factory KalenderTimeRange.allDay() {
    return KalenderTimeRange(
      start: const KalenderTime(hour: 0, minute: 0),
      end: const KalenderTime(hour: 23, minute: 59),
    );
  }

  /// Creates a [KalenderTimeRange] that represents the given [hour].
  factory KalenderTimeRange.forHour(int hour) {
    return KalenderTimeRange(
      start: KalenderTime(hour: hour, minute: 0),
      end: KalenderTime(hour: hour, minute: 59),
    );
  }

  /// Creates a [KalenderTimeRange] from the given [KalenderDateTimeRange].
  factory KalenderTimeRange.fromDateTimeRange(KalenderDateTimeRange dateTimeRange) {
    return KalenderTimeRange(
      start: KalenderTime.fromDateTime(dateTimeRange.start),
      end: KalenderTime.fromDateTime(dateTimeRange.end),
    );
  }

  /// The start time of the range.
  final KalenderTime start;

  /// The end time of the range.
  final KalenderTime end;

  /// Whether this range runs from 00:00 to 23:59.
  bool get coversWholeDay => start.hour == 0 && end.hour == 23 && end.minute == 59;

  /// Returns a [Duration] representing the time difference between the [start] and [end].
  /// * Note we need to add 1 minute to the duration to include the end time.
  Duration get duration {
    return Duration(
      hours: end.hour - start.hour,
      minutes: (end.minute - start.minute) + 1,
    );
  }

  /// Generates a list of [KalenderTimeRange] segments from the current [KalenderTimeRange].
  ///
  /// The list of [KalenderTimeRange] is generated based on the provided [segmentLength] in minutes.
  ///
  /// The last segment might not be of the same length as [segmentLength].
  ///
  /// Example:
  /// ```dart
  /// final range = KalenderTimeRange(start: KalenderTime(hour: 10, minute: 0), end: KalenderTime(hour: 11, minute: 30));
  /// final segments = range.splitIntoSegments(30);
  /// print(segments);
  /// ```
  /// Output:
  /// ```
  /// [10:00 - 10:29, 10:30 - 10:59, 11:00 - 11:29, 11:30 - 11:30]
  /// ```
  ///
  /// The segments are inclusive of the start and end times.
  List<KalenderTimeRange> splitIntoSegments(int segmentLength) {
    final segments = <KalenderTimeRange>[];
    final rangeStartMinutes = start.hour * 60 + start.minute;
    final rangeEndMinutes = end.hour * 60 + end.minute;

    var currentMinutes = rangeStartMinutes;
    while (currentMinutes <= rangeEndMinutes) {
      final startOfSegment = KalenderTime(
        hour: currentMinutes ~/ 60,
        minute: currentMinutes % 60,
      );

      var endOfSegmentMinutes = currentMinutes + segmentLength - 1;
      if (endOfSegmentMinutes > rangeEndMinutes) {
        endOfSegmentMinutes = rangeEndMinutes;
      }

      final endOfSegment = KalenderTime(
        hour: endOfSegmentMinutes ~/ 60,
        minute: endOfSegmentMinutes % 60,
      );

      segments.add(KalenderTimeRange(start: startOfSegment, end: endOfSegment));
      currentMinutes += segmentLength;
    }
    return segments;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is KalenderTimeRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() {
    return '$start - $end';
  }
}
