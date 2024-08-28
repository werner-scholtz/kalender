import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';

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
  const WeekDayHeader({
    super.key,
    required this.date,
    this.style,
  });

  /// The date to display.
  final DateTime date;

  /// The style used by the [WeekDayHeader].
  final WeekDayHeaderStyle? style;

  @override
  Widget build(BuildContext context) {
    final padding = style?.padding ?? const EdgeInsets.symmetric(vertical: 2);
    final textStyle = style?.textStyle ?? Theme.of(context).textTheme.bodySmall;
    final dateText = style?.stringBuilder?.call(date) ?? date.dayNameEnglish;
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
