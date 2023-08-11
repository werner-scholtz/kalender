import 'package:flutter/material.dart';
import 'package:kalender/src/constants.dart';

/// A widget that displays the abbreviated day of the week. ('EEE')
class DateText extends StatelessWidget {
  const DateText({
    super.key,
    required this.date,
    required this.textStyle,
    required this.upperCase,
  });

  /// The date to display.
  final DateTime date;

  /// The [TextStyle] used to display the date.
  final TextStyle? textStyle;

  /// Whether the date should be displayed in upper case.
  final bool upperCase;

  @override
  Widget build(BuildContext context) {
    //format too EEE
    String formattedDate = dayOfWeek[date.weekday - 1];

    return Text(
      upperCase ? formattedDate.toUpperCase() : formattedDate,
      style: textStyle,
    );
  }
}
