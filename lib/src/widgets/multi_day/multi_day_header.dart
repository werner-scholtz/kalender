import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/components/multi_day_components.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/components/day_header.dart';
import 'package:kalender/src/widgets/components/week_number.dart';
import 'package:kalender/src/widgets/drag_targets/multi_day_drag_target.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';
import 'package:kalender/src/widgets/gesture_detectors/multi_day_gesture_detector.dart';

class MultiDayHeader<T extends Object?> extends StatelessWidget {
  /// The [EventsController] that will be used by the [MultiDayHeader].
  final EventsController<T>? eventsController;

  /// The [CalendarController] that will be used by the [MultiDayHeader].
  final CalendarController<T>? calendarController;

  /// The [CalendarCallbacks] that will be used by the [MultiDayHeader].
  final CalendarCallbacks<T>? callbacks;

  /// The [TileComponents] that will be used by the [MultiDayHeader].
  final TileComponents<T> tileComponents;

  /// The [MultiDayHeaderConfiguration] that will be used by the [MultiDayHeader].
  final MultiDayHeaderConfiguration? configuration;

  /// The [MultiDayHeaderComponentBuilders] that will be used by the [MultiDayHeader].
  final MultiDayHeaderComponentBuilders? componentBuilders;

  /// The [MultiDayHeaderComponentStyles] that will be used by the [MultiDayHeader].
  final MultiDayHeaderComponentStyles? componentStyles;

  /// Creates a new [MultiDayHeader].
  const MultiDayHeader({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    required this.tileComponents,
    this.configuration,
    this.componentBuilders,
    this.componentStyles,
  });

  @override
  Widget build(BuildContext context) {
    var eventsController = this.eventsController;
    var calendarController = this.calendarController;
    var callbacks = this.callbacks;

    final provider = CalendarProvider.maybeOf<T>(context);
    if (provider == null) {
      assert(
        eventsController != null,
        'The eventsController needs to be provided when the $MultiDayHeader<$T> is not wrapped in a $CalendarProvider<$T>.',
      );
      assert(
        calendarController != null,
        'The calendarController needs to be provided when the $MultiDayHeader<$T> is not wrapped in a $CalendarProvider<$T>.',
      );
    } else {
      eventsController ??= provider.eventsController;
      calendarController ??= provider.calendarController;
      callbacks ??= provider.callbacks;
    }

    assert(
      calendarController!.isAttached,
      'The CalendarController needs to be attached to a $ViewController<$T>.',
    );

    assert(
      calendarController!.viewController is MultiDayViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MultiDayViewController<$T>',
    );

    final viewController =
        calendarController!.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final headerConfiguration =
        this.configuration ?? MultiDayHeaderConfiguration();

    return LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        late final dayWidth = (pageWidth - viewConfiguration.timelineWidth) /
            viewConfiguration.numberOfDays;

        return ValueListenableBuilder(
          valueListenable: viewController.visibleDateTimeRange,
          builder: (context, visibleDateTimeRange, child) {
            final header = viewConfiguration.numberOfDays == 1
                ? _SingleDayHeader(
                    eventsController: eventsController!,
                    viewController: viewController,
                    visibleDateTimeRange: visibleDateTimeRange,
                    headerConfiguration: headerConfiguration,
                    tileComponents: tileComponents,
                    componentBuilders: componentBuilders,
                    componentStyles: componentStyles,
                    timelineWidth: viewConfiguration.timelineWidth,
                    tileHeight: headerConfiguration.tileHeight,
                    pageWidth: pageWidth,
                    callbacks: callbacks,
                  )
                : _MultiDayHeader(
                    eventsController: eventsController!,
                    viewController: viewController,
                    visibleDateTimeRange: visibleDateTimeRange,
                    headerConfiguration: headerConfiguration,
                    tileComponents: tileComponents,
                    componentBuilders: componentBuilders,
                    componentStyles: componentStyles,
                    timelineWidth: viewConfiguration.timelineWidth,
                    tileHeight: headerConfiguration.tileHeight,
                    pageWidth: pageWidth,
                    dayWidth: dayWidth,
                    callbacks: callbacks,
                  );

            return Column(
              children: [header],
            );
          },
        );
      },
    );
  }
}

class _SingleDayHeader<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final MultiDayViewController<T> viewController;
  final CalendarCallbacks<T>? callbacks;
  final DateTimeRange visibleDateTimeRange;
  final MultiDayHeaderConfiguration headerConfiguration;
  final TileComponents<T> tileComponents;
  final MultiDayHeaderComponentBuilders? componentBuilders;
  final MultiDayHeaderComponentStyles? componentStyles;
  final double timelineWidth;
  final double tileHeight;
  final double pageWidth;

  const _SingleDayHeader({
    super.key,
    required this.eventsController,
    required this.viewController,
    required this.callbacks,
    required this.visibleDateTimeRange,
    required this.headerConfiguration,
    required this.tileComponents,
    required this.componentBuilders,
    required this.componentStyles,
    required this.timelineWidth,
    required this.tileHeight,
    required this.pageWidth,
  });

  @override
  Widget build(BuildContext context) {
    final constraints = BoxConstraints(
      minHeight: tileHeight * 2,
      minWidth: pageWidth,
    );

    final dayHeaderStyle = componentStyles?.dayHeaderStyle;
    final dayHeaderWidget = componentBuilders?.dayHeaderBuilder?.call(
          visibleDateTimeRange.start,
          dayHeaderStyle,
        ) ??
        DayHeader(
          date: visibleDateTimeRange.start,
          style: dayHeaderStyle,
        );

    final dayHeader = SizedBox(
      width: timelineWidth,
      child: dayHeaderWidget,
    );

    final multiDayEvents = MultiDayEventWidget<T>(
      eventsController: eventsController,
      visibleDateTimeRange: visibleDateTimeRange,
      tileComponents: tileComponents,
      viewController: viewController,
      dayWidth: pageWidth,
      allowResizing: headerConfiguration.allowResizing,
      showAllEvents: false,
      callbacks: callbacks,
      tileHeight: tileHeight,
    );

    final multiDayDragTarget = MultiDayDragTarget<T>(
      eventsController: eventsController,
      viewController: viewController,
      tileComponents: tileComponents,
      pageTriggerSetup: headerConfiguration.pageTriggerConfiguration,
      visibleDateTimeRange: visibleDateTimeRange,
      dayWidth: pageWidth,
      pageWidth: pageWidth,
      tileHeight: tileHeight,
      callbacks: callbacks,
      allowSingleDayEvents: false,
    );

    final gestureDetector = MultiDayGestureDetector<T>(
      visibleDateTimeRange: visibleDateTimeRange,
      eventsController: eventsController,
      viewController: viewController,
      callbacks: callbacks,
      createEventTrigger: headerConfiguration.createEventTrigger,
      dayWidth: pageWidth,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dayHeader,
        Expanded(
          child: IntrinsicHeight(
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned.fill(child: gestureDetector),
                    ConstrainedBox(
                      constraints: constraints,
                      child: multiDayEvents,
                    ),
                    Positioned.fill(
                      child: multiDayDragTarget,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MultiDayHeader<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final MultiDayViewController<T> viewController;
  final DateTimeRange visibleDateTimeRange;
  final CalendarCallbacks<T>? callbacks;
  final MultiDayHeaderConfiguration headerConfiguration;
  final TileComponents<T> tileComponents;
  final MultiDayHeaderComponentBuilders? componentBuilders;
  final MultiDayHeaderComponentStyles? componentStyles;
  final double timelineWidth;
  final double tileHeight;
  final double pageWidth;
  final double dayWidth;

  const _MultiDayHeader({
    super.key,
    required this.eventsController,
    required this.viewController,
    required this.callbacks,
    required this.visibleDateTimeRange,
    required this.headerConfiguration,
    required this.tileComponents,
    required this.componentBuilders,
    required this.componentStyles,
    required this.timelineWidth,
    required this.tileHeight,
    required this.pageWidth,
    required this.dayWidth,
  });

  @override
  Widget build(BuildContext context) {
    final constraints = BoxConstraints(
      minHeight: tileHeight,
      minWidth: pageWidth,
    );

    final weekNumberStyle = componentStyles?.weekNumberStyle;
    final weekNumberWidget = componentBuilders?.weekNumberBuilder?.call(
          visibleDateTimeRange,
          weekNumberStyle,
        ) ??
        WeekNumber(
          visibleDateTimeRange: visibleDateTimeRange,
          weekNumberStyle: weekNumberStyle,
        );

    final weekNumber = SizedBox(
      width: timelineWidth,
      child: weekNumberWidget,
    );

    final visibleDates = visibleDateTimeRange.datesSpanned;
    final dayHeaderStyle = componentStyles?.dayHeaderStyle;
    final dayHeaders = visibleDates.map((date) {
      final dayHeader = componentBuilders?.dayHeaderBuilder?.call(
            date,
            dayHeaderStyle,
          ) ??
          DayHeader(
            date: date,
            style: dayHeaderStyle,
          );

      return SizedBox(
        width: dayWidth,
        child: dayHeader,
      );
    }).toList();

    final multiDayEvents = MultiDayEventWidget<T>(
      eventsController: eventsController,
      visibleDateTimeRange: visibleDateTimeRange,
      tileComponents: tileComponents,
      viewController: viewController,
      dayWidth: dayWidth,
      allowResizing: headerConfiguration.allowResizing,
      showAllEvents: false,
      callbacks: callbacks,
      tileHeight: tileHeight,
    );

    final multiDayDragTarget = MultiDayDragTarget<T>(
      eventsController: eventsController,
      viewController: viewController,
      tileComponents: tileComponents,
      pageTriggerSetup: headerConfiguration.pageTriggerConfiguration,
      visibleDateTimeRange: visibleDateTimeRange,
      dayWidth: dayWidth,
      pageWidth: pageWidth,
      tileHeight: tileHeight,
      callbacks: callbacks,
      allowSingleDayEvents: false,
    );

    final gestureDetector = MultiDayGestureDetector<T>(
      visibleDateTimeRange: visibleDateTimeRange,
      eventsController: eventsController,
      viewController: viewController,
      callbacks: callbacks,
      createEventTrigger: headerConfiguration.createEventTrigger,
      dayWidth: dayWidth,
    );

    return Row(
      children: [
        weekNumber,
        Expanded(
          child: Column(
            children: [
              Row(children: [...dayHeaders]),
              IntrinsicHeight(
                child: Stack(
                  children: [
                    Positioned.fill(child: gestureDetector),
                    ConstrainedBox(
                      constraints: constraints,
                      child: multiDayEvents,
                    ),
                    Positioned.fill(child: multiDayDragTarget),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
