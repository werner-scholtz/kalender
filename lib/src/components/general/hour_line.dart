import 'package:flutter/material.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/providers/calendar_internals.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class HourLineStyle {
  const HourLineStyle({
    this.thickness,
    this.color,
  });

  /// The thickness of the hour line.
  final double? thickness;

  /// The hour line color.
  final Color? color;
}

class HourLine extends StatelessWidget {
  const HourLine({
    super.key,
    required this.hourlineWidth,
    required this.hourHeight,
  });

  /// The width of the hour line.
  final double hourlineWidth;

  /// The spacing between the hour lines.
  final double hourHeight;

  @override
  Widget build(BuildContext context) {
    HourLineStyle? hourLineStyle = CalendarStyleProvider.of(context).style.hourLineStyle;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: hourHeight / 2),
      child: Column(
        children: <Widget>[
          for (int i = 1; i < hoursADay; i++)
            SizedBox(
              height: hourHeight,
              child: Center(
                child: Container(
                  width: hourlineWidth,
                  height: hourLineStyle?.thickness ?? 1,
                  color: hourLineStyle?.color ?? Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
