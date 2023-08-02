import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_components.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/calendar/calendar_platform_data.dart';
import 'package:kalender/src/models/calendar/calendar_view_state.dart';


/// The [InheritedWidget] that provides the calendar with the necessary data.
/// 
/// [components] is used to build the calendar's components.
/// [tileComponents] is used to build the calendar's tiles.
/// [functions] is used to handle events.
/// [state] is used to store the calendar's state.
/// [platformData] is used to store platform specific data.
/// 
class CalendarScope<T extends Object?> extends InheritedWidget {
  final CalendarEventsController<T> eventsController;

  final CalendarComponents components;

  final CalendarTileComponents<T> tileComponents;

  final CalendarFunctions<T> functions;

  final ViewState state;

  final PlatformData platformData;

  const CalendarScope({
    super.key,
    required this.eventsController,
    required this.components,
    required this.tileComponents,
    required this.functions,
    required this.state,
    required this.platformData,
    required super.child,
  });

  static CalendarScope<T> of<T extends Object?>(BuildContext context) {
    CalendarScope<T>? result = context.dependOnInheritedWidgetOfExactType<CalendarScope<T>>();
    assert(
        result != null,
        'No CalendarInternals<$T> found in context. '
        'Make sure to set the type to $T');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant CalendarScope<T> oldWidget) {
    return eventsController != oldWidget.eventsController ||
        components != oldWidget.components ||
        tileComponents != oldWidget.tileComponents ||
        functions != oldWidget.functions ||
        state != oldWidget.state ||
        platformData != oldWidget.platformData;
  }
}
