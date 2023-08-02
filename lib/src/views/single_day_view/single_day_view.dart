import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_components.dart';

import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/calendar/calendar_platform_data.dart';
import 'package:kalender/src/models/calendar/calendar_style.dart';
import 'package:kalender/src/models/calendar/calendar_view_state.dart';
import 'package:kalender/src/models/view_configurations/view_confiuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/providers/calendar_style.dart';
import 'package:kalender/src/typedefs.dart';
import 'package:kalender/src/views/single_day_view/single_day_content.dart';
import 'package:kalender/src/views/single_day_view/single_day_header.dart';

/// A widget that displays a single day.
class SingleDayView<T> extends StatefulWidget {
  const SingleDayView({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.eventTileBuilder,
    required this.multiDayEventTileBuilder,
    this.components,
    this.singleDayViewConfiguration,
    this.functions,
    this.createNewEvents = true,
  });

  /// The [CalendarController] used to control the view.
  final CalendarController<T> controller;

  /// The [CalendarEventsController] used to control events.
  final CalendarEventsController<T> eventsController;

  /// The [SingleDayViewConfiguration] used to configure the view.
  final SingleDayViewConfiguration? singleDayViewConfiguration;

  /// The [CalendarComponents] used to build the components of the view.
  final CalendarComponents? components;

  /// The [CalendarEventHandlers] used to handle events.
  final CalendarEventHandlers<T>? functions;

  /// The [EventTileBuilder] used to build event tiles.
  final EventTileBuilder<T> eventTileBuilder;

  /// The [MultiDayEventTileBuilder] used to build multi day event tiles.
  final MultiDayEventTileBuilder<T> multiDayEventTileBuilder;

  /// Can create new events.
  final bool createNewEvents;

  @override
  State<SingleDayView<T>> createState() => _SingleDayViewState<T>();
}

class _SingleDayViewState<T> extends State<SingleDayView<T>> {
  late CalendarController<T> _controller;
  late CalendarEventsController<T> _eventsController;
  late ViewState _viewState;
  late CalendarEventHandlers<T> _functions;
  late CalendarComponents _components;
  late CalendarTileComponents<T> _tileComponents;
  late SingleDayViewConfiguration _viewConfiguration;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    _eventsController = widget.eventsController;
    _functions = widget.functions ?? CalendarEventHandlers<T>();
    _components = widget.components ?? CalendarComponents();
    _tileComponents = CalendarTileComponents<T>(
      eventTileBuilder: widget.eventTileBuilder,
      multiDayEventTileBuilder: widget.multiDayEventTileBuilder,
    );

    _viewConfiguration = (widget.singleDayViewConfiguration ?? const DayConfiguration());
    _initializeViewState();

    if (kDebugMode) {
      print('The controller is already attached to a view. detaching first.');
    }
    // _controller.detach();
    _controller.attach(_viewState);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _eventsController = widget.eventsController;
  }

  @override
  void didUpdateWidget(covariant SingleDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _eventsController = widget.eventsController;
    if (widget.singleDayViewConfiguration != null &&
        widget.singleDayViewConfiguration != _viewConfiguration) {
      _viewConfiguration = widget.singleDayViewConfiguration!;
      _initializeViewState();
      if (kDebugMode) {
        print('The controller is already attached to a view. detaching first.');
      }
      // _controller.detach();
      _controller.attach(_viewState);
    }
  }

  void _initializeViewState() {
    DateTimeRange adjustedDateTimeRange = _viewConfiguration.calculateAdjustedDateTimeRange(
      dateTimeRange: _controller.dateTimeRange,
      visibleStart: _controller.selectedDate,
    );

    int numberOfPages = _viewConfiguration.calculateNumberOfPages(
      _controller.dateTimeRange,
    );

    int initialPage = _viewConfiguration.calculateDateIndex(
      _controller.selectedDate,
      _controller.dateTimeRange.start,
    );

    PageController pageController = PageController(
      initialPage: initialPage,
    );

    DateTimeRange visibleDateRange = _viewConfiguration.calcualteVisibleDateTimeRange(
      _controller.selectedDate,
      _controller.dateTimeRange.start.weekday,
    );

    _viewState = ViewState(
      viewConfiguration: _viewConfiguration,
      pageController: pageController,
      adjustedDateTimeRange: adjustedDateTimeRange,
      numberOfPages: numberOfPages,
      scrollController: ScrollController(),
      visibleDateTimeRange: ValueNotifier<DateTimeRange>(visibleDateRange),
      heightPerMinute: ValueNotifier<double>(0.7),
      createNewEvents: widget.createNewEvents,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalendarStyleProvider(
      style: const CalendarStyle(),
      child: CalendarScope<T>(
        state: _viewState,
        eventsController: _eventsController,
        functions: _functions,
        components: _components,
        platformData: PlatformData(),
        tileComponents: _tileComponents,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Calculate the width of the day.
            double dayWidth = constraints.maxWidth - _viewConfiguration.timelineWidth;

            return Column(
              children: <Widget>[
                SingleDayHeader<T>(
                  dayWidth: dayWidth,
                  viewConfiguration: _viewConfiguration,
                ),
                SingleDayContent<T>(
                  dayWidth: dayWidth,
                  viewConfiguration: _viewConfiguration,
                  controller: _controller,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
