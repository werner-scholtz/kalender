import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/date_text.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the month header.
class MonthHeader extends StatelessWidget {
  const MonthHeader({
    super.key,
    required this.dayWidth,
    required this.date,
  });

  /// The width of the day cell.
  final double dayWidth;

  /// The date to display.
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final monthHeaderStyle =
        CalendarStyleProvider.of(context).style.monthHeaderStyle;
    return SizedBox(
      width: dayWidth,
      child: Padding(
        padding: monthHeaderStyle?.padding ??
            const EdgeInsets.symmetric(vertical: 2),
        child: Center(
          child: DateText(
            date: date,
            textStyle: monthHeaderStyle?.textStyle ??
                Theme.of(context).textTheme.bodySmall,
            upperCase: monthHeaderStyle?.useUpperCase ?? false,
          ),
        ),
      ),
    );
  }
}
