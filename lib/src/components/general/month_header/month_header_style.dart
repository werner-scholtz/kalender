import 'package:flutter/material.dart';

/// The [MonthHeaderStyle] class is used by the default [MonthHeader] widget.
class MonthHeaderStyle {
  const MonthHeaderStyle({
    this.textStyle,
    this.padding,
    this.useUpperCase,
    this.dateFormat = 'E',
  });

  /// The [TextStyle] used by the [DateText] widget to display the day of the week.
  final TextStyle? textStyle;

  /// Whether the day of the week should be displayed in upper case.
  final bool? useUpperCase;

  /// DateFormat from the intl package.
  /// ex. 'E' for short day of the week, 'EEEE' for long day of the week.
  final String dateFormat;

  /// The padding around the [MonthHeader] widget.
  final EdgeInsets? padding;
}
