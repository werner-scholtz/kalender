import 'package:flutter/material.dart';

class TimelineStyle {
  const TimelineStyle({
    this.textStyle,
    this.use24HourFormat,
  });

  /// The [TextStyle] of the time text.
  final TextStyle? textStyle;

  /// Whether to use 24 hour format.
  /// If true the time is displayed as 'HH:mm'.
  /// If false the time is displayed as 'h am/pm'.
  ///
  /// If null, the value of [MediaQueryData.alwaysUse24HourFormat] is used.
  final bool? use24HourFormat;
}
