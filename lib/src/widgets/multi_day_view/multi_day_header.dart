import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/src/calendar_view.dart';
import 'package:kalender/src/extensions.dart';

import 'package:kalender/src/models/controllers/calendar_controller.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/components/day_header.dart';
import 'package:kalender/src/widgets/components/week_number.dart';
import 'package:kalender/src/widgets/multi_day_events_widget.dart';

class MultiDayHeader<T extends Object?> extends StatelessWidget {
  /// The [EventsController] that will be used by the [MultiDayHeader].
  final EventsController<T>? eventsController;

  /// The [CalendarController] that will be used by the [MultiDayHeader].
  final CalendarController<T>? calendarController;

  /// The [CalendarCallbacks] that will be used by the [MultiDayHeader].
  final CalendarCallbacks<T>? callbacks;

  const MultiDayHeader({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
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

    return ValueListenableBuilder(
      valueListenable: viewController.visibleDateTimeRange,
      builder: (context, visibleDateTimeRange, child) {
        final multiDayEventsWidget = MultiDayEventWidget(
          visibleDateTimeRange: visibleDateTimeRange,
          eventBeingDragged: viewController.eventBeingDragged,
          eventsController: eventsController!,
        );

        final header = viewConfiguration.numberOfDays == 1
            ? _SingleDayHeader(
                visibleDateTimeRange: visibleDateTimeRange,
                timelineWidth: viewConfiguration.timelineWidth,
              )
            : _MultiDayHeader(
                visibleDateTimeRange: visibleDateTimeRange,
                timelineWidth: viewConfiguration.timelineWidth,
                multiDayEventsWidget: multiDayEventsWidget,
              );

        return Column(
          children: [
            header,
          ],
        );
      },
    );
  }
}

class _SingleDayHeader<T> extends StatelessWidget {
  final DateTimeRange visibleDateTimeRange;
  final double timelineWidth;

  const _SingleDayHeader({
    super.key,
    required this.visibleDateTimeRange,
    required this.timelineWidth,
  });

  @override
  Widget build(BuildContext context) {
    final dayHeader = SizedBox(
      width: timelineWidth,
      child: DayHeader(date: visibleDateTimeRange.start),
    );

    return Row(
      children: [
        dayHeader,
      ],
    );
  }
}

class _MultiDayHeader<T> extends StatelessWidget {
  final DateTimeRange visibleDateTimeRange;
  final double timelineWidth;
  final Widget multiDayEventsWidget;

  const _MultiDayHeader({
    super.key,
    required this.visibleDateTimeRange,
    required this.timelineWidth,
    required this.multiDayEventsWidget,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final weekNumber = SizedBox(
          width: timelineWidth,
          child: WeekNumber(visibleDateTimeRange: visibleDateTimeRange),
        );

        final dayWidth = (constraints.maxWidth - timelineWidth) /
            visibleDateTimeRange.datesSpanned.length;

        final visibleDates = visibleDateTimeRange.datesSpanned;
        final dayHeaders = visibleDates.map((date) {
          return SizedBox(
            width: dayWidth,
            child: DayHeader(date: date),
          );
        }).toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                weekNumber,
                ...dayHeaders,
              ],
            ),
            multiDayEventsWidget,
          ],
        );
      },
    );
  }
}
