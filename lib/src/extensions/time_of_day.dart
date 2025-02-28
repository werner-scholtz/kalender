import 'package:flutter/material.dart';

/// Utility functions for working with [TimeOfDay].
extension TimeOfDayExtension on TimeOfDay {
  /// An extension on [TimeOfDay] that adds a method to convert the [TimeOfDay] to a [DateTime].
  DateTime toDateTime(DateTime dateTime) {
    return dateTime.copyWith(year: dateTime.year, month: dateTime.month, day: dateTime.day, hour: hour, minute: minute);
  }
}
