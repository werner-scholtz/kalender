import 'package:flutter/material.dart';

/// The [ScheduleMonthHeaderStyle] class is used by the default [ScheduleMonthHeader] widget.
class ScheduleMonthHeaderStyle {
  const ScheduleMonthHeaderStyle({
    this.textStyle,
    this.monthNames = const {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'Mei',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    },
    this.monthColors = const {
      1: Color(0xFFE57373),
      2: Color(0xFFF06292),
      3: Color(0xFFBA68C8),
      4: Color(0xFF9575CD),
      5: Color(0xFF7986CB),
      6: Color(0xFF64B5F6),
      7: Color(0xFF4FC3F7),
      8: Color(0xFF4DD0E1),
      9: Color(0xFF4DB6AC),
      10: Color(0xFF81C784),
      11: Color(0xFFAED581),
      12: Color(0xFFFF8A65),
    },
    this.margin = const EdgeInsets.only(top: 8),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
  });

  final Map<int, Color> monthColors;
  final Map<int, String> monthNames;
  final TextStyle? textStyle;
  final EdgeInsets margin;
  final EdgeInsets padding;
}
