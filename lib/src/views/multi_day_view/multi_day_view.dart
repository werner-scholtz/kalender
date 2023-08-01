import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_components.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/calendar/calendar_platform_data.dart';
import 'package:kalender/src/models/calendar/calendar_style.dart';
import 'package:kalender/src/models/view_configurations/view_confiuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/providers/calendar_style.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_content.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_header.dart';

class MultidDayView<T extends Object?> extends StatefulWidget {
  const MultidDayView({
    super.key,
    required this.controller,
    required this.eventController,
    required this.components,
    this.viewConfiguration,
    this.functions,
  });

  final CalendarController controller;
  final CalendarEventController<T> eventController;
  final MultiDayViewConfiguration? viewConfiguration;
  final CalendarComponents<T> components;
  final CalendarFunctions<T>? functions;

  @override
  State<MultidDayView<T>> createState() => _MultidDayViewState<T>();
}

class _MultidDayViewState<T extends Object?> extends State<MultidDayView<T>> {
  late CalendarController _controller;
  late CalendarEventController<T> _eventController;
  late CalendarViewState _controllerState;
  late CalendarFunctions<T> _functions;
  late CalendarComponents<T> _components;
  late MultiDayViewConfiguration _viewConfiguration;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _eventController = widget.eventController;
    _functions = widget.functions ?? CalendarFunctions<T>();
    _components = widget.components;

    _initializeControllerState();
    _controller.attach(_controllerState);
  }

  @override
  void dispose() {
    // Set the selectedDate to the start of the visibleDateTimeRange.
    _controller.selectedDate = _controllerState.visibleDateTimeRange.value.start;

    // Detach the controller from the current state.
    _controller.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CalendarStyleProvider(
      style: const CalendarStyle(),
      child: CalendarScope<T>(
        state: _controllerState,
        eventController: _eventController,
        functions: _functions,
        components: _components,
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Initializes the [_controllerState].
  void _initializeControllerState() {
    _viewConfiguration = (widget.viewConfiguration ?? const WeekConfiguration());

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

    _controllerState = CalendarViewState(
      viewConfiguration: _viewConfiguration,
      pageController: pageController,
      adjustedDateTimeRange: adjustedDateTimeRange,
      numberOfPages: numberOfPages,
      scrollController: ScrollController(),
      visibleDateTimeRange: ValueNotifier<DateTimeRange>(visibleDateRange),
      heightPerMinute: ValueNotifier<double>(0.7),
    );
  }
}
