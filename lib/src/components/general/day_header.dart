import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/date_icon_button.dart';
import 'package:kalender/src/components/general/date_text.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

class DayHeaderStyle {
  const DayHeaderStyle({
    this.textStyle,
    this.buttonTextStyle,
    this.buttonVisualDensity,
    this.dateFormat,
    this.useUpperCase,
    this.padding,
  });

  /// The [TextStyle] used by the [DateText] widget to display the day of the week.
  final TextStyle? textStyle;

  /// The date format used by the [DateText] widget to display the day of the week.
  final String? dateFormat;

  /// Whether the day of the week should be displayed in upper case.
  final bool? useUpperCase;

  /// The [TextStyle] used by the [DateIconButton] widget to display the day number.
  final TextStyle? buttonTextStyle;

  /// The [VisualDensity] used by the [DateIconButton] widget.
  final VisualDensity? buttonVisualDensity;

  /// The padding around the [DayHeader] widget.
  final EdgeInsets? padding;
}

class DayHeader extends StatelessWidget {
  const DayHeader({
    super.key,
    required this.date,
    required this.onTapped,
  });

  final DateTime date;
  final Function(DateTime date)? onTapped;

  @override
  Widget build(BuildContext context) {
    DayHeaderStyle? dayHeaderStyle = CalendarInternals.of(context).style.dayHeaderStyle;
    return Padding(
      padding: dayHeaderStyle?.padding ?? const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Column(
          children: <Widget>[
            DateText(
              date: date,
              textStyle: dayHeaderStyle?.textStyle ?? Theme.of(context).textTheme.bodySmall,
              dateFormat: dayHeaderStyle?.dateFormat ?? 'EEE',
              upperCase: dayHeaderStyle?.useUpperCase ?? false,
            ),
            RepaintBoundary(
              child: DateIconButton(
                date: date,
                onTapped: (DateTime date) => onTapped?.call(date),
                textStyle: dayHeaderStyle?.buttonTextStyle ?? Theme.of(context).textTheme.bodyLarge,
                visualDensity: dayHeaderStyle?.buttonVisualDensity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
