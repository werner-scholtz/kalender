import 'package:flutter/material.dart';

mixin DragTargetUtils {
  /// Calculate the [DateTimeRange] from the start [DateTime].
  ///
  /// Will return a [DateTimeRange] with an updated start [DateTime] and the same end [DateTime].
  /// - In the case where the new start [DateTime] is after the end [DateTime], the start and end [DateTime]s will be swapped.
  /// - In the case where the [DateTime]s are the same, the original [DateTimeRange] will be returned.
  DateTimeRange calculateDateTimeRangeFromStart(
    DateTimeRange dateTimeRange,
    DateTime newStart,
  ) {
    if (newStart.isBefore(dateTimeRange.end)) {
      return DateTimeRange(start: newStart, end: dateTimeRange.end);
    } else if (newStart.isAtSameMomentAs(dateTimeRange.end)) {
      return DateTimeRange(start: dateTimeRange.start, end: dateTimeRange.end);
    } else {
      return DateTimeRange(start: dateTimeRange.end, end: newStart);
    }
  }

  /// Calculate the [DateTimeRange] from the end [DateTime].
  ///
  /// Will return a [DateTimeRange] with an updated end [DateTime] and the same start [DateTime].
  /// - In the case where the new end [DateTime] is before the start [DateTime], the start and end [DateTime]s will be swapped.
  /// - In the case where the [DateTime]s are the same, the original [DateTimeRange] will be returned.
  DateTimeRange calculateDateTimeRangeFromEnd(
    DateTimeRange dateTimeRange,
    DateTime newEnd,
  ) {
    if (newEnd.isBefore(dateTimeRange.start)) {
      return DateTimeRange(start: newEnd, end: dateTimeRange.start);
    } else if (newEnd.isAtSameMomentAs(dateTimeRange.start)) {
      return DateTimeRange(start: dateTimeRange.start, end: dateTimeRange.end);
    } else {
      return DateTimeRange(start: dateTimeRange.start, end: newEnd);
    }
  }
}
