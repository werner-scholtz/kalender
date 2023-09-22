import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the month grid.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context).colorScheme.surfaceVariant;
    final thickness =
        CalendarStyleProvider.of(context).style.monthGridStyle?.thickness ?? 0;

    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 8; i++)
              VerticalDivider(
                width: thickness,
                thickness: thickness,
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
              ),
          ],
        ),
      ],
    );
  }
}
