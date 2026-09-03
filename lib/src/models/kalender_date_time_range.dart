/// A range between two [DateTime]s.
///
/// The type kalender's public signatures use for a start and end pair.
class KalenderDateTimeRange {
  /// Creates a [KalenderDateTimeRange].
  KalenderDateTimeRange({required this.start, required this.end}) : assert(!start.isAfter(end));

  /// The start of the range.
  final DateTime start;

  /// The end of the range.
  final DateTime end;

  /// The [Duration] between [start] and [end].
  Duration get duration => end.difference(start);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is KalenderDateTimeRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start - $end';
}
