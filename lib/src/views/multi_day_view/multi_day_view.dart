import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

/// A widget that displays a multi day view.
class MultiDayView<T> extends StatefulWidget {
  const MultiDayView({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.tileBuilder,
    required this.multiDayTileBuilder,
    this.components,
    this.style,
    this.multiDayViewConfiguration = const WeekConfiguration(),
    this.functions,
    this.layoutControllers,
  });

  /// The [CalendarController] used to control the view.
  final CalendarController<T> controller;

  /// The [CalendarEventsController] used to control events.
  final CalendarEventsController<T> eventsController;

  /// The [MultiDayViewConfiguration] used to configure the view.
  final MultiDayViewConfiguration multiDayViewConfiguration;

  /// The [CalendarComponents] used to build the components of the view.
  final CalendarComponents? components;

  /// The [CalendarStyle] used to style the default components.
  final CalendarStyle? style;

  /// The [CalendarEventHandlers] used to handle events.
  final CalendarEventHandlers<T>? functions;

  /// The [CalendarLayoutDelegates] used to layout the calendar's tiles.
  final CalendarLayoutDelegates<T>? layoutControllers;

  /// The [TileBuilder] used to build event tiles.
  final TileBuilder<T> tileBuilder;

  /// The [MultiDayTileBuilder] used to build multi day event tiles.
  final MultiDayTileBuilder<T> multiDayTileBuilder;

  @override
  State<MultiDayView<T>> createState() => _MultiDayViewState<T>();
}

class _MultiDayViewState<T> extends State<MultiDayView<T>> {
  late MultiDayViewState _viewState;

  @override
  void initState() {
    super.initState();

    _initializeViewState();

    if (kDebugMode) {
      print('The controller is already attached to a view. detaching first.');
    }
    // _controller.detach();
    widget.controller.attach(_viewState);
  }

  @override
  void didUpdateWidget(covariant MultiDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_viewState.viewConfiguration != widget.multiDayViewConfiguration) {
      _initializeViewState();

      if (kDebugMode) {
        print('The controller is already attached to a view. detaching first.');
      }

      // _controller.detach();
      widget.controller.attach(_viewState);
    }
  }

  void _initializeViewState() {
    final initialDate = widget.controller.selectedDate;

    final adjustedDateTimeRange =
        widget.multiDayViewConfiguration.calculateAdjustedDateTimeRange(
      dateTimeRange: widget.controller.dateTimeRange,
      visibleStart: initialDate,
    );

    final numberOfPages =
        widget.multiDayViewConfiguration.calculateNumberOfPages(
      adjustedDateTimeRange,
    );

    final initialPage = widget.multiDayViewConfiguration.calculateDateIndex(
      initialDate,
      adjustedDateTimeRange.start,
    );

    final pageController = PageController(
      initialPage: initialPage,
    );

    final visibleDateRange =
        widget.multiDayViewConfiguration.calculateVisibleDateTimeRange(
      initialDate,
    );

    final heightPerMinute =
        (widget.controller.previousState is MultiDayViewState)
            ? (widget.controller.previousState as MultiDayViewState)
                .heightPerMinute
                ?.value
            : 0.7;

    _viewState = MultiDayViewState(
      viewConfiguration: widget.multiDayViewConfiguration,
      pageController: pageController,
      adjustedDateTimeRange: adjustedDateTimeRange,
      numberOfPages: numberOfPages,
      scrollController: ScrollController(),
      visibleDateTimeRange: ValueNotifier<DateTimeRange>(visibleDateRange),
      heightPerMinute: ValueNotifier<double>(heightPerMinute ?? 0.7),
    );
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
          tileBuilder: widget.tileBuilder,
          multiDayTileBuilder: widget.multiDayTileBuilder,
        ),
        platformData: PlatformData(),
        layoutDelegates:
            widget.layoutControllers ?? CalendarLayoutDelegates<T>(),
        child: Column(
          children: <Widget>[
            MultiDayHeader<T>(
              viewConfiguration: widget.multiDayViewConfiguration,
            ),
            Expanded(
              child: MultiDayContent<T>(
                controller: widget.controller,
                viewConfiguration: widget.multiDayViewConfiguration,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
