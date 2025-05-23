import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/components/schedule_components.dart';
import 'package:kalender/src/models/components/schedule_styles.dart';
import 'package:kalender/src/models/mixins/schedule_map.dart';
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

    final viewController = calendarController.viewController as ScheduleViewController<T>;
    final components = provider?.components?.scheduleComponents ?? ScheduleComponents();
    final styles = provider?.components?.scheduleComponentStyles ?? const ScheduleComponentStyles();
    final scheduleComponents = tileComponents as ScheduleTileComponents<T>;

    if (viewController is ContinuousScheduleViewController<T>) {
      return SchedulePositionList(
        eventsController: eventsController,
        calendarController: calendarController,
        viewController: viewController,
        callbacks: callbacks,
        tileComponents: scheduleComponents,
        styles: styles,
        interaction: interaction,
        components: components,
        dateTimeRange: viewController.viewConfiguration.pageNavigationFunctions.adjustedRange,
        currentPage: 0,
      );
    } else if (viewController is PaginatedScheduleViewController<T>) {
      return PaginatedSchedule(
        eventsController: eventsController,
        calendarController: calendarController,
        viewController: viewController,
        callbacks: callbacks,
        tileComponents: scheduleComponents,
        styles: styles,
        interaction: interaction,
        components: components,
      );
    } else {
      throw Exception(
        'The view controller is not a $PaginatedScheduleViewController or $ContinuousScheduleViewController',
      );
    }
  }
}

class PaginatedSchedule<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final PaginatedScheduleViewController<T> viewController;
  final CalendarCallbacks<T>? callbacks;
  final ScheduleTileComponents<T> tileComponents;
  final ValueNotifier<CalendarInteraction> interaction;
  final ScheduleComponentStyles styles;
  final ScheduleComponents components;

  const PaginatedSchedule({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.viewController,
    required this.callbacks,
    required this.tileComponents,
    required this.styles,
    required this.interaction,
    required this.components,
  });

  @override
  State<PaginatedSchedule<T>> createState() => _PaginatedScheduleState<T>();
}

class _PaginatedScheduleState<T extends Object?> extends State<PaginatedSchedule<T>> {
  PaginatedScheduleViewController<T> get viewController => widget.viewController;
  EventsController<T> get eventsController => widget.eventsController;
  CalendarController<T> get calendarController => widget.calendarController;
  CalendarCallbacks<T>? get callbacks => widget.callbacks;
  ScheduleTileComponents<T> get tileComponents => widget.tileComponents;
  ValueNotifier<CalendarInteraction> get interaction => widget.interaction;
  ScheduleComponentStyles get styles => widget.styles;
  ScheduleComponents get components => widget.components;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: viewController.pageController,
      itemCount: viewController.viewConfiguration.pageNavigationFunctions.numberOfPages,
      itemBuilder: (context, index) {
        return SchedulePositionList(
          eventsController: eventsController,
          calendarController: calendarController,
          viewController: viewController,
          callbacks: callbacks,
          tileComponents: tileComponents,
          styles: styles,
          interaction: interaction,
          components: components,
          dateTimeRange: viewController.viewConfiguration.pageNavigationFunctions.dateTimeRangeFromIndex(index),
          currentPage: index,
        );
      },
    );
  }
}

class SchedulePositionList<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final ScheduleViewController<T> viewController;
  final CalendarCallbacks<T>? callbacks;
  final ScheduleTileComponents<T> tileComponents;
  final ValueNotifier<CalendarInteraction> interaction;
  final ScheduleComponentStyles styles;
  final ScheduleComponents components;
  final DateTimeRange dateTimeRange;
  final int currentPage;

  const SchedulePositionList({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.viewController,
    required this.callbacks,
    required this.tileComponents,
    required this.styles,
    required this.interaction,
    required this.components,
    required this.dateTimeRange,
    required this.currentPage,
  });

  @override
  State<SchedulePositionList<T>> createState() => _SchedulePositionListState<T>();
}

class _SchedulePositionListState<T extends Object?> extends State<SchedulePositionList<T>> {
  ScheduleViewController<T> get viewController => widget.viewController;
  EventsController<T> get eventsController => widget.eventsController;
  CalendarController<T> get calendarController => widget.calendarController;
  CalendarCallbacks<T>? get callbacks => widget.callbacks;
  ScheduleTileComponents<T> get tileComponents => widget.tileComponents;
  ValueNotifier<CalendarInteraction> get interaction => widget.interaction;
  ScheduleComponentStyles get styles => widget.styles;
  ScheduleComponents get components => widget.components;
  ScheduleViewConfiguration get viewConfiguration => widget.viewController.viewConfiguration;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    viewController.itemScrollController = itemScrollController;
    viewController.itemPositionsListener = itemPositionsListener;
    viewController.currentPage = widget.currentPage;

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

  /// Would make sense to extract this somehow and just pass it a date, this way it is useful for paginated and continuous.
  void _generateMap() {
    // TODO: I have some concerns about the performance of this when a lot of events are present.
    // Maybe we need to update the DateMap to do this once and keep it updated based on what added/removed events.

    // TODO: Add the current month on paginated view. (This is so item can be moved to the current month.)
    // Get the range of dates from the view configuration.
    final dates = widget.dateTimeRange.dates();
    viewController.clear();

    for (final date in dates) {
      final events = eventsController.eventsFromDateTimeRange(date.dayRange);

      if (events.isEmpty) {
        switch (viewConfiguration.emptyDays) {
          case EmptyDaysBehavior.show:
            viewController.addItem(item: EmptyItem(), date: date);
            continue;

          case EmptyDaysBehavior.showToday:
            if (date.isToday) {
              viewController.addItem(item: EmptyItem(), date: date);
            }
            continue;

          case EmptyDaysBehavior.hide:
            continue;
        }
      }

      // Get the datetime for the previous item.
      final previousDateItem = viewController.dateTimeItemIndex(widget.currentPage).keys.lastOrNull;

      // Check if the date is the first date of the month.
      if (previousDateItem == null || previousDateItem.startOfMonth != date.startOfMonth) {
        viewController.addItem(item: MonthItem(), date: date);
      }

      // Add all the events for the date.
      for (final (index, event) in events.indexed) {
        final isFirst = index == 0;
        viewController.addItem(item: EventItem(event.id, isFirst), date: date, isFirst: isFirst);
      }
    }
  }

  void _positionListener() {
    final itemPositions = viewController.itemPositionsListener.itemPositions.value;
    if (itemPositions.isNotEmpty) {
      // Get the first and last visible item positions.
      var first = viewController.itemCount;
      var last = 0;
      for (final position in itemPositions) {
        if (position.index < first) first = position.index;
        if (position.index > last) last = position.index;
      }

      // Update the visible date time range based on the first and last items.
      final start = viewController.dateTimeFromIndex(first);
      final end = viewController.dateTimeFromIndex(last);
      if (start != null && end != null) {
        viewController.visibleDateTimeRange.value = DateTimeRange(start: start, end: end);
      }

      // Update the visible events based on the current item positions.
      final events = itemPositions.map((position) {
        final item = viewController.item(position.index);
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
              itemCount: viewController.itemCount,
              // TODO: this should be adjustable.
              // TODO: this might have to be different for paginated and continuous.
              initialScrollIndex: viewController.initialScrollIndex(DateTime.now()),
              itemBuilder: (context, index) {
                final item = viewController.item(index);
                final date = viewController.dateTimeFromIndex(index)!;
                late final leading = components.dayHeaderBuilder.call(date.asLocal, styles.scheduleDateStyle);

                if (item is MonthItem) {
                  return ListTile(title: Text(date.monthNameEnglish));
                } else if (item is EmptyItem) {
                  return ScheduleListItemHighlight(
                    date: date,
                    dateTimeRange: viewController.highlightedDateTimeRange,
                    child: ListTile(
                      leading: leading,
                      title: tileComponents.emptyTileBuilder?.call(date.asLocal.dayRange),
                    ),
                  );
                } else if (item is EventItem) {
                  final showDate = item.isFirst;
                  final event = eventsController.byId(item.eventId)!;

                  return ScheduleListItemHighlight(
                    date: date,
                    dateTimeRange: viewController.highlightedDateTimeRange,
                    child: ListTile(
                      leading: showDate ? leading : const SizedBox(width: 32),
                      title: ScheduleEventTile(
                        controller: calendarController,
                        eventsController: eventsController,
                        callbacks: callbacks,
                        tileComponents: tileComponents,
                        event: event,
                        dateTimeRange: date.dayRange,
                        interaction: interaction,
                      ),
                    ),
                  );
                } else {
                  throw Exception('Unknown item type: ${item.runtimeType}');
                }
              },
            ),
            Positioned.fill(
              // TODO: Implement cursor navigation.
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

class ScheduleListItemHighlight extends StatelessWidget {
  final DateTime date;
  final ValueNotifier<DateTimeRange?> dateTimeRange;
  final Widget child;
  const ScheduleListItemHighlight({
    super.key,
    required this.date,
    required this.dateTimeRange,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dateTimeRange,
      builder: (context, value, child) {
        if (value != null && date.isWithin(value)) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(50),
            ),
            child: child!,
          );
        } else {
          return child!;
        }
      },
      child: child,
    );
  }
}
