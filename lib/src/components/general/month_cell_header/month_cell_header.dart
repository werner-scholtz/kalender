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

    final decoration = BoxDecoration(
      color: style.monthCellHeaderStyle.backgroundColor,
      borderRadius: style.monthCellHeaderStyle.borderRadius,
    );
    final visualDensity =
        style.monthCellHeaderStyle.visualDensity ?? VisualDensity.compact;
    final textStyle = style.monthCellHeaderStyle.textStyle;
    return DecoratedBox(
      decoration: decoration,
      child: DateIconButton(
        date: date,
        onTapped: (date) => onTapped?.call(date),
        visualDensity: visualDensity,
        textStyle: textStyle,
      ),
    );
  }
}
