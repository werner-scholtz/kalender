import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/date_icon_button.dart';
import 'package:kalender/src/models/calendar/calendar_style.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

import 'package:kalender/src/providers/calendar_style.dart';

class MonthCellHeaderStyle {
  const MonthCellHeaderStyle({
    this.visualDensity,
    this.textStyle,
  });

  final TextStyle? textStyle;

  final VisualDensity? visualDensity;
}

/// A widget that displays the date.
class MonthCellHeader<T> extends StatelessWidget {
  const MonthCellHeader({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of<T>(context);
    CalendarStyle style = CalendarStyleProvider.of(context).style;
    return DateIconButton(
      date: date,
      onTapped: (DateTime date) => scope.functions.onDateTapped?.call(date),
      visualDensity: style.monthCellHeaderStyle?.visualDensity ?? VisualDensity.compact,
      textStyle: style.monthCellHeaderStyle?.textStyle,
    );
  }
}
