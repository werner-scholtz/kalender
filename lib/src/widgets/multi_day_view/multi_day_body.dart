import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/providers/multi_day_body_provider.dart';
import 'package:kalender/src/models/view_configurations/export.dart';
import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/widgets/components/day_separator.dart';
import 'package:kalender/src/widgets/components/hour_lines.dart';
import 'package:kalender/src/widgets/components/time_indicator.dart';
import 'package:kalender/src/widgets/components/time_line.dart';
import 'package:kalender/src/widgets/multi_day_view/multi_day_drag_target.dart';
import 'package:kalender/src/widgets/multi_day_view/multi_day_page_view.dart';

/// The styles of the default components used by the [MultiDayBody].
class MultiDayBodyComponentStyles {
  /// The style of the day separator.
  final DaySeparatorStyle? daySeparatorStyle;

  /// The style of the time indicator.
  final TimeIndicatorStyle? timeIndicatorStyle;

  /// The style of the hour lines.
  final HourLinesStyle? hourLinesStyle;

  /// The style of the timeline.
  final TimelineStyle? timelineStyle;

  const MultiDayBodyComponentStyles({
    this.daySeparatorStyle,
    this.timeIndicatorStyle,
    this.hourLinesStyle,
    this.timelineStyle,
  });
}

/// The component builders used by the [MultiDayBody].
///
/// - Using these will override the respective default components.
class MultiDayBodyComponents {
  final HourLinesBuilder? hourLines;
  final TimeLineBuilder? timeline;
  final DaySeparatorBuilder? daySeparator;
  final TimeIndicatorBuilder? timeIndicator;

  const MultiDayBodyComponents({
    this.hourLines,
    this.timeline,
    this.daySeparator,
    this.timeIndicator,
  });
}

/// The components used by the [MultiDayBody] to render the event tiles.
///
/// See [Draggable] for more information on how the components are used.
/// - [tileBuilder]
/// - [tileWhenDraggingBuilder]
/// - [feedbackTileBuilder]
/// - [dragAnchorStrategy]
///
/// The [dropTargetTile] is an extra component used to display where the event will be dropped.
class MultiDayBodyTileComponents<T extends Object?> {
  final TileBuilder<T> tileBuilder;

  final TileWhenDraggingBuilder<T>? tileWhenDraggingBuilder;

  final FeedbackTileBuilder<T>? feedbackTileBuilder;

  final DragAnchorStrategy? dragAnchorStrategy;

  final TileDropTargetBuilder<T> dropTargetTile;

  final Widget? resizeHandle;

  const MultiDayBodyTileComponents({
    required this.tileBuilder,
    required this.dropTargetTile,
    this.tileWhenDraggingBuilder,
    this.feedbackTileBuilder,
    this.dragAnchorStrategy,
    this.resizeHandle,
  });
}

/// The callbacks used by the [MultiDayBody].
class MultiDayBodyCallbacks<T extends Object?> {
  final OnEventTapped<T>? onEventTapped;
  final OnEventChanged<T>? onEventDropped;
  final OnEventCreated? onEventCreated;
  final OnPageChanged? onPageChanged;

  const MultiDayBodyCallbacks({
    this.onEventTapped,
    this.onEventDropped,
    this.onEventCreated,
    // this.onCalendarDragged,
    this.onPageChanged,
  });
}

/// This widget is used to display a multi-day body.
class MultiDayBody<T extends Object?> extends StatelessWidget {
  /// The components used by the [MultiDayBody].
  final MultiDayBodyTileComponents<T> tileComponents;

  /// The styles of the components.
  final MultiDayBodyComponentStyles? componentStyles;

  /// The callbacks used by the [MultiDayBody].
  final MultiDayBodyCallbacks<T>? callbacks;

  /// The [EventsController] that will be used by the [MultiDayBody].
  final EventsController<T>? eventsController;

  /// The [CalendarController] that will be used by the [MultiDayBody].
  final CalendarController<T>? calendarController;

  /// The [ValueNotifier] containing the [heightPerMinute] value.
  final ValueNotifier<double>? heightPerMinute;

  /// The [ScrollController] used by the scrollable body.
  final ScrollController? scrollController;

  /// The [ScrollPhysics] used by the scrollable body.
  final ScrollPhysics? scrollPhysics;

  /// The [ScrollPhysics] used by the page view.
  final ScrollPhysics? pageScrollPhysics;

  const MultiDayBody({
    super.key,
    required this.tileComponents,
    this.componentStyles,
    this.callbacks,
    this.eventsController,
    this.calendarController,
    this.scrollController,
    this.heightPerMinute,
    this.scrollPhysics,
    this.pageScrollPhysics,
  });

  @override
  Widget build(BuildContext context) {
    late final provider = CalendarProvider.of<T>(context);

    return _MultiDayBody(
      eventsController: eventsController ?? provider.eventsController,
      calendarController: calendarController ?? provider.calendarController,
      scrollController: scrollController,
      heightPerMinute: heightPerMinute,
      scrollPhysics: scrollPhysics,
      pageScrollPhysics: pageScrollPhysics,
      tileComponents: tileComponents,
      componentStyles: componentStyles,
      callbacks: callbacks,
    );
  }
}

class _MultiDayBody<T extends Object?> extends StatefulWidget {
  const _MultiDayBody({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.tileComponents,
    this.callbacks,
    this.componentStyles,
    this.scrollController,
    this.heightPerMinute,
    this.scrollPhysics,
    this.pageScrollPhysics,
  });

  /// The [EventsController] that will be used by the [_MultiDayBody].
  final EventsController<T> eventsController;

  /// The [CalendarController] that will be used by the [_MultiDayBody].
  final CalendarController<T> calendarController;

  /// The components used by the [MultiDayBody].
  final MultiDayBodyTileComponents<T> tileComponents;

  /// The styles of the components.
  final MultiDayBodyComponentStyles? componentStyles;

  /// The callbacks used by the [MultiDayBody].
  final MultiDayBodyCallbacks<T>? callbacks;

  /// The [ValueNotifier] containing the [heightPerMinute] value.
  final ValueNotifier<double>? heightPerMinute;

  /// The [ScrollController] used by the scrollable body.
  final ScrollController? scrollController;

  /// The [ScrollPhysics] used by the scrollable body.
  final ScrollPhysics? scrollPhysics;

  /// The [ScrollPhysics] used by the page view.
  final ScrollPhysics? pageScrollPhysics;

  @override
  State<_MultiDayBody<T>> createState() => _MultiDayBodyState<T>();
}

class _MultiDayBodyState<T extends Object?> extends State<_MultiDayBody<T>> {
  late final EventsController<T> _eventsController;
  late final CalendarController<T> _controller;
  late MultiDayViewController _viewController;
  late PageController _pageController;
  late int _numberOfPages;
  late ScrollController _scrollController;
  late ValueNotifier<double> _heightPerMinute;
  late ValueNotifier<DateTimeRange> _visibleDateTimeRange;
  late ValueNotifier<CalendarEvent<T>?> _eventBeingDragged;

  MultiDayViewConfiguration get _viewConfiguration {
    return _viewController.viewConfiguration;
  }

  @override
  void initState() {
    super.initState();

    _eventsController = widget.eventsController;
    _controller = widget.calendarController;

    // Check that the calendar controller is attached.
    assert(
      _controller.isAttached,
      '$_controller needs to be attached to a $ViewConfiguration',
    );

    _setupView();
    _attachToViewController();
    _controller.addListener(_controllerListener);
  }

  @override
  void didUpdateWidget(covariant _MultiDayBody<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setupView();
    _attachToViewController();
  }

  @override
  void dispose() {
    super.dispose();
    _detachFromViewController();
    _controller.removeListener(_controllerListener);
  }

  void _controllerListener() {
    final oldConfiguration = _viewController.viewConfiguration;
    final currentConfiguration = _controller.viewController!.viewConfiguration;

    // Check if the configuration has changed.
    final hasChangedConfiguration = oldConfiguration != currentConfiguration;
    if (hasChangedConfiguration) {
      setState(() {
        _detachFromViewController();
        _setupView();
        _attachToViewController();
      });
    }
  }

  /// Setup [_MultiDayBody] with the provided controllers and variables.
  void _setupView() {
    // Check that the viewController is a MultiDayViewController.
    assert(
      _controller.viewController is MultiDayViewController,
      'The $_controller $ViewController needs to be a $MultiDayViewController',
    );
    _viewController = _controller.viewController as MultiDayViewController;

    final pageFunctions = _viewConfiguration.pageNavigationFunctions;

    // Setup the page controller.
    _numberOfPages = pageFunctions.numberOfPages;
    final initialPage = pageFunctions.indexFromDate(_controller.focusedDate);
    _pageController = PageController(initialPage: initialPage);
    _heightPerMinute = widget.heightPerMinute ?? ValueNotifier(0.7);
    _scrollController = widget.scrollController ?? ScrollController();

    // Setup the visible date time range.
    final visibleDateTimeRange = pageFunctions.dateTimeRangeFromDate(
      _controller.focusedDate,
    );
    _visibleDateTimeRange = ValueNotifier(visibleDateTimeRange);
    _eventBeingDragged = ValueNotifier<CalendarEvent<T>?>(null);
  }

  /// Attach the [_MultiDayBody] to the [ViewController].
  void _attachToViewController() {
    _viewController.attachBody(
      pageController: _pageController,
      scrollController: _scrollController,
      heightPerMinute: _heightPerMinute,
      visibleDateTimeRange: _visibleDateTimeRange,
    );
  }

  /// Detach the [_MultiDayBody] from the [ViewController].
  void _detachFromViewController() {
    _viewController.detachBody();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder(
          valueListenable: _heightPerMinute,
          builder: (context, heightPerMinute, child) {
            // Calculate the height of the page.
            final dayDuration = _viewConfiguration.timeOfDayRange.duration;
            final pageHeight = heightPerMinute * dayDuration.inMinutes;

            // Calculate the width of the page.
            final timelineWidth = _viewConfiguration.timelineWidth;
            final pageWidth = constraints.maxWidth - timelineWidth;

            // Calculate the width of a single day.
            final numberOfDays = _viewConfiguration.numberOfDays;
            final dayWidth = pageWidth / numberOfDays;

            final viewPortHeight = constraints.maxHeight;

            final hourLines = HourLines(
              timeOfDayRange: _viewConfiguration.timeOfDayRange,
              heightPerMinute: heightPerMinute,
              style: widget.componentStyles?.hourLinesStyle,
            );

            final timeline = TimeLine(
              timeOfDayRange: _viewConfiguration.timeOfDayRange,
              heightPerMinute: heightPerMinute,
              style: widget.componentStyles?.timelineStyle,
              eventBeingDragged: _eventBeingDragged,
            );

            final pageView = MultiDayPageView(
              eventsController: _eventsController,
              calendarController: _controller,
              eventBeingDragged: _eventBeingDragged,
              components: widget.tileComponents,
              callbacks: widget.callbacks,
            );

            final dragTarget = MultiDayDragTarget(
              eventsController: _eventsController,
              viewController: _viewController,
              eventBeingDragged: _eventBeingDragged,
              callbacks: widget.callbacks,
            );

            return MultiDayBodyProvider(
              viewConfiguration: _viewConfiguration,
              visibleDateTimeRange: _visibleDateTimeRange,
              dropTargetWidgetSize: _eventsController.feedbackWidgetSize,
              pageController: _pageController,
              pageScrollPhysics: widget.pageScrollPhysics,
              scrollController: _scrollController,
              heightPerMinute: heightPerMinute,
              viewportHeight: viewPortHeight,
              pageWidth: pageWidth,
              dayWidth: dayWidth,
              numberOfPages: _numberOfPages,
              componentStyles: widget.componentStyles,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Scrollbar(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: widget.scrollPhysics,
                        child: SizedBox(
                          height: pageHeight,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                width: 56.0,
                                child: timeline,
                              ),
                              Positioned.fill(child: hourLines),
                              Positioned.fill(child: pageView),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: timelineWidth,
                    height: min(pageHeight, viewPortHeight),
                    child: dragTarget,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
