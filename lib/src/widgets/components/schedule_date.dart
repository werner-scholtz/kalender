import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

// TODO: update

/// The day header builder.
///
/// The [date] is the date that the header will be displayed for.
/// The [style] is used to style the day header.
typedef ScheduleDateBuilder = Widget Function(
  InternalDateTime date,
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

  /// Creates a copy of this style with the given fields replaced with the new values.
  ScheduleDateStyle copyWith({
    TextStyle? textStyle,
    String Function(DateTime date)? stringBuilder,
    TextStyle? numberTextStyle,
  }) {
    return ScheduleDateStyle(
      textStyle: textStyle ?? this.textStyle,
      stringBuilder: stringBuilder ?? this.stringBuilder,
      numberTextStyle: numberTextStyle ?? this.numberTextStyle,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  ScheduleDateStyle merge(ScheduleDateStyle? other) {
    if (other == null) return this;
    return ScheduleDateStyle(
      textStyle: other.textStyle ?? textStyle,
      stringBuilder: other.stringBuilder ?? stringBuilder,
      numberTextStyle: other.numberTextStyle ?? numberTextStyle,
    );
  }

  /// Linearly interpolates between [a] and [b]. Fields that cannot be interpolated switch at the midpoint.
  static ScheduleDateStyle? lerp(ScheduleDateStyle? a, ScheduleDateStyle? b, double t) {
    if (identical(a, b)) return a;
    return ScheduleDateStyle(
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      stringBuilder: t < 0.5 ? a?.stringBuilder : b?.stringBuilder,
      numberTextStyle: TextStyle.lerp(a?.numberTextStyle, b?.numberTextStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleDateStyle &&
        other.textStyle == textStyle &&
        other.stringBuilder == stringBuilder &&
        other.numberTextStyle == numberTextStyle;
  }

  @override
  int get hashCode => Object.hash(textStyle, stringBuilder, numberTextStyle);
}

/// A widget that displays the name of the day and the day number of the week.
class ScheduleDate extends StatelessWidget {
  /// Key applied to the [IconButton] when the date is today.
  static const todayKey = ValueKey('ScheduleDate.today');

  final InternalDateTime date;
  final ScheduleDateStyle? style;

  /// Create a new [ScheduleDate].
  ///
  /// The [date] is the date that will be displayed.
  /// The [style] is the style of the [ScheduleDate].
  const ScheduleDate({super.key, required this.date, this.style});
  static ScheduleDate builder(InternalDateTime date, ScheduleDateStyle? style) {
    return ScheduleDate(date: date, style: style);
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(
      style?.stringBuilder?.call(date) ?? date.dayNameLocalized(context.locale).characters.take(3).toString(),
      style: style?.textStyle ?? Theme.of(context).textTheme.bodySmall,
    );

    final isToday = context.isToday(date);
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

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [text, button],
      ),
    );
  }
}
