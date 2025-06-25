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
  final ValueNotifier<CalendarInteraction> interaction;

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
    required this.interaction,
  });

  @override
  State<DayEventsWidget<T>> createState() => _DayEventsWidgetState<T>();
}

class _DayEventsWidgetState<T extends Object?> extends State<DayEventsWidget<T>> {
  /// The days that should be rendered by this widget.
  late final _visibleDays = widget.visibleDateTimeRange.dates();

  late final Map<DateTime, ValueNotifier<List<CalendarEvent<T>>>> _notifiersMap = Map.fromIterables(
    _visibleDays,
    List.from(_visibleDays.map((date) => ValueNotifier<List<CalendarEvent<T>>>([]))),
  );

  /// A map containing all the days and Events that will be displayed.
  late Map<DateTime, List<CalendarEvent<T>>> eventsMap;

  @override
  void initState() {
    super.initState();
    _updateEvents();
    widget.eventsController.addListener(_updateEvents);
  }

  @override
  void dispose() {
    widget.eventsController.removeListener(_updateEvents);
    super.dispose();
  }

  void _updateEvents() {
    final showMultiDayEvents = widget.configuration.showMultiDayEvents;
    final layoutStrategy = widget.configuration.eventLayoutStrategy;

    for (final date in _visibleDays) {
      final events = widget.eventsController.eventsFromDateTimeRange(
        date.dayRange,
        includeDayEvents: true,
        includeMultiDayEvents: showMultiDayEvents,
      );

      // Update the events for the date.
      final sortedEvents = layoutStrategy(
        [],
        date,
        widget.timeOfDayRange,
        widget.heightPerMinute,
        widget.configuration.minimumTileHeight,
      ).sortEvents(events) as List<CalendarEvent<T>>;

      final notifier = _notifiersMap[date]!;
      if (listEquals(notifier.value, sortedEvents)) continue;
      // Notify the listeners of the changes.
      notifier.value = sortedEvents;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final date in _visibleDays)
          Expanded(
            child: Padding(
              padding: widget.configuration.horizontalPadding.copyWith(top: 0, bottom: 0),
              child: _SingleDayWidget<T>(
                date: date,
                eventNotifier: _notifiersMap[date]!,
                heightPerMinute: widget.heightPerMinute,
                timeOfDayRange: widget.timeOfDayRange,
                eventsController: widget.eventsController,
                controller: widget.controller,
                callbacks: widget.callbacks,
                tileComponents: widget.tileComponents,
                configuration: widget.configuration,
                interaction: widget.interaction,
              ),
            ),
          ),
      ],
    );
  }
}

class _SingleDayWidget<T extends Object?> extends StatelessWidget {
  final DateTime date;
  final ValueNotifier<List<CalendarEvent<T>>> eventNotifier;
  final EventsController<T> eventsController;
  final CalendarController<T> controller;
  final double heightPerMinute;
  final TimeOfDayRange timeOfDayRange;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;
  final MultiDayBodyConfiguration configuration;
  final ValueNotifier<CalendarInteraction> interaction;

  const _SingleDayWidget({
    super.key,
    required this.date,
    required this.eventNotifier,
    required this.heightPerMinute,
    required this.timeOfDayRange,
    required this.eventsController,
    required this.controller,
    required this.callbacks,
    required this.tileComponents,
    required this.configuration,
    required this.interaction,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: eventNotifier,
      builder: (context, events, child) {
        final layoutStrategy = configuration.eventLayoutStrategy;
        final eventsWidget = CustomMultiChildLayout(
          delegate: layoutStrategy.call(
            events,
            date,
            timeOfDayRange,
            heightPerMinute,
            configuration.minimumTileHeight,
          ),
          children: events.indexed
              .map(
                (item) => LayoutId(
                  id: item.$1,
                  child: DayEventTile(
                    key: DayEventTile.getKey(item.$2.id),
                    event: item.$2,
                    eventsController: eventsController,
                    controller: controller,
                    callbacks: callbacks,
                    tileComponents: tileComponents,
                    dateTimeRange: date.dayRange,
                    interaction: interaction,
                  ),
                ),
              )
              .toList(),
        );

        // TODO: investigate a more efficient way to do this.
        // This can get computationally expensive when there a lot of events.
        // Might be worth it to store the current layout instead of re-calculating every time.
        final dropTargetWidget = ValueListenableBuilder(
          valueListenable: controller.selectedEvent,
          builder: (context, event, child) {
            // If there is no event being dragged, return an empty widget.
            if (event == null) return const SizedBox();
            if (!event.dateTimeRangeAsUtc.overlaps(date.dayRange)) return const SizedBox();
            if (!configuration.showMultiDayEvents && event.isMultiDayEvent) return const SizedBox();

            final eventList = events.toList();
            // Find the index of the selected event.
            final index = eventList.indexWhere((e) => e.id == controller.selectedEventId);
            if (index != -1) {
              // If it exists override it with the selectedEvent.
              eventList[index] = event;
            } else {
              // Else add it at the start of the list.
              eventList.insert(0, event);
            }

            final dropTarget = tileComponents.dropTargetTile;

            return CustomMultiChildLayout(
              delegate: layoutStrategy.call(
                eventList,
                date,
                timeOfDayRange,
                heightPerMinute,
                configuration.minimumTileHeight,
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
          },
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: eventsWidget),
            Positioned.fill(child: PassThroughPointer(child: dropTargetWidget)),
          ],
        );
      },
    );
  }
}
