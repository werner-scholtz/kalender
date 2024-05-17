import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/components/multi_day_components.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/providers/multi_day_provider.dart';
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
        final dayWidth = (pageWidth - viewConfiguration.timelineWidth) /
            viewConfiguration.numberOfDays;

        return ValueListenableBuilder(
          valueListenable: viewController.visibleDateTimeRange,
          builder: (context, visibleDateTimeRange, child) {
            final header = viewConfiguration.numberOfDays == 1
                ? _SingleDayHeader(visibleDateTimeRange: visibleDateTimeRange)
                : _MultiDayHeader(visibleDateTimeRange: visibleDateTimeRange);

            return MultiDayProvider(
              eventsController: eventsController!,
              viewController: viewController,
              tileComponents: tileComponents,
              pageWidth: pageWidth,
              dayWidth: dayWidth,
              callbacks: callbacks,
              headerConfiguration: headerConfiguration,
              componentBuilders: componentBuilders,
              componentStyles: componentStyles,
              child: Column(
                children: [
                  header,
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SingleDayHeader<T extends Object?> extends StatelessWidget {
  final DateTimeRange visibleDateTimeRange;
  const _SingleDayHeader({
    super.key,
    required this.visibleDateTimeRange,
  });

  @override
  Widget build(BuildContext context) {
    final provider = MultiDayProvider.of<T>(context);
    final timelineWidth = provider.timelineWidth;

    final tileHeight = provider.tileHeight;
    final pageWidth = provider.pageWidth;
    final constraints = BoxConstraints(
      minHeight: tileHeight * 2,
      minWidth: pageWidth,
    );

    final dayHeaderStyle = provider.componentStyles?.dayHeaderStyle;
    final dayHeaderWidget = provider.componentBuilders?.dayHeaderBuilder?.call(
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
      visibleDateTimeRange: visibleDateTimeRange,
    );

    final multiDayDragTarget = MultiDayDragTarget<T>(
      allowSingleDayEvents: false,
    );

    final gestureDetector = MultiDayGestureDetector<T>(
      visibleDateTimeRange: visibleDateTimeRange,
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
  final DateTimeRange visibleDateTimeRange;
  const _MultiDayHeader({super.key, required this.visibleDateTimeRange});

  @override
  Widget build(BuildContext context) {
    final provider = MultiDayProvider.of<T>(context);
    final timelineWidth = provider.timelineWidth;
    final tileHeight = provider.tileHeight;
    final pageWidth = provider.pageWidth;
    final numberOfDays = provider.viewConfiguration.numberOfDays;

    final constraints = BoxConstraints(
      minHeight: tileHeight,
      minWidth: pageWidth,
    );

    final weekNumberStyle = provider.componentStyles?.weekNumberStyle;
    final weekNumberWidget =
        provider.componentBuilders?.weekNumberBuilder?.call(
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

    final dayWidth = (pageWidth - timelineWidth) / numberOfDays;

    final visibleDates = visibleDateTimeRange.datesSpanned;
    final dayHeaderStyle = provider.componentStyles?.dayHeaderStyle;
    final dayHeaders = visibleDates.map((date) {
      final dayHeader = provider.componentBuilders?.dayHeaderBuilder?.call(
            visibleDateTimeRange.start,
            dayHeaderStyle,
          ) ??
          DayHeader(
            date: visibleDateTimeRange.start,
            style: dayHeaderStyle,
          );

      return SizedBox(
        width: dayWidth,
        child: dayHeader,
      );
    }).toList();

    final multiDayEvents = MultiDayEventWidget<T>(
      visibleDateTimeRange: visibleDateTimeRange,
    );
    final multiDayDragTarget = MultiDayDragTarget<T>(
      allowSingleDayEvents: false,
    );

    final gestureDetector = MultiDayGestureDetector<T>(
      visibleDateTimeRange: visibleDateTimeRange,
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
