import 'package:flutter/material.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// The month day header builder.
typedef MonthDayHeaderBuilder = Widget Function(
  DateTime date,
  MonthDayHeaderStyle? style,
);

/// The style of the [MonthDayHeader].
class MonthDayHeaderStyle {
  /// Creates a new [MonthDayHeaderStyle].
  const MonthDayHeaderStyle({
    this.stringBuilder,
    this.numberTextStyle,
    this.textPadding,
    this.decoration,
    this.todayDecoration,
  });

  /// Use this function to customize the sting displayed by the [MonthDayHeader].
  final String Function(DateTime date)? stringBuilder;

  /// The [TextStyle] used by the [MonthDayHeader] widget to display the day number of the week.
  final TextStyle? numberTextStyle;

  /// The padding of the text inside the [MonthDayHeader].
  final EdgeInsets? textPadding;

  /// The decoration of the [MonthDayHeader].
  final BoxDecoration? decoration;

  /// The decoration of the [MonthDayHeader] when the date is today.
  final BoxDecoration? todayDecoration;
}

/// A widget that displays the day number.
class MonthDayHeader extends StatelessWidget {
  final DateTime date;
  final MonthDayHeaderStyle? style;

  const MonthDayHeader({super.key, required this.date, this.style});
  static MonthDayHeader builder(DateTime date, MonthDayHeaderStyle? style) {
    return MonthDayHeader(date: date, style: style);
  }

  static Widget fromContext<T extends Object?>(BuildContext context, DateTime date) {
    final components = context.provider<T>().components;
    final dayHeader = components?.monthComponents?.bodyComponents?.monthDayHeaderBuilder ?? MonthDayHeader.builder;
    final style = components?.monthComponentStyles?.bodyStyles?.monthDayHeaderStyle;
    return dayHeader(date, style);
  }

  @override
  Widget build(BuildContext context) {
    final text = date.day.toString();

    final decoration = style?.decoration ??
        BoxDecoration(
          color: date.isToday
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerLow,
          shape: BoxShape.circle,
        );

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: style?.textPadding ?? const EdgeInsets.all(8.0),
        child: Text(style: style?.numberTextStyle, textAlign: TextAlign.center, text),
      ),
    );
  }
}
