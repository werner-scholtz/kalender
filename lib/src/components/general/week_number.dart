import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class WeekNumberStyle {
  const WeekNumberStyle({
    this.textStyle,
    this.visualDensity,
    this.tooltip,
  });

  /// The [TextStyle] used by the [WeekNumber] widget to display the week number.
  final TextStyle? textStyle;

  /// The [VisualDensity] used by the [WeekNumber] widget.
  final VisualDensity? visualDensity;

  /// The tooltip displayed when the [WeekNumber] widget is long pressed/hovered.
  final String? tooltip;
}

class WeekNumber extends StatelessWidget {
  const WeekNumber({
    super.key,
    required this.visibleDateRange,
  });

  final DateTimeRange visibleDateRange;

  @override
  Widget build(BuildContext context) {
    WeekNumberStyle? weekNumberStyle =
        CalendarStyleProvider.of(context).style.weekNumberStyle;
    return IconButton.filledTonal(
      tooltip: weekNumberStyle?.tooltip ?? 'Week Number',
      onPressed: null,
      visualDensity: weekNumberStyle?.visualDensity ?? VisualDensity.compact,
      icon: Text(
        visibleDateRange.start.startOfWeek.weekNumber.toString(),
        style: weekNumberStyle?.textStyle ??
            Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
