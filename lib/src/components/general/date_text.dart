import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget that displays the abbreviated day of the week. ('EEE')
class DateText extends StatelessWidget {
  const DateText({
    super.key,
    required this.date,
    required this.textStyle,
    required this.dateFormat,
    required this.upperCase,
  });

  /// The date to display.
  final DateTime date;

  /// The date format used to display the date.
  final String dateFormat;

  /// The [TextStyle] used to display the date.
  final TextStyle? textStyle;

  /// Whether the date should be displayed in upper case.
  final bool upperCase;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(dateFormat).format(date);

    return Text(
      upperCase ? formattedDate.toUpperCase() : formattedDate,
      style: textStyle,
    );
  }
}
