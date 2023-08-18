import 'package:flutter/material.dart';

/// The [MonthGridStyle] class is used by the [MonthGrid] widget.
class MonthGridStyle {
  const MonthGridStyle({
    this.color,
    this.thickness,
  });

  /// The color of the month grid lines.
  final Color? color;

  /// The thickness of the month grid lines.
  final double? thickness;
}
