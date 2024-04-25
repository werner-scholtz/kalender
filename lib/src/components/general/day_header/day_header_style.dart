import 'package:flutter/material.dart';

/// The [DayHeaderStyle] class is used by the default [DayHeader] widget.
class DayHeaderStyle {
  const DayHeaderStyle({
    this.textStyle,
    this.buttonTextStyle,
    this.buttonVisualDensity,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.stringBuilder,
  });

  /// The [TextStyle] used by the [DayHeader] widget to display the day of the week.
  final TextStyle? textStyle;

  /// Use this function to customize the sting displayed by the [DayHeader].
  final String Function(DateTime date)? stringBuilder;

  /// The [TextStyle] used by the icon button in the [DayHeader] widget.
  final TextStyle? buttonTextStyle;

  /// The [VisualDensity] used by the icon button in the [DayHeader] widget.
  final VisualDensity? buttonVisualDensity;

  /// The padding around the [DayHeader] widget.
  final EdgeInsets? padding;

  /// The background color of the [DayHeader] widget.
  final Color? backgroundColor;

  /// The border radius of the [DayHeader] widget.
  final BorderRadius? borderRadius;
}
