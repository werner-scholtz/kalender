import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/schedule_map.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/schedule_drag_target.dart';
import 'package:kalender/src/widgets/event_tiles/schedule_event_tile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// A widget that displays events in a schedule/list format.
///
/// The [ScheduleBody] is the main widget for displaying calendar events in a
/// vertical list format, similar to a traditional agenda or schedule view.
/// It supports both continuous scrolling and paginated navigation.
///
/// The widget automatically detects the type of [ScheduleViewController] and
/// renders either:
/// - [ContinuousScheduleViewController]: Single scrollable list of all events
/// - [PaginatedScheduleViewController]: Paginated view with discrete pages
class ScheduleBody<T extends Object?> extends StatelessWidget {
  /// Configuration options for the schedule body behavior and appearance.
  ///
  /// If not provided, default [ScheduleBodyConfiguration] will be used.
  final ScheduleBodyConfiguration? configuration;

  /// Creates a [ScheduleBody].
  const ScheduleBody({super.key, this.configuration});

  @override
  Widget build(BuildContext context) {
    final provider = context.provider<T>();
    final eventsController = provider.eventsController;
    final calendarController = provider.calendarController;

    final bodyProvider = context.bodyProvider<T>();
    final callbacks = bodyProvider.callbacks;
    final interaction = bodyProvider.interaction;

    assert(
      calendarController.viewController is ScheduleViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MonthViewController<$T>',
    );

    final viewController = calendarController.viewController as ScheduleViewController<T>;
    final components = provider.components?.scheduleComponents ?? ScheduleComponents();
    final styles = provider.components?.scheduleComponentStyles ?? const ScheduleComponentStyles();
    final configuration = this.configuration ?? ScheduleBodyConfiguration();
    final tileComponents = bodyProvider.tileComponents as ScheduleTileComponents<T>;

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

/// A paginated schedule widget that displays events across multiple pages.
///
/// This widget is used when the [ScheduleViewController] is a
/// [PaginatedScheduleViewController]. It creates a [PageView] where each page
/// contains a [SchedulePositionList] for a specific date range.
///
/// The pagination allows users to swipe between different time periods
/// (e.g., weeks, months) in the schedule view.
class PaginatedSchedule<T extends Object?> extends StatefulWidget {
  /// The controller managing the events in the schedule.
  final EventsController<T> eventsController;

  /// The controller managing the calendar state.
  final CalendarController<T> calendarController;

  /// The controller specifically for paginated schedule view.
  final PaginatedScheduleViewController<T> viewController;

  /// Callbacks for handling user interactions.
  final CalendarCallbacks<T>? callbacks;

  /// Components for customizing the appearance of schedule tiles.
  final ScheduleTileComponents<T> tileComponents;

  /// Notifier for tracking user interaction state.
  final ValueNotifier<CalendarInteraction> interaction;

  /// Styling configuration for schedule components.
  final ScheduleComponentStyles styles;

  /// Component builders for schedule elements.
  final ScheduleComponents components;

  /// Configuration for schedule body behavior.
  final ScheduleBodyConfiguration configuration;

  /// Creates a [PaginatedSchedule].
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

/// A scrollable list widget that displays schedule items with position tracking.
///
/// This widget creates a scrollable list of schedule items (events, month headers,
/// empty days) and tracks their positions for visibility and navigation purposes.
/// It's used both in continuous schedule views and as individual pages in
/// paginated schedule views.
///
/// The widget automatically generates and maintains a map of items based on the
/// provided date range and events, handling different item types:
/// - [MonthItem]: Month header separators
/// - [EventItem]: Individual event entries
/// - [EmptyItem]: Placeholder for days with no events (configurable)
class SchedulePositionList<T extends Object?> extends StatefulWidget {
  /// The controller managing the events displayed in this list.
  final EventsController<T> eventsController;

  /// The main calendar controller managing overall state.
  final CalendarController<T> calendarController;

  /// The schedule view controller for this specific view.
  final ScheduleViewController<T> viewController;

  /// Configuration options for the schedule body behavior.
  final ScheduleBodyConfiguration configuration;

  /// Callbacks for handling user interactions.
  final CalendarCallbacks<T>? callbacks;

  /// Components for customizing tile appearance and behavior.
  final ScheduleTileComponents<T> tileComponents;

  /// Notifier for tracking current user interactions.
  final ValueNotifier<CalendarInteraction> interaction;

  /// Styling configuration for schedule components.
  final ScheduleComponentStyles styles;

  /// Component builders for various schedule elements.
  final ScheduleComponents components;

  /// The date range to display in this list.
  final DateTimeRange dateTimeRange;

  /// The current page index (used in paginated views).
  final int currentPage;

  /// Whether this list is part of a paginated view.
  final bool paginated;

  /// Creates a [SchedulePositionList].
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

/// The state implementation for [SchedulePositionList].
///
/// This class manages the complex logic of generating, organizing, and tracking
/// schedule items. It handles event changes, position updates, and maintains
/// the mapping between dates and schedule items.
class _SchedulePositionListState<T extends Object?> extends State<SchedulePositionList<T>> {
  // Convenience getters for accessing widget properties
  ScheduleViewController<T> get viewController => widget.viewController;
  EventsController<T> get eventsController => widget.eventsController;
  CalendarController<T> get calendarController => widget.calendarController;
  CalendarCallbacks<T>? get callbacks => widget.callbacks;
  ScheduleTileComponents<T> get tileComponents => widget.tileComponents;
  ValueNotifier<CalendarInteraction> get interaction => widget.interaction;
  ScheduleComponentStyles get styles => widget.styles;
  ScheduleComponents get components => widget.components;
  ScheduleViewConfiguration get viewConfiguration => widget.viewController.viewConfiguration;

  /// Controller for programmatically scrolling to specific items in the list.
  final ItemScrollController _itemScrollController = ItemScrollController();

  /// Listener for tracking which items are currently visible in the viewport.
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void didUpdateWidget(covariant SchedulePositionList<T> oldWidget) {
    _removeListeners();
    _setup();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _removeListeners();
    _setup();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  /// Sets up all necessary components for the schedule list.
  ///
  /// This method initializes the view controller, generates the item mapping,
  /// and sets up event listeners. Called during initialization and when
  /// dependencies change.
  void _setup() {
    _setupViewController();
    _generateMap();
    _addListeners();
  }

  /// Adds event listeners for tracking changes and position updates.
  void _addListeners() {
    eventsController.addListener(_updateMap);
    _itemPositionsListener.itemPositions.addListener(_positionListener);
  }

  /// Removes all event listeners to prevent memory leaks.
  void _removeListeners() {
    eventsController.removeListener(_updateMap);
    _itemPositionsListener.itemPositions.removeListener(_positionListener);
  }

  /// Configures the view controller with the necessary controllers and state.
  void _setupViewController() {
    viewController.itemScrollController = _itemScrollController;
    viewController.itemPositionsListener = _itemPositionsListener;
    viewController.currentPage = widget.currentPage;
  }

  /// Updates the item mapping when events change.
  ///
  /// This is called as a listener callback when the events controller notifies
  /// of changes to the event data.
  void _updateMap() => setState(_generateMap);

  /// Generates the complete mapping of schedule items for the current date range.
  ///
  /// This method processes all dates in the range and creates appropriate
  /// schedule items (months, events, empty days) based on the configuration
  /// and available events. This is a potentially expensive operation for
  /// large date ranges with many events.
  ///
  /// TODO: Performance optimization needed for large event collections.
  void _generateMap() {
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

  /// Adds a month header item if needed for the given date.
  ///
  /// This method checks if a month header should be added based on whether
  /// this is the first occurrence of a new month in the current view.
  ///
  /// [date] The date to potentially add a month header for.
  void _addMonthItem(DateTime date) {
    // Check if the date is the first date of the month.
    final previousDateItem = viewController.dateTimeItemIndex(widget.currentPage).keys.lastOrNull;
    if (previousDateItem == null || previousDateItem.startOfMonth != date.startOfMonth) {
      viewController.addItem(item: MonthItem(), date: date);
    }
  }

  /// Handles position changes in the scrollable list.
  ///
  /// This method tracks which items are currently visible and updates the
  /// view controller's visible date range and events accordingly. This enables
  /// features like highlighting current dates and optimizing performance.
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
              final locale = CalendarProvider.single(context).locale;
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
