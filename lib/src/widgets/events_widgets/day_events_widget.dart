import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';
import 'package:timezone/timezone.dart';

/// This widget is renders all the event tiles that are visible on the provided dateTimeRange.
///
/// It fetches the events that need to be rendered from the [EventsController],
/// the [EventsController] is also listened to in-case events are added or updated.
///
/// This widget also takes responsibility for updating the [CalendarController.visibleEvents].
///
/// To render the event tiles it uses [CustomMultiChildLayout],
/// along with a [overlapLayoutStrategy], [sideBySideLayoutStrategy] or custom strategy defined by the user.
class MultiDayEventsRow<T extends Object?> extends StatelessWidget {
  final MultiDayBodyConfiguration configuration;
  final DateTimeRange visibleDateTimeRange;
  final MultiDayViewController<T> viewController;
  const MultiDayEventsRow({
    super.key,
    required this.configuration,
    required this.visibleDateTimeRange,
    required this.viewController,
  });

  /// A key used to identify the day events widget.
  static Key columnKey(DateTime date) => Key('DayEvents-$date');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final date in visibleDateTimeRange.dates())
          Expanded(
            child: Padding(
              padding: configuration.horizontalPadding.copyWith(top: 0, bottom: 0),
              child: DayEventsColumn<T>(
                key: columnKey(date),
                configuration: configuration,
                date: date,
                eventsController: context.eventsController<T>(),
                viewController: viewController,
                location: context.location,
              ),
            ),
          ),
      ],
    );
  }
}

class DayEventsColumn<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;

  final MultiDayBodyConfiguration configuration;
  final DateTime date;
  final MultiDayViewController<T> viewController;
  final Location? location;
  const DayEventsColumn({
    super.key,
    required this.eventsController,
    required this.configuration,
    required this.date,
    required this.viewController,
    required this.location,
  });

  @override
  State<DayEventsColumn<T>> createState() => _DayEventsColumnState<T>();
}

class _DayEventsColumnState<T extends Object?> extends State<DayEventsColumn<T>> {
  /// The events that are displayed on the day.
  List<CalendarEvent<T>> _events = [];
  EventsController<T> get _eventsController => widget.eventsController;
  EventLayoutDelegateCache get cache => widget.viewController.cache;
  MultiDayViewConfiguration get viewConfiguration => widget.viewController.viewConfiguration;

  @override
  void initState() {
    _update();
    _eventsController.addListener(_update);
    super.initState();
  }

  @override
  void dispose() {
    _eventsController.removeListener(_update);
    super.dispose();
  }

  void _update() {
    final sortedEvents = _sort(
      _eventsController.eventsFromDateTimeRange(
        widget.date.dayRange,
        widget.location,
        includeDayEvents: true,
        includeMultiDayEvents: widget.configuration.showMultiDayEvents,
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
      cache,
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
        viewConfiguration.timeOfDayRange,
        context.heightPerMinute,
        widget.configuration.minimumTileHeight,
        cache,
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
                dateTimeRange: widget.date.dayRange,
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
              viewConfiguration: viewConfiguration,
              date: widget.date,
              controller: controller,
              viewController: widget.viewController,
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
  final DateTime date;
  final List<CalendarEvent<T>> events;
  final CalendarController<T> controller;
  final MultiDayViewController<T> viewController;
  final Location? location;
  const DayDropTargetColumn({
    super.key,
    required this.events,
    required this.eventsController,
    required this.configuration,
    required this.viewConfiguration,
    required this.date,
    required this.controller,
    required this.viewController,
    required this.location,
  });

  @override
  State<DayDropTargetColumn<T>> createState() => _DayDropTargetColumnState<T>();
}

class _DayDropTargetColumnState<T extends Object?> extends State<DayDropTargetColumn<T>> {
  CalendarController<T> get controller => widget.controller;
  CalendarEvent<T>? _selectedEvent;

  @override
  void initState() {
    super.initState();
    controller.selectedEvent.addListener(_update);
  }

  @override
  void dispose() {
    controller.selectedEvent.removeListener(_update);
    super.dispose();
  }

  void _update() {
    final selectedEvent = controller.selectedEvent.value;
    // This ensures that we do not rebuild the widget if the selected event is the same as the current one.
    if (selectedEvent == _selectedEvent) return;

    // If the selected event is null, we reset the state.
    if (selectedEvent == null) {
      setState(() => _selectedEvent = null);
      return;
    }

    // If the selected event does not overlap with the current date.
    if (!selectedEvent.dateTimeRangeAsUtc(widget.location).overlaps(widget.date.dayRange)) {
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
        widget.viewController.cache,
        widget.location,
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
