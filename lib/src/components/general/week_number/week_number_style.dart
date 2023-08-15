import 'package:flutter/material.dart';

/// The [WeekNumberStyle] class is used by the default [WeekNumber] widget.
class WeekNumberStyle {
  const WeekNumberStyle({
    this.textStyle,
    this.visualDensity,
    this.tooltip,
  });

  /// The [TextStyle] used by the [WeekNumber] widget to display the week number.
  final TextStyle? textStyle;

  /// The [VisualDensity] used by the [WeekNumber] widget.
  final VisualDensity? visualDensity;

  /// The tooltip displayed when the [WeekNumber] widget is long pressed/hovered.
  final String? tooltip;
}
