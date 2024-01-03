import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_components.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/calendar/calendar_layout_delegates.dart';

import 'package:kalender/src/models/calendar/platform_data/web_platform_data.dart'
    if (dart.library.io) 'package:kalender/src/models/calendar/platform_data/io_platform_data.dart';
import 'package:kalender/src/models/calendar/view_state/view_state.dart';

/// The [InheritedWidget] that provides the calendar with the necessary data.
///
/// [tileComponents] is used to build the calendar's tiles.
/// [functions] is used to handle events.
/// [state] is used to store the calendar's state.
/// [platformData] is used to store platform specific data.
/// [layoutDelegates] is used to layout the calendar's tiles.
///
class CalendarScope<T> extends InheritedWidget {
  final CalendarEventsController<T> eventsController;

  // final CalendarComponents components;

  final CalendarTileComponents<T> tileComponents;

  final CalendarEventHandlers<T> functions;

  final CalendarLayoutDelegates<T> layoutDelegates;

  final ViewState state;

  final PlatformData platformData;

  const CalendarScope({
    super.key,
    required this.eventsController,
    // required this.components,
    required this.tileComponents,
    required this.functions,
    required this.state,
    required this.platformData,
    required this.layoutDelegates,
    required super.child,
  });

  static CalendarScope<T> of<T>(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<CalendarScope<T>>();
    assert(
        result != null,
        'No CalendarInternals<$T> found in context. '
        'Make sure to set the type to $T');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant CalendarScope<T> oldWidget) {
    return eventsController != oldWidget.eventsController ||
        // components != oldWidget.components ||
        tileComponents != oldWidget.tileComponents ||
        functions != oldWidget.functions ||
        state != oldWidget.state ||
        platformData != oldWidget.platformData ||
        layoutDelegates != oldWidget.layoutDelegates;
  }
}
