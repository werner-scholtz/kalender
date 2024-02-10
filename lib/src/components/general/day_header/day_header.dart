import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalender/src/components/general/date_icon_button.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the day of the week and the day number.
class DayHeader extends StatelessWidget {
  const DayHeader({
    super.key,
    required this.date,
    required this.onTapped,
  });

  final DateTime date;
  final Function(DateTime date)? onTapped;

  @override
  Widget build(BuildContext context) {
    final dayHeaderStyle =
        CalendarStyleProvider.of(context).style.dayHeaderStyle;
    final dateFormat = DateFormat(dayHeaderStyle.dateFormat);
    return Container(
      decoration: BoxDecoration(
        color: dayHeaderStyle.backgroundColor,
        borderRadius: dayHeaderStyle.borderRadius,
      ),
      child: Column(
        children: <Widget>[
          Text(
            dateFormat.format(date),
            style: dayHeaderStyle.textStyle ??
                Theme.of(context).textTheme.bodySmall,
          ),
          DateIconButton(
            date: date,
            onTapped: (date) => onTapped?.call(date),
            textStyle: dayHeaderStyle.buttonTextStyle ??
                Theme.of(context).textTheme.bodySmall,
            visualDensity:
                dayHeaderStyle.buttonVisualDensity ?? VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
