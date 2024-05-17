import 'package:flutter/material.dart';
import 'package:kalender/src/calendar_view.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/controllers/calendar_controller.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
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

  /// The height of the tiles.
  final double tileHeight;

  const MultiDayHeader({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    this.tileHeight = 24.0,
    required this.tileComponents,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        final dayWidth = pageWidth / viewConfiguration.numberOfDays;

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
              tileHeight: tileHeight,
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

    final dayHeader = SizedBox(
      width: timelineWidth,
      child: DayHeader(date: visibleDateTimeRange.start),
    );

    final multiDayEvents = MultiDayEventWidget<T>(
      visibleDateTimeRange: visibleDateTimeRange,
    );

    final multiDayDragTarget = MultiDayDragTarget<T>(
      allowSingleDayEvents: false,
    );

    final tileHeight = provider.tileHeight;
    final pageWidth = provider.pageWidth;
    final dragTargetConstrains = BoxConstraints(
      minHeight: tileHeight,
      minWidth: pageWidth,
    );

    final gestureDetector = MultiDayGestureDetector<T>(
      visibleDateTimeRange: visibleDateTimeRange,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dayHeader,
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(child: gestureDetector),
              multiDayEvents,
              Positioned.fill(
                child: ConstrainedBox(
                  constraints: dragTargetConstrains,
                  child: multiDayDragTarget,
                ),
              ),
            ],
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

    final weekNumber = SizedBox(
      width: timelineWidth,
      child: WeekNumber(visibleDateTimeRange: visibleDateTimeRange),
    );

    final dayWidth = (pageWidth - timelineWidth) / numberOfDays;

    final visibleDates = visibleDateTimeRange.datesSpanned;
    final dayHeaders = visibleDates.map((date) {
      return SizedBox(
        width: dayWidth,
        child: DayHeader(date: date),
      );
    }).toList();

    final multiDayEvents = MultiDayEventWidget<T>(
      visibleDateTimeRange: visibleDateTimeRange,
    );
    final multiDayDragTarget = MultiDayDragTarget<T>(
      allowSingleDayEvents: false,
    );

    final constraints = BoxConstraints(
      minHeight: tileHeight,
      minWidth: pageWidth,
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
