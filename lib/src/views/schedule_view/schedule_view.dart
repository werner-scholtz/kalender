import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar/view_state/schedule_view_state.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
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
    required this.scheduleTileBuilder,
    this.components,
    this.style,
    this.scheduleViewConfiguration = const ScheduleConfiguration(),
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
  late ScheduleViewState<T> _viewState;
  late ScheduleViewConfiguration _scheduleViewConfiguration;

  @override
  void initState() {
    super.initState();

    _scheduleViewConfiguration = widget.scheduleViewConfiguration;
    // _initializeViewState();

    if (kDebugMode) {
      print('The controller is already attached to a view. detaching first.');
    }

    widget.controller.attach(_scheduleViewConfiguration);
    // _controller.detach();
    // widget.controller.attach(_viewState);
  }

  @override
  void didUpdateWidget(covariant ScheduleView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_scheduleViewConfiguration != oldWidget.scheduleViewConfiguration) {
      _scheduleViewConfiguration = widget.scheduleViewConfiguration;
      // _initializeViewState();

      if (kDebugMode) {
        print('The controller is already attached to a view. detaching first.');
      }

      widget.controller.attach(_scheduleViewConfiguration);
      // _controller.detach();
      // widget.controller.attach(_viewState);
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
        tileComponents: CalendarTileComponents<T>(
          scheduleTileBuilder: widget.scheduleTileBuilder,
        ),
        platformData: PlatformData(),
        layoutDelegates: widget.layoutDelegates ?? CalendarLayoutDelegates<T>(),
        child: Column(
          children: <Widget>[
            ScheduleHeader<T>(
              viewConfiguration: widget.scheduleViewConfiguration,
              viewState: _viewState,
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.eventsController,
                builder: (context, child) {
                  _viewState.scheduleGroups =
                      widget.eventsController.getScheduleGroups().toList();

                  return ScheduleContent<T>(
                    controller: widget.controller,
                    viewConfiguration: widget.scheduleViewConfiguration,
                    viewState: _viewState,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _initializeViewState() {
  //   _scheduleViewConfiguration = widget.scheduleViewConfiguration;
  //   final initialDate = widget.controller.selectedDate;

  //   final adjustedDateTimeRange =
  //       widget.scheduleViewConfiguration.calculateAdjustedDateTimeRange(
  //     dateTimeRange: widget.controller.dateTimeRange,
  //     visibleStart: initialDate,
  //   );

  //   final visibleDateRange =
  //       widget.scheduleViewConfiguration.calculateVisibleDateTimeRange(
  //     initialDate,
  //   );

  //   _viewState = ScheduleViewState<T>(
  //     viewConfiguration: _scheduleViewConfiguration,
  //     adjustedDateTimeRange: adjustedDateTimeRange,
  //     visibleDateTimeRange: ValueNotifier<DateTimeRange>(visibleDateRange),
  //     itemScrollController: itemScrollController,
  //     itemPositionsListener: itemPositionsListener,
  //   );
  // }
}
