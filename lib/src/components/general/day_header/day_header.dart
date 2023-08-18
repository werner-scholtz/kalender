import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/date_icon_button.dart';
import 'package:kalender/src/components/general/date_text.dart';
import 'package:kalender/src/components/general/day_header/day_header_style.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the day of the week and the day number.
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
    DayHeaderStyle? dayHeaderStyle =
        CalendarStyleProvider.of(context).style.dayHeaderStyle;
    return Container(
      decoration: BoxDecoration(
        color: dayHeaderStyle?.backgroundColor,
        borderRadius: dayHeaderStyle?.borderRadius,
      ),
      child: Padding(
        padding:
            dayHeaderStyle?.padding ?? const EdgeInsets.symmetric(vertical: 4),
        child: Center(
          child: Column(
            children: <Widget>[
              DateText(
                date: date,
                textStyle: dayHeaderStyle?.textStyle ??
                    Theme.of(context).textTheme.bodySmall,
                upperCase: dayHeaderStyle?.useUpperCase ?? false,
              ),
              RepaintBoundary(
                child: DateIconButton(
                  date: date,
                  onTapped: (DateTime date) => onTapped?.call(date),
                  textStyle: dayHeaderStyle?.buttonTextStyle ??
                      Theme.of(context).textTheme.bodyLarge,
                  visualDensity: dayHeaderStyle?.buttonVisualDensity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
