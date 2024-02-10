import 'package:flutter/material.dart';

/// The [TimeIndicatorStyle] class is used by the default [TimeIndicator] widget.
class TimeIndicatorStyle {
  const TimeIndicatorStyle({
    this.circleRadius,
    this.color,
    this.lineWidth,
  });

  /// The radius of the circle on the left.
  final double? circleRadius;

  /// The width of the line.
  final double? lineWidth;

  /// The color of time indicator.
  final Color? color;
}
