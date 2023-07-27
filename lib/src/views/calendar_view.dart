import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar_components.dart';
import 'package:kalender/src/models/calendar_configuration.dart';
import 'package:kalender/src/models/calendar_controller.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/calendar_functions.dart';
import 'package:kalender/src/models/calendar_state.dart';
import 'package:kalender/src/models/calendar_style.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/providers/calendar_controller_provider.dart';
import 'package:kalender/src/providers/calendar_internals.dart';
import 'package:kalender/src/providers/calendar_style.dart';
import 'package:kalender/src/typedefs.dart';
import 'package:kalender/src/views/month_view/month_view.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_view.dart';
import 'package:kalender/src/views/schedule_view/schedule_view.dart';
import 'package:kalender/src/views/single_day_view/single_day_view.dart';

class CalendarView<T extends Object?> extends StatefulWidget {
  const CalendarView({
    super.key,
    this.controller,
    this.calendarConfiguration,
    this.onEventChanged,
    this.onEventTapped,
    this.onCreateEvent,
    required this.eventTileBuilder,
    required this.multiDayEventTileBuilder,
    required this.monthEventTileBuilder,
    required this.scheduleEventTileBuilder,
  });

  final CalendarController<T>? controller;

  final CalendarConfiguration? calendarConfiguration;

  /// The [Function] called when an event is changed.
  ///
  /// The [T] that is returned will be used as the eventData of the [CalendarEvent].
  final Future<void> Function(DateTimeRange initialDateTimeRange, CalendarEvent<T> event)?
      onEventChanged;

  /// The [Function] called when an event is tapped.
  final Future<void> Function(CalendarEvent<T> event)? onEventTapped;

  /// The [Function] called when an event is created.
  ///
  /// The [CalendarEvent] that is returned will be added to the [CalendarController].
  /// If null the event will not be created.
  final Future<CalendarEvent<T>?> Function(CalendarEvent<T> newEvent)? onCreateEvent;

  /// This builder is used to build event's with a duration < 24 hours.
  final EventTileBuilder<T> eventTileBuilder;

  /// This builder is used to build event's with a duration >= 24 hours.
  final MultiDayEventTileBuilder<T> multiDayEventTileBuilder;

  /// This builder is used to build event's on the [ViewType.month].
  final MonthEventTileBuilder<T> monthEventTileBuilder;

  /// This builder is used to build event's on the [ViewType.schedule].
  final ScheduleEventTileBuilder<T> scheduleEventTileBuilder;

  @override
  State<CalendarView<T>> createState() => _CalendarViewState<T>();
}

class _CalendarViewState<T extends Object?> extends State<CalendarView<T>> {
  CalendarController<T>? _controller;
  late CalendarConfiguration _configuration;

  late PageController _pageController;
  late int _initialPageIndex;
  late int _numberOfPages;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _heightPerMinute = ValueNotifier<double>(0.7);
  late ViewConfiguration _viewConfiguration;
  late DateTimeRange _dateTimeRange;
  late final ValueNotifier<DateTimeRange> _visibleDateRange;
  late final ValueNotifier<DateTime> _highlightedDate;
  late CalendarViewState _viewState;

  @override
  void initState() {
    super.initState();

    _configuration = widget.calendarConfiguration ?? CalendarConfiguration();

    _setViewConfiguration(_configuration.initialViewConfiguration);

    _highlightedDate = ValueNotifier<DateTime>(
      _configuration.initialDate,
    );

    _visibleDateRange = ValueNotifier<DateTimeRange>(
      _configuration.dateTimeRange,
    );

    _setDateTimeRange();
    _setVisibleDateTimeRange();
    _setNumberOfPages();
    _regulateVisibleDateRange();
    _setIndex();

    _pageController = PageController(
      initialPage: _initialPageIndex,
    );

    _setViewState();
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
      style: const CalendarStyle(),
      child: CalendarInternals<T>(
        controller: _controller!,
        components: CalendarComponents<T>(
          eventTileBuilder: widget.eventTileBuilder,
          multiDayEventTileBuilder: widget.multiDayEventTileBuilder,
          monthEventTileBuilder: widget.monthEventTileBuilder,
          scheduleEventTileBuilder: widget.scheduleEventTileBuilder,
        ),
        configuration: CalendarConfiguration(),
        functions: CalendarFunctions<T>(
          onPageChanged: _onPageChanged,
          onConfigurationChanged: changeConfiguration,
          onLeftArrowPressed: animateToPreviousPage,
          onDateSelectorPressed: _onDateSelectorPressed,
          onRightArrowPressed: animateToNextPage,
        ),
        style: const CalendarStyle(),
        state: _viewState,
        child: Builder(
          builder: (BuildContext context) {
            switch (_viewConfiguration.viewType) {
              case ViewType.singleDay:
                return SingleDayView<T>(
                  viewConfiguration: _viewConfiguration as SingleDayViewConfiguration,
                );
              case ViewType.multiDay:
                return MultiDayView<T>();
              case ViewType.month:
                return MonthView<T>();
              case ViewType.schedule:
                return ScheduleView<T>();
            }
          },
        ),
      ),
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
    _pageController.dispose();

    setState(() {
      _setViewConfiguration(viewConfiguration);
      _setDateTimeRange();
      _setVisibleDateTimeRange();
      _regulateVisibleDateRange();
      _setNumberOfPages();
      _setIndex();
      _pageController = PageController(
        initialPage: _initialPageIndex,
        keepPage: true,
      );
      _setViewState();
    });
  }

  void _setViewState() {
    _viewState = CalendarViewState(
      scrollController: _scrollController,
      visibleDateRange: _visibleDateRange,
      heightPerMinute: _heightPerMinute,
      dateTimeRange: _dateTimeRange,
      pageController: _pageController,
      numberOfPages: _numberOfPages,
    );
  }

  void _setViewConfiguration(ViewConfiguration viewConfiguration) {
    assert(_configuration.viewConfigurations.contains(viewConfiguration));
    _viewConfiguration = _configuration.initialViewConfiguration;
  }

  void _setDateTimeRange() {
    _dateTimeRange = _viewConfiguration.calculateAdjustedDateTimeRange(
      _configuration.dateTimeRange,
      _highlightedDate.value,
      _configuration.firstDayOfWeek,
    );
  }

  /// Sets the visible [DateTimeRange].
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

  void _setIndex() {
    _initialPageIndex =
        _viewConfiguration.calculateIndex(_dateTimeRange.start, _highlightedDate.value);
  }

  /// Sets the [_numberOfPages].
  void _setNumberOfPages() {
    _numberOfPages = _viewConfiguration.calculateNumberOfPages(_dateTimeRange);
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
