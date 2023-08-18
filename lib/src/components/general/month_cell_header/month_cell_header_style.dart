import 'package:flutter/material.dart';

/// The [MonthCellHeaderStyle] class is used by the default [MonthCellHeader] widget.
class MonthCellHeaderStyle {
  const MonthCellHeaderStyle({
    this.visualDensity,
    this.textStyle,
  });

  final TextStyle? textStyle;

  final VisualDensity? visualDensity;
}
