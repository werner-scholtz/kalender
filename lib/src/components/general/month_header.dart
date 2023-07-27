import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/date_text.dart';
import 'package:kalender/src/providers/calendar_internals.dart';


class MonthHeaderStyle {
  const MonthHeaderStyle({
    this.textStyle,
    this.padding,
    this.dateFormat,
    this.useUpperCase,
  });

  /// The [TextStyle] used by the [DateText] widget to display the day of the week.
  final TextStyle? textStyle;

  /// The date format used by the [DateText] widget to display the day of the week.
  final String? dateFormat;

  /// Whether the day of the week should be displayed in upper case.
  final bool? useUpperCase;

  /// The padding around the [MonthCellHeader] widget.
  final EdgeInsets? padding;
}

class MonthCellHeader extends StatelessWidget {
  const MonthCellHeader({
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
    MonthHeaderStyle? monthHeaderStyle = CalendarInternals.of(context).style.monthHeaderStyle;
    return SizedBox(
      width: dayWidth,
      child: Padding(
        padding: monthHeaderStyle?.padding ?? const EdgeInsets.symmetric(vertical: 2),
        child: Center(
          child: DateText(
            date: date,
            dateFormat: monthHeaderStyle?.dateFormat ?? 'EEE',
            textStyle: monthHeaderStyle?.textStyle ?? Theme.of(context).textTheme.bodySmall,
            upperCase: monthHeaderStyle?.useUpperCase ?? false,
          ),
        ),
      ),
    );
  }
}
