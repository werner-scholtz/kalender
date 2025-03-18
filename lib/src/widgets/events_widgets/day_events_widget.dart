import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/day_event_tile.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';

/// This widget is renders all the event tiles that are visible on the provided dateTimeRange.
///
/// It fetches the events that need to be rendered from the [EventsController],
/// the [EventsController] is also listened to in-case events are added or updated.
///
/// This widget also takes responsibility for updating the [CalendarController.visibleEvents].
///
/// To render the event tiles it uses [CustomMultiChildLayout],
/// along with a [overlapLayoutStrategy], [sideBySideLayoutStrategy] or custom strategy defined by the user.
///
/// * Note: When a event is being modified by the user it renders that event in a separate [CustomMultiChildLayout],
///         This is somewhat expensive computationally as it lays out all the events again to determine the position
///         of the event being modified. See todo for a possible solution.
class DayEventsWidget<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> controller;
  final CalendarCallbacks<T>? callbacks;

  final TileComponents<T> tileComponents;
  final MultiDayBodyConfiguration configuration;
  final DateTimeRange visibleDateTimeRange;
  final TimeOfDayRange timeOfDayRange;
  final double dayWidth;
  final double heightPerMinute;

  /// Creates a [DayEventsWidget].
  const DayEventsWidget({
    super.key,
    required this.eventsController,
    required this.controller,
    required this.callbacks,
    required this.tileComponents,
    required this.configuration,
    required this.dayWidth,
    required this.heightPerMinute,
    required this.visibleDateTimeRange,
    required this.timeOfDayRange,
  });

  @override
  State<DayEventsWidget<T>> createState() => _DayEventsWidgetState<T>();
}

class _DayEventsWidgetState<T extends Object?> extends State<DayEventsWidget<T>> {
  /// The visible events value notifier.
  ValueNotifier<Set<CalendarEvent<T>>> get visibleEvents => widget.controller.visibleEvents;

  /// A map containing all the days and Events that will be displayed.
  late Map<DateTime, List<CalendarEvent<T>>> eventsMap;

  @override
  void initState() {
    super.initState();
    _populateEventsMap();
    widget.eventsController.addListener(_updateEventsMap);
  }

  @override
  void dispose() {
    widget.eventsController.removeListener(_updateEventsMap);
    super.dispose();
  }

  /// Update the [eventsMap].
  void _updateEventsMap() => setState(_populateEventsMap);

  /// Populate the [eventsMap].
  void _populateEventsMap() {
    final visibleDates = widget.visibleDateTimeRange.dates();
    final showMultiDayEvents = widget.configuration.showMultiDayEvents;
    final layoutStrategy = widget.configuration.eventLayoutStrategy;

    // Clear the visible events.
    final allEvents = <CalendarEvent<T>>{};

    final entries = visibleDates.map((date) {
      final events = widget.eventsController.eventsFromDateTimeRange(
        date.dayRange,
        includeDayEvents: true,
        includeMultiDayEvents: showMultiDayEvents,
      );

      allEvents.addAll(events);

      final sortedEvents = layoutStrategy(
        [],
        date,
        TimeOfDayRange.allDay(),
        0,
      ).sortEvents(events) as List<CalendarEvent<T>>;
      return MapEntry(date, sortedEvents);
    });

    // Add the events to the visible events.
    visibleEvents.value = allEvents;

    eventsMap = Map.fromEntries(entries);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final entry in eventsMap.entries)
          Expanded(
            child: Padding(
              padding: widget.configuration.horizontalPadding.copyWith(top: 0, bottom: 0),
              child: _SingleDayWidget<T>(
                date: entry.key,
                events: entry.value,
                heightPerMinute: widget.heightPerMinute,
                timeOfDayRange: widget.timeOfDayRange,
                eventsController: widget.eventsController,
                controller: widget.controller,
                callbacks: widget.callbacks,
                tileComponents: widget.tileComponents,
                configuration: widget.configuration,
              ),
            ),
          ),
      ],
    );
  }
}

class _SingleDayWidget<T extends Object?> extends StatefulWidget {
  final DateTime date;
  final List<CalendarEvent<T>> events;
  final EventsController<T> eventsController;
  final CalendarController<T> controller;
  final double heightPerMinute;
  final TimeOfDayRange timeOfDayRange;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;
  final MultiDayBodyConfiguration configuration;

  const _SingleDayWidget({
    super.key,
    required this.date,
    required this.events,
    required this.heightPerMinute,
    required this.timeOfDayRange,
    required this.eventsController,
    required this.controller,
    required this.callbacks,
    required this.tileComponents,
    required this.configuration,
  });

  @override
  State<_SingleDayWidget<T>> createState() => _SingleDayWidgetState<T>();
}

class _SingleDayWidgetState<T extends Object?> extends State<_SingleDayWidget<T>> {
  late DateTime date = widget.date;
  late List<CalendarEvent<T>> events = widget.events;

  @override
  void didUpdateWidget(covariant _SingleDayWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final didChangeEvents = !listEquals(widget.events, oldWidget.events);

    final didChangeDate = widget.date != oldWidget.date;
    if (didChangeEvents || didChangeDate) {
      setState(() {
        date = widget.date;
        events = widget.events;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final layoutStrategy = widget.configuration.eventLayoutStrategy;
    final eventsWidget = CustomMultiChildLayout(
      delegate: layoutStrategy.call(
        events,
        date,
        widget.timeOfDayRange,
        widget.heightPerMinute,
      ),
      children: events.indexed
          .map(
            (item) => LayoutId(
              id: item.$1,
              child: DayEventTile(
                event: item.$2,
                eventsController: widget.eventsController,
                controller: widget.controller,
                callbacks: widget.callbacks,
                tileComponents: widget.tileComponents,
                dateTimeRange: date.dayRange,
                allowResizing: widget.configuration.allowResizing,
                allowRescheduling: widget.configuration.allowRescheduling,
              ),
            ),
          )
          .toList(),
    );

    // TODO: investigate a more efficient way to do this.
    // This can get computationally expensive when there a lot of events.
    // Might be worth it to store the current layout instead of re-calculating every time.
    final dropTargetWidget = ValueListenableBuilder(
      valueListenable: widget.controller.selectedEvent,
      builder: (context, event, child) {
        // If there is no event being dragged, return an empty widget.
        if (event == null) return const SizedBox();
        if (!event.dateTimeRangeAsUtc.overlaps(date.dayRange)) return const SizedBox();
        if (!widget.configuration.showMultiDayEvents && event.isMultiDayEvent) return const SizedBox();

        final eventList = events.toList();
        // Find the index of the selected event.
        final index = eventList.indexWhere((e) => e.id == widget.controller.selectedEventId);
        if (index != -1) {
          // If it exists override it with the selectedEvent.
          eventList[index] = event;
        } else {
          // Else add it at the start of the list.
          eventList.insert(0, event);
        }

        final dropTarget = widget.tileComponents.dropTargetTile;

        return CustomMultiChildLayout(
          delegate: layoutStrategy.call(eventList, date, widget.timeOfDayRange, widget.heightPerMinute),
          children: eventList.indexed.map(
            (item) {
              final event = item.$2;
              final drawTile = dropTarget != null && (event.id == -1 || event.id == widget.controller.selectedEventId);

              return LayoutId(
                id: item.$1,
                child: drawTile ? dropTarget.call(event) : const SizedBox(),
              );
            },
          ).toList(),
        );
      },
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: eventsWidget),
        Positioned.fill(child: PassThroughPointer(child: dropTargetWidget)),
      ],
    );
  }
}
