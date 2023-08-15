import 'package:flutter/material.dart';

/// The [TimeIndicatorStyle] class is used by the default [TimeIndicator] widget.
class TimeIndicatorStyle {
  const TimeIndicatorStyle({
    this.circleRadius,
    this.color,
  });

  /// The radius of the circle on the left.
  final double? circleRadius;

  /// The color of time indicator.
  final Color? color;
}
