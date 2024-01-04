import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The [InheritedWidget] that provides the calendar with the necessary styleData.
class CalendarStyleProvider extends InheritedWidget {
  const CalendarStyleProvider({
    Key? key,
    required this.style,
    required this.components,
    required Widget child,
  }) : super(key: key, child: child);

  final CalendarStyle style;

  final CalendarComponents components;

  static CalendarStyleProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<CalendarStyleProvider>();
    return result!;
  }

  @override
  bool updateShouldNotify(CalendarStyleProvider oldWidget) {
    return style != oldWidget.style || components != oldWidget.components;
  }
}
