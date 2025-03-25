import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_event_tile.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';

/// A function that generates the layout frame for the events.
typedef MultiDayGenerateLayoutFrame<T extends Object?> = MultiDayLayoutFrame<T> Function({
  required DateTimeRange dateTimeRange,
  required List<CalendarEvent<T>> events,
});

MultiDayLayoutFrame<T> defaultMultiDayGenerateFrame<T extends Object?>({
  required DateTimeRange dateTimeRange,
  required List<CalendarEvent<T>> events,
}) {
  // Sort the events in descending order.
  final sortedEvents = events.toList()..sort((a, b) => b.duration.compareTo(a.duration));

  // Generate the horizontal layout info for the events.
  final horizontalInfo = sortedEvents.map(
    (event) {
      final rangeAsUtc = event.dateTimeRangeAsUtc;

      final layoutInfo = EventLayoutInfo(
        id: event.id,
        row: 0,
        range: DateTimeRange(
          start: rangeAsUtc.start,
          // If the end date is the start of the day, we use the start of the day otherwise
          // we use the end of the day so that the day is included.
          end: rangeAsUtc.end == rangeAsUtc.end.startOfDay ? rangeAsUtc.end.startOfDay : rangeAsUtc.end.endOfDay,
        ),
      );

      return layoutInfo;
    },
  );

  /// Generate the vertical layout info for the events.
  final verticalInfo = <EventLayoutInfo>[];
  var maxRow = 0;
  final map = <DateTime, int>{
    for (final date in dateTimeRange.dates()) date: 0,
  };

  for (final eventLayoutInfo in horizontalInfo) {
    final overlaps = verticalInfo.where((e) {
      return e.range.overlaps(eventLayoutInfo.range);
    }).toList();

    // Find the first row that doesn't overlap with any other event.
    final row = overlaps.isEmpty ? 0 : overlaps.last.row + 1;

    // Update the max row.
    maxRow = max(maxRow, row);

    // Update the map with the number of rows for each date.
    final days = eventLayoutInfo.range.dates().toList();
    for (final date in days) {
      map[date] = max(map[date] ?? 0, row);
    }

    final info = eventLayoutInfo.copyWith(row: row);
    verticalInfo.add(info);
  }

  return MultiDayLayoutFrame(
    dateTimeRange: dateTimeRange,
    layoutInfo: verticalInfo,
    events: sortedEvents,
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
  final ValueNotifier<CalendarInteraction> interaction;

  /// The list of events that will be laid out.
  ///
  /// * Note: not all of these events will necessarily be visible,
  ///         it depends on the height constraint.
  final List<CalendarEvent<T>> events;
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
    final children = _frame.events.map((item) {
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
    });

    final multiDayEventsWidget = CustomMultiChildLayout(
      delegate: MultiDayLayout(
        frame: _frame,
        tileHeight: widget.tileHeight,
      ),
      children: [...children],
    );

    final dropTargetWidget = ValueListenableBuilder(
      valueListenable: widget.controller.selectedEvent,
      builder: (context, event, child) {
        if (event == null) return const SizedBox();
        if (!widget.showAllEvents && !event.isMultiDayEvent) return const SizedBox();
        if (!event.dateTimeRangeAsUtc.overlaps(widget.visibleDateTimeRange)) return const SizedBox();

        final events = _frame.events.toList()
          ..removeWhere((e) => e.id == widget.controller.selectedEventId)
          ..add(event);

        final frame = widget.generateFrame(dateTimeRange: widget.visibleDateTimeRange, events: events);

        final children = frame.events.map((item) {
          final event = item;
          final id = event.id;
          return LayoutId(
            id: id,
            child: event.id == -1 || event.id == widget.controller.selectedEventId
                ? widget.tileComponents.dropTargetTile?.call(event) ?? const SizedBox()
                : const SizedBox(),
          );
        });

        return CustomMultiChildLayout(
          delegate: MultiDayLayout(
            frame: frame,
            tileHeight: widget.tileHeight,
          ),
          children: [...children],
        );
      },
    );

    // TODO: make this a parameter.
    const maxNumberOfRows = 4;

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

              if (rows >= maxNumberOfRows) {
                // TODO make a component for this.
                return Container(
                  color: Colors.red.withAlpha(100),
                  width: widget.dayWidth,
                  
                  child: const Text('...'),
                );
              } else {
                return SizedBox(width: widget.dayWidth);
              }
            }).toList(),
          )
      ],
    );
  }
}

class MultiDayLayout extends MultiChildLayoutDelegate {
  MultiDayLayout({
    required this.frame,
    required this.tileHeight,
  });

  /// The frame that contains all the data needed to layout the events.
  final MultiDayLayoutFrame<dynamic> frame;

  /// The height of each tile.
  final double tileHeight;

  @override
  Size getSize(BoxConstraints constraints) {
    super.getSize(constraints);
    return Size(constraints.maxWidth, (frame.totalNumberOfRows + 1) * tileHeight);
  }

  @override
  void performLayout(Size size) {
    final numberOfChildren = frame.layoutInfo.length;
    final visibleDates = frame.dateTimeRange.dates();
    final dayWidth = size.width / visibleDates.length;

    for (var i = 0; i < numberOfChildren; i++) {
      final info = frame.layoutInfo[i];
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
    return oldDelegate.frame != frame || oldDelegate.tileHeight != tileHeight;
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

  /// The total number of rows that are needed to layout all the events.
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
