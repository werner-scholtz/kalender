import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_model_export.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/providers/calendar_controller_provider.dart';
import 'package:kalender/src/providers/calendar_internals.dart';
import 'package:kalender/src/providers/calendar_style.dart';
import 'package:kalender/src/views/month_view/month_view.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_view.dart';
import 'package:kalender/src/views/schedule_view/schedule_view.dart';
import 'package:kalender/src/views/single_day_view/single_day_view.dart';

import 'package:kalender/src/models/view_configurations/view_confiuration_export.dart';

class CalendarView<T extends Object?> extends StatefulWidget {
  const CalendarView({
    super.key,
    this.controller,
    this.calendarConfiguration,
    required this.calendarComponents,
    this.calendarStyle,
    this.onEventChanged,
    this.onEventTapped,
    this.onCreateEvent,
    this.onDateTapped,
  });

  /// The [CalendarController] used to store events.
  final CalendarController<T>? controller;

  /// The [CalendarConfiguration] used to configure the [CalendarView].
  final CalendarConfiguration? calendarConfiguration;

  /// The [CalendarComponents] used to build different componets of the [CalendarView].
  final CalendarComponents<T> calendarComponents;

  /// The [CalendarStyle] used to style the [CalendarView].
  /// And all of its components.
  final CalendarStyle? calendarStyle;

  /// The [Function] called when an event is changed.
  ///
  /// [previousDateTimeRange] is the [DateTimeRange] of the event before it was changed.
  final void Function(DateTimeRange previousDateTimeRange, CalendarEvent<T> event)? onEventChanged;

  /// The [Function] called when an event is tapped.
  final Future<void> Function(CalendarEvent<T> event)? onEventTapped;

  /// The [Function] called when an event is created.
  ///
  /// The [CalendarEvent] that is returned will be added to the [CalendarController].
  /// If null the event will not be created.
  final Future<CalendarEvent<T>?> Function(CalendarEvent<T> newEvent)? onCreateEvent;

  /// The [Function] called when a date is tapped.
  final void Function(DateTime date)? onDateTapped;

  @override
  State<CalendarView<T>> createState() => CalendarViewState<T>();
}

class CalendarViewState<T extends Object?> extends State<CalendarView<T>> {
  CalendarController<T>? _controller;
  CalendarController<T> get controller => _controller!;

  late CalendarConfiguration _configuration;
  late CalendarComponents<T> _components;
  late CalendarFunctions<T> _funcitons;
  late CalendarState _viewState;
  late CalendarStyle _style;

  late PageController _pageController;
  late ViewConfiguration _viewConfiguration;
  late DateTimeRange _dateTimeRange;

  final ScrollController _scrollController = ScrollController();

  late final ValueNotifier<double> _heightPerMinute;
  late final ValueNotifier<DateTimeRange> _visibleDateRange;
  late final ValueNotifier<DateTime> _highlightedDate;

  @override
  void initState() {
    super.initState();

    _components = widget.calendarComponents;
    _style = widget.calendarStyle ?? const CalendarStyle();
    _configuration = widget.calendarConfiguration ?? CalendarConfiguration();
    _highlightedDate = ValueNotifier<DateTime>(
      _configuration.initialDate,
    );

    _heightPerMinute = ValueNotifier<double>(0.7);

    _setViewConfiguration(_configuration.initialViewConfiguration);

    _visibleDateRange = ValueNotifier<DateTimeRange>(
      _viewConfiguration.calcualteVisibleDateTimeRange(
        _highlightedDate.value,
        _configuration.firstDayOfWeek,
      ),
    );

    _setDateTimeRange();
    _setVisibleDateTimeRange();
    _regulateVisibleDateRange();
    _setPageController();
    _setCalendarFunctions();
    _setCalendarState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assignController();
  }

  @override
  void didUpdateWidget(covariant CalendarView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _assignController();
  }

  @override
  Widget build(BuildContext context) {
    return CalendarStyleProvider(
      style: _style,
      child: CalendarInternals<T>(
        controller: _controller!,
        components: _components,
        configuration: _configuration,
        functions: _funcitons,
        state: _viewState,
        child: SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              switch (_viewConfiguration.viewType) {
                case ViewType.singleDay:
                  return SingleDayView<T>(
                    viewConfiguration: _viewConfiguration as SingleDayViewConfiguration,
                  );
                case ViewType.multiDay:
                  return MultiDayView<T>(
                    viewConfiguration: _viewConfiguration as MultiDayViewConfiguration,
                  );
                case ViewType.month:
                  return MonthView<T>();
                case ViewType.schedule:
                  return ScheduleView<T>();
              }
            },
          ),
        ),
      ),
    );
  }

  void _setCalendarFunctions() {
    _funcitons = CalendarFunctions<T>(
      onPageChanged: _onPageChanged,
      onConfigurationChanged: changeConfiguration,
      onLeftArrowPressed: animateToPreviousPage,
      onDateSelectorPressed: _onDateSelectorPressed,
      onRightArrowPressed: animateToNextPage,
      onDateTapped: widget.onDateTapped,
      onCreateEvent: widget.onCreateEvent,
      onEventChanged: widget.onEventChanged,
      onEventTapped: widget.onEventTapped,
    );
  }

  void _assignController() {
    CalendarController<T> controller =
        widget.controller ?? CalendarControllerProvider.of<T>(context).controller;
    if (controller != _controller) {
      _controller = controller;
    }
  }

  void changeConfiguration(ViewConfiguration viewConfiguration) {
    setState(() {
      _pageController.dispose();
      _setViewConfiguration(viewConfiguration);
      _setDateTimeRange();
      _setVisibleDateTimeRange();
      _regulateVisibleDateRange();
      _setPageController();
      _setCalendarState();
    });
  }

  void _setCalendarState() {
    _viewState = CalendarState(
      scrollController: _scrollController,
      visibleDateRange: _visibleDateRange,
      heightPerMinute: _heightPerMinute,
      dateTimeRange: _dateTimeRange,
      pageController: _pageController,
      numberOfPages: _viewConfiguration.calculateNumberOfPages(_dateTimeRange),
    );
  }

  void _setViewConfiguration(ViewConfiguration viewConfiguration) {
    assert(_configuration.viewConfigurations.contains(viewConfiguration));
    _viewConfiguration = viewConfiguration;
  }

  void _setPageController() {
    _pageController = PageController(
      initialPage: _viewConfiguration.calculateIndex(_dateTimeRange.start, _highlightedDate.value),
    );
  }

  /// Sets the visible [DateTimeRange].
  void _setDateTimeRange() {
    _dateTimeRange = _viewConfiguration.calculateAdjustedDateTimeRange(
      _configuration.dateTimeRange,
      _highlightedDate.value,
      _configuration.firstDayOfWeek,
    );
  }

  void _setVisibleDateTimeRange() {
    _visibleDateRange.value = _viewConfiguration.calcualteVisibleDateTimeRange(
      _highlightedDate.value,
      _configuration.firstDayOfWeek,
    );
  }

  /// Regulates the [_visibleDateRange] to be within the [_dateTimeRange].
  void _regulateVisibleDateRange() {
    assert(
      _visibleDateRange.value.start.isWithin(_dateTimeRange),
      'The start of the visible date range must be within dateTimeRange of the calendar.',
    );

    assert(
      _visibleDateRange.value.end.isWithin(_dateTimeRange),
      'The end of the visible date range must be within dateTimeRange of the calendar.',
    );

    _visibleDateRange.value = _viewConfiguration.regulateVisibleDateTimeRange(
      _dateTimeRange,
      _visibleDateRange.value,
      _configuration.firstDayOfWeek,
    );
  }

  /// Called when the page is changed.
  void _onPageChanged(int index) {
    _visibleDateRange.value = _viewConfiguration.calculateVisibleDateRangeForIndex(
      index,
      _dateTimeRange.start,
      _configuration.firstDayOfWeek,
    );
    _highlightedDate.value = _viewConfiguration.getHighlighedDate(
      _visibleDateRange.value,
    );
  }

  /// Called when the date selector is pressed.
  void _onDateSelectorPressed() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _visibleDateRange.value.start,
      firstDate: _dateTimeRange.start,
      lastDate: _dateTimeRange.end,
    );
    if (selectedDate == null) return;
    await animateToDate(selectedDate);
  }

  /// Animates to the next page of the [PageView].
  void animateToNextPage({Duration? duration, Curve? curve}) => _pageController.nextPage(
        duration: duration ?? _configuration.pageTransitionDuration,
        curve: curve ?? _configuration.pageTransitionCurve,
      );

  /// Animates to the previous page of the [PageView].
  void animateToPreviousPage({Duration? duration, Curve? curve}) => _pageController.previousPage(
        duration: duration ?? _configuration.pageTransitionDuration,
        curve: curve ?? _configuration.pageTransitionCurve,
      );

  /// Jumps to the [int] index of the [PageView].
  void jumpToPage(int index) => _pageController.jumpToPage(index);

  /// Jumps to the [date] of the [CalendarView].
  void jumpToDate(DateTime date) {
    if (!date.isWithin(_dateTimeRange)) {
      throw Exception('The date must be within the date range of the DayView.');
    }
    _pageController.jumpToPage(
      _viewConfiguration.calculateDateIndex(
        date,
        _dateTimeRange.start,
      ),
    );
  }

  /// Animates to the [DateTime] provided.
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    if (!date.isWithin(_dateTimeRange)) {
      throw Exception('The date must be within the dateTimeRange of the Calendar.');
    }
    await _pageController.animateToPage(
      _viewConfiguration.calculateDateIndex(
        date,
        _dateTimeRange.start,
      ),
      duration: duration ?? _configuration.pageTransitionDuration,
      curve: curve ?? _configuration.pageTransitionCurve,
    );
  }
}
