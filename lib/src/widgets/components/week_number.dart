import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/extensions/internal.dart';

/// The week number builder.
///
/// The [visibleDateTimeRange] is the range of dates that the week number will be displayed for.
/// The [style] is used to style the week number.
typedef WeekNumberBuilder = Widget Function(
  InternalDateTimeRange visibleDateTimeRange,
  WeekNumberStyle? style,
);

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
  /// The range of dates that the week number will be displayed for.
  final InternalDateTimeRange visibleDateTimeRange;

  /// The style used by the [WeekNumber].
  final WeekNumberStyle? weekNumberStyle;

  const WeekNumber({super.key, required this.visibleDateTimeRange, this.weekNumberStyle});
  static WeekNumber builder(InternalDateTimeRange visibleDateTimeRange, WeekNumberStyle? weekNumberStyle) {
    return WeekNumber(visibleDateTimeRange: visibleDateTimeRange, weekNumberStyle: weekNumberStyle);
  }

  @override
  Widget build(BuildContext context) {
    final (start, end) = visibleDateTimeRange.weekNumbers;
    final weekNumber = start.toString() + ((end == null) ? '' : ' - $end');

    final padding = weekNumberStyle?.padding ?? const EdgeInsets.symmetric(horizontal: 4);

    return Center(
      child: Padding(
        padding: padding,
        child: IconButton.filledTonal(
          tooltip: weekNumberStyle?.tooltip ?? 'Week Number',
          onPressed: null,
          visualDensity: weekNumberStyle?.visualDensity ?? VisualDensity.compact,
          icon: Text(
            weekNumber,
            style: weekNumberStyle?.textStyle ?? Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
