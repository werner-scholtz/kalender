import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/date_icon_button.dart';
import 'package:kalender/src/components/general/date_text.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

class ScheduleDateStyle {
  const ScheduleDateStyle({
    this.textStyle,
    this.buttonTextStyle,
    this.buttonVisualDensity,
    this.dateFormat,
    this.useUpperCase,
  });

  /// The [TextStyle] used by the [DateText] widget to display the date.
  final TextStyle? textStyle;

  /// The date format used by the [DateText] widget to display the date.
  final String? dateFormat;

  /// Whether the date should be displayed in upper case.
  final bool? useUpperCase;

  /// The [TextStyle] used by the [DateIconButton] widget to display the date.
  final TextStyle? buttonTextStyle;

  /// The [VisualDensity] used by the [DateIconButton] widget.
  final VisualDensity? buttonVisualDensity;
}

class ScheduleDate extends StatelessWidget {
  const ScheduleDate({
    super.key,
    required this.date,
    required this.onDateTapped,
  });

  final DateTime date;
  final void Function(DateTime date)? onDateTapped;

  @override
  Widget build(BuildContext context) {
    ScheduleDateStyle? scheduleDateStyle = CalendarInternals.of(context).style.scheduleDateStyle;
    if (CalendarInternals.of(context).configuration.isMobileDevice) {
      // If the device is mobile, the date is displayed vertically.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Center(
          child: Column(
            children: <Widget>[
              DateText(
                date: date,
                textStyle: scheduleDateStyle?.textStyle ?? Theme.of(context).textTheme.bodySmall,
                dateFormat: scheduleDateStyle?.dateFormat ?? 'EEE',
                upperCase: scheduleDateStyle?.useUpperCase ?? false,
              ),
              DateIconButton(
                date: date,
                onTapped: (DateTime date) => onDateTapped?.call(date),
                visualDensity: scheduleDateStyle?.buttonVisualDensity ?? VisualDensity.standard,
                textStyle:
                    scheduleDateStyle?.buttonTextStyle ?? Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    } else {
      // If the device is not mobile, the date is displayed horizontally.
      // The width of the widget is fixed to 108 so that the widget is a constant size.
      return SizedBox(
        width: 108,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DateIconButton(
              date: date,
              onTapped: (DateTime date) => onDateTapped?.call(date),
              visualDensity: scheduleDateStyle?.buttonVisualDensity ?? VisualDensity.compact,
              textStyle:
                  scheduleDateStyle?.buttonTextStyle ?? Theme.of(context).textTheme.bodyMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: DateText(
                date: date,
                textStyle: scheduleDateStyle?.textStyle ?? Theme.of(context).textTheme.bodySmall,
                dateFormat: scheduleDateStyle?.dateFormat ?? 'MMM, EEE',
                upperCase: scheduleDateStyle?.useUpperCase ?? true,
              ),
            ),
          ],
        ),
      );
    }
  }
}
