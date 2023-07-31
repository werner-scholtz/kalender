import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/date_icon_button.dart';
import 'package:kalender/src/models/calendar/calendar_style.dart';
import 'package:kalender/src/providers/calendar_internals.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class MonthCellHeaderStyle {
  const MonthCellHeaderStyle({
    this.visualDensity,
    this.textStyle,
  });

  final TextStyle? textStyle;

  final VisualDensity? visualDensity;
}

class MonthCellHeader<T extends Object?> extends StatelessWidget {
  const MonthCellHeader({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    CalendarInternals<T> internals = CalendarInternals.of<T>(context);
    CalendarStyle style = CalendarStyleProvider.of(context).style;
    return DateIconButton(
      date: date,
      onTapped: (DateTime date) => internals.functions.onDateTapped?.call(date),
      visualDensity: style.monthCellHeaderStyle?.visualDensity,
      textStyle: style.monthCellHeaderStyle?.textStyle,
    );
  }
}
