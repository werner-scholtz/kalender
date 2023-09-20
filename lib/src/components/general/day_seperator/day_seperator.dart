import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the day seperators.
class DaySeparator extends StatelessWidget {
  const DaySeparator({
    super.key,
    required this.numberOfDays,
  });

  /// The number of days.
  ///
  /// This is used to determine the number of day separators to display.
  final int numberOfDays;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (int i = 0; i < numberOfDays; i++)
          Container(
            width: CalendarStyleProvider.of(context)
                    .style
                    .daySeparatorStyle
                    ?.thickness ??
                1,
            color: CalendarStyleProvider.of(context)
                    .style
                    .daySeparatorStyle
                    ?.color ??
                Theme.of(context).colorScheme.surfaceVariant,
          ),
        const SizedBox.shrink(),
      ],
    );
  }
}
