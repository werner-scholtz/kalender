import 'package:flutter/material.dart';

/// The [HourLineStyle] class is used by the default [HourLines] widget.
class HourLineStyle {
  const HourLineStyle({
    this.thickness,
    this.color,
  });

  /// The thickness of the hour line.
  final double? thickness;

  /// The hour line color.
  final Color? color;
}
