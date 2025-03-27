import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_event_tile.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';

/// A function that generates the layout frame for the events.
///
/// The layout frame contains all the data needed to layout the events with [MultiDayLayout].
typedef MultiDayGenerateLayoutFrame<T extends Object?> = MultiDayLayoutFrame<T> Function({
  required DateTimeRange dateTimeRange,
  required List<CalendarEvent<T>> events,
});

/// A default implementation of [MultiDayGenerateLayoutFrame].
///
/// The default implementation sorts the events from the earliest to the latest and longest to shortest.
/// Then it finds the first row that doesn't overlap with any other event and assigns the event to that row.
MultiDayLayoutFrame<T> defaultMultiDayGenerateFrame<T extends Object?>({
  required DateTimeRange dateTimeRange,
  required List<CalendarEvent<T>> events,
}) {
  // Sort the events in descending order.
  final sortedEvents = events.toList()
    ..sort((a, b) => a.start.compareTo(b.start))
    ..sort((a, b) => b.duration.compareTo(a.duration));

  final layoutInfo = <EventLayoutInfo>[];
  var maxRow = 0;
  final map = <DateTime, int>{
    for (final date in dateTimeRange.dates()) date: 0,
  };

  for (final event in sortedEvents) {
    // Get the range of the event as UTC.
    final rangeAsUtc = event.dateTimeRangeAsUtc;

    // Create a range that uses the correct start and end date.
    final range = DateTimeRange(
      start: rangeAsUtc.start,
      // If the end date is the start of the day, we use the start of the day otherwise
      // we use the end of the day so that the day is included.
      end: rangeAsUtc.end == rangeAsUtc.end.startOfDay ? rangeAsUtc.end.startOfDay : rangeAsUtc.end.endOfDay,
    );

    final info = EventLayoutInfo(
      id: event.id,
      row: 0,
      range: range,
    );

    // From all the existing layout info find the ones that overlap with the current event.
    final overlaps = layoutInfo.where((e) {
      return e.range.overlaps(info.range);
    }).toList();

    // Find the first row that doesn't overlap with any other event.
    final row = overlaps.isEmpty ? 0 : overlaps.last.row + 1;

    // Update the max row.
    maxRow = max(maxRow, row);

    // Update the map with the number of rows for each date.
    final days = info.range.dates().toList();
    for (final date in days) {
      if (map[date] != null) map[date] = max(map[date] ?? 0, row);
    }

    layoutInfo.add(info.copyWith(row: row));
  }

  // TODO: add a compacting step that moves events up to a row if there is a empty space above it.

  return MultiDayLayoutFrame(
    dateTimeRange: dateTimeRange,
    layoutInfo: layoutInfo,
    events: events,
    totalNumberOfRows: maxRow + 1,
    dateToNumberOfRows: map,
  );
}

class MultiDayEventLayoutWidget<T extends Object?> extends StatefulWidget {
  const MultiDayEventLayoutWidget({
    required this.events,
    required this.eventsController,
    required this.controller,
    required this.visibleDateTimeRange,
    required this.tileComponents,
    required this.callbacks,
    required this.dayWidth,
    required this.showAllEvents,
    required this.tileHeight,
    required this.maxNumberOfVerticalEvents,
    required this.interaction,
    required this.generateFrame,
    super.key,
  });

  final EventsController<T> eventsController;
  final CalendarController<T> controller;
  final DateTimeRange visibleDateTimeRange;
  final TileComponents<T> tileComponents;
  final CalendarCallbacks<T>? callbacks;
  final double dayWidth;
  final bool showAllEvents;
  final double tileHeight;
  final int? maxNumberOfVerticalEvents;
  final ValueNotifier<CalendarInteraction> interaction;

  /// The list of events that will be laid out.
  ///
  /// * Note: not all of these events will necessarily be visible,
  ///         it depends on the height constraint.
  final List<CalendarEvent<T>> events;

  /// The function that generates the layout frame for the events.
  final MultiDayGenerateLayoutFrame<T> generateFrame;

  @override
  State<MultiDayEventLayoutWidget<T>> createState() => _MultiDayEventLayoutWidgetState<T>();
}

class _MultiDayEventLayoutWidgetState<T extends Object?> extends State<MultiDayEventLayoutWidget<T>> {
  /// The range of dates that the events will be laid out on.
  late DateTimeRange _dateTimeRange;

  /// The layout frame that contains all the data needed to display the events.
  late MultiDayLayoutFrame<T> _frame;

  @override
  void initState() {
    super.initState();
    _dateTimeRange = widget.visibleDateTimeRange;
    _frame = widget.generateFrame(dateTimeRange: _dateTimeRange, events: widget.events);
  }

  @override
  void didUpdateWidget(covariant MultiDayEventLayoutWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // TODO: add all needed checks.
    final didUpdate = !oldWidget.events.equals(widget.events) ||
        oldWidget.visibleDateTimeRange != widget.visibleDateTimeRange ||
        oldWidget.generateFrame != widget.generateFrame;

    if (didUpdate) {
      _dateTimeRange = widget.visibleDateTimeRange;

      setState(() {
        _frame = widget.generateFrame(dateTimeRange: _dateTimeRange, events: widget.events);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final (events, layoutInfo) = _frame.visibleEvents(widget.maxNumberOfVerticalEvents);

    final maxNumberOfRows = widget.maxNumberOfVerticalEvents == null
        ? _frame.totalNumberOfRows
        : min(_frame.totalNumberOfRows, widget.maxNumberOfVerticalEvents!);

    final multiDayEventsWidget = CustomMultiChildLayout(
      delegate: MultiDayLayout(
        dateTimeRange: widget.visibleDateTimeRange,
        layoutInfo: layoutInfo,
        numberOfRows: maxNumberOfRows,
        tileHeight: widget.tileHeight,
      ),
      children: events.map((item) {
        final event = item;
        final id = event.id;

        return LayoutId(
          id: id,
          child: MultiDayEventTile<T>(
            event: event,
            eventsController: widget.eventsController,
            controller: widget.controller,
            callbacks: widget.callbacks,
            tileComponents: widget.tileComponents,
            interaction: widget.interaction,
            dateTimeRange: widget.visibleDateTimeRange,
          ),
        );
      }).toList(),
    );

    final dropTargetWidget = ValueListenableBuilder(
      valueListenable: widget.controller.selectedEvent,
      builder: (context, event, child) {
        if (event == null) return const SizedBox();
        if (!widget.showAllEvents && !event.isMultiDayEvent) return const SizedBox();
        if (!event.dateTimeRangeAsUtc.overlaps(widget.visibleDateTimeRange)) return const SizedBox();
        final frame = widget.generateFrame(dateTimeRange: widget.visibleDateTimeRange, events: [event]);

        return CustomMultiChildLayout(
          delegate: MultiDayLayout(
            dateTimeRange: widget.visibleDateTimeRange,
            layoutInfo: frame.layoutInfo,
            numberOfRows: frame.totalNumberOfRows,
            tileHeight: widget.tileHeight,
          ),
          children: [
            LayoutId(
              id: event.id,
              child: event.id == -1 || event.id == widget.controller.selectedEventId
                  ? widget.tileComponents.dropTargetTile?.call(event) ?? const SizedBox()
                  : const SizedBox(),
            ),
          ],
        );
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            multiDayEventsWidget,
            PassThroughPointer(child: dropTargetWidget),
          ],
        ),
        if (_frame.totalNumberOfRows >= maxNumberOfRows)
          Row(
            children: _frame.dateToNumberOfRows.entries.map((entry) {
              final rows = entry.value;
              return Expanded(
                child: rows >= maxNumberOfRows
                    // TODO: make this a custom widget.
                    // This widget will be passed some information like position date and events
                    // I don't think it is worth the hassle to implement a overlay within the package.
                    // for now this will have to be done by developers.
                    ? Container(
                        color: Colors.red.withAlpha(100),
                        width: widget.dayWidth,
                        child: const Text('...'),
                      )
                    : SizedBox(width: widget.dayWidth),
              );
            }).toList(),
          ),
      ],
    );
  }
}

/// Frame containing all the data to layout the events with [MultiDayLayout].
@immutable
class MultiDayLayoutFrame<T> {
  /// The range of dates that the events are laid out on.
  final DateTimeRange dateTimeRange;

  /// The sorted events that will be used to generate [MultiDayEventTile].
  final List<CalendarEvent<T>> events;

  /// The layout info for each event.
  final List<EventLayoutInfo> layoutInfo;

  /// The number of rows needed to layout all the events.
  final int totalNumberOfRows;

  /// A map that contains the number of rows for each date.
  final Map<DateTime, int> dateToNumberOfRows;

  const MultiDayLayoutFrame({
    required this.dateTimeRange,
    required this.layoutInfo,
    required this.events,
    required this.totalNumberOfRows,
    required this.dateToNumberOfRows,
  });

  (List<CalendarEvent<T>> events, List<EventLayoutInfo> layoutInfo) visibleEvents(int? maxNumberOfRows) {
    // If there is no max number of rows we return all the events.
    if (maxNumberOfRows == null) return (this.events, layoutInfo);

    // If the number of rows is less than the max number of rows we return all the events.
    if (totalNumberOfRows <= maxNumberOfRows) return (this.events, layoutInfo);

    // If the number of rows is greater than the max number of rows we only return the events that
    // should be fitted in the max number of rows.
    final info = layoutInfo.where((e) => e.row < maxNumberOfRows).toList();
    final events = info.map((e) {
      return this.events.firstWhere((event) => event.id == e.id);
    }).toList();

    return (events, info);
  }
}

/// Contains all the data needed to layout a single event.
@immutable
class EventLayoutInfo {
  /// The id of the event.
  final int id;

  /// The row that the event should be laid out on.
  final int row;

  /// The range of dates that the event is laid out on.
  final DateTimeRange range;

  const EventLayoutInfo({
    required this.id,
    required this.row,
    required this.range,
  });

  /// Creates a copy of the [EventLayoutInfo] with the provided values.
  EventLayoutInfo copyWith({
    int? row,
    DateTimeRange? range,
  }) {
    return EventLayoutInfo(
      id: id,
      row: row ?? this.row,
      range: range ?? this.range,
    );
  }

  @override
  String toString() {
    return 'EventLayoutInfo(id: $id, row: $row, start: ${range.start}, end: ${range.end})';
  }
}

class MultiDayLayout extends MultiChildLayoutDelegate {
  MultiDayLayout({
    required this.dateTimeRange,
    required this.layoutInfo,
    required this.numberOfRows,
    required this.tileHeight,
  });

  /// The date range that the events are laid out on.
  final DateTimeRange dateTimeRange;

  /// The layout info for each event.
  final List<EventLayoutInfo> layoutInfo;

  /// The number of rows needed to layout all the events.
  final int numberOfRows;

  /// The height of each tile.
  final double tileHeight;

  @override
  Size getSize(BoxConstraints constraints) {
    super.getSize(constraints);
    return Size(constraints.maxWidth, numberOfRows * tileHeight);
  }

  @override
  void performLayout(Size size) {
    final numberOfChildren = layoutInfo.length;
    final visibleDates = dateTimeRange.dates();
    final dayWidth = size.width / visibleDates.length;

    for (var i = 0; i < numberOfChildren; i++) {
      final info = layoutInfo[i];
      var startIndex = visibleDates.indexOf(info.range.start);
      if (startIndex == -1) startIndex = 0;
      var endIndex = visibleDates.indexOf(info.range.end);
      if (endIndex == -1) endIndex = visibleDates.length;

      final dx = startIndex * dayWidth;
      final dy = info.row * tileHeight;
      final width = (endIndex - startIndex) * dayWidth;

      layoutChild(info.id, BoxConstraints.tightFor(width: width, height: tileHeight));
      positionChild(info.id, Offset(dx, dy));
    }
  }

  @override
  bool shouldRelayout(covariant MultiDayLayout oldDelegate) {
    return oldDelegate.dateTimeRange != dateTimeRange ||
        oldDelegate.layoutInfo != layoutInfo ||
        oldDelegate.numberOfRows != numberOfRows ||
        oldDelegate.tileHeight != tileHeight;
  }
}
