import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_components.dart';
import 'package:kalender/src/models/calendar_configuration.dart';
import 'package:kalender/src/models/calendar_functions.dart';
import 'package:kalender/src/models/calendar_state.dart';
import 'package:kalender/src/models/calendar_style.dart';

class CalendarInternals<T extends Object?> extends InheritedWidget {
  const CalendarInternals({
    Key? key,
    required this.controller,
    required this.style,
    required this.state,
    required this.components,
    required this.configuration,
    required this.functions,
    required Widget child,
  }) : super(key: key, child: child);

  final CalendarConfiguration configuration;
  final CalendarStyle style;
  final CalendarViewState state;

  final CalendarController<T> controller;
  final CalendarComponents<T> components;
  final CalendarFunctions<T> functions;

  static CalendarInternals<T> of<T extends Object?>(BuildContext context) {
    CalendarInternals<T>? result =
        context.dependOnInheritedWidgetOfExactType<CalendarInternals<T>>();

    return result!;
  }

  @override
  bool updateShouldNotify(CalendarInternals<T> oldWidget) => false;
}
