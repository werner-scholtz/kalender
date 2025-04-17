import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/components/schedule_components.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScheduleBody<T extends Object?> extends StatelessWidget {
  /// The [EventsController] that will be used by the [ScheduleBody].
  final EventsController<T>? eventsController;

  /// The [CalendarController] that will be used by the [ScheduleBody].
  final CalendarController<T>? calendarController;

  /// The callbacks used by the [ScheduleBody].
  final CalendarCallbacks<T>? callbacks;

  /// The tile components used by the [ScheduleBody].
  final TileComponents<T> tileComponents;

  const ScheduleBody({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    required this.tileComponents,
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

    final viewController = calendarController.viewController as ContinuousScheduleViewController<T>;
    final components = provider?.components?.scheduleComponents ?? ScheduleComponents();

    return ListenableBuilder(
      listenable: eventsController,
      builder: (context, child) {
        // TODO: I have some concerns about the performance of this when a lot of events are present.
        // Maybe we need to update the DateMap to do this once and keep it updated based on what added/removed events.

        // Get the range of dates from the view configuration.
        final dates = viewController.viewConfiguration.pageNavigationFunctions.adjustedRange.dates();
        viewController.itemIndexEventId.clear();
        viewController.dateItemIndices.clear();
        viewController.indicesDateItem.clear();
        viewController.monthItemIndices.clear();

        // Iterate through the dates and get the events for each date.
        for (final date in dates) {
          final events = eventsController!.eventsFromDateTimeRange(date.dayRange);
          if (events.isEmpty) continue;

          // Check if the date is the first date of the month.
          // If it is, set the start index of the month.
          final previousDateItemIndex = viewController.indicesDateItem.entries.lastOrNull?.value;
          if (previousDateItemIndex == null || previousDateItemIndex.startOfMonth != date.startOfMonth) {
            viewController.monthItemIndices[viewController.itemIndexEventId.length] = date;
          }

          // Set the start index of the date and the date item index.
          viewController.dateItemIndices[date] = viewController.itemIndexEventId.length;
          viewController.indicesDateItem[viewController.itemIndexEventId.length] = date;

          for (final event in events) {
            final index = viewController.itemIndexEventId.length;
            viewController.itemIndexEventId[index] = event.id;
            viewController.firstItemIndex.putIfAbsent(event.id, () => index);
          }
        }

        return ScrollablePositionedList.builder(
          itemScrollController: viewController.itemScrollController,
          itemPositionsListener: viewController.itemPositionsListener,
          itemCount: viewController.itemIndexEventId.length,
          itemBuilder: (context, index) {
            final date = viewController.indicesDateItem[index];
            final showDate = date != null;
            final isFirstDateOfMonth = viewController.monthItemIndices[index] != null;

            final tile = ListTile(
              leading: showDate ? components.dayHeaderBuilder?.call(date.asLocal, const DayHeaderStyle()) : null,
              onTap: () {},
            );

            late final monthTile = ListBody(
              children: [
                ListTile(title: Text(date?.monthNameEnglish ?? 'ERROR')),
                tile,
              ],
            );

            return isFirstDateOfMonth ? monthTile : tile;
          },
        );
      },
    );
  }
}
