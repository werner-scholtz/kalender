import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';

/// The style of the [WeekNumber].
class WeekNumberStyle {
  /// Creates a new [WeekNumberStyle].
  const WeekNumberStyle({
    this.textStyle,
    this.visualDensity,
    this.tooltip,
    this.padding,
  });

  /// The [TextStyle] used by the [WeekNumber] widget to display the week number.
  final TextStyle? textStyle;

  /// The [VisualDensity] used by the [WeekNumber] widget.
  final VisualDensity? visualDensity;

  /// The tooltip used by the [WeekNumber] widget.
  final String? tooltip;

  /// The padding around by the [WeekNumber] widget.
  final EdgeInsets? padding;
}

/// A widget that displays the week number.
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

    final padding =
        weekNumberStyle?.padding ?? const EdgeInsets.symmetric(horizontal: 4);

    return Center(
      child: Padding(
        padding: padding,
        child: IconButton.filledTonal(
          tooltip: tooltip,
          onPressed: null,
          visualDensity: visualDensity,
          icon: Text(
            weekNumber,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
