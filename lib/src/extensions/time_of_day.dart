import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';

/// Utility functions for working with [TimeOfDay].
extension TimeOfDayExtension on TimeOfDay {
  /// An extension on [TimeOfDay] that adds a method to convert the [TimeOfDay] to a [DateTime].
  InternalDateTime toDateTime(InternalDateTime dateTime) {
    return InternalDateTime.fromDateTime(
      dateTime.copyWith(year: dateTime.year, month: dateTime.month, day: dateTime.day, hour: hour, minute: minute),
    );
  }
}
