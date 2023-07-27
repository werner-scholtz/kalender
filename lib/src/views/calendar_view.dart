import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_controller.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/view_configurations/day_configuration.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/providers/calendar_controller_provider.dart';

class CalendarView<T extends Object?> extends StatefulWidget {
  const CalendarView({
    super.key,
    this.controller,
    this.initialViewConfiguration = const DayConfiguration(),
    this.viewConfigurations = const <ViewConfiguration>[
      DayConfiguration(),
    ],
    this.initialDate,
    this.dateTimeRange,
    this.onEventChanged,
    this.onEventTapped,
    this.onCreateEvent,
  });

  final CalendarController<T>? controller;
  final ViewConfiguration initialViewConfiguration;
  final List<ViewConfiguration> viewConfigurations;
  final DateTime? initialDate;
  final DateTimeRange? dateTimeRange;

  /// The [Function] called when an event is changed.
  ///
  /// The [T] that is returned will be used as the eventData of the [CalendarEvent].
  final Future<void> Function(DateTimeRange initialDateTimeRange, CalendarEvent<T> event)?
      onEventChanged;

  /// The [Function] called when an event is tapped.
  final Future<void> Function(CalendarEvent<T> event)? onEventTapped;

  /// The [Function] called when an event is created.
  ///
  /// The [CalendarEvent] that is returned will be added to the [CalendarController].
  /// If null the event will not be created.
  final Future<CalendarEvent<T>?> Function(CalendarEvent<T> newEvent)? onCreateEvent;

  @override
  State<CalendarView<T>> createState() => _CalendarViewState<T>();
}

class _CalendarViewState<T extends Object?> extends State<CalendarView<T>> {
  CalendarController<T>? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assignController();
  }

  @override
  void didUpdateWidget(covariant CalendarView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _assignController();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _assignController() {
    CalendarController<T> controller =
        widget.controller ?? CalendarControllerProvider.of<T>(context).controller;
    if (controller != _controller) {
      _controller = controller;
    }
  }
}
