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

    return ContinuousSchedulePositionedList(
      eventsController: eventsController,
      calendarController: calendarController,
      viewController: viewController,
      callbacks: callbacks,
      tileComponents: tileComponents,
      styles: styles,
      interaction: interaction,
      components: components,
    );
  }
}

/// TODO: Move logic here to the [ScheduleBody].
class ContinuousSchedulePositionedList<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final ContinuousScheduleViewController<T> viewController;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;
  final ValueNotifier<CalendarInteraction> interaction;
  final ScheduleComponentStyles styles;
  final ScheduleComponents components;

  const ContinuousSchedulePositionedList({
    required this.eventsController,
    required this.calendarController,
    required this.viewController,
    required this.callbacks,
    required this.tileComponents,
    required this.styles,
    required this.interaction,
    required this.components,
    super.key,
  });

  @override
  State<ContinuousSchedulePositionedList<T>> createState() => _ContinuousSchedulePositionedListState<T>();
}

class _ContinuousSchedulePositionedListState<T extends Object?> extends State<ContinuousSchedulePositionedList<T>> {
  ContinuousScheduleViewController<T> get viewController => widget.viewController;
  EventsController<T> get eventsController => widget.eventsController;
  CalendarController<T> get calendarController => widget.calendarController;
  CalendarCallbacks<T>? get callbacks => widget.callbacks;
  TileComponents<T> get tileComponents => widget.tileComponents;
  ValueNotifier<CalendarInteraction> get interaction => widget.interaction;
  ScheduleComponentStyles get styles => widget.styles;
  ScheduleComponents get components => widget.components;

  @override
  void initState() {
    super.initState();
    _calculateIndices();
    eventsController.addListener(_updateIndices);
  }

  @override
  void dispose() {
    eventsController.removeListener(_updateIndices);
    super.dispose();
  }

  void _updateIndices() => setState(_calculateIndices);

  void _calculateIndices() {
    // TODO: I have some concerns about the performance of this when a lot of events are present.
    // Maybe we need to update the DateMap to do this once and keep it updated based on what added/removed events.

    // TODO: Always add today ...(Setting in config.)?
    // Get the range of dates from the view configuration.
    final dates = viewController.viewConfiguration.pageNavigationFunctions.adjustedRange.dates();
    viewController.indicesItems.clear();
    viewController.itemIndexEventId.clear();
    viewController.dateItemIndices.clear();
    viewController.indicesDateItem.clear();

    for (final date in dates) {
      final events = eventsController.eventsFromDateTimeRange(date.dayRange);
      if (events.isEmpty && !date.isToday) continue;
      if (events.isEmpty && date.isToday) {
        // Add the today date item.
        viewController.indicesItems[viewController.itemIndexEventId.length] = date;
      }

      // Check if the date is the first date of the month.
      final previousDateItemIndex = viewController.indicesDateItem.entries.lastOrNull?.value;
      if (previousDateItemIndex == null || previousDateItemIndex.startOfMonth != date.startOfMonth) {
        viewController.indicesItems[viewController.itemIndexEventId.length] = date;
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
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            ScrollablePositionedList.builder(
              itemScrollController: viewController.itemScrollController,
              itemPositionsListener: viewController.itemPositionsListener,
              itemCount: viewController.itemIndexEventId.length,
              // initialScrollIndex: , TODO: add initial scroll index.
              itemBuilder: (context, index) {
                final item = viewController.indicesItems[index];
                if (item is DateTime) {
                  return ListTile(title: Text(item.monthNameEnglish));
                } else {
                  final date = viewController.indicesDateItem[index];
                  final showDate = date != null;
                  final event = eventsController.byId(viewController.itemIndexEventId[index]!)!;
                  final indexDate = viewController.eventIdDateIndex[event.id]!;

                  return ValueListenableBuilder(
                    valueListenable: viewController.highlightedDate,
                    builder: (context, value, child) {
                      if (value != null && value == date) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withAlpha(50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: child,
                        );
                      } else {
                        return child!;
                      }
                    },
                    child: ListTile(
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
                    ),
                  );
                }
              },
            ),
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
