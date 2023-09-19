import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';

/// A [IconButton] that displays the date.
/// It display's [IconButton] when the date is not today and [IconButton.filledTonal] when the date is today.
class DateIconButton extends StatelessWidget {
  const DateIconButton({
    super.key,
    required this.date,
    required this.onTapped,
    this.textStyle,
    this.visualDensity,
  });

  /// The date to display.
  final DateTime date;

  /// The callback function that is called when the button is tapped.
  final void Function(DateTime date) onTapped;

  /// The [TextStyle] used to display the date.
  final TextStyle? textStyle;

  /// The [VisualDensity] used by the [IconButton] widget.
  final VisualDensity? visualDensity;

  @override
  Widget build(BuildContext context) {
    return date.isToday
        ? IconButton.filledTonal(
            onPressed: () => onTapped(date),
            visualDensity: visualDensity,
            icon: Text(
              date.day.toString(),
              style: textStyle,
            ),
          )
        : IconButton(
            onPressed: () => onTapped(date),
            visualDensity: visualDensity,
            icon: Text(
              date.day.toString(),
              style: textStyle,
            ),
          );
  }
}
