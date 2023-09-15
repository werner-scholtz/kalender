import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/date_icon_button.dart';

import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the date in the month cell header.
class MonthCellHeader extends StatelessWidget {
  const MonthCellHeader({
    super.key,
    required this.date,
    this.onTapped,
  });

  final DateTime date;
  final void Function(DateTime date)? onTapped;

  @override
  Widget build(BuildContext context) {
    final style = CalendarStyleProvider.of(context).style;
    return Container(
      decoration: BoxDecoration(
        color: style.monthCellHeaderStyle?.backgroundColor,
        borderRadius: style.monthCellHeaderStyle?.borderRadius,
      ),
      child: DateIconButton(
        date: date,
        onTapped: (date) => onTapped?.call(date),
        visualDensity:
            style.monthCellHeaderStyle?.visualDensity ?? VisualDensity.compact,
        textStyle: style.monthCellHeaderStyle?.textStyle,
      ),
    );
  }
}
