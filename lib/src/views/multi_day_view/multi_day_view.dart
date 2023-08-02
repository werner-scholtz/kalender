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
import 'package:kalender/src/views/multi_day_view/multi_day_content.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_header.dart';

class MultiDayView<T> extends StatefulWidget {
  const MultiDayView({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.eventsTileBuilder,
    required this.multiDayEventTileBuilder,
    this.components,
    this.viewConfiguration,
    this.functions,
    this.createNewEvents = true,
  });

  final CalendarController<T> controller;
  final CalendarEventsController<T> eventsController;
  final MultiDayViewConfiguration? viewConfiguration;
  final CalendarComponents? components;
  final CalendarFunctions<T>? functions;
  final EventTileBuilder<T> eventsTileBuilder;
  final MultiDayEventTileBuilder<T> multiDayEventTileBuilder;
  final bool createNewEvents;

  @override
  State<MultiDayView<T>> createState() => _MultiDayViewState<T>();
}

class _MultiDayViewState<T> extends State<MultiDayView<T>> {
  late CalendarController<T> _controller;
  late ViewState _viewState;
  late CalendarEventsController<T> _eventsController;
  late CalendarFunctions<T> _functions;
  late CalendarComponents _components;
  late CalendarTileComponents<T> _tileComponents;
  late MultiDayViewConfiguration _viewConfiguration;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _eventsController = widget.eventsController;
    _functions = widget.functions ?? CalendarFunctions<T>();
    _components = widget.components ?? CalendarComponents();
    _tileComponents = CalendarTileComponents<T>(
      eventTileBuilder: widget.eventsTileBuilder,
      multiDayEventTileBuilder: widget.multiDayEventTileBuilder,
    );
    _viewConfiguration = (widget.viewConfiguration ?? const WeekConfiguration());
    _initializeViewState();

    if (kDebugMode) {
      print('The controller is already attached to a view. detaching first.');
    }
    _controller.detach();
    _controller.attach(_viewState);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _eventsController = widget.eventsController;
  }

  @override
  void didUpdateWidget(covariant MultiDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _eventsController = widget.eventsController;
    if (widget.viewConfiguration != null && widget.viewConfiguration != _viewConfiguration) {
      _viewConfiguration = widget.viewConfiguration!;
      _initializeViewState();
      if (kDebugMode) {
        print('The controller is already attached to a view. detaching first.');
      }
      _controller.detach();
      _controller.attach(_viewState);
    }
  }

  void _initializeViewState() {
    DateTimeRange adjustedDateTimeRange = _viewConfiguration.calculateAdjustedDateTimeRange(
      dateTimeRange: _controller.dateTimeRange,
      visibleStart: _controller.selectedDate,
      firstDayOfWeek: _viewConfiguration.firstDayOfWeek,
    );

    int numberOfPages = _viewConfiguration.calculateNumberOfPages(
      adjustedDateTimeRange,
    );

    int initialPage = _viewConfiguration.calculateDateIndex(
      _controller.selectedDate,
      adjustedDateTimeRange.start,
    );

    PageController pageController = PageController(
      initialPage: initialPage,
    );

    DateTimeRange visibleDateRange = _viewConfiguration.calcualteVisibleDateTimeRange(
      _controller.selectedDate,
      _viewConfiguration.firstDayOfWeek,
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
        tileComponents: _tileComponents,
        platformData: PlatformData(),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Calculate the width of the page.
            double pageWidth = constraints.maxWidth - _viewConfiguration.timelineWidth;

            // Calculate the width of the day.
            double dayWidth = _viewConfiguration.calculateDayWidth(pageWidth);

            return Column(
              children: <Widget>[
                MultiDayHeader<T>(
                  viewConfiguration: _viewConfiguration,
                  dayWidth: dayWidth,
                  pageWidth: pageWidth,
                ),
                MultiDayContent<T>(
                  viewConfiguration: _viewConfiguration,
                  dayWidth: dayWidth,
                  pageWidth: pageWidth,
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
