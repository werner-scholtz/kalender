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

  /// Creates a copy of this style with the given fields replaced with the new values.
  MonthDayHeaderStyle copyWith({
    TextStyle? textStyle,
    String Function(DateTime date)? stringBuilder,
    TextStyle? numberTextStyle,
  }) {
    return MonthDayHeaderStyle(
      textStyle: textStyle ?? this.textStyle,
      stringBuilder: stringBuilder ?? this.stringBuilder,
      numberTextStyle: numberTextStyle ?? this.numberTextStyle,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  MonthDayHeaderStyle merge(MonthDayHeaderStyle? other) {
    if (other == null) return this;
    return MonthDayHeaderStyle(
      textStyle: other.textStyle ?? textStyle,
      stringBuilder: other.stringBuilder ?? stringBuilder,
      numberTextStyle: other.numberTextStyle ?? numberTextStyle,
    );
  }

  /// Linearly interpolates between [a] and [b]. Fields that cannot be interpolated switch at the midpoint.
  static MonthDayHeaderStyle? lerp(MonthDayHeaderStyle? a, MonthDayHeaderStyle? b, double t) {
    if (identical(a, b)) return a;
    return MonthDayHeaderStyle(
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      stringBuilder: t < 0.5 ? a?.stringBuilder : b?.stringBuilder,
      numberTextStyle: TextStyle.lerp(a?.numberTextStyle, b?.numberTextStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthDayHeaderStyle &&
        other.textStyle == textStyle &&
        other.stringBuilder == stringBuilder &&
        other.numberTextStyle == numberTextStyle;
  }

  @override
  int get hashCode => Object.hash(textStyle, stringBuilder, numberTextStyle);
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
    final style = (KalenderTheme.of(context).monthDayHeaderStyle ?? const MonthDayHeaderStyle()).merge(this.style);
    final localDate = InternalDateTime.fromExternal(date, location: context.location);
    final isToday = context.isToday(localDate);
    final button = isToday
        ? IconButton.filled(
            key: todayKey,
            onPressed: null,
            icon: Text(
              date.day.toString(),
              style: style.numberTextStyle,
            ),
            visualDensity: VisualDensity.compact,
          )
        : IconButton(
            onPressed: null,
            icon: Text(
              date.day.toString(),
              style: style.numberTextStyle,
            ),
            visualDensity: VisualDensity.compact,
          );

    return button;
  }
}
