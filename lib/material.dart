/// Conversions between kalender's value types and the ones in
/// `package:flutter/material.dart`.
///
/// Import this alongside `package:kalender/kalender.dart` where an app hands
/// kalender values to a Material API, or the other way round:
///
/// ```dart
/// final picked = await showTimePicker(context: context, initialTime: time.toTimeOfDay());
/// final time = picked?.toKalenderTime();
/// ```
///
/// It is a separate entry point so that importing `package:kalender/kalender.dart`
/// does not name a Material type.
library;

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// Converts a [KalenderDateTimeRange] to Material's [DateTimeRange].
extension KalenderDateTimeRangeMaterial on KalenderDateTimeRange {
  /// This range as a Material [DateTimeRange].
  DateTimeRange<DateTime> toDateTimeRange() => DateTimeRange<DateTime>(start: start, end: end);
}

/// Converts Material's [DateTimeRange] to a [KalenderDateTimeRange].
extension MaterialDateTimeRangeKalender<T extends DateTime> on DateTimeRange<T> {
  /// This range as a [KalenderDateTimeRange].
  KalenderDateTimeRange toKalenderDateTimeRange() => KalenderDateTimeRange(start: start, end: end);
}

/// Converts a [KalenderTime] to Material's [TimeOfDay].
extension KalenderTimeMaterial on KalenderTime {
  /// This time as a Material [TimeOfDay].
  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);
}

/// Converts Material's [TimeOfDay] to a [KalenderTime].
extension MaterialTimeOfDayKalender on TimeOfDay {
  /// This time as a [KalenderTime].
  KalenderTime toKalenderTime() => KalenderTime(hour: hour, minute: minute);
}
