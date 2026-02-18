import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The month day header builder.
typedef MonthDayHeaderBuilder = Widget Function(
  InternalDateTime date,
  MonthDayHeaderStyle? style,
);

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
  final InternalDateTime date;
  final MonthDayHeaderStyle? style;

  const MonthDayHeader({super.key, required this.date, this.style});
  static MonthDayHeader builder(InternalDateTime date, MonthDayHeaderStyle? style) {
    return MonthDayHeader(date: date, style: style);
  }

  static Widget fromContext<T extends Object?>(BuildContext context, InternalDateTime date) {
    final components = context.components<T>();
    final dayHeader = components.monthComponents.bodyComponents.monthDayHeaderBuilder;
    final style = components.monthComponentStyles.bodyStyles.monthDayHeaderStyle;
    return dayHeader(date, style);
  }

  @override
  Widget build(BuildContext context) {
    final button = date.isToday(location: context.location)
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
