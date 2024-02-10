import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final monthHeaderStyle =
        CalendarStyleProvider.of(context).style.monthHeaderStyle;

    final padding =
        monthHeaderStyle.padding ?? const EdgeInsets.symmetric(vertical: 2);
    final textStyle =
        monthHeaderStyle.textStyle ?? Theme.of(context).textTheme.bodySmall;
    final upperCase = monthHeaderStyle.useUpperCase ?? false;

    final dateFormat = DateFormat(monthHeaderStyle.dateFormat);
    var text = dateFormat.format(date);
    if (upperCase) {
      text = text.toUpperCase();
    }

    return Padding(
      padding: padding,
      child: Center(
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
