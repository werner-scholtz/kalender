import 'package:flutter/material.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the hour lines.
class HourLines extends StatelessWidget {
  const HourLines({
    super.key,
    required this.hourHeight,
    required this.leftOffset,
  });

  final double hourHeight;
  final double leftOffset;

  @override
  Widget build(BuildContext context) {
    final hourLineStyle = CalendarStyleProvider.of(context).style.hourLineStyle;

    final roundedHourHeight = hourHeight.roundToDouble();
    final thickness = hourLineStyle.thickness ?? 1;
    final color =
        hourLineStyle.color ?? Theme.of(context).colorScheme.surfaceContainerHighest;

    return Stack(
      fit: StackFit.expand,
      children: [
        for (int i = 1; i < hoursADay; i++)
          Positioned(
            left: leftOffset,
            right: 0,
            height: thickness,
            top: (i * roundedHourHeight),
            child: Container(
              height: thickness,
              color: color,
            ),
          ),
      ],
    );
  }
}
