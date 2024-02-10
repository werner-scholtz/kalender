import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the month grid.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final style = CalendarStyleProvider.of(context).style.monthGridStyle;
    final thickness = style.thickness ?? 0;
    final color = style.color;

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
