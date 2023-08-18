import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_components.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/calendar/calendar_layout_controllers.dart';
import 'package:kalender/src/models/calendar/calendar_style.dart';
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
/// [monthTileBuilder] is a [MonthTileBuilder] used to build month event tiles.
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
///     * [MonthTileBuilder] which is used to build month event tiles.
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
class CalendarView<T> extends StatelessWidget {
  const CalendarView({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.viewConfiguration,
    required this.tileBuilder,
    required this.multiDayTileBuilder,
    required this.monthTileBuilder,
    this.components,
    this.style,
    this.eventHandlers,
    this.layoutControllers,
  }) : assert(
          tileBuilder != null &&
              multiDayTileBuilder != null &&
              monthTileBuilder != null,
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
    this.style,
    this.eventHandlers,
    this.layoutControllers,
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
    this.style,
    this.eventHandlers,
    this.layoutControllers,
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
    this.style,
    this.eventHandlers,
    this.layoutControllers,
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

  /// The [ViewConfiguration] used to configure the view.
  final ViewConfiguration viewConfiguration;

  /// The [CalendarComponents] used to build the components of the view.
  final CalendarComponents? components;

  /// The [CalendarStyle] used to style the default components.
  final CalendarStyle? style;

  /// The [CalendarEventHandlers] used to handle events.
  final CalendarEventHandlers<T>? eventHandlers;

  /// The [CalendarLayoutControllers] used to layout the calendar's tiles.
  final CalendarLayoutControllers<T>? layoutControllers;

  /// The [TileBuilder] used to build event tiles.
  final TileBuilder<T>? tileBuilder;

  /// The [MultiDayTileBuilder] used to build multi day event tiles.
  final MultiDayTileBuilder<T>? multiDayTileBuilder;

  /// The [MonthTileBuilder] used to build month event tiles.
  final MonthTileBuilder<T>? monthTileBuilder;

  @override
  Widget build(BuildContext context) {
    if (viewConfiguration is SingleDayViewConfiguration) {
      return SingleDayView<T>(
        controller: controller,
        eventsController: eventsController,
        tileBuilder: tileBuilder!,
        multiDayTileBuilder: multiDayTileBuilder!,
        components: components,
        functions: eventHandlers,
        singleDayViewConfiguration:
            viewConfiguration as SingleDayViewConfiguration,
        style: style,
        layoutControllers: layoutControllers,
      );
    }

    if (viewConfiguration is MultiDayViewConfiguration) {
      return MultiDayView<T>(
        controller: controller,
        eventsController: eventsController,
        tileBuilder: tileBuilder!,
        multiDayTileBuilder: multiDayTileBuilder!,
        components: components,
        functions: eventHandlers,
        multiDayViewConfiguration:
            viewConfiguration as MultiDayViewConfiguration,
        style: style,
        layoutControllers: layoutControllers,
      );
    }

    if (viewConfiguration is MonthViewConfiguration) {
      return MonthView<T>(
        controller: controller,
        eventsController: eventsController,
        monthTileBuilder: monthTileBuilder!,
        components: components,
        functions: eventHandlers,
        monthViewConfiguration: viewConfiguration as MonthViewConfiguration,
        style: style,
        layoutControllers: layoutControllers,
      );
    }
    return Container();
  }
}
