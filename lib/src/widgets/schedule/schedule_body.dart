import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/schedule_map.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/providers/locale_provider.dart';
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
  final ScheduleTileComponents<T>? tileComponents;

  /// The [CalendarInteraction] that will be used by the [ScheduleBody].
  final ValueNotifier<CalendarInteraction>? interaction;

  /// The configuration for the schedule body.
  final ScheduleBodyConfiguration? configuration;

  const ScheduleBody({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    this.interaction,
    required this.tileComponents,
    this.configuration,
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
    final configuration = this.configuration ?? ScheduleBodyConfiguration();
    final tileComponents = this.tileComponents ?? ScheduleTileComponents.defaultComponents<T>();

    if (viewController is ContinuousScheduleViewController<T>) {
      return SchedulePositionList<T>(
        eventsController: eventsController,
        calendarController: calendarController,
        viewController: viewController,
        callbacks: callbacks,
        tileComponents: tileComponents,
        styles: styles,
        interaction: interaction,
        components: components,
        dateTimeRange: viewController.viewConfiguration.pageNavigationFunctions.adjustedRange,
        currentPage: 0,
        paginated: false,
        configuration: configuration,
      );
    } else if (viewController is PaginatedScheduleViewController<T>) {
      return PaginatedSchedule<T>(
        eventsController: eventsController,
        calendarController: calendarController,
        viewController: viewController,
        callbacks: callbacks,
        tileComponents: tileComponents,
        styles: styles,
        interaction: interaction,
        components: components,
        configuration: configuration,
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
  final ScheduleBodyConfiguration configuration;

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
    required this.configuration,
  });

  @override
  State<PaginatedSchedule<T>> createState() => _PaginatedScheduleState<T>();
}

class _PaginatedScheduleState<T extends Object?> extends State<PaginatedSchedule<T>> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      // key: ValueKey(widget.viewController.hashCode),
      controller: widget.viewController.pageController,
      itemCount: widget.viewController.viewConfiguration.pageNavigationFunctions.numberOfPages,
      physics: widget.configuration.pageScrollPhysics,
      onPageChanged: (value) {
        final range = widget.viewController.viewConfiguration.pageNavigationFunctions.dateTimeRangeFromIndex(value);
        widget.callbacks?.onPageChanged?.call(range);
      },
      itemBuilder: (context, index) {
        return SchedulePositionList<T>(
          eventsController: widget.eventsController,
          calendarController: widget.calendarController,
          viewController: widget.viewController,
          callbacks: widget.callbacks,
          tileComponents: widget.tileComponents,
          styles: widget.styles,
          interaction: widget.interaction,
          components: widget.components,
          dateTimeRange: widget.viewController.viewConfiguration.pageNavigationFunctions.dateTimeRangeFromIndex(index),
          currentPage: index,
          paginated: true,
          configuration: widget.configuration,
        );
      },
    );
  }
}

class SchedulePositionList<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final ScheduleViewController<T> viewController;
  final ScheduleBodyConfiguration configuration;
  final CalendarCallbacks<T>? callbacks;
  final ScheduleTileComponents<T> tileComponents;
  final ValueNotifier<CalendarInteraction> interaction;
  final ScheduleComponentStyles styles;
  final ScheduleComponents components;
  final DateTimeRange dateTimeRange;
  final int currentPage;
  final bool paginated;

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
    required this.paginated,
    required this.configuration,
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

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    viewController.itemScrollController = _itemScrollController;
    viewController.itemPositionsListener = _itemPositionsListener;
    viewController.currentPage = widget.currentPage;

    _generateMap();
    _addListeners();
  }

  @override
  void didUpdateWidget(covariant SchedulePositionList<T> oldWidget) {
    _updateMap();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _removeListeners();
    _generateMap();
    _addListeners();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  void _addListeners() {
    eventsController.addListener(_updateMap);
    _itemPositionsListener.itemPositions.addListener(_positionListener);
  }

  void _removeListeners() {
    eventsController.removeListener(_updateMap);
    _itemPositionsListener.itemPositions.removeListener(_positionListener);
  }

  /// Updates the map of items in the view controller.
  void _updateMap() => setState(_generateMap);

  void _generateMap() {
    // TODO: I have some concerns about the performance of this when a lot of events are present.

    // Get the range of dates from the view configuration.
    final dates = widget.dateTimeRange.dates();
    viewController.clear();

    var hasAddedMonth = false;

    for (final date in dates) {
      final events = eventsController.eventsFromDateTimeRange(date.dayRange);

      if (events.isEmpty) {
        if (widget.paginated && !hasAddedMonth) {
          _addMonthItem(date);
          hasAddedMonth = true;
        }

        switch (widget.configuration.emptyDay) {
          case EmptyDayBehavior.show:
            viewController.addItem(item: EmptyItem(), date: date);
            continue;

          case EmptyDayBehavior.showToday:
            if (date.isToday) {
              viewController.addItem(item: EmptyItem(), date: date);
            }
            continue;

          case EmptyDayBehavior.hide:
            continue;
        }
      }

      if (!widget.paginated || widget.paginated && !hasAddedMonth) _addMonthItem(date);

      // Add all the events for the date.
      for (final (index, event) in events.indexed) {
        final isFirst = index == 0;
        viewController.addItem(item: EventItem(event.id, isFirst), date: date, isFirst: isFirst);
      }
    }
  }

  void _addMonthItem(DateTime date) {
    // Check if the date is the first date of the month.
    final previousDateItem = viewController.dateTimeItemIndex(widget.currentPage).keys.lastOrNull;
    if (previousDateItem == null || previousDateItem.startOfMonth != date.startOfMonth) {
      viewController.addItem(item: MonthItem(), date: date);
    }
  }

  void _positionListener() {
    final itemPositions = _itemPositionsListener.itemPositions.value;
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
    return Stack(
      children: [
        ScrollablePositionedList.builder(
          itemScrollController: _itemScrollController,
          itemPositionsListener: _itemPositionsListener,
          itemCount: viewController.itemCount,
          initialScrollIndex: viewController.initialScrollIndex(viewController.initialDate),
          physics: widget.configuration.scrollPhysics,
          itemBuilder: (context, index) {
            final item = viewController.item(index);
            final date = viewController.dateTimeFromIndex(index)!;

            late final leading = components.leadingDateBuilder.call(date.asLocal, styles.scheduleDateStyle);
            late final highlightStyle = styles.scheduleTileHighlightStyle;
            late final highlightBuilder = components.scheduleTileHighlightBuilder;

            if (item is MonthItem) {
              final locale = LocaleProvider.of(context);
              return tileComponents.monthItemBuilder?.call(date.asLocal.monthRange) ??
                  ListTile(title: Text(date.monthNameLocalized(locale)));
            } else if (item is EmptyItem) {
              final child = ListTile(
                leading: leading,
                title: tileComponents.emptyItemBuilder?.call(date.asLocal.dayRange),
              );

              return highlightBuilder(
                date,
                viewController.highlightedDateTimeRange,
                highlightStyle,
                child,
              );
            } else if (item is EventItem) {
              final showDate = item.isFirst;
              final event = eventsController.byId(item.eventId)!;

              final child = ListTile(
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
              );

              return highlightBuilder(
                date,
                viewController.highlightedDateTimeRange,
                highlightStyle,
                child,
              );
            } else {
              throw Exception('Unknown item type: ${item.runtimeType}');
            }
          },
        ),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ScheduleDragTarget(
                eventsController: eventsController,
                calendarController: calendarController,
                callbacks: callbacks,
                viewController: viewController,
                constraints: constraints,
                paginated: widget.paginated,
                pageTriggerConfiguration: widget.configuration.pageTriggerConfiguration,
                scrollTriggerConfiguration: widget.configuration.scrollTriggerConfiguration,
              );
            },
          ),
        ),
      ],
    );
  }
}
