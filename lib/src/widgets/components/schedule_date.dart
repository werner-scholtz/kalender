import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/providers/locale_provider.dart';

// TODO: update

/// The day header builder.
///
/// The [date] is the date that the header will be displayed for.
/// The [style] is used to style the day header.
typedef ScheduleDateBuilder = Widget Function(
  DateTime date,
  ScheduleDateStyle? style,
);

/// The style of the [ScheduleDate].
class ScheduleDateStyle {
  /// Creates a new [ScheduleDateStyle].
  const ScheduleDateStyle({
    this.textStyle,
    this.stringBuilder,
    this.numberTextStyle,
  });

  /// The [TextStyle] used by the [ScheduleDate] widget to display the name of the day.
  final TextStyle? textStyle;

  /// Use this function to customize the sting displayed by the [ScheduleDate].
  final String Function(DateTime date)? stringBuilder;

  /// The [TextStyle] used by the [ScheduleDate] widget to display the day number of the week.
  final TextStyle? numberTextStyle;
}

/// A widget that displays the name of the day and the day number of the week.
class ScheduleDate extends StatelessWidget {
  final DateTime date;
  final ScheduleDateStyle? style;

  /// Create a new [ScheduleDate].
  ///
  /// The [date] is the date that will be displayed.
  /// The [style] is the style of the [ScheduleDate].
  const ScheduleDate({super.key, required this.date, this.style});
  static ScheduleDate builder(DateTime date, ScheduleDateStyle? style) {
    return ScheduleDate(date: date, style: style);
  }

  @override
  Widget build(BuildContext context) {
    final locale = LocaleProvider.of(context);
    final text = Text(
      style?.stringBuilder?.call(date) ?? date.dayNameLocalized(locale).characters.take(3).toString(),
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
      children: [text, button],
    );
  }
}
