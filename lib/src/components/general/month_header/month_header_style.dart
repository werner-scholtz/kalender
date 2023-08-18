import 'package:flutter/material.dart';

/// The [MonthHeaderStyle] class is used by the default [MonthHeader] widget.
class MonthHeaderStyle {
  const MonthHeaderStyle({
    this.textStyle,
    this.padding,
    this.useUpperCase,
  });

  /// The [TextStyle] used by the [DateText] widget to display the day of the week.
  final TextStyle? textStyle;

  /// Whether the day of the week should be displayed in upper case.
  final bool? useUpperCase;

  /// The padding around the [MonthHeader] widget.
  final EdgeInsets? padding;
}
