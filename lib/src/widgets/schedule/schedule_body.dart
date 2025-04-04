// TODO: Implement this

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/components/scheudle_components.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScheduleBody<T extends Object?> extends StatelessWidget {
  /// The [EventsController] that will be used by the [MonthBody].
  final EventsController<T>? eventsController;

  /// The [CalendarController] that will be used by the [MonthBody].
  final CalendarController<T>? calendarController;

  /// The [MultiDayBodyConfiguration] that will be used by the [MonthBody].
  // final MultiDayHeaderConfiguration<T>? configuration;

  /// The callbacks used by the [MonthBody].
  final CalendarCallbacks<T>? callbacks;

  /// The tile components used by the [MonthBody].
  final TileComponents<T> tileComponents;

  /// The [CalendarInteraction] that will be used by the [MonthBody].
  final ValueNotifier<CalendarInteraction>? interaction;

  const ScheduleBody({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    required this.tileComponents,
    // this.configuration,
    required this.interaction,
  });

  @override
  Widget build(BuildContext context) {
    var eventsController = this.eventsController;
    var calendarController = this.calendarController;
    var callbacks = this.callbacks;

    final provider = CalendarProvider.maybeOf<T>(context);
    eventsController ??= CalendarProvider.eventsControllerOf<T>(context);
    calendarController ??= CalendarProvider.calendarControllerOf<T>(context);
    callbacks ??= CalendarProvider.callbacksOf<T>(context);

    assert(
      calendarController.viewController is ScheduleViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MonthViewController<$T>',
    );

    final viewController = calendarController.viewController as ScheduleViewController<T>;

    final components = provider?.components?.scheduleComponents ?? ScheduleComponents();

    return ListenableBuilder(
      listenable: eventsController,
      builder: (context, child) {
        final items = <(DateTime, Iterable<CalendarEvent<T>>)>[];
        final monthStartIndexes = <DateTime, int>{};

        for (final date in viewController.viewConfiguration.pageNavigationFunctions.adjustedRange.dates()) {
          final events = eventsController!.eventsFromDateTimeRange(date.dayRange);
          if (events.isEmpty) continue;
          final (lastDate, _) = items.lastOrNull ?? (null, null);

          // Check if the last date is null or if the month has changed
          if (lastDate == null || lastDate.startOfMonth != date.startOfMonth) {
            monthStartIndexes[date] = items.length;
          }

          items.add((date, events));
        }

        return ScrollablePositionedList.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final (date, events) = items[index];
            final isFirstDateOfMonth = monthStartIndexes[date] != null;

            return ListBody(
              children: [
                if (isFirstDateOfMonth) ListTile(title: Text(date.monthNameEnglish)),
                ...events.indexed.map((item) {
                  final (index, event) = item;
                  late final leading = components.dayHeaderBuilder?.call(date, DayHeaderStyle()) ?? DayHeader(date: date);
                  return ListTile(
                    leading: index == 0 ? leading : null,
                    title: Text(event.data.toString()),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}
