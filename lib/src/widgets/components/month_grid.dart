import 'package:flutter/material.dart';

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

  const MonthGrid({
    super.key,
    this.style,
  });

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
            for (int i = 0; i < 6; i++)
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
