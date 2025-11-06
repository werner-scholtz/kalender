import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions/internal.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';
import 'package:timezone/timezone.dart';

/// This widget renders a [DayEventsColumn] for each day in the [internalRange].
class MultiDayEventsRow<T extends Object?> extends StatelessWidget {
  /// The configuration for the multi-day body.
  final MultiDayBodyConfiguration configuration;

  /// The internal date time range that is being displayed.
  final InternalDateTimeRange internalRange;

  /// The controller for the multi-day view.
  final MultiDayViewController<T> viewController;

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
              child: DayEventsColumn<T>(
                key: columnKey(date),
                configuration: configuration,
                date: InternalDateTime.fromDateTime(date),
                eventsController: context.eventsController<T>(),
                location: context.location,
                viewConfiguration: viewController.viewConfiguration,
                cache: viewController.cache,
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
class DayEventsColumn<T extends Object?> extends StatefulWidget {
  /// The controller that holds the events.
  final EventsController<T> eventsController;

  /// The configuration for the multi-day body.
  final MultiDayBodyConfiguration configuration;

  final MultiDayViewConfiguration viewConfiguration;

  /// The date for which the events are being displayed.
  final InternalDateTime date;

  /// The controller for the multi-day view.
  // final MultiDayViewController<T> viewController;

  final EventLayoutDelegateCache cache;

  /// The location used for date and time calculations.
  final Location? location;

  /// Creates a new instance of the [DayEventsColumn] widget.
  const DayEventsColumn({
    super.key,
    required this.eventsController,
    required this.configuration,
    required this.viewConfiguration,
    required this.date,
    required this.location,
    required this.cache,
  });

  @override
  State<DayEventsColumn<T>> createState() => _DayEventsColumnState<T>();
}

class _DayEventsColumnState<T extends Object?> extends State<DayEventsColumn<T>> {
  /// The events that are displayed on the day.
  List<CalendarEvent<T>> _events = [];

  @override
  void initState() {
    _update();
    widget.eventsController.addListener(_update);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DayEventsColumn<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      widget.cache.clearAll();
      _update();
    }
  }

  @override
  void dispose() {
    widget.eventsController.removeListener(_update);
    super.dispose();
  }

  void _update() {
    final sortedEvents = _sort(
      widget.eventsController.eventsFromDateTimeRange(
        InternalDateTimeRange.fromDateTimeRange(widget.date.dayRange),
        includeDayEvents: true,
        includeMultiDayEvents: widget.configuration.showMultiDayEvents,
        location: widget.location,
      ),
    );

    if (!listEquals(sortedEvents, _events)) {
      setState(() => _events = sortedEvents);
    }
  }

  /// Sorts the events based on the layout strategy defined in the configuration.
  List<CalendarEvent<T>> _sort(Iterable<CalendarEvent<T>> events) {
    return widget.configuration.eventLayoutStrategy(
      [],
      widget.date,
      TimeOfDayRange.allDay(),
      0,
      widget.configuration.minimumTileHeight,
      widget.cache,
      widget.location,
    ).sortEvents(events) as List<CalendarEvent<T>>;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.calendarController<T>();

    final layoutStrategy = widget.configuration.eventLayoutStrategy;
    final eventsWidget = CustomMultiChildLayout(
      delegate: layoutStrategy.call(
        _events,
        widget.date,
        widget.viewConfiguration.timeOfDayRange,
        context.heightPerMinute,
        widget.configuration.minimumTileHeight,
        widget.cache,
        widget.location,
      ),
      children: _events.indexed
          .map(
            (item) => LayoutId(
              id: item.$1,
              key: DayEventTile.tileKey(item.$2.id),
              child: DayEventTile(
                event: item.$2,
                callbacks: context.callbacks<T>(),
                tileComponents: context.tileComponents<T>(),
                dateTimeRange: InternalDateTimeRange.fromDateTimeRange(widget.date.dayRange),
                interaction: context.interaction,
                resizeAxis: Axis.vertical,
              ),
            ),
          )
          .toList(),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: eventsWidget),
        Positioned.fill(
          child: PassThroughPointer(
            child: DayDropTargetColumn<T>(
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
class DayDropTargetColumn<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final MultiDayViewConfiguration viewConfiguration;
  final MultiDayBodyConfiguration configuration;
  final InternalDateTime date;
  final List<CalendarEvent<T>> events;
  final CalendarController<T> controller;
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
  State<DayDropTargetColumn<T>> createState() => _DayDropTargetColumnState<T>();
}

class _DayDropTargetColumnState<T extends Object?> extends State<DayDropTargetColumn<T>> {
  CalendarEvent<T>? _selectedEvent;

  @override
  void initState() {
    super.initState();
    widget.controller.selectedEvent.addListener(_update);
  }

  @override
  void didUpdateWidget(covariant DayDropTargetColumn<T> oldWidget) {
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
    if (!selectedEvent.internalRange(widget.location).overlaps(widget.date.dayRange)) {
      // We need to check if the _selectedEvent is null, if it is not, we reset the state.
      if (_selectedEvent != null) setState(() => _selectedEvent = null);
      return;
    }

    // If the configuration does not allow multi-day events and the selected event is a multi-day event, we do not update the state.
    if (!widget.configuration.showMultiDayEvents && selectedEvent.isMultiDayEvent) return;

    setState(() => _selectedEvent = selectedEvent);
  }

  @override
  Widget build(BuildContext context) {
    final layoutStrategy = widget.configuration.eventLayoutStrategy;
    final controller = context.calendarController<T>();

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

    final dropTarget = context.tileComponents<T>().dropTargetTile;

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
          final drawTile = dropTarget != null && (event.id == -1 || event.id == controller.selectedEventId);

          return LayoutId(
            id: item.$1,
            child: drawTile ? dropTarget.call(event) : const SizedBox(),
          );
        },
      ).toList(),
    );
  }
}
