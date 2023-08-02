import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:kalender/src/models/calendar/calendar_components.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/view_configurations/view_confiuration_export.dart';
import 'package:kalender/src/typedefs.dart';
import 'package:kalender/src/views/month_view/month_view.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_view.dart';
import 'package:kalender/src/views/single_day_view/single_day_view.dart';

class CalendarView<T> extends StatefulWidget {
  const CalendarView({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.viewConfiguration,
    required this.eventTileBuilder,
    required this.multiDayEventTileBuilder,
    required this.monthEventTileBuilder,
    this.components,
    this.functions,
    this.createNewEvents = true,
  }) : assert(
          eventTileBuilder != null &&
              multiDayEventTileBuilder != null &&
              monthEventTileBuilder != null,
          'All Event Tile builders must be assigned',
        );

  const CalendarView.singleDay({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.viewConfiguration,
    required this.eventTileBuilder,
    required this.multiDayEventTileBuilder,
    this.components,
    this.functions,
    this.createNewEvents = true,
  }) : monthEventTileBuilder = null;

  /// The [CalendarController] used to control the view.
  final CalendarController<T> controller;

  /// The [CalendarEventsController] used to control events.
  final CalendarEventsController<T> eventsController;

  /// The [SingleDayViewConfiguration] used to configure the view.
  final ViewConfiguration viewConfiguration;

  /// The [CalendarComponents] used to build the components of the view.
  final CalendarComponents? components;

  /// The [CalendarEventHandlers] used to handle events.
  final CalendarEventHandlers<T>? functions;

  /// The [EventTileBuilder] used to build event tiles.
  final EventTileBuilder<T>? eventTileBuilder;

  /// The [MultiDayEventTileBuilder] used to build multi day event tiles.
  final MultiDayEventTileBuilder<T>? multiDayEventTileBuilder;

  /// The [MonthEventTileBuilder] used to build month event tiles.
  final MonthEventTileBuilder<T>? monthEventTileBuilder;

  /// Can create new events.
  final bool createNewEvents;

  @override
  State<CalendarView<T>> createState() => _CalendarViewState<T>();
}

class _CalendarViewState<T> extends State<CalendarView<T>> {
  late ViewConfiguration _viewConfiguration;

  @override
  void initState() {
    super.initState();
    _viewConfiguration = widget.viewConfiguration;
  }

  @override
  void didUpdateWidget(covariant CalendarView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewConfiguration != oldWidget.viewConfiguration) {
      _viewConfiguration = widget.viewConfiguration;
    }
  }

  @override
  Widget build(BuildContext context) {
    log(_viewConfiguration.runtimeType.toString());

    if (_viewConfiguration is SingleDayViewConfiguration) {
      return SingleDayView<T>(
        controller: widget.controller,
        eventsController: widget.eventsController,
        eventTileBuilder: widget.eventTileBuilder!,
        multiDayEventTileBuilder: widget.multiDayEventTileBuilder!,
        components: widget.components,
        functions: widget.functions,
        singleDayViewConfiguration: _viewConfiguration as SingleDayViewConfiguration,
        createNewEvents: widget.createNewEvents,
      );
    }

    if (_viewConfiguration is MultiDayViewConfiguration) {
      return MultiDayView<T>(
        controller: widget.controller,
        eventsController: widget.eventsController,
        eventTileBuilder: widget.eventTileBuilder!,
        multiDayEventTileBuilder: widget.multiDayEventTileBuilder!,
        components: widget.components,
        functions: widget.functions,
        multiDayViewConfiguration: _viewConfiguration as MultiDayViewConfiguration,
        createNewEvents: widget.createNewEvents,
      );
    }

    if (_viewConfiguration is MonthViewConfiguration) {
      return MonthView<T>(
        controller: widget.controller,
        eventsController: widget.eventsController,
        monthEventTileBuilder: widget.monthEventTileBuilder!,
        components: widget.components,
        functions: widget.functions,
        monthViewConfiguration: _viewConfiguration as MonthViewConfiguration,
        createNewEvents: widget.createNewEvents,
      );
    }

    return Container();
  }
}
