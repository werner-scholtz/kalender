import 'package:flutter/material.dart';

/// The [MonthCellHeaderStyle] class is used by the default [MonthCellHeader] widget.
class MonthCellHeaderStyle {
  const MonthCellHeaderStyle({
    this.visualDensity,
    this.textStyle,
    this.backgroundColor,
    this.borderRadius,
  });

  final TextStyle? textStyle;

  final VisualDensity? visualDensity;

  /// The background color of the [MonthCellHeaderStyle] widget.
  final Color? backgroundColor;

  /// The border radius of the [MonthCellHeaderStyle] widget.
  final BorderRadius? borderRadius;
}
