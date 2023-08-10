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
import 'package:kalender/src/views/month_view/month_view_content.dart';
import 'package:kalender/src/views/month_view/month_view_header.dart';

class MonthView<T> extends StatefulWidget {
  const MonthView({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.monthTileBuilder,
    this.monthViewConfiguration,
    this.components,
    this.style,
    this.functions,
    this.createNewEvents = true,
  });

  /// The [CalendarController] used to control the view.
  final CalendarController<T> controller;

  /// The [CalendarEventsController] used to control events.
  final CalendarEventsController<T> eventsController;

  /// The [MonthViewConfiguration] used to configure the view.
  final MonthViewConfiguration? monthViewConfiguration;

  /// The [CalendarComponents] used to build the components of the view.
  final CalendarComponents? components;

  /// The [CalendarStyle] used to style the default components.
  final CalendarStyle? style;

  /// The [CalendarEventHandlers] used to handle events.
  final CalendarEventHandlers<T>? functions;

  /// The [MonthTileBuilder] used to build month event tiles.
  final MonthTileBuilder<T> monthTileBuilder;

  /// Can create new events.
  final bool createNewEvents;

  @override
  State<MonthView<T>> createState() => _MonthViewState<T>();
}

class _MonthViewState<T> extends State<MonthView<T>> {
  late CalendarController<T> _controller;
  late ViewState _viewState;
  late CalendarEventsController<T> _eventsController;
  late CalendarEventHandlers<T> _functions;
  late CalendarComponents _components;
  late CalendarTileComponents<T> _tileComponents;
  late MonthViewConfiguration _viewConfiguration;
  late CalendarStyle _style;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _eventsController = widget.eventsController;
    _functions = widget.functions ?? CalendarEventHandlers<T>();
    _components = widget.components ?? CalendarComponents();
    _tileComponents = CalendarTileComponents<T>(
      monthTileBuilder: widget.monthTileBuilder,
    );
    _viewConfiguration =
        (widget.monthViewConfiguration ?? const MonthConfiguration());
    _style = widget.style ?? const CalendarStyle();
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
  void didUpdateWidget(covariant MonthView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _eventsController = widget.eventsController;

    if (_style != widget.style) {
      _style = widget.style ?? const CalendarStyle();
    }

    if (widget.monthViewConfiguration != null &&
        widget.monthViewConfiguration != _viewConfiguration) {
      _viewConfiguration = widget.monthViewConfiguration!;
      _initializeViewState();
      if (kDebugMode) {
        print('The controller is already attached to a view. detaching first.');
      }
      // _controller.detach();
      _controller.attach(_viewState);
    }
  }

  void _initializeViewState() {
    DateTimeRange adjustedDateTimeRange =
        _viewConfiguration.calculateAdjustedDateTimeRange(
      dateTimeRange: _controller.dateTimeRange,
      visibleStart: _controller.selectedDate,
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

    DateTimeRange visibleDateRange =
        _viewConfiguration.calcualteVisibleDateTimeRange(
      _controller.selectedDate,
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
      style: _style,
      child: CalendarScope<T>(
        state: _viewState,
        eventsController: _eventsController,
        functions: _functions,
        components: _components,
        tileComponents: _tileComponents,
        platformData: PlatformData(),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double pageWidth = constraints.maxWidth;

            double cellWidth = _viewConfiguration.calculateDayWidth(pageWidth);

            return Column(
              children: <Widget>[
                MonthViewHeader<T>(
                  cellWidth: cellWidth,
                  viewConfiguration: _viewConfiguration,
                ),
                MonthViewContent<T>(
                  cellWidth: cellWidth,
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
