import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/components/multi_day_expand.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_event_tile.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';

/// A function type that generates a layout frame for multi-day events.
///
/// This function is responsible for calculating the layout information required
/// to position and size multi-day events within a calendar view. The layout frame
/// includes metadata such as the row and column assignments for events, the total number of rows,
/// and a mapping of columns (dates) to the number of rows.
///
/// ## Parameters:
/// - [visibleDateTimeRange]: The range of dates for which the layout is being generated.
/// - [events]: A list of [CalendarEvent] objects representing the events to be laid out.
typedef GenerateMultiDayLayoutFrame<T extends Object?> = MultiDayLayoutFrame<T> Function({
  required DateTimeRange visibleDateTimeRange,
  required List<CalendarEvent<T>> events,
});

/// The default implementation of [GenerateMultiDayLayoutFrame].
///
/// This function generates a layout frame for multi-day events by:
/// 1. Sorting the events by their duration (descending) and start time (ascending).
/// 2. Calculating the column (date) indices for each event based on its range.
/// 3. Assigning each event to the first available row that does not overlap with other events.
/// 4. Calculating the total number of rows each column requires.
///
/// ## Returns:
/// A [MultiDayLayoutFrame] object containing:
/// - The sorted list of events.
/// - Layout information for each event, including row and column assignments.
/// - The total number of rows required to display all events.
/// - A mapping of columns to the number of rows.
///
/// ## Algorithm:
/// 1. **Sorting**:
///    - Events are sorted by duration in descending order.
///    - If two events have the same duration, they are sorted by start time in ascending order.
/// 2. **Row Assignment**:
///    - Each event is assigned to the first available row that does not overlap with other events.
///    - Overlaps are determined based on the columns (dates) the event spans.
/// 3. **Row Count Calculation**:
///    - The total number of rows is updated as events are assigned to rows.
///    - A map is maintained to track the number of rows required for each date.
///
MultiDayLayoutFrame<T> defaultMultiDayGenerateFrame<T extends Object?>({
  required DateTimeRange visibleDateTimeRange,
  required List<CalendarEvent<T>> events,
}) {
  // A list of dates that are visible in the current date range.
  final visibleDates = visibleDateTimeRange.dates();

  // Sort the events.
  final sortedEvents = events.toList()
    ..sort((a, b) {
      // Sort by duration (descending)
      final comparison = b.duration.compareTo(a.duration);
      if (comparison != 0) return comparison;
      // Sort by start time (ascending) if durations are equal
      return a.start.compareTo(b.start);
    });

  // A list containing the layout information for each event.
  final layoutInfo = <EventLayoutInformation>[];

  // The maximum number of rows needed to layout all the events.
  var maxRow = 0;

  // A map that contains the number of rows for each of the columns.
  final columnRowMap = <int, int>{
    for (final date in visibleDates) visibleDates.indexOf(date): 0,
  };

  for (final event in sortedEvents) {
    final rangeAsUtc = event.dateTimeRangeAsUtc;

    // Create a range that rounds the start and end dates to the start and end of the day.
    final range = DateTimeRange(
      start: rangeAsUtc.start,
      // If the end date is the start of the day, we use the start of the day otherwise
      // we use the end of the day so that the day is included.
      end: rangeAsUtc.end == rangeAsUtc.end.startOfDay ? rangeAsUtc.end.startOfDay : rangeAsUtc.end.endOfDay,
    );

    // Find all the columns that the event will appear on.
    final columns = <int>[];
    for (final date in range.dates()) {
      final index = visibleDates.indexOf(date);

      // If the date is not in the visible dates, we skip it.
      if (index == -1) continue;

      // Add the index to the columns list.
      columns.add(index);
    }

    // Create a preliminary layout information for the event.
    final preliminaryLayout = EventLayoutInformation.preliminary(id: event.id, columns: columns);

    // From all the existing layout info find the ones that overlap with the current event.
    final overlaps = layoutInfo.where(preliminaryLayout.overlaps).toList();

    // Find the first row with enough space to fit the event.
    int? firstAvailableRow;
    for (var row = 0; row <= maxRow; row++) {
      final hasOverlap = overlaps.any((info) => info.row == row);
      if (!hasOverlap) {
        firstAvailableRow = row;
        break;
      }
    }

    // Find the first row that doesn't overlap with any other event.
    late final nextRow = overlaps.isEmpty ? 0 : overlaps.last.row + 1;

    // If no row with space is found, use the next open row.
    final rowToUse = firstAvailableRow ?? nextRow;

    // Create the final layout information for the event.
    final layout = preliminaryLayout.copyWith(row: rowToUse);

    // Update the max row.
    maxRow = max(maxRow, layout.row);

    // Update the map with the number of rows for each column.
    for (final column in columns) {
      columnRowMap[column] = max(columnRowMap[column] ?? 0, layout.row);
    }

    layoutInfo.add(layout);
  }

  return MultiDayLayoutFrame(
    dateTimeRange: visibleDateTimeRange,
    layoutInfo: layoutInfo,
    events: events,
    totalNumberOfRows: maxRow + 1,
    columnRowMap: columnRowMap,
  );
}

/// A widget that lays out events spanning multiple days in a calendar view.
///
/// The [MultiDayEventLayoutWidget] is responsible for arranging and displaying
/// events that occur over multiple days in a visually organized manner. It ensures
/// that overlapping or adjacent events are properly aligned and do not overlap
/// visually.
///
/// This widget is used by month views and in day view headers, for  displaying multi-day activities.
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
    required this.multiDayExpandBuilder,
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
  ///         it depends on [maxNumberOfVerticalEvents].
  final List<CalendarEvent<T>> events;

  /// The function that generates the layout frame for the events.
  final GenerateMultiDayLayoutFrame<T> generateFrame;

  /// The builder for the multi-day expand widget.
  final MultiDayExpandBuilder? multiDayExpandBuilder;

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
    _frame = widget.generateFrame(visibleDateTimeRange: _dateTimeRange, events: widget.events);
  }

  @override
  void didUpdateWidget(covariant MultiDayEventLayoutWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // TODO: add all needed checks this is a minimal implementation.
    final didUpdate = !oldWidget.events.equals(widget.events) ||
        oldWidget.visibleDateTimeRange != widget.visibleDateTimeRange ||
        oldWidget.generateFrame != widget.generateFrame;

    if (didUpdate) {
      _dateTimeRange = widget.visibleDateTimeRange;

      setState(() {
        _frame = widget.generateFrame(visibleDateTimeRange: _dateTimeRange, events: widget.events);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final (events, layoutInfo) = _frame.visibleEvents(widget.maxNumberOfVerticalEvents);

    final maxNumberOfRows = widget.maxNumberOfVerticalEvents == null
        ? _frame.totalNumberOfRows
        : min(_frame.totalNumberOfRows, widget.maxNumberOfVerticalEvents!);

    // The multi-day events widget is used to display the events that span multiple days.
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

    // The drop target widget is used to show the drop target for the event that is being dragged.
    final dropTargetWidget = ValueListenableBuilder(
      valueListenable: widget.controller.selectedEvent,
      builder: (context, event, child) {
        if (event == null) return const SizedBox();
        if (!widget.showAllEvents && !event.isMultiDayEvent) return const SizedBox();
        if (!event.dateTimeRangeAsUtc.overlaps(widget.visibleDateTimeRange)) return const SizedBox();
        final frame = widget.generateFrame(visibleDateTimeRange: widget.visibleDateTimeRange, events: [event]);

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

    late final expandWidgets = [
      const Spacer(),
      Row(
        children: _frame.columnRowMap.entries.map((entry) {
          final column = entry.key;
          final row = entry.value;

          final date = _frame.dateFromColumn(column);
          final onExpand = widget.callbacks?.onMultiDayExpand;
          final expandWidget =
              widget.multiDayExpandBuilder?.call(date, onExpand) ?? MultiDayExpand(date: date, onExpand: onExpand);

          return Expanded(
            child: row >= maxNumberOfRows ? expandWidget : SizedBox(width: widget.dayWidth),
          );
        }).toList(),
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            multiDayEventsWidget,
            PassThroughPointer(child: dropTargetWidget),
          ],
        ),
        if (_frame.totalNumberOfRows >= maxNumberOfRows) ...expandWidgets,
      ],
    );
  }
}

/// Frame containing all the data to layout the [CalendarEvent]s with [MultiDayLayout].
@immutable
class MultiDayLayoutFrame<T> {
  /// The range of dates that the events are laid out on.
  final DateTimeRange dateTimeRange;

  /// The sorted events that will be used to generate [MultiDayEventTile]s.
  final List<CalendarEvent<T>> events;

  /// The layout information for each event.
  final List<EventLayoutInformation> layoutInfo;

  /// The number of rows needed to layout all the events.
  final int totalNumberOfRows;

  /// A map that contains the number of rows for each date.
  final Map<int, int> columnRowMap;

  const MultiDayLayoutFrame({
    required this.dateTimeRange,
    required this.layoutInfo,
    required this.events,
    required this.totalNumberOfRows,
    required this.columnRowMap,
  });

  /// Returns the date for the given column index.
  DateTime dateFromColumn(int column) => dateTimeRange.start.addDays(column);

  /// Returns the visible events and their layout information based on the provided max number of rows.
  ///
  /// If [maxNumberOfRows] is null, all events are returned.
  (List<CalendarEvent<T>> events, List<EventLayoutInformation> layoutInfo) visibleEvents(int? maxNumberOfRows) {
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

/// Contains all the data needed to layout a single event with the [MultiDayLayout].
@immutable
class EventLayoutInformation {
  /// The id of the event.
  final int id;

  /// The row that the event should be laid out on.
  final int row;

  /// The columns that the event should be laid out on.
  final List<int> columns;

  /// The starting column of the event.
  int get start => columns.first;

  /// The ending column of the event.
  int get end => columns.last;

  EventLayoutInformation({
    required this.id,
    required this.row,
    required this.columns,
  }) : assert(columns.isNotEmpty, 'Columns cannot be empty');

  factory EventLayoutInformation.preliminary({
    required int id,
    required List<int> columns,
  }) {
    return EventLayoutInformation(
      id: id,
      row: 0,
      columns: columns,
    );
  }

  /// Creates a copy of the [EventLayoutInformation] with the provided values.
  EventLayoutInformation copyWith({
    int? row,
    List<int>? columns,
  }) {
    return EventLayoutInformation(
      id: id,
      row: row ?? this.row,
      columns: columns ?? this.columns,
    );
  }

  /// Checks if this overlaps with another [EventLayoutInformation].
  bool overlaps(EventLayoutInformation other) {
    // TODO: this can be improved by just comparing the start and end columns.
    return columns.any((column) => other.columns.contains(column));
  }

  @override
  String toString() {
    return 'EventLayoutInfo(id: $id, row: $row, start: $start, end: $end)';
  }
}

/// A custom layout delegate for arranging multi-day events in a calendar view.
///
/// The [MultiDayLayout] is responsible for positioning and sizing event tiles
/// within a multi-day calendar view. It calculates the layout based on the
/// provided date range, event layout information, number of rows, and tile height.
///
/// This layout ensures that events spanning multiple days are displayed correctly
/// across the corresponding date columns and rows.
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
  final List<EventLayoutInformation> layoutInfo;

  /// The number of rows needed to layout all the events.
  final int numberOfRows;

  /// The height of each tile.
  final double tileHeight;

  /// Calculates the [Size] of the layout based on the number of rows and tile height.
  ///
  /// The height is determined as [numberOfRows] * [tileHeight], and the width
  /// is constrained by the parent widget.
  @override
  Size getSize(BoxConstraints constraints) {
    super.getSize(constraints);
    return Size(constraints.maxWidth, numberOfRows * tileHeight);
  }

  /// Positions and sizes each child (event tile) based on its layout information.
  @override
  void performLayout(Size size) {
    final numberOfChildren = layoutInfo.length;
    final visibleDates = dateTimeRange.dates();
    final dayWidth = size.width / visibleDates.length;
    for (var i = 0; i < numberOfChildren; i++) {
      // Get the layout information for the current child.
      final information = layoutInfo[i];

      // Calculate the x position based on the start column and day width.
      final dx = information.start * dayWidth;

      // Calculate the y position based on the row and tile height.
      final dy = information.row * tileHeight;

      // Calculate the width of the child based on the number of columns and day width.
      final width = information.columns.length * dayWidth;

      layoutChild(information.id, BoxConstraints.tightFor(width: width, height: tileHeight));
      positionChild(information.id, Offset(dx, dy));
    }
  }

  /// Determines if the layout should be re-calculated based on changes in the
  /// [dateTimeRange], [layoutInfo], [numberOfRows], or [tileHeight].
  @override
  bool shouldRelayout(covariant MultiDayLayout oldDelegate) {
    return oldDelegate.dateTimeRange != dateTimeRange ||
        oldDelegate.layoutInfo != layoutInfo ||
        oldDelegate.numberOfRows != numberOfRows ||
        oldDelegate.tileHeight != tileHeight;
  }
}
