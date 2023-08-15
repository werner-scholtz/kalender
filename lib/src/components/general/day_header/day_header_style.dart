import 'package:flutter/material.dart';

/// The [DayHeaderStyle] class is used by the default [DayHeader] widget.
class DayHeaderStyle {
  const DayHeaderStyle({
    this.textStyle,
    this.buttonTextStyle,
    this.buttonVisualDensity,
    this.useUpperCase,
    this.padding,
  });

  /// The [TextStyle] used by the [DateText] widget to display the day of the week.
  final TextStyle? textStyle;

  /// Whether the day of the week should be displayed in upper case.
  final bool? useUpperCase;

  /// The [TextStyle] used by the [DateIconButton] widget to display the day number.
  final TextStyle? buttonTextStyle;

  /// The [VisualDensity] used by the [DateIconButton] widget.
  final VisualDensity? buttonVisualDensity;

  /// The padding around the [DayHeader] widget.
  final EdgeInsets? padding;
}
