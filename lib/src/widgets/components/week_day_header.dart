import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The week day header builder.
///
/// The [date] is the date that the header will be displayed for.
/// The [style] is used to style the week day header.
typedef WeekDayHeaderBuilder = Widget Function(
  DateTime date,
  WeekDayHeaderStyle? style,
);

/// The [WeekDayHeaderStyle] class is used by the default [WeekDayHeader] widget.
class WeekDayHeaderStyle {
  const WeekDayHeaderStyle({
    this.textStyle,
    this.padding,
    this.stringBuilder,
  });

  /// The [TextStyle] used by the [DateText] widget to display the day of the week.
  final TextStyle? textStyle;

  /// Use this function to customize the sting displayed by the [WeekDayHeader].
  final String Function(DateTime date)? stringBuilder;

  /// The padding around the [WeekDayHeader] widget.
  final EdgeInsets? padding;
}

/// A widget that displays the name of the day of the week.
class WeekDayHeader extends StatelessWidget {
  /// The date to display.
  final DateTime date;

  /// The style used by the [WeekDayHeader].
  final WeekDayHeaderStyle? style;

  const WeekDayHeader({super.key, required this.date, this.style});
  static WeekDayHeader builder(DateTime date, WeekDayHeaderStyle? style) {
    return WeekDayHeader(date: date, style: style);
  }

  @override
  Widget build(BuildContext context) {
    final padding = style?.padding ?? const EdgeInsets.symmetric(vertical: 2);
    final textStyle = style?.textStyle ?? Theme.of(context).textTheme.bodySmall;
    final dateText = style?.stringBuilder?.call(date) ?? date.dayNameLocalized(context.locale);
    return Padding(
      padding: padding,
      child: Center(
        child: Text(
          dateText,
          style: textStyle,
        ),
      ),
    );
  }
}
