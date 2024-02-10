import 'package:flutter/material.dart';

/// The [DayHeaderStyle] class is used by the default [DayHeader] widget.
class DayHeaderStyle {
  const DayHeaderStyle({
    this.textStyle,
    this.buttonTextStyle,
    this.buttonVisualDensity,
    this.useUpperCase,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.dateFormat = 'E',
  });

  /// The [TextStyle] used by the [DayHeader] widget to display the day of the week.
  final TextStyle? textStyle;

  /// DateFormat from the intl package.
  /// ex. 'E' for short day of the week, 'EEEE' for long day of the week.
  final String dateFormat;

  /// Whether the day of the week should be displayed in upper case.
  final bool? useUpperCase;

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
