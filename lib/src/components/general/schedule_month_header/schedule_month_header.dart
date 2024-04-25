import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class ScheduleMonthHeader extends StatelessWidget {
  const ScheduleMonthHeader({
    super.key,
    required this.date,
  });
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final style =
        CalendarStyleProvider.of(context).style.scheduleMonthHeaderStyle;
    final padding = style.padding;
    final margin = style.margin;
    final decoration = BoxDecoration(
      color: style.monthColors[date.month] ?? Colors.transparent,
    );

    final monthName = date.englishMonthName;
    final text = style.stringBuilder?.call(date) ?? '${date.year} - $monthName';
    final textStyle = style.textStyle;

    return Container(
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: Text(text, style: textStyle),
    );
  }
}
