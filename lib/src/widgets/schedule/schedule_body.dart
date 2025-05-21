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
    _generateMap();
    eventsController.addListener(_updateMap);
    viewController.itemPositionsListener.itemPositions.addListener(_positionListener);
  }

  @override
  void dispose() {
    eventsController.removeListener(_updateMap);
    viewController.itemPositionsListener.itemPositions.removeListener(_positionListener);
    super.dispose();
  }

  void _updateMap() => setState(_generateMap);

  void _generateMap() {
    // TODO: I have some concerns about the performance of this when a lot of events are present.
    // Maybe we need to update the DateMap to do this once and keep it updated based on what added/removed events.

    // TODO: Always add today ...(Setting in config.)?
    // Get the range of dates from the view configuration.
    final dates = viewController.viewConfiguration.pageNavigationFunctions.adjustedRange.dates();
    viewController.clear();

    for (final date in dates) {
      final events = eventsController.eventsFromDateTimeRange(date.dayRange);
      if (events.isEmpty && !date.isToday) continue;

      // Get the datetime for the previous item.
      final previousDateItem = viewController.dateTimeFirstItemIndex.entries.lastOrNull?.key;

      // Check if the date is the first date of the month.
      if (previousDateItem == null || previousDateItem.startOfMonth != date.startOfMonth) {
        viewController.addItem(MonthItem(), date);
      }

      // Add all the events for the date.
      for (final (index, event) in events.indexed) {
        final isFirst = index == 0;
        viewController.addItem(EventItem(event.id, isFirst), date, isFirst: isFirst);
      }
    }
  }

  void _positionListener() {
    final itemPositions = viewController.itemPositionsListener.itemPositions.value;
    if (itemPositions.isNotEmpty) {
      var first = 0;
      var last = 0;
      for (final position in itemPositions) {
        if (position.index < first) first = position.index;
        if (position.index > last) last = position.index;
      }

      // Update the visible date time range based on the first and last items.
      final start = viewController.itemIndexDateTime[first];
      final end = viewController.itemIndexDateTime[last];
      if (start != null && end != null) {
        viewController.visibleDateTimeRange.value = DateTimeRange(start: start, end: end);
      }

      // Update the visible events based on the current item positions.
      final events = itemPositions.map((position) {
        final item = viewController.indexItem[position.index];
        if (item is! EventItem) return null;
        final eventId = item.eventId;
        return eventsController.byId(eventId);
      });

      viewController.visibleEvents.value = events.nonNulls.toSet();
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
              itemCount: viewController.indexItem.length,
              // TODO: this should be adjustable.
              initialScrollIndex: viewController.initialScrollIndex(DateTime.now()),
              itemBuilder: (context, index) {
                final item = viewController.indexItem[index]!;
                final date = viewController.itemIndexDateTime[index]!;

                if (item is MonthItem) {
                  return ListTile(title: Text(date.monthNameEnglish));
                } else if (item is EmptyItem) {
                  return const ListTile(title: Text('Empty'));
                } else if (item is EventItem) {
                  final event = eventsController.byId(item.eventId)!;

                  return ValueListenableBuilder(
                    valueListenable: viewController.highlightedDateTimeRange,
                    builder: (context, value, child) {
                      if (value != null && date.isWithin(value)) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            // TODO: this should be adjustable.
                            color: Theme.of(context).colorScheme.primary.withAlpha(50),
                          ),
                          child: child,
                        );
                      } else {
                        return child!;
                      }
                    },
                    child: ListTile(
                      leading: item.isFirst
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
                          dateTimeRange: date.dayRange,
                          interaction: interaction,
                        ),
                      ),
                      trailing: Text(event.id.toString()),
                    ),
                  );
                } else {
                  throw Exception('Unknown item type: ${item.runtimeType}');
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
