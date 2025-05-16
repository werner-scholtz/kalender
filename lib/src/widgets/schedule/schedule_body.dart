import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/components/schedule_components.dart';
import 'package:kalender/src/models/components/schedule_styles.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/schedule_drag_target.dart';
import 'package:kalender/src/widgets/event_tiles/schedule_event_tile.dart';
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

  /// The [CalendarInteraction] that will be used by the [ScheduleBody].
  final ValueNotifier<CalendarInteraction>? interaction;

  const ScheduleBody({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    this.interaction,
    required this.tileComponents,
  });

  @override
  Widget build(BuildContext context) {
    final provider = CalendarProvider.maybeOf<T>(context);
    final eventsController = this.eventsController ?? CalendarProvider.eventsControllerOf<T>(context);
    final calendarController = this.calendarController ?? CalendarProvider.calendarControllerOf<T>(context);
    final callbacks = this.callbacks ?? CalendarProvider.callbacksOf<T>(context);
    final interaction = this.interaction ?? ValueNotifier(CalendarInteraction());

    assert(
      calendarController.viewController is ScheduleViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MonthViewController<$T>',
    );

    final viewController = calendarController.viewController as ContinuousScheduleViewController<T>;
    final components = provider?.components?.scheduleComponents ?? ScheduleComponents();
    final styles = provider?.components?.scheduleComponentStyles ?? const ScheduleComponentStyles();

    final positionedList = ListenableBuilder(
      listenable: eventsController,
      builder: (context, child) {
        // TODO: I have some concerns about the performance of this when a lot of events are present.
        // Maybe we need to update the DateMap to do this once and keep it updated based on what added/removed events.

        // TODO: Always add today ...?
        // Get the range of dates from the view configuration.
        final dates = viewController.viewConfiguration.pageNavigationFunctions.adjustedRange.dates();
        viewController.itemIndexEventId.clear();
        viewController.dateItemIndices.clear();
        viewController.indicesDateItem.clear();
        viewController.monthItemIndices.clear();

        // Iterate through the dates and get the events for each date.
        for (final date in dates) {
          final events = eventsController.eventsFromDateTimeRange(date.dayRange);
          if (events.isEmpty && !date.isToday) continue;

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
            viewController.eventIdDateIndex[event.id] = date;
          }
        }

        /// TODO: how are we going to handle rescheduling ???
        return ScrollablePositionedList.builder(
          itemScrollController: viewController.itemScrollController,
          itemPositionsListener: viewController.itemPositionsListener,
          itemCount: viewController.itemIndexEventId.length,
          // initialScrollIndex: , TODO: add initial scroll index.
          itemBuilder: (context, index) {
            final date = viewController.indicesDateItem[index];
            final showDate = date != null;
            final isFirstDateOfMonth = viewController.monthItemIndices[index] != null;
            final event = eventsController.byId(viewController.itemIndexEventId[index]!)!;
            final indexDate = viewController.eventIdDateIndex[event.id]!;

            final tile = ListTile(
              leading: showDate
                  ? components.dayHeaderBuilder.call(date.asLocal, styles.scheduleDateStyle)
                  // TODO: this should be adjustable.
                  : const SizedBox(width: 32),
              title: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 24),
                child: ScheduleEventTile(
                  controller: calendarController,
                  eventsController: eventsController,
                  callbacks: callbacks,
                  tileComponents: tileComponents,
                  event: event,
                  dateTimeRange: indexDate.dayRange,
                  interaction: interaction,
                ),
              ),
              trailing: Text(event.id.toString()),
            );

            late final monthTile = ListBody(
              children: [
                ListTile(title: Text(date?.monthNameEnglish ?? 'ERROR')),
                tile,
              ],
            );

            final test = ValueListenableBuilder(
              valueListenable: viewController.highlightedDate,
              builder: (context, value, child) {
                if (value == null) return const SizedBox.shrink();
                if (value != date) return const SizedBox.shrink();
                return DecoratedBox(decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface.withAlpha(50)));
              },
            );

            return Stack(
              children: [
                Positioned.fill(child: test),
                isFirstDateOfMonth ? monthTile : tile,
              ],
            );
          },
        );
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            positionedList,
            Positioned.fill(
              child: ScheduleDragTarget(
                eventsController: eventsController,
                calendarController: calendarController,
                callbacks: callbacks,
                scheduleViewController: viewController,
                constraints: constraints,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// TODO: Move logic here to the [ScheduleBody].
class ContinuousSchedulePositionedList<T extends Object?> extends StatefulWidget {
  const ContinuousSchedulePositionedList({super.key});

  @override
  State<ContinuousSchedulePositionedList<T>> createState() => _ContinuousSchedulePositionedListState<T>();
}

class _ContinuousSchedulePositionedListState<T extends Object?> extends State<ContinuousSchedulePositionedList<T>> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/// TODO: implement this.
class PaginatedSchedulePositionList<T extends Object?> extends StatefulWidget {
  const PaginatedSchedulePositionList({super.key});

  @override
  State<PaginatedSchedulePositionList<T>> createState() => _PaginatedSchedulePositionListState<T>();
}

class _PaginatedSchedulePositionListState<T extends Object?> extends State<PaginatedSchedulePositionList<T>> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
