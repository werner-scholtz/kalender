import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar/view_state/schedule_view_state.dart';
import 'package:kalender/src/providers/calendar_style.dart';

import 'package:kalender/src/models/calendar/platform_data/web_platform_data.dart'
    if (dart.library.io) 'package:kalender/src/models/calendar/platform_data/io_platform_data.dart';
import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/views/schedule_view/schedule_header.dart';
import 'package:kalender/src/views/schedule_view/schedule_content.dart';

class ScheduleView<T> extends StatefulWidget {
  const ScheduleView({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.scheduleViewConfiguration,
    required this.scheduleTileBuilder,
    this.components,
    this.style,
    this.functions,
    this.layoutDelegates,
  });

  /// The [CalendarController] used to control the view.
  final CalendarController<T> controller;

  /// The [CalendarEventsController] used to control events.
  final CalendarEventsController<T> eventsController;

  /// The [MultiDayViewConfiguration] used to configure the view.
  final ScheduleViewConfiguration scheduleViewConfiguration;

  /// The [CalendarComponents] used to build the components of the view.
  final CalendarComponents? components;

  /// The [CalendarStyle] used to style the default components.
  final CalendarStyle? style;

  /// The [CalendarEventHandlers] used to handle events.
  final CalendarEventHandlers<T>? functions;

  /// The [CalendarLayoutDelegates] used to layout the calendar's tiles.
  final CalendarLayoutDelegates<T>? layoutDelegates;

  final ScheduleTileBuilder<T> scheduleTileBuilder;

  @override
  State<ScheduleView<T>> createState() => _ScheduleViewState<T>();
}

class _ScheduleViewState<T> extends State<ScheduleView<T>> {
  late ScheduleViewState _viewState;

  @override
  void deactivate() {
    widget.controller.detach();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.scheduleViewConfiguration,
      builder: (context, child) {
        _viewState = widget.controller.attach(
          widget.scheduleViewConfiguration,
        ) as ScheduleViewState;

        return CalendarStyleProvider(
          style: widget.style ?? const CalendarStyle(),
          components: widget.components ?? CalendarComponents(),
          child: CalendarScope<T>(
            state: _viewState,
            eventsController: widget.eventsController,
            functions: widget.functions ?? CalendarEventHandlers<T>(),
            tileComponents: CalendarTileComponents<T>(
              scheduleTileBuilder: widget.scheduleTileBuilder,
            ),
            platformData: PlatformData(),
            layoutDelegates:
                widget.layoutDelegates ?? CalendarLayoutDelegates<T>(),
            child: Column(
              children: <Widget>[
                ScheduleHeader<T>(
                  viewConfiguration: widget.scheduleViewConfiguration,
                  viewState: _viewState,
                ),
                Expanded(
                  child: ScheduleContent<T>(
                    controller: widget.controller,
                    viewConfiguration: widget.scheduleViewConfiguration,
                    viewState: _viewState,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
