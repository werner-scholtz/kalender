import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/calendar/calendar_state.dart';

class CalendarInternals<T extends Object?> extends InheritedWidget {
  const CalendarInternals({
    Key? key,
    required this.controller,
    required this.state,
    required this.components,
    required this.configuration,
    required this.functions,
    required Widget child,
  }) : super(key: key, child: child);

  final CalendarConfiguration configuration;
  final CalendarState state;

  final CalendarController<T> controller;
  final CalendarComponents<T> components;
  final CalendarFunctions<T> functions;

  static CalendarInternals<T> of<T extends Object?>(BuildContext context) {
    CalendarInternals<T>? result =
        context.dependOnInheritedWidgetOfExactType<CalendarInternals<T>>();
    assert(
        result != null,
        'No CalendarInternals<$T> found in context. '
        'Make sure to set the type to $T');
    return result!;
  }

  @override
  bool updateShouldNotify(CalendarInternals<T> oldWidget) => false;
}
