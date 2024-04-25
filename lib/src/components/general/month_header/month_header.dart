import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader({
    super.key,
    required this.date,
  });

  /// The date to display.
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final style = CalendarStyleProvider.of(context).style.monthHeaderStyle;

    final padding = style.padding ?? const EdgeInsets.symmetric(vertical: 2);
    final textStyle = style.textStyle ?? Theme.of(context).textTheme.bodySmall;

    final dateText = style.stringBuilder?.call(date) ?? date.englishDayName;

    return Padding(
      padding: padding,
      child: Center(
        child: Text(
          dateText,
          style: textStyle,
        ),
      ),
    );
  }
}
