import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The day header builder.
///
/// The [date] is the date that the header will be displayed for.
/// The [style] is used to style the day header.
typedef DayHeaderBuilder = Widget Function(
  InternalDateTime date,
  DayHeaderStyle? style,
);

/// The styling class for the [DayHeader].
///
/// This class allows you to customize the appearance of the [DayHeader] widget.
/// You can change the text style, the string displayed, the number text style, and the alignment.
class DayHeaderStyle {
  /// The [TextStyle] used by the [DayHeader] widget to display the name of the day.
  final TextStyle? textStyle;

  /// The [TextStyle] used by the [DayHeader] widget to display the day number of the week.
  final TextStyle? numberTextStyle;

  /// The main axis alignment of the [DayHeader].
  final MainAxisAlignment? mainAxisAlignment;

  /// Use this function to customize the string used for the day number.
  ///
  /// By default, the [DateTime.day] is used to get the day number.
  final String Function(DateTime date)? numberStringBuilder;

  /// Use this function to customize the sting displayed under the day number.
  ///
  /// By default, the [DateTimeExtensions.dayNameShortLocalized] is used to get the short name of the day in the current locale.
  final String Function(DateTime date)? stringBuilder;

  /// Creates a new [DayHeaderStyle].
  const DayHeaderStyle({
    this.textStyle,
    this.numberTextStyle,
    this.mainAxisAlignment,
    this.numberStringBuilder,
    this.stringBuilder,
  });
}

/// A widget that displays the name of the day and the day number of the week.
class DayHeader extends StatelessWidget {
  /// The date that will be displayed in the [DayHeader].
  final InternalDateTime date;

  /// The style of the [DayHeader].
  final DayHeaderStyle? style;

  /// Create a new [DayHeader].
  ///
  /// The [date] is the date that will be displayed.
  /// The [style] is the style of the [DayHeader].
  const DayHeader({super.key, required this.date, this.style});

  /// The default builder for the [DayHeader].
  static DayHeader builder(InternalDateTime date, DayHeaderStyle? style) => DayHeader(date: date, style: style);

  static Widget fromContext(BuildContext context, InternalDateTime date) {
    final dayHeaderBuilder = context.components().multiDayComponents.headerComponents.dayHeaderBuilder;
    final dayHeaderStyle = context.components().multiDayComponentStyles.headerStyles.dayHeaderStyle;
    return dayHeaderBuilder.call(date, dayHeaderStyle);
  }

  @override
  Widget build(BuildContext context) {
    final numberText = Text(
      style?.numberStringBuilder?.call(date) ?? date.day.toString(),
      style: style?.numberTextStyle ?? Theme.of(context).textTheme.bodyMedium,
    );

    final button = date.isToday
        ? IconButton.filled(onPressed: null, icon: numberText, visualDensity: VisualDensity.compact)
        : IconButton(onPressed: null, icon: numberText, visualDensity: VisualDensity.compact);

    final dayName = Text(
      style?.stringBuilder?.call(date) ?? date.dayNameShortLocalized(context.locale),
      style: style?.textStyle ?? Theme.of(context).textTheme.bodySmall,
    );

    return Center(
      child: Column(
        mainAxisAlignment: style?.mainAxisAlignment ?? MainAxisAlignment.start,
        children: [button, dayName],
      ),
    );
  }
}
