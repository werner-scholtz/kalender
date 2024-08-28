import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';

/// The style of the [DayHeader].
class DayHeaderStyle {
  /// Creates a new [DayHeaderStyle].
  const DayHeaderStyle({
    this.textStyle,
    this.stringBuilder,
    this.numberTextStyle,
  });

  /// The [TextStyle] used by the [DayHeader] widget to display the name of the day.
  final TextStyle? textStyle;

  /// Use this function to customize the sting displayed by the [DayHeader].
  final String Function(DateTime date)? stringBuilder;

  /// The [TextStyle] used by the [DayHeader] widget to display the day number of the week.
  final TextStyle? numberTextStyle;
}

/// A widget that displays the name of the day and the day number of the week.
class DayHeader extends StatelessWidget {
  final DateTime date;
  final DayHeaderStyle? style;

  /// Create a new [DayHeader].
  /// 
  /// The [date] is the date that will be displayed.
  /// The [style] is the style of the [DayHeader].
  const DayHeader({
    super.key,
    required this.date,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      style?.stringBuilder?.call(date) ?? date.dayNameEnglish.characters.take(3).toString(),
      style: style?.textStyle ?? Theme.of(context).textTheme.bodySmall,
    );

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

    return Column(
      children: [
        button,
        text,
      ],
    );
  }
}
