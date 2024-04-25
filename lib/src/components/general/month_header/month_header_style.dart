import 'package:flutter/material.dart';

/// The [MonthHeaderStyle] class is used by the default [MonthHeader] widget.
class MonthHeaderStyle {
  const MonthHeaderStyle({
    this.textStyle,
    this.padding,
    this.stringBuilder,
  });

  /// The [TextStyle] used by the [DateText] widget to display the day of the week.
  final TextStyle? textStyle;

  /// Use this function to customize the sting displayed by the [MonthHeader].
  final String Function(DateTime date)? stringBuilder;

  /// The padding around the [MonthHeader] widget.
  final EdgeInsets? padding;
}
