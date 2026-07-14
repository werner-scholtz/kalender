import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/theme/kalender_theme.dart';

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

  /// Creates a copy of this style with the given fields replaced with the new values.
  WeekDayHeaderStyle copyWith({
    TextStyle? textStyle,
    String Function(DateTime date)? stringBuilder,
    EdgeInsets? padding,
  }) {
    return WeekDayHeaderStyle(
      textStyle: textStyle ?? this.textStyle,
      stringBuilder: stringBuilder ?? this.stringBuilder,
      padding: padding ?? this.padding,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  WeekDayHeaderStyle merge(WeekDayHeaderStyle? other) {
    if (other == null) return this;
    return WeekDayHeaderStyle(
      textStyle: other.textStyle ?? textStyle,
      stringBuilder: other.stringBuilder ?? stringBuilder,
      padding: other.padding ?? padding,
    );
  }

  /// Linearly interpolates between [a] and [b]. Fields that cannot be interpolated switch at the midpoint.
  static WeekDayHeaderStyle? lerp(WeekDayHeaderStyle? a, WeekDayHeaderStyle? b, double t) {
    if (identical(a, b)) return a;
    return WeekDayHeaderStyle(
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      stringBuilder: t < 0.5 ? a?.stringBuilder : b?.stringBuilder,
      padding: EdgeInsets.lerp(a?.padding, b?.padding, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeekDayHeaderStyle &&
        other.textStyle == textStyle &&
        other.stringBuilder == stringBuilder &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(textStyle, stringBuilder, padding);
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
    final style = (KalenderTheme.of(context).weekDayHeaderStyle ?? const WeekDayHeaderStyle()).merge(this.style);
    final padding = style.padding ?? const EdgeInsets.symmetric(vertical: 2);
    final dateText = style.stringBuilder?.call(date) ?? date.dayNameLocalized(context.locale);
    return Padding(padding: padding, child: Center(child: Text(dateText, style: style.textStyle)));
  }
}
