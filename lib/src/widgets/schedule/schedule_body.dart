import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/schedule_map.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/schedule_drag_target.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';
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
class ScheduleBody extends StatelessWidget {
  /// Configuration options for the schedule body behavior and appearance.
  ///
  /// If not provided, default [ScheduleBodyConfiguration] will be used.
  final ScheduleBodyConfiguration? configuration;

  /// Creates a [ScheduleBody].
  const ScheduleBody({super.key, this.configuration});

  @override
  Widget build(BuildContext context) {
    final calendarController = context.calendarController();
    assert(
      calendarController.viewController is ScheduleViewController,
      'The CalendarController\'s $ViewController needs to be a $MonthViewController',
    );
    final viewController = calendarController.viewController as ScheduleViewController;
    final configuration = this.configuration ?? ScheduleBodyConfiguration();
    if (viewController is ContinuousScheduleViewController) {
      return SchedulePositionList(
        eventsController: context.eventsController(),
        viewController: viewController,
        // TODO: this might cause rebuilds.
        dateTimeRange: viewController.viewConfiguration.pageIndexCalculator.internalRange(context.location),
        currentPage: 0,
        paginated: false,
        configuration: configuration,
      );
    } else if (viewController is PaginatedScheduleViewController) {
      return PaginatedSchedule(viewController: viewController, configuration: configuration);
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
class PaginatedSchedule extends StatefulWidget {
  /// The controller specifically for paginated schedule view.
  final PaginatedScheduleViewController viewController;

  /// Configuration for schedule body behavior.
  final ScheduleBodyConfiguration configuration;

  /// Creates a [PaginatedSchedule].
  const PaginatedSchedule({
    super.key,
    required this.viewController,
    required this.configuration,
  });

  @override
  State<PaginatedSchedule> createState() => _PaginatedScheduleState();
}

class _PaginatedScheduleState extends State<PaginatedSchedule> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      // key: ValueKey(widget.viewController.hashCode),
      controller: widget.viewController.pageController,
      itemCount: widget.viewController.viewConfiguration.pageIndexCalculator.numberOfPages(context.location),
      physics: widget.configuration.pageScrollPhysics,
      onPageChanged: (value) {
        // TODO: Should be fine.
        final range =
            widget.viewController.viewConfiguration.pageIndexCalculator.dateTimeRangeFromIndex(value, context.location);
        context.callbacks()?.onPageChanged?.call(range);
      },
      itemBuilder: (context, index) {
        return SchedulePositionList(
          eventsController: context.eventsController(),
          viewController: widget.viewController,
          // TODO: Might cause unnecessary rebuilds.
          dateTimeRange: widget.viewController.viewConfiguration.pageIndexCalculator
              .dateTimeRangeFromIndex(index, context.location),
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
class SchedulePositionList extends StatefulWidget {
  /// The controller managing the events displayed in this list.
  final EventsController eventsController;

  /// The schedule view controller for this specific view.
  final ScheduleViewController viewController;

  /// Configuration options for the schedule body behavior.
  final ScheduleBodyConfiguration configuration;

  /// The date range to display in this list.
  final InternalDateTimeRange dateTimeRange;

  /// The current page index (used in paginated views).
  final int currentPage;

  /// Whether this list is part of a paginated view.
  final bool paginated;

  /// Creates a [SchedulePositionList].
  const SchedulePositionList({
    super.key,
    required this.eventsController,
    required this.viewController,
    required this.dateTimeRange,
    required this.currentPage,
    required this.paginated,
    required this.configuration,
  });

  @override
  State<SchedulePositionList> createState() => _SchedulePositionListState();
}

/// The state implementation for [SchedulePositionList].
///
/// This class manages the complex logic of generating, organizing, and tracking
/// schedule items. It handles event changes, position updates, and maintains
/// the mapping between dates and schedule items.
class _SchedulePositionListState extends State<SchedulePositionList> {
  // Convenience getters for accessing widget properties
  ScheduleViewController get viewController => widget.viewController;
  EventsController get eventsController => widget.eventsController;
  CalendarController get calendarController => context.calendarController();
  CalendarCallbacks? get callbacks => context.callbacks();
  ScheduleComponentStyles get styles => context.components().scheduleComponentStyles;
  ScheduleComponents get components => context.components().scheduleComponents;
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
  void didUpdateWidget(covariant SchedulePositionList oldWidget) {
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
      final internalDate = InternalDateTime.fromDateTime(date);
      // TODO: this location needs to be passed down properly.
      final events = eventsController.eventsFromDateTimeRange(
        InternalDateTimeRange.fromDateTimeRange(internalDate.dayRange),
        location: context.location,
      );

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
            // TODO: check that this works as expected.
            if (internalDate.isToday(location: context.location)) {
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
        calendarController.internalDateTimeRange.value = InternalDateTimeRange(start: start, end: end);
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
            // TODO: Check that this is still working as expected.
            final item = viewController.item(index);
            final date = viewController.dateTimeFromIndex(index)!;

            late final leading =
                components.leadingDateBuilder.call(InternalDateTime.fromDateTime(date), styles.scheduleDateStyle);
            late final highlightStyle = styles.scheduleTileHighlightStyle;
            late final highlightBuilder = components.scheduleTileHighlightBuilder;

            late final tileComponents = context.tileComponents() as ScheduleTileComponents;
            if (item is MonthItem) {
              final locale = context.locale;
              return tileComponents.monthItemBuilder?.call(InternalDateTime.fromDateTime(date).monthRange) ??
                  ListTile(title: Text(date.monthNameLocalized(locale)));
            } else if (item is EmptyItem) {
              final child = ListTile(
                leading: leading,
                title: tileComponents.emptyItemBuilder?.call(InternalDateTime.fromDateTime(date).dayRange),
              );
              return highlightBuilder(date, viewController.highlightedDateTimeRange, highlightStyle, child);
            } else if (item is EventItem) {
              final showDate = item.isFirst;
              final event = eventsController.byId(item.eventId)!;

              final child = ListTile(
                leading: showDate ? leading : const SizedBox(width: 32),
                title: ScheduleEventTile(
                  key: ScheduleEventTile.tileKey(event.id),
                  event: event,
                  tileComponents: tileComponents,
                  dateTimeRange: InternalDateTimeRange.fromDateTimeRange(date.dayRange),
                  resizeAxis: null,
                ),
              );

              return highlightBuilder(date, viewController.highlightedDateTimeRange, highlightStyle, child);
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
