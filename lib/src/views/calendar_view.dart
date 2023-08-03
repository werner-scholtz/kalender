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
    required this.tileBuilder,
    required this.multiDayTileBuilder,
    required this.monthTileBuilder,
    this.components,
    this.eventHandlers,
    this.createNewEvents = true,
  }) : assert(
          tileBuilder != null && multiDayTileBuilder != null && monthTileBuilder != null,
          'All Event Tile builders must be assigned',
        );

  const CalendarView.singleDay({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.viewConfiguration,
    required this.tileBuilder,
    required this.multiDayTileBuilder,
    this.components,
    this.eventHandlers,
    this.createNewEvents = true,
  })  : monthTileBuilder = null,
        assert(
          tileBuilder != null && multiDayTileBuilder != null,
          'EventTileBuilder and MultiDayEventTileBuilder must be assigned',
        ),
        assert(
          viewConfiguration is SingleDayViewConfiguration,
          'SingleDayViewConfiguration must be assigned',
        );

  const CalendarView.multiDay({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.viewConfiguration,
    required this.tileBuilder,
    required this.multiDayTileBuilder,
    this.components,
    this.eventHandlers,
    this.createNewEvents = true,
  })  : monthTileBuilder = null,
        assert(
          tileBuilder != null && multiDayTileBuilder != null,
          'EventTileBuilder and MultiDayEventTileBuilder must be assigned',
        ),
        assert(
          viewConfiguration is MultiDayViewConfiguration,
          'MultiDayViewConfiguration must be assigned',
        );

  const CalendarView.month({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.viewConfiguration,
    required this.monthTileBuilder,
    this.components,
    this.eventHandlers,
    this.createNewEvents = true,
  })  : tileBuilder = null,
        multiDayTileBuilder = null,
        assert(
          monthTileBuilder != null,
          'Month Event Tile builder must be assigned',
        ),
        assert(
          viewConfiguration is MonthViewConfiguration,
          'MonthViewConfiguration must be assigned',
        );

  /// The [CalendarController] used to control the view.
  final CalendarController<T> controller;

  /// The [CalendarEventsController] used to control events.
  final CalendarEventsController<T> eventsController;

  /// The [SingleDayViewConfiguration] used to configure the view.
  final ViewConfiguration viewConfiguration;

  /// The [CalendarComponents] used to build the components of the view.
  final CalendarComponents? components;

  /// The [CalendarEventHandlers] used to handle events.
  final CalendarEventHandlers<T>? eventHandlers;

  /// The [TileBuilder] used to build event tiles.
  final TileBuilder<T>? tileBuilder;

  /// The [MultiDayTileBuilder] used to build multi day event tiles.
  final MultiDayTileBuilder<T>? multiDayTileBuilder;

  /// The [MonthEventBuilder] used to build month event tiles.
  final MonthEventBuilder<T>? monthTileBuilder;

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
    if (_viewConfiguration is SingleDayViewConfiguration) {
      return SingleDayView<T>(
        controller: widget.controller,
        eventsController: widget.eventsController,
        tileBuilder: widget.tileBuilder!,
        multiDayTileBuilder: widget.multiDayTileBuilder!,
        components: widget.components,
        functions: widget.eventHandlers,
        singleDayViewConfiguration: _viewConfiguration as SingleDayViewConfiguration,
        createNewEvents: widget.createNewEvents,
      );
    }

    if (_viewConfiguration is MultiDayViewConfiguration) {
      return MultiDayView<T>(
        controller: widget.controller,
        eventsController: widget.eventsController,
        tileBuilder: widget.tileBuilder!,
        multiDayTileBuilder: widget.multiDayTileBuilder!,
        components: widget.components,
        functions: widget.eventHandlers,
        multiDayViewConfiguration: _viewConfiguration as MultiDayViewConfiguration,
        createNewEvents: widget.createNewEvents,
      );
    }

    if (_viewConfiguration is MonthViewConfiguration) {
      return MonthView<T>(
        controller: widget.controller,
        eventsController: widget.eventsController,
        monthTileBuilder: widget.monthTileBuilder!,
        components: widget.components,
        functions: widget.eventHandlers,
        monthViewConfiguration: _viewConfiguration as MonthViewConfiguration,
        createNewEvents: widget.createNewEvents,
      );
    }

    return Container();
  }
}
