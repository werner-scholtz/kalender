import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/views/calendar_view.dart';

/// Provides a [CalendarController] to all descendants of this Widget.
class CalendarControllerProvider<T extends Object?> extends InheritedWidget {
  final CalendarController<T> controller;

  const CalendarControllerProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  static CalendarControllerProvider<T> of<T extends Object?>(BuildContext context) {
    final CalendarControllerProvider<T>? result =
        context.dependOnInheritedWidgetOfExactType<CalendarControllerProvider<T>>();
    assert(
        result != null,
        'No CalendarControllerProvider<$T> found in context. '
        'Please wrap your app with a CalendarControllerProvider<$T>. '
        'OR'
        'Provide a CalendarController<$T> to the $CalendarView class.');
    return result!;
  }

  @override
  bool updateShouldNotify(CalendarControllerProvider<T> oldWidget) =>
      oldWidget.controller != controller;
}
