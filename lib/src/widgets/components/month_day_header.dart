import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The month day header builder.
///
/// The [date] is provided as a wall-clock [DateTime] in the calendar's
/// configured location (via `.forLocation()`), so consumer comparisons against
/// `DateTime.now()` behave correctly. See #248.
typedef MonthDayHeaderBuilder = Widget Function(
  DateTime date,
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
  /// Key applied to the [IconButton] when the date is today.
  static const todayKey = ValueKey('MonthDayHeader.today');

  final DateTime date;
  final MonthDayHeaderStyle? style;

  const MonthDayHeader({super.key, required this.date, this.style});
  static MonthDayHeader builder(DateTime date, MonthDayHeaderStyle? style) {
    return MonthDayHeader(date: date, style: style);
  }

  static Widget fromContext(BuildContext context, InternalDateTime date) {
    final components = context.components;
    final dayHeader = components.monthComponents.bodyComponents.monthDayHeaderBuilder;
    final style = components.monthComponentStyles.bodyStyles.monthDayHeaderStyle;
    return dayHeader(date.forLocation(location: context.location), style);
  }

  @override
  Widget build(BuildContext context) {
    final now = context.calendarController.viewController?.viewConfiguration.nowCallback?.call();
    final localDate = InternalDateTime.fromExternal(date, location: context.location);
    final isToday = now != null ? localDate.isToday(now: now) : localDate.isToday(location: context.location);
    final button = isToday
        ? IconButton.filled(
            key: todayKey,
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
