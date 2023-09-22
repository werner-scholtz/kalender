import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar/calendar_components.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/calendar/calendar_layout_delegates.dart';
import 'package:kalender/src/models/calendar/calendar_style.dart';
import 'package:kalender/src/models/calendar/calendar_view_state.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/providers/calendar_style.dart';
import 'package:kalender/src/type_definitions.dart';

import 'package:kalender/src/models/calendar/platform_data/web_platform_data.dart'
    if (dart.library.io) 'package:kalender/src/models/calendar/platform_data/io_platform_data.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_content.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_header.dart';
import 'package:kalender/src/views/schedule_view/schedule_header.dart';
import 'package:kalender/src/views/schedule_view/schule_content.dart';

/// TODO: implement ScheduleView.
class ScheduleView<T> extends StatefulWidget {
  const ScheduleView({
    super.key,
    required this.controller,
    required this.eventsController,
    this.components,
    this.style,
    this.scheduleViewConfiguration,
    this.functions,
    this.layoutControllers,
  });

  /// The [CalendarController] used to control the view.
  final CalendarController<T> controller;

  /// The [CalendarEventsController] used to control events.
  final CalendarEventsController<T> eventsController;

  /// The [MultiDayViewConfiguration] used to configure the view.
  final ScheduleViewConfiguration? scheduleViewConfiguration;

  /// The [CalendarComponents] used to build the components of the view.
  final CalendarComponents? components;

  /// The [CalendarStyle] used to style the default components.
  final CalendarStyle? style;

  /// The [CalendarEventHandlers] used to handle events.
  final CalendarEventHandlers<T>? functions;

  /// The [CalendarLayoutDelegates] used to layout the calendar's tiles.
  final CalendarLayoutDelegates<T>? layoutControllers;

  @override
  State<ScheduleView<T>> createState() => _ScheduleViewState<T>();
}

class _ScheduleViewState<T> extends State<ScheduleView<T>> {
  late ViewState _viewState;
  late ScheduleViewConfiguration _viewConfiguration;

  @override
  void initState() {
    super.initState();

    _viewConfiguration =
        (widget.scheduleViewConfiguration ?? ScheduleConfiguration());
    _initializeViewState();

    if (kDebugMode) {
      print('The controller is already attached to a view. detaching first.');
    }
    // _controller.detach();
    widget.controller.attach(_viewState);
  }

  @override
  void didUpdateWidget(covariant ScheduleView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.scheduleViewConfiguration != null &&
        widget.scheduleViewConfiguration != _viewConfiguration) {
      _viewConfiguration = widget.scheduleViewConfiguration!;
      _initializeViewState();

      if (kDebugMode) {
        print('The controller is already attached to a view. detaching first.');
      }
      // _controller.detach();
      widget.controller.attach(_viewState);
    }
  }

  void _initializeViewState() {
    final adjustedDateTimeRange =
        _viewConfiguration.calculateAdjustedDateTimeRange(
      dateTimeRange: widget.controller.dateTimeRange,
      visibleStart: widget.controller.selectedDate,
    );

    final numberOfPages = _viewConfiguration.calculateNumberOfPages(
      adjustedDateTimeRange,
    );

    final initialPage = _viewConfiguration.calculateDateIndex(
      widget.controller.selectedDate,
      adjustedDateTimeRange.start,
    );

    final pageController = PageController(
      initialPage: initialPage,
    );

    final visibleDateRange = _viewConfiguration.calculateVisibleDateTimeRange(
      widget.controller.selectedDate,
    );

    _viewState = ViewState(
      viewConfiguration: _viewConfiguration,
      pageController: pageController,
      adjustedDateTimeRange: adjustedDateTimeRange,
      numberOfPages: numberOfPages,
      scrollController: ScrollController(),
      visibleDateTimeRange: ValueNotifier<DateTimeRange>(visibleDateRange),
      heightPerMinute: ValueNotifier<double>(0.7),
    );
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
        tileComponents: CalendarTileComponents<T>(),
        platformData: PlatformData(),
        layoutControllers:
            widget.layoutControllers ?? CalendarLayoutDelegates<T>(),
        child: Column(
          children: <Widget>[
            ScheduleHeader<T>(
              viewConfiguration: _viewConfiguration,
            ),
            ScheduleContent(
              controller: widget.controller,
              viewConfiguration: _viewConfiguration,
            ),
          ],
        ),
      ),
    );
  }
}
