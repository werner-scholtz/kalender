import 'package:flutter/material.dart';

/// A row of weekday headers for a week in the month view.
class WeekDayHeaders<T> extends StatelessWidget {
  final List<DateTime> dates;
  final Widget Function(BuildContext context, DateTime date) dayHeaderBuilder;
  const WeekDayHeaders({super.key, required this.dates, required this.dayHeaderBuilder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dates
              .map(
                (date) => SizedBox(
                  width: constraints.maxWidth / dates.length,
                  child: dayHeaderBuilder.call(context, date),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
