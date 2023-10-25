import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_components.dart';

import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/calendar/calendar_layout_delegates.dart';
import 'package:kalender/src/models/calendar/calendar_style.dart';
import 'package:kalender/src/models/calendar/view_state/month_view_state.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/providers/calendar_style.dart';
import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/views/month_view/month_view_content.dart';
import 'package:kalender/src/views/month_view/month_view_header.dart';

import 'package:kalender/src/models/calendar/platform_data/web_platform_data.dart'
    if (dart.library.io) 'package:kalender/src/models/calendar/platform_data/io_platform_data.dart';

class MonthView<T> extends StatefulWidget {
  const MonthView({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.multiDayTileBuilder,
    this.monthViewConfiguration = const MonthConfiguration(),
    this.components,
    this.style,
    this.functions,
    this.layoutDelegates,
  });

  /// The [CalendarController] used to control the view.
  final CalendarController<T> controller;

  /// The [CalendarEventsController] used to control events.
  final CalendarEventsController<T> eventsController;

  /// The [MonthViewConfiguration] used to configure the view.
  final MonthViewConfiguration monthViewConfiguration;

  /// The [CalendarComponents] used to build the components of the view.
  final CalendarComponents? components;

  /// The [CalendarStyle] used to style the default components.
  final CalendarStyle? style;

  /// The [CalendarEventHandlers] used to handle events.
  final CalendarEventHandlers<T>? functions;

  /// The [CalendarLayoutDelegates] used to layout the calendar's tiles.
  final CalendarLayoutDelegates<T>? layoutDelegates;

  /// The [MonthTileBuilder] used to build month event tiles.
  final MultiDayTileBuilder<T> multiDayTileBuilder;

  @override
  State<MonthView<T>> createState() => _MonthViewState<T>();
}

class _MonthViewState<T> extends State<MonthView<T>>
    with SingleTickerProviderStateMixin {
  late MonthViewState _viewState;
  late MonthViewConfiguration _monthViewConfiguration;

  @override
  void initState() {
    super.initState();

    _monthViewConfiguration = widget.monthViewConfiguration;

    _viewState =
        widget.controller.attach(_monthViewConfiguration) as MonthViewState;
  }

  @override
  void didUpdateWidget(covariant MonthView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_monthViewConfiguration != widget.monthViewConfiguration) {
      _monthViewConfiguration = widget.monthViewConfiguration;

      _viewState =
          widget.controller.attach(_monthViewConfiguration) as MonthViewState;
    }
  }

  @override
  void deactivate() {
    widget.controller.detach();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return CalendarStyleProvider(
      style: widget.style ?? const CalendarStyle(),
      child: CalendarScope<T>(
        state: _viewState,
        eventsController: widget.eventsController,
        functions: widget.functions ?? CalendarEventHandlers<T>(),
        components: widget.components ?? CalendarComponents(),
        tileComponents: CalendarTileComponents(
          multiDayTileBuilder: widget.multiDayTileBuilder,
        ),
        platformData: PlatformData(),
        layoutDelegates: widget.layoutDelegates ?? CalendarLayoutDelegates(),
        child: Column(
          children: <Widget>[
            MonthViewHeader<T>(
              viewConfiguration: widget.monthViewConfiguration,
            ),
            MonthViewContent<T>(
              viewConfiguration: widget.monthViewConfiguration,
              controller: widget.controller,
            ),
          ],
        ),
      ),
    );
  }
}
