import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The month grid builder.
///
/// The [style] is used to style the month grid.
///
/// The [visibleDateTimeRange] is the full range the grid covers — including the
/// leading and trailing days from adjacent months — as a wall-clock
/// [DateTimeRange] in the calendar's configured location (via `.forLocation()`).
/// Together with [numberOfRows] (there are always 7 columns per row) it lets a
/// builder resolve the date of every cell, e.g. to style days that fall outside
/// the focused month. See #140.
typedef MonthGridBuilder = Widget Function(
  MonthGridStyle? style,
  int numberOfRows,
  DateTimeRange visibleDateTimeRange,
);

/// The [MonthGridStyle] class is used by the [MonthGrid] widget.
class MonthGridStyle {
  const MonthGridStyle({
    this.color,
    this.thickness,
  });

  /// The color of the month grid lines.
  final Color? color;

  /// The thickness of the month grid lines.
  final double? thickness;
}

/// A widget that displays the month grid.
class MonthGrid extends StatelessWidget {
  final MonthGridStyle? style;
  final int numberOfRows;

  /// The full range the grid covers, including adjacent-month days. Exposed to
  /// custom builders via [MonthGridBuilder]; the default grid does not use it.
  final DateTimeRange visibleDateTimeRange;

  const MonthGrid({
    super.key,
    this.style,
    required this.numberOfRows,
    required this.visibleDateTimeRange,
  });
  static MonthGrid builder(MonthGridStyle? style, int numberOfRows, DateTimeRange visibleDateTimeRange) {
    return MonthGrid(style: style, numberOfRows: numberOfRows, visibleDateTimeRange: visibleDateTimeRange);
  }

  static Widget fromContext(BuildContext context, int numberOfRows, InternalDateTimeRange visibleDateTimeRange) {
    final components = context.components;
    final component = components.monthComponents.bodyComponents.monthGridBuilder;
    final style = components.monthComponentStyles.bodyStyles.monthGridStyle;
    return component.call(style, numberOfRows, visibleDateTimeRange.forLocation(location: context.location));
  }

  @override
  Widget build(BuildContext context) {
    final thickness = style?.thickness ?? 0;
    final color = style?.color ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 8; i++)
              VerticalDivider(
                width: thickness,
                thickness: thickness,
                color: color,
              ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < numberOfRows + 1; i++)
              Divider(
                height: thickness,
                thickness: thickness,
                color: color,
              ),
          ],
        ),
      ],
    );
  }
}
