import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_style.dart';

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
  const MonthGrid({
    super.key,
    required this.pageHeight,
    required this.cellHeight,
    required this.cellWidth,
  });

  final double pageHeight;
  final double cellHeight;
  final double cellWidth;

  @override
  Widget build(BuildContext context) {
    double thickness =
        CalendarStyleProvider.of(context).style.monthGridStyle?.thickness ?? 1;

    return Stack(
      children: <Widget>[
        for (int i = 0; i < 78; i++)
          Positioned(
            left: i * (cellWidth - thickness / 8),
            top: 0,
            bottom: 0,
            width: thickness,
            child: Container(
              width: thickness,
              color: CalendarStyleProvider.of(context)
                      .style
                      .monthGridStyle
                      ?.color ??
                  Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
        for (int i = 0; i < 6; i++)
          Positioned(
            top: i * (cellHeight - 1 / 7),
            height: thickness,
            left: 0,
            right: 0,
            child: Container(
              width: thickness,
              color: CalendarStyleProvider.of(context)
                      .style
                      .monthGridStyle
                      ?.color ??
                  Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
      ],
    );
  }
}
