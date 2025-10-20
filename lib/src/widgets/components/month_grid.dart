import 'package:flutter/material.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The month grid builder.
///
/// The [style] is used to style the month grid.
typedef MonthGridBuilder = Widget Function(
  MonthGridStyle? style,
  int numberOfRows,
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

  const MonthGrid({super.key, this.style, required this.numberOfRows});
  static MonthGrid builder(MonthGridStyle? style, int numberOfRows) {
    return MonthGrid(style: style, numberOfRows: numberOfRows);
  }

  static Widget fromContext<T extends Object?>(BuildContext context, int numberOfRows) {
    final components = context.components<T>();
    final component = components.monthComponents.bodyComponents.monthGridBuilder;
    final style = components.monthComponentStyles.bodyStyles.monthGridStyle;
    return component.call(style, numberOfRows);
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
