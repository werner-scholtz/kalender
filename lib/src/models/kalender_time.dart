import 'package:kalender/kalender_extensions.dart';

/// A time of day, as an hour and a minute.
///
/// The type kalender's public signatures use for a time without a date.
class KalenderTime implements Comparable<KalenderTime> {
  /// Creates a [KalenderTime].
  ///
  /// [hour] must be between 0 and 23, and [minute] between 0 and 59.
  const KalenderTime({required this.hour, required this.minute});

  /// Creates a [KalenderTime] from the hour and minute of [time].
  KalenderTime.fromDateTime(DateTime time)
      : hour = time.hour,
        minute = time.minute;

  /// Creates a [KalenderTime] from the current local time.
  KalenderTime.now() : this.fromDateTime(DateTime.now());

  /// The number of hours in a day.
  static const int hoursPerDay = 24;

  /// The number of minutes in an hour.
  static const int minutesPerHour = 60;

  /// The hour, from 0 to 23.
  final int hour;

  /// The minute, from 0 to 59.
  final int minute;

  /// Returns a copy with [hour] and/or [minute] replaced.
  KalenderTime replacing({int? hour, int? minute}) {
    assert(hour == null || (hour >= 0 && hour < hoursPerDay));
    assert(minute == null || (minute >= 0 && minute < minutesPerHour));
    return KalenderTime(hour: hour ?? this.hour, minute: minute ?? this.minute);
  }

  /// This time on [dateTime]'s date, as an [InternalDateTime].
  InternalDateTime toInternalDateTime(InternalDateTime dateTime) {
    return InternalDateTime(dateTime.year, dateTime.month, dateTime.day, hour, minute);
  }

  /// This time on [dateTime]'s date.
  DateTime toDateTime(DateTime dateTime) {
    return dateTime.copyWith(hour: hour, minute: minute, second: 0, millisecond: 0, microsecond: 0);
  }

  /// Whether this occurs earlier in the day than [other].
  bool isBefore(KalenderTime other) => compareTo(other) < 0;

  /// Whether this occurs later in the day than [other].
  bool isAfter(KalenderTime other) => compareTo(other) > 0;

  /// Whether this is the same time of day as [other].
  bool isAtSameTimeAs(KalenderTime other) => compareTo(other) == 0;

  @override
  int compareTo(KalenderTime other) {
    final hourComparison = hour.compareTo(other.hour);
    return hourComparison == 0 ? minute.compareTo(other.minute) : hourComparison;
  }

  @override
  bool operator ==(Object other) => other is KalenderTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() {
    final hourLabel = hour.toString().padLeft(2, '0');
    final minuteLabel = minute.toString().padLeft(2, '0');
    return '$hourLabel:$minuteLabel';
  }
}
