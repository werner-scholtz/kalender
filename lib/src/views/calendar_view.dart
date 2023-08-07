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

/// A navigable arrangement of events.
///
/// [controller] is a [CalendarController] used to control the view.
///
/// [eventsController] is a [CalendarEventsController] used to store and control events.
///
/// [viewConfiguration] is a [ViewConfiguration] used to configure the view.
///
/// [components] is a [CalendarComponents] used to build the components of the view.
///
/// [eventHandlers] is a [CalendarEventHandlers] used to handle any event that occurs.
///
/// [tileBuilder] is a [TileBuilder] used to build event tiles.
///
/// [multiDayTileBuilder] is a [MultiDayTileBuilder] used to build multi day event tiles.
///
/// [monthTileBuilder] is a [MonthEventBuilder] used to build month event tiles.
///
/// [createNewEvents] is a bool used to determine if new events can be created.
///
///
/// There are four options for constructing a [CalendarView]:
///
///  1. The default constructor can display any view configuration and will update when a
///     new view configuration is assigned.
///
///  2. The [CalendarView.singleDay] displays a single day and takes:
///     * [SingleDayViewConfiguration] which is used to configure the view.
///     * [TileBuilder] which is used to build tiles in the main view.
///     * [MultiDayTileBuilder] which is used to build tiles above the main view.
///
///  3. The [CalendarView.multiDay] displays multiple days and takes:
///     * [MultiDayViewConfiguration] which is used to configure the view.
///     * [TileBuilder] which is used to build tiles in the main view.
///     * [MultiDayTileBuilder] which is used to build tiles above the main view.
///
///  4. The [CalendarView.month] displays a month.
///     * [MonthViewConfiguration] which is used to configure the view.
///     * [MonthEventBuilder] which is used to build month event tiles.
///
/// Default constructor example:
///
/// {@tool snippet}
/// '''dart
/// CalendarView(
///   controller: controller,
///   eventsController: eventsController,
///   viewConfiguration: viewConfiguration,
///   tileBuilder: (event, tileType, continuesBefore, continuesAfter) => Container(
///     color: Colors.blue,
///   ),
///   multiDayTileBuilder: (event, tileType, continuesBefore, continuesAfter) => Container(
///     color: Colors.blue,
///   ),
///   monthTileBuilder: (event, tileType, continuesBefore, continuesAfter) => Container(
///     color: Colors.blue,
///   ),
/// );
/// '''
///
/// SingleDay constructor example:
///
/// {@tool snippet}
/// '''dart
/// CalendarView.singleDay(
///   controller: controller,
///   eventsController: eventsController,
///   viewConfiguration: DayConfiguration(),
///   tileBuilder: (event, tileType, continuesBefore, continuesAfter) => Container(
///     color: Colors.blue,
///   ),
///   multiDayTileBuilder: (event, tileType, continuesBefore, continuesAfter) => Container(
///     color: Colors.blue,
///   ),
/// );
/// '''
/// {@end-tool}
///
///
/// MultiDay constructor example:
///
/// {@tool snippet}
/// '''dart
/// CalendarView.multiDay(
///   controller: controller,
///   eventsController: eventsController,
///   viewConfiguration: WeekConfiguration(),
///   tileBuilder: (event, tileType, continuesBefore, continuesAfter) => Container(
///     color: Colors.blue,
///   ),
///   multiDayTileBuilder: (event, tileType, continuesBefore, continuesAfter) => Container(
///     color: Colors.blue,
///   ),
/// );
/// '''
/// {@end-tool}
///
///
/// Month constructor example:
///
/// {@tool snippet}
/// '''dart
/// CalendarView.month(
///   controller: controller,
///   eventsController: eventsController,
///   tileBuilder: (context, event) => Container(),
///   viewConfiguration: MonthViewConfiguration(),
///   multiDayTileBuilder: (context, event) => Container(
///     color: Colors.blue,
///   ),
/// );
/// '''
/// {@end-tool}
///
///
///
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
