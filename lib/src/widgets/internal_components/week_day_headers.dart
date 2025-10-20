import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A row of weekday headers for a week in the month view.
class WeekDayHeaders<T> extends StatelessWidget {
  final List<DateTime> dates;
  const WeekDayHeaders({super.key, required this.dates});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: dates.map((date) => MonthDayHeader.fromContext<T>(context, date)).toList(),
    );
  }
}
