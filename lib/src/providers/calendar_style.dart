import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_style.dart';

/// The [InheritedWidget] that provides the calendar with the necessary styleData.
class CalendarStyleProvider extends InheritedWidget {
  const CalendarStyleProvider({
    Key? key,
    required this.style,
    required Widget child,
  }) : super(key: key, child: child);

  final CalendarStyle style;

  static CalendarStyleProvider of(BuildContext context) {
    CalendarStyleProvider? result =
        context.dependOnInheritedWidgetOfExactType<CalendarStyleProvider>();
    return result!;
  }

  @override
  bool updateShouldNotify(CalendarStyleProvider oldWidget) => false;
}
