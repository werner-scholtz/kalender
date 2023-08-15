import 'package:flutter/material.dart';

/// [DateTime] extensions.
extension DateTimeExtentions on DateTime {
  /// Gets the start of the day.
  DateTime get startOfDay => DateTime(year, month, day);

  /// Gets the end of the day.
  /// [end] of day == [start] of next day.
  DateTime get endOfDay => DateTime(year, month, day + 1);

  /// Checks if the [DateTime] is the same day as the calling object.
  bool isSameDay(DateTime date) =>
      year == date.year && month == date.month && day == date.day;

  /// Checks if the [DateTime] is within the [DateTimeRange].
  bool isWithin(DateTimeRange range) =>
      isAfter(range.start) && isBefore(range.end);
}
