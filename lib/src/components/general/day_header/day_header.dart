import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/date_icon_button.dart';
import 'package:kalender/src/extensions.dart';
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
    final style = CalendarStyleProvider.of(context).style.dayHeaderStyle;

    final decoration = BoxDecoration(
      color: style.backgroundColor,
      borderRadius: style.borderRadius,
    );

    final dateText = style.stringBuilder?.call(date) ?? date.englishDayName;
    final dateTextStyle =
        style.textStyle ?? Theme.of(context).textTheme.bodySmall;

    final dateIconButtonTextStyle =
        style.buttonTextStyle ?? Theme.of(context).textTheme.bodySmall;
    final dateIconButtonVisualDensity =
        style.buttonVisualDensity ?? VisualDensity.compact;

    return Container(
      decoration: decoration,
      child: Column(
        children: <Widget>[
          Text(
            dateText,
            style: dateTextStyle,
          ),
          DateIconButton(
            date: date,
            onTapped: (date) => onTapped?.call(date),
            textStyle: dateIconButtonTextStyle,
            visualDensity: dateIconButtonVisualDensity,
          ),
        ],
      ),
    );
  }
}
