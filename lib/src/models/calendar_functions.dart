import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

class CalendarFunctions<T extends Object?> {
  const CalendarFunctions({
    this.onEventChanged,
    this.onEventTapped,
    this.onCreateEvent,
    this.onDateTapped,
    required this.onPageChanged,
    required this.onConfigurationChanged,
    required this.onLeftArrowPressed,
    required this.onRightArrowPressed,
    required this.onDateSelectorPressed,
  });

  final Function(ViewConfiguration pageView) onConfigurationChanged;
  final void Function() onLeftArrowPressed;
  final void Function() onRightArrowPressed;
  final void Function() onDateSelectorPressed;

  /// The [Function] called when the page is changed.
  final Function(int index) onPageChanged;

  /// The [Function] called when the event is changed.
  final void Function(DateTimeRange initialDateTimeRange, CalendarEvent<T> event)? onEventChanged;

  /// The [Function] called when the event is tapped.
  final void Function(CalendarEvent<T> event)? onEventTapped;

  /// The [Function] called when an event is created.
  final Future<CalendarEvent<T>?> Function(CalendarEvent<T> newEvent)? onCreateEvent;

  /// The [Function] called when the event is tapped.
  final Function(DateTime date)? onDateTapped;
}
