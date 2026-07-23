import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';

/// This widget renders a [DayEventsColumn] for each day in the [internalRange].
class MultiDayEventsRow extends StatelessWidget {
  /// The configuration for the multi-day body.
  final MultiDayBodyConfiguration configuration;

  /// The internal date time range that is being displayed.
  final InternalDateTimeRange internalRange;

  /// The controller for the multi-day view.
  final MultiDayViewController viewController;

  /// Creates a new instance of the [MultiDayEventsRow] widget.
  const MultiDayEventsRow({
    super.key,
    required this.configuration,
    required this.internalRange,
    required this.viewController,
  });

  /// A key used to identify the day events widget.
  static Key columnKey(DateTime date) => Key('DayEvents-$date');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final date in internalRange.dates())
          Expanded(
            child: Padding(
              padding: configuration.horizontalPadding.copyWith(top: 0, bottom: 0),
              child: DayEventsColumn(
                key: columnKey(date),
                configuration: configuration,
                date: InternalDateTime.fromDateTime(date),
                eventsController: context.eventsController,
                location: context.location,
                viewConfiguration: viewController.viewConfiguration,
                cache: viewController.cache,
                heightPerMinute: context.heightPerMinute,
                scrollController: viewController.scrollController,
                calendarController: context.calendarController,
              ),
            ),
          ),
      ],
    );
  }
}

/// This widget is used to render the events for a single day.
///
/// It listens to the [EventsController] for changes and updates the events accordingly.
class DayEventsColumn extends StatefulWidget {
  /// The controller that holds the events.
  final EventsController eventsController;

  /// The configuration for the multi-day body.
  final MultiDayBodyConfiguration configuration;

  final MultiDayViewConfiguration viewConfiguration;

  /// The date for which the events are being displayed.
  final InternalDateTime date;

  /// The controller for the multi-day view.
  // final MultiDayViewController viewController;

  final EventLayoutDelegateCache cache;

  /// The location used for date and time calculations.
  final Location? location;

  final double heightPerMinute;

  /// The vertical scroll controller of the multi-day body.
  ///
  /// Used to only build the event tiles whose time band is within the visible
  /// scroll window (plus an overscan margin), instead of every event of the day.
  final ScrollController scrollController;

  /// The calendar controller, used to keep a selected (being dragged/resized)
  /// event built even when it scrolls out of view.
  final CalendarController calendarController;

  /// Creates a new instance of the [DayEventsColumn] widget.
  const DayEventsColumn({
    super.key,
    required this.eventsController,
    required this.configuration,
    required this.viewConfiguration,
    required this.date,
    required this.location,
    required this.cache,
    required this.heightPerMinute,
    required this.scrollController,
    required this.calendarController,
  });

  @override
  State<DayEventsColumn> createState() => _DayEventsColumnState();
}

class _DayEventsColumnState extends State<DayEventsColumn> {
  /// The events that are displayed on the day.
  List<CalendarEvent> _events = [];

  /// The (top, bottom) pixel band of each event in [_events], used to decide
  /// which events fall inside the visible scroll window.
  List<(double, double)> _bands = const [];

  /// The indices into [_events] whose tiles are currently built. Only events
  /// within the visible scroll window (plus an overscan margin) are built.
  Set<int> _visibleIndices = const {};

  @override
  void initState() {
    super.initState();
    _events = _sort(_queryEvents());
    _bands = _computeBands(_events);
    _visibleIndices = _computeVisibleIndices();
    widget.eventsController.addListener(_update);
    widget.scrollController.addListener(_onViewportChanged);
    widget.calendarController.selectedEvent.addListener(_onViewportChanged);
    // The scroll view may not be attached on the first build, in which case
    // everything is built. Re-cull once it is attached.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onViewportChanged();
    });
  }

  @override
  void didUpdateWidget(covariant DayEventsColumn oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onViewportChanged);
      widget.scrollController.addListener(_onViewportChanged);
    }
    if (oldWidget.calendarController != widget.calendarController) {
      oldWidget.calendarController.selectedEvent.removeListener(_onViewportChanged);
      widget.calendarController.selectedEvent.addListener(_onViewportChanged);
    }

    final didUpdateLocation = oldWidget.location != widget.location;
    final didUpdateHeightPerMinute = oldWidget.heightPerMinute != widget.heightPerMinute;

    if (didUpdateLocation || didUpdateHeightPerMinute) {
      widget.cache.clearAll();
      setState(() {
        _events = _sort(_queryEvents());
        _bands = _computeBands(_events);
        _visibleIndices = _computeVisibleIndices();
      });
    }
  }

  @override
  void dispose() {
    widget.eventsController.removeListener(_update);
    widget.scrollController.removeListener(_onViewportChanged);
    widget.calendarController.selectedEvent.removeListener(_onViewportChanged);
    super.dispose();
  }

  /// Queries the events for this day from the controller.
  Iterable<CalendarEvent> _queryEvents() {
    return widget.eventsController.eventsFromDateTimeRange(
      InternalDateTimeRange.fromDateTimeRange(widget.date.dayRange),
      includeDayEvents: true,
      includeMultiDayEvents: widget.configuration.showMultiDayEvents,
      location: widget.location,
    );
  }

  void _update() {
    final sortedEvents = _sort(_queryEvents());

    if (_needsLayout(sortedEvents)) {
      setState(() {
        _events = sortedEvents;
        _bands = _computeBands(sortedEvents);
        _visibleIndices = _computeVisibleIndices();
      });
    }
  }

  /// Recomputes the visible events as the scroll position (or selection)
  /// changes, and rebuilds only when the set actually changes.
  void _onViewportChanged() {
    final next = _computeVisibleIndices();
    if (!setEquals(next, _visibleIndices)) {
      setState(() => _visibleIndices = next);
    }
  }

  /// Computes the (top, bottom) pixel band of each event, matching the layout
  /// delegate's geometry so culling lines up with what is actually drawn.
  List<(double, double)> _computeBands(List<CalendarEvent> events) {
    if (events.isEmpty) return const [];
    final delegate = widget.configuration.eventLayoutStrategy(
      const [],
      widget.date,
      widget.viewConfiguration.timeOfDayRange,
      widget.heightPerMinute,
      widget.configuration.minimumTileHeight,
      widget.cache,
      widget.location,
    );
    return [
      for (final event in events)
        (
          delegate.calculateDistanceFromStart(event),
          delegate.calculateDistanceFromStart(event) + delegate.calculateHeight(event)
        ),
    ];
  }

  /// The indices of the events whose band intersects the visible scroll window
  /// (plus an overscan margin). Falls back to all events when the scroll view is
  /// not attached yet.
  Set<int> _computeVisibleIndices() {
    final controller = widget.scrollController;
    if (!controller.hasClients || controller.positions.length != 1) {
      return {for (var i = 0; i < _events.length; i++) i};
    }

    final position = controller.position;
    // The viewport/pixels are not available until the scroll view has been laid
    // out. Until then build everything; the post-frame callback re-culls.
    if (!position.hasViewportDimension || !position.hasPixels) {
      return {for (var i = 0; i < _events.length; i++) i};
    }
    final overscan = position.viewportDimension * 0.5;
    final windowTop = position.pixels - overscan;
    final windowBottom = position.pixels + position.viewportDimension + overscan;

    final visible = <int>{};
    for (var i = 0; i < _bands.length; i++) {
      final (top, bottom) = _bands[i];
      if (bottom >= windowTop && top <= windowBottom) visible.add(i);
    }

    // Keep a selected (being dragged/resized) event built even when it scrolls
    // out of view, so the interaction is not interrupted.
    final selectedId = widget.calendarController.selectedEventId;
    if (selectedId != null) {
      final index = _events.indexWhere((event) => event.id == selectedId);
      if (index != -1) visible.add(index);
    }

    return visible;
  }

  /// Checks if the layout of the events has changed.
  bool _needsLayout(List<CalendarEvent> sortedEvents) {
    if (sortedEvents.length != _events.length) return true;
    for (var i = 0; i < sortedEvents.length; i++) {
      if (!sortedEvents[i].layoutEquals(_events[i])) return true;
    }
    return false;
  }

  /// Sorts the events based on the layout strategy defined in the configuration.
  List<CalendarEvent> _sort(Iterable<CalendarEvent> events) {
    return widget.configuration.eventLayoutStrategy(
      [],
      widget.date,
      TimeOfDayRange.allDay(),
      0,
      widget.configuration.minimumTileHeight,
      widget.cache,
      widget.location,
    ).sortEvents(events);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.calendarController;

    final layoutStrategy = widget.configuration.eventLayoutStrategy;
    // The tile range is the same for every tile in this column, so compute it
    // once instead of allocating a new range per event.
    final tileRange = InternalDateTimeRange.fromDateTimeRange(widget.date.dayRange);
    final eventsWidget = CustomMultiChildLayout(
      delegate: layoutStrategy.call(
        _events,
        widget.date,
        widget.viewConfiguration.timeOfDayRange,
        context.heightPerMinute,
        widget.configuration.minimumTileHeight,
        widget.cache,
        context.location,
      ),
      // Only build the tiles within the visible scroll window. The delegate
      // still receives every event (above) so overlap widths stay correct even
      // when an overlapping partner is culled.
      children: [
        for (final index in _visibleIndices)
          LayoutId(
            id: index,
            key: DayEventTile.tileKey(_events[index].id),
            child: DayEventTile(
              event: _events[index],
              tileComponents: context.tileComponents,
              dateTimeRange: tileRange,
              resizeAxis: Axis.vertical,
            ),
          ),
      ],
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: eventsWidget),
        Positioned.fill(
          child: PassThroughPointer(
            child: DayDropTargetColumn(
              events: _events,
              eventsController: widget.eventsController,
              configuration: widget.configuration,
              viewConfiguration: widget.viewConfiguration,
              date: widget.date,
              controller: controller,
              cache: widget.cache,
              location: widget.location,
            ),
          ),
        ),
      ],
    );
  }
}

/// This widget is used to render the drop target for the day events.
class DayDropTargetColumn extends StatefulWidget {
  final EventsController eventsController;
  final MultiDayViewConfiguration viewConfiguration;
  final MultiDayBodyConfiguration configuration;
  final InternalDateTime date;
  final List<CalendarEvent> events;
  final CalendarController controller;
  final EventLayoutDelegateCache cache;
  final Location? location;
  const DayDropTargetColumn({
    super.key,
    required this.events,
    required this.eventsController,
    required this.configuration,
    required this.viewConfiguration,
    required this.date,
    required this.controller,
    required this.cache,
    required this.location,
  });

  @override
  State<DayDropTargetColumn> createState() => _DayDropTargetColumnState();
}

class _DayDropTargetColumnState extends State<DayDropTargetColumn> {
  CalendarEvent? _selectedEvent;

  @override
  void initState() {
    super.initState();
    widget.controller.selectedEvent.addListener(_update);
  }

  @override
  void didUpdateWidget(covariant DayDropTargetColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) _update();
  }

  @override
  void dispose() {
    widget.controller.selectedEvent.removeListener(_update);
    super.dispose();
  }

  void _update() {
    final selectedEvent = widget.controller.selectedEvent.value;
    // This ensures that we do not rebuild the widget if the selected event is the same as the current one.
    if (selectedEvent == _selectedEvent) return;

    // If the selected event is null, we reset the state.
    if (selectedEvent == null) {
      setState(() => _selectedEvent = null);
      return;
    }

    // If the selected event does not overlap with the current date.
    if (!selectedEvent.internalRange(location: widget.location).overlaps(widget.date.dayRange)) {
      // We need to check if the _selectedEvent is null, if it is not, we reset the state.
      if (_selectedEvent != null) setState(() => _selectedEvent = null);
      return;
    }

    // If the configuration does not allow multi-day events and the selected event is a multi-day event, clear the state.
    if (!widget.configuration.showMultiDayEvents && selectedEvent.spansMultipleDays(location: widget.location)) {
      if (_selectedEvent != null) setState(() => _selectedEvent = null);
      return;
    }

    setState(() => _selectedEvent = selectedEvent);
  }

  @override
  Widget build(BuildContext context) {
    final layoutStrategy = widget.configuration.eventLayoutStrategy;
    final controller = context.calendarController;

    // If there is no event being dragged, return an empty widget.
    final event = _selectedEvent;
    if (event == null) return const SizedBox();

    final eventList = widget.events.toList();
    // Find the index of the selected event.
    final index = eventList.indexWhere((e) => e.id == controller.selectedEventId);
    if (index != -1) {
      // If it exists override it with the selectedEvent.
      eventList[index] = event;
    } else {
      // Else add it at the start of the list.
      eventList.insert(0, event);
    }

    final dropTarget = context.tileComponents.dropTargetTile;

    return CustomMultiChildLayout(
      delegate: layoutStrategy.call(
        eventList,
        widget.date,
        widget.viewConfiguration.timeOfDayRange,
        context.heightPerMinute,
        widget.configuration.minimumTileHeight,
        widget.cache,
        context.location,
      ),
      children: eventList.indexed.map(
        (item) {
          final event = item.$2;
          final latest = widget.eventsController.byId(event.id);
          final selected = event.id == controller.selectedEventId;
          final drawTile = dropTarget != null && selected;

          return LayoutId(
            id: item.$1,
            child: drawTile ? dropTarget.call(latest ?? event) : const SizedBox(),
          );
        },
      ).toList(),
    );
  }
}
