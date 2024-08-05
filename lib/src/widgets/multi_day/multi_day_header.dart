import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/multi_day_drag_target.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';
import 'package:kalender/src/widgets/gesture_detectors/multi_day_gesture_detector.dart';
import 'package:kalender/src/widgets/internal_components/expandable_page_view.dart';
import 'package:kalender/src/widgets/internal_components/page_clipper.dart';

// TODO: document this.
// Maybe give a broad overview of what this widget and how it works.

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

  /// The [MultiDayHeaderComponents] that will be used by the [MultiDayHeader].
  final MultiDayHeaderComponents? components;

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
    this.components,
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

    final viewController = calendarController!.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final headerConfiguration = this.configuration ?? MultiDayHeaderConfiguration();

    return LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        late final dayWidth =
            (pageWidth - viewConfiguration.timelineWidth) / viewConfiguration.numberOfDays;

        late final singleDay = _SingleDayHeader(
          key: ValueKey(viewConfiguration.hashCode),
          eventsController: eventsController!,
          calendarController: calendarController!,
          configuration: headerConfiguration,
          tileComponents: tileComponents,
          components: components,
          componentStyles: componentStyles,
          timelineWidth: viewConfiguration.timelineWidth,
          tileHeight: headerConfiguration.tileHeight,
          pageWidth: pageWidth,
          callbacks: callbacks,
        );

        late final multiDay = _MultiDayHeader(
          key: ValueKey(viewConfiguration.hashCode),
          eventsController: eventsController!,
          calendarController: calendarController!,
          configuration: headerConfiguration,
          tileComponents: tileComponents,
          components: components,
          componentStyles: componentStyles,
          timelineWidth: viewConfiguration.timelineWidth,
          tileHeight: headerConfiguration.tileHeight,
          pageWidth: pageWidth,
          dayWidth: dayWidth,
          callbacks: callbacks,
        );

        final header = viewConfiguration.numberOfDays == 1 ? singleDay : multiDay;

        return Column(children: [header]);
      },
    );
  }
}

class _SingleDayHeader<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;

  final CalendarCallbacks<T>? callbacks;

  final MultiDayHeaderConfiguration configuration;
  final TileComponents<T> tileComponents;
  final MultiDayHeaderComponents? components;
  final MultiDayHeaderComponentStyles? componentStyles;
  final double timelineWidth;
  final double tileHeight;
  final double pageWidth;

  const _SingleDayHeader({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.callbacks,
    required this.configuration,
    required this.tileComponents,
    required this.components,
    required this.componentStyles,
    required this.timelineWidth,
    required this.tileHeight,
    required this.pageWidth,
  });

  @override
  Widget build(BuildContext context) {
    final viewController = calendarController.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;

    final dayHeaderStyle = componentStyles?.dayHeaderStyle;
    final dayHeaderWidget = ValueListenableBuilder(
      valueListenable: viewController.visibleDateTimeRange,
      builder: (context, visibleRange, child) {
        return components?.dayHeaderBuilder?.call(
              visibleRange.start,
              dayHeaderStyle,
            ) ??
            DayHeader(
              date: visibleRange.start,
              style: dayHeaderStyle,
            );
      },
    );

    final dayHeader = SizedBox(
      width: timelineWidth,
      child: dayHeaderWidget,
    );

    final pageView = ExpandablePageView(
      controller: viewController.headerController,
      itemCount: viewController.numberOfPages,
      itemBuilder: (context, index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(
          index,
        );

        final constraints = BoxConstraints(
          minHeight: tileHeight * 2,
          minWidth: pageWidth,
        );

        final multiDayEvents = MultiDayEventWidget<T>(
          eventsController: eventsController,
          controller: calendarController,
          visibleDateTimeRange: visibleRange,
          tileComponents: tileComponents,
          dayWidth: pageWidth,
          allowResizing: configuration.allowResizing,
          allowRescheduling: configuration.allowRescheduling,
          showAllEvents: false,
          callbacks: callbacks,
          tileHeight: tileHeight,
          layoutStrategy: configuration.eventLayoutStrategy,
        );

        final multiDayDragTarget = MultiDayDragTarget<T>(
          eventsController: eventsController,
          calendarController: calendarController,
          callbacks: callbacks,
          tileComponents: tileComponents,
          pageTriggerSetup: configuration.pageTriggerConfiguration,
          visibleDateTimeRange: visibleRange,
          dayWidth: pageWidth,
          pageWidth: pageWidth,
          tileHeight: tileHeight,
          allowSingleDayEvents: false,
          leftPageTrigger: components?.leftTriggerBuilder,
          rightPageTrigger: components?.rightTriggerBuilder,
        );

        final gestureDetector = MultiDayGestureDetector<T>(
          visibleDateTimeRange: visibleRange,
          eventsController: eventsController,
          controller: calendarController,
          callbacks: callbacks,
          createEventTrigger: configuration.createEventTrigger,
          dayWidth: pageWidth,
        );

        return Stack(
          children: [
            Positioned.fill(child: gestureDetector),
            ConstrainedBox(constraints: constraints, child: multiDayEvents),
            Positioned.fill(child: multiDayDragTarget),
          ],
        );
      },
    );

    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: dayHeader,
        ),
        PageClipWidget(
          left: viewConfiguration.leftPageClip,
          child: Row(
            children: [
              SizedBox(width: timelineWidth),
              Expanded(child: pageView),
            ],
          ),
        ),
      ],
    );
  }
}

class _MultiDayHeader<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;

  final CalendarCallbacks<T>? callbacks;
  final MultiDayHeaderConfiguration configuration;
  final TileComponents<T> tileComponents;
  final MultiDayHeaderComponents? components;
  final MultiDayHeaderComponentStyles? componentStyles;
  final double timelineWidth;
  final double tileHeight;
  final double pageWidth;
  final double dayWidth;

  const _MultiDayHeader({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.callbacks,
    required this.configuration,
    required this.tileComponents,
    required this.components,
    required this.componentStyles,
    required this.timelineWidth,
    required this.tileHeight,
    required this.pageWidth,
    required this.dayWidth,
  });

  @override
  Widget build(BuildContext context) {
    final viewController = calendarController.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;

    final weekNumberStyle = componentStyles?.weekNumberStyle;

    final weekNumberWidget = ValueListenableBuilder(
      valueListenable: viewController.visibleDateTimeRange,
      builder: (context, value, child) {
        return components?.weekNumberBuilder?.call(
              value,
              weekNumberStyle,
            ) ??
            WeekNumber(
              visibleDateTimeRange: value,
              weekNumberStyle: weekNumberStyle,
            );
      },
    );

    final pageView = ExpandablePageView(
      controller: viewController.headerController,
      itemCount: viewController.numberOfPages,
      itemBuilder: (context, index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(
          index,
        );
        final visibleDates = visibleRange.days;

        final dayHeaderStyle = componentStyles?.dayHeaderStyle;
        final dayHeaders = visibleDates.map((date) {
          final dayHeader = components?.dayHeaderBuilder?.call(
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
          controller: calendarController,
          eventsController: eventsController,
          visibleDateTimeRange: visibleRange,
          tileComponents: tileComponents,
          dayWidth: dayWidth,
          allowResizing: configuration.allowResizing,
          allowRescheduling: configuration.allowRescheduling,
          showAllEvents: false,
          callbacks: callbacks,
          tileHeight: tileHeight,
          layoutStrategy: configuration.eventLayoutStrategy,
        );

        final multiDayDragTarget = MultiDayDragTarget<T>(
          calendarController: calendarController,
          eventsController: eventsController,
          callbacks: callbacks,
          tileComponents: tileComponents,
          pageTriggerSetup: configuration.pageTriggerConfiguration,
          visibleDateTimeRange: visibleRange,
          dayWidth: dayWidth,
          pageWidth: pageWidth,
          tileHeight: tileHeight,
          allowSingleDayEvents: false,
          leftPageTrigger: components?.leftTriggerBuilder,
          rightPageTrigger: components?.rightTriggerBuilder,
        );

        final gestureDetector = MultiDayGestureDetector<T>(
          visibleDateTimeRange: visibleRange,
          eventsController: eventsController,
          controller: calendarController,
          callbacks: callbacks,
          createEventTrigger: configuration.createEventTrigger,
          dayWidth: dayWidth,
        );

        final constraints = BoxConstraints(
          minHeight: tileHeight,
          minWidth: pageWidth,
        );

        return Column(
          children: [
            Row(children: [...dayHeaders]),
            if (configuration.showTiles)
              Stack(
                children: [
                  Positioned.fill(child: gestureDetector),
                  ConstrainedBox(constraints: constraints, child: multiDayEvents),
                  Positioned.fill(child: multiDayDragTarget),
                ],
              ),
          ],
        );
      },
    );

    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: timelineWidth,
          child: weekNumberWidget,
        ),
        PageClipWidget(
          left: viewConfiguration.leftPageClip,
          child: Row(
            children: [
              SizedBox(width: timelineWidth),
              Expanded(child: pageView),
            ],
          ),
        ),
      ],
    );
  }
}
