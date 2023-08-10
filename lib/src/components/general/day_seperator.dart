import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class DaySeperatorStyle {
  const DaySeperatorStyle({
    this.thickness,
    this.color,
  });

  /// The thickness of the day seperator.
  final double? thickness;

  /// The day seperator color.
  final Color? color;
}

/// A widget that displays the day seperators.
class DaySeperator extends StatelessWidget {
  const DaySeperator({
    super.key,
    required this.pageHeight,
    required this.dayWidth,
    required this.numberOfDays,
  });

  /// The height of the page.
  ///
  /// This is used as the height of the day seperator.
  final double pageHeight;

  /// The width of a day.
  ///
  /// This is used as the spacing between the day seperators.
  final double dayWidth;

  /// The number of days.
  ///
  /// This is used to determine the number of day seperators to display.
  final int numberOfDays;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < numberOfDays; i++)
          SizedBox(
            width: dayWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: pageHeight,
                  width: CalendarStyleProvider.of(context)
                          .style
                          .daySeperatorStyle
                          ?.thickness ??
                      1,
                  color: CalendarStyleProvider.of(context)
                          .style
                          .daySeperatorStyle
                          ?.color ??
                      Theme.of(context).colorScheme.surfaceVariant,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
