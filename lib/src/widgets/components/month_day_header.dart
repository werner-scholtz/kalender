import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';

/// The style of the [MonthDayHeader].
class MonthDayHeaderStyle {
  /// Creates a new [MonthDayHeaderStyle].
  const MonthDayHeaderStyle({
    this.textStyle,
    this.stringBuilder,
    this.numberTextStyle,
  });

  /// The [TextStyle] used by the [MonthDayHeader] widget to display the name of the day.
  final TextStyle? textStyle;

  /// Use this function to customize the sting displayed by the [MonthDayHeader].
  final String Function(DateTime date)? stringBuilder;

  /// The [TextStyle] used by the [MonthDayHeader] widget to display the day number of the week.
  final TextStyle? numberTextStyle;
}

/// A widget that displays the day number.
class MonthDayHeader extends StatelessWidget {
  final DateTime date;
  final MonthDayHeaderStyle? style;

  const MonthDayHeader({
    super.key,
    required this.date,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final button = date.isToday
        ? IconButton.filled(
            onPressed: null,
            icon: Text(
              date.day.toString(),
              style: style?.numberTextStyle,
            ),
            visualDensity: VisualDensity.compact,
          )
        : IconButton(
            onPressed: null,
            icon: Text(
              date.day.toString(),
              style: style?.numberTextStyle,
            ),
            visualDensity: VisualDensity.compact,
          );

    return button;
  }
}
