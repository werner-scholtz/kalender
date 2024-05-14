import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';

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

  /// The tooltip used by the [WeekNumber] widget.
  final String? tooltip;
}

class WeekNumber extends StatelessWidget {
  final DateTimeRange visibleDateTimeRange;

  final WeekNumberStyle? weekNumberStyle;

  const WeekNumber({
    super.key,
    required this.visibleDateTimeRange,
    this.weekNumberStyle,
  });

  @override
  Widget build(BuildContext context) {
    final tooltip = weekNumberStyle?.tooltip ?? 'Week Number';

    final visualDensity =
        weekNumberStyle?.visualDensity ?? VisualDensity.compact;

    final textStyle =
        weekNumberStyle?.textStyle ?? Theme.of(context).textTheme.bodyMedium;

    final (start, end) = visibleDateTimeRange.weekNumbers;
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
