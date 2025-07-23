import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/day_event_tile.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';

/// TODO: sort this out.

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
class MultiDayEventsRow<T extends Object?> extends StatelessWidget {
  final MultiDayBodyConfiguration configuration;
  final MultiDayViewConfiguration viewConfiguration;
  final DateTimeRange visibleDateTimeRange;
  const MultiDayEventsRow({
    super.key,
    required this.configuration,
    required this.viewConfiguration,
    required this.visibleDateTimeRange,
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
                viewConfiguration: viewConfiguration,
                configuration: configuration,
                date: date,
                eventsController: context.eventsController<T>(),
              ),
            ),
          ),
      ],
    );
  }
}

class DayEventsColumn<T> extends StatefulWidget {
  final EventsController<T> eventsController;
  final MultiDayViewConfiguration viewConfiguration;
  final MultiDayBodyConfiguration configuration;
  final DateTime date;
  const DayEventsColumn({
    super.key,
    required this.eventsController,
    required this.configuration,
    required this.viewConfiguration,
    required this.date,
  });

  @override
  State<DayEventsColumn<T>> createState() => _DayEventsColumnState<T>();
}

class _DayEventsColumnState<T> extends State<DayEventsColumn<T>> {
  /// The events that are displayed on the day.
  List<CalendarEvent<T>> _events = [];
  EventsController<T> get _eventsController => widget.eventsController;

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
              ),
            ),
          )
          .toList(),
    );

    // TODO: investigate a more efficient way to do this.
    // This can get computationally expensive when there a lot of events.
    // Might be worth it to store the current layout instead of re-calculating every time.
    final dropTargetWidget = ValueListenableBuilder(
      valueListenable: context.calendarController<T>().selectedEvent,
      builder: (context, event, child) {
        // If there is no event being dragged, return an empty widget.
        if (event == null) return const SizedBox();
        if (!event.dateTimeRangeAsUtc.overlaps(widget.date.dayRange)) return const SizedBox();
        if (!widget.configuration.showMultiDayEvents && event.isMultiDayEvent) return const SizedBox();

        final eventList = _events.toList();
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
  }
}
