import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
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

    final tooltip = weekNumberStyle.tooltip ?? 'Week Number';

    final visualDensity =
        weekNumberStyle.visualDensity ?? VisualDensity.comfortable;

    final textStyle =
        weekNumberStyle.textStyle ?? Theme.of(context).textTheme.bodyMedium;

    final (start, end) = visibleDateRange.weekNumbers;
    final weekNumber = start.toString() + ((end == null) ? '' : ' - $end');

    return IconButton.filledTonal(
      tooltip: tooltip,
      onPressed: null,
      visualDensity: visualDensity,
      icon: Text(
        weekNumber,
        style: textStyle,
      ),
    );
  }
}
