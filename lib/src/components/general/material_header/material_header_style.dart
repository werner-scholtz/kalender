import 'package:flutter/material.dart';

/// The [CalendarHeaderBackgroundStyle] class is used by the default [CalendarHeaderBackground] widget.
class CalendarHeaderBackgroundStyle {
  const CalendarHeaderBackgroundStyle({
    this.headerBackgroundColor,
    this.headerSurfaceTintColor,
    this.headerElevation,
  });

  /// The background color of the header.
  final Color? headerBackgroundColor;

  /// The surface tint color of the header.
  final Color? headerSurfaceTintColor;

  /// The elevation of the header.
  final double? headerElevation;
}
