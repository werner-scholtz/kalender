import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the day separators.
class DaySeparator extends StatelessWidget {
  const DaySeparator({
    super.key,
    required this.numberOfDays,
    required this.dayWidth,
  });

  /// The number of days.
  ///
  /// This is used to determine the number of day separators to display.
  final int numberOfDays;

  /// The width of a day. (rounded)
  ///
  /// This is if you want to display the day separators perfectly.
  final double dayWidth;

  @override
  Widget build(BuildContext context) {
    final style = CalendarStyleProvider.of(context).style.daySeparatorStyle;

    final width = style.thickness ?? 1;
    final color = style.color ?? Theme.of(context).colorScheme.surfaceVariant;
    return Stack(
      fit: StackFit.expand,
      children: [
        for (int i = 0; i < numberOfDays; i++)
          Positioned(
            top: 0,
            bottom: 0,
            left: (i * dayWidth + i) - (width / 2).floorToDouble(),
            child: Container(
              width: width,
              color: color,
            ),
          ),
      ],
    );
  }
}
