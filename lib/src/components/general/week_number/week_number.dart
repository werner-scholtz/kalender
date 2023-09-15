import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the week number.
class WeekNumber extends StatelessWidget {
  const WeekNumber({
    super.key,
    required this.visibleDateRange,
  });

  final DateTimeRange visibleDateRange;

  @override
  Widget build(BuildContext context) {
    final weekNumberStyle =
        CalendarStyleProvider.of(context).style.weekNumberStyle;
    return IconButton.filledTonal(
      tooltip: weekNumberStyle?.tooltip ?? 'Week Number',
      onPressed: null,
      visualDensity: weekNumberStyle?.visualDensity ?? VisualDensity.compact,
      icon: Text(
        visibleDateRange.start.startOfWeek.weekOfYear.toString(),
        style: weekNumberStyle?.textStyle ??
            Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
