import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A function type that generates a layout frame for multi-day events.
///
/// This function is responsible for calculating the layout information required
/// to position and size multi-day events within a calendar view. The layout frame
/// includes metadata such as the row and column assignments for events, the total number of rows,
/// and a mapping of columns (dates) to the number of rows.
/// * (columns and rows in this context does not refer to widgets instead it is a concept used within within the [MultiDayLayout] to position and layout events)
///
/// - [visibleDateTimeRange]: The range of dates for which the layout is being generated.
/// - [events]: A list of [CalendarEvent] objects representing the events to be laid out.
/// - [textDirection]: The text direction (LTR or RTL) for the layout.
typedef GenerateMultiDayLayoutFrame = MultiDayLayoutFrame Function({
  required InternalDateTimeRange visibleDateTimeRange,
  required List<CalendarEvent> events,
  required TextDirection textDirection,
  required Location? location,
  MultiDayLayoutFrameCache? cache,
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
///    - If an eventComparator is provided, it is used to sort the events instead.
/// 2. **Row Assignment**:
///    - Each event is assigned to the first available row that does not overlap with other events.
///    - Overlaps are determined based on the columns (dates) the event spans.
/// 3. **Row Count Calculation**:
///    - The total number of rows is updated as events are assigned to rows.
///    - A map is maintained to track the number of rows required for each date.
MultiDayLayoutFrame defaultMultiDayFrameGenerator({
  required InternalDateTimeRange visibleDateTimeRange,
  required List<CalendarEvent> events,
  required TextDirection textDirection,
  required Location? location,
  MultiDayLayoutFrameCache? cache,
  int Function(CalendarEvent, CalendarEvent)? eventComparator,
}) {
  // Check cache first if provided
  if (cache != null) {
    final cachedFrame = cache.getCache(visibleDateTimeRange);
    if (cachedFrame != null) return cachedFrame;
  }

  // A list of dates that are visible in the current date range.
  final dates = visibleDateTimeRange.dates();
  // Take the text direction into account to determine the order of the dates.
  final visibleDates = textDirection == TextDirection.ltr ? dates : dates.reversed.toList();

  // Precompute each event's internal range and sort keys once. The sort runs its
  // comparator O(N log N) times, and the old comparator recomputed timezone
  // conversions (internalStart/internalRange) on every call. That dominated the
  // cost when many events share a duration, because the tie-breaker then runs on
  // almost every comparison.
  final entries = <_FrameEntry>[];
  for (final event in events) {
    final range = event.internalRange(location: location);
    // Round the end to the end of the day unless it already sits on a day
    // boundary, so the final day of the event is included.
    final roundedEnd = range.end == range.end.startOfDay ? range.end.startOfDay : range.end.endOfDay;
    entries.add(
      _FrameEntry(
        event: event,
        start: range.start,
        roundedEnd: roundedEnd,
        durationMicroseconds: event.duration.inMicroseconds,
      ),
    );
  }

  // Sort the events.
  if (eventComparator != null) {
    entries.sort((a, b) => eventComparator(a.event, b.event));
  } else {
    entries.sort((a, b) {
      // Sort by duration (descending).
      final comparison = b.durationMicroseconds.compareTo(a.durationMicroseconds);
      if (comparison != 0) return comparison;

      // Sort by start time (ascending) if durations are equal. Compares the
      // start of a against the rounded end of b, preserving the previous order.
      return a.start.compareTo(b.roundedEnd);
    });
  }

  final sortedEvents = [for (final entry in entries) entry.event];

  // A list containing the layout information for each event.
  final layoutInfo = <EventLayoutInformation>[];

  // The columns occupied by each row, indexed by row. A column is added once an
  // event is placed on that row so later events can find the first row whose
  // columns do not clash with them. This replaces re-scanning every placed
  // event on every row (the previous O(N^2) inner loop).
  final rowColumns = <Set<int>>[];

  // The maximum number of rows needed to layout all the events.
  var maxRow = 0;

  // Maps each visible date to its column index so column lookups are O(1)
  // instead of a linear search per event per day.
  final columnForDate = <InternalDateTime, int>{
    for (var i = 0; i < visibleDates.length; i++) visibleDates[i]: i,
  };

  // A map that contains the number of rows for each of the columns.
  // Initialised to -1 (sentinel: no event assigned to this column yet) so that
  // columns without any events do not trigger spurious overflow buttons when
  // maxNumberOfRows is 0.
  final columnRowMap = <int, int>{
    for (var i = 0; i < visibleDates.length; i++) i: -1,
  };

  for (final entry in entries) {
    final event = entry.event;

    // The range with the end rounded to the end of the day (precomputed above).
    final range = InternalDateTimeRange(start: entry.start, end: entry.roundedEnd);

    // Find all the columns that the event will appear on.
    final columns = <int>[];
    // Take the text direction into account so that the columns are in the correct order.
    final dates = textDirection == TextDirection.ltr ? range.dates() : range.dates().reversed.toList();
    for (final date in dates) {
      final index = columnForDate[date];

      // If the date is not in the visible dates, we skip it.
      if (index == null) continue;

      // Add the index to the columns list.
      columns.add(index);
    }

    // An event with no visible columns cannot be laid out.
    if (columns.isEmpty) continue;

    // The event spans a contiguous range of columns, so overlap only depends on
    // its first and last column.
    final start = columns.first < columns.last ? columns.first : columns.last;
    final end = columns.first < columns.last ? columns.last : columns.first;

    // Find the first row whose occupied columns do not clash with this event.
    var rowToUse = -1;
    for (var row = 0; row < rowColumns.length; row++) {
      final occupied = rowColumns[row];
      var fits = true;
      for (var column = start; column <= end; column++) {
        if (occupied.contains(column)) {
          fits = false;
          break;
        }
      }
      if (fits) {
        rowToUse = row;
        break;
      }
    }

    // If no existing row has space, use a new row.
    if (rowToUse == -1) {
      rowToUse = rowColumns.length;
      rowColumns.add(<int>{});
    }

    // Mark this event's columns as occupied on the chosen row.
    final occupied = rowColumns[rowToUse];
    for (var column = start; column <= end; column++) {
      occupied.add(column);
    }

    // Create the final layout information for the event.
    final layout = EventLayoutInformation(id: event.id, row: rowToUse, columns: columns);

    // Update the max row.
    maxRow = max(maxRow, layout.row);

    // Update the map with the number of rows for each column.
    for (final column in columns) {
      columnRowMap[column] = max(columnRowMap[column] ?? -1, layout.row);
    }

    layoutInfo.add(layout);
  }

  final frame = MultiDayLayoutFrame(
    dateTimeRange: visibleDateTimeRange,
    layoutInfo: layoutInfo,
    events: sortedEvents,
    totalNumberOfRows: sortedEvents.isEmpty ? 0 : maxRow + 1,
    columnRowMap: columnRowMap,
  );

  // Store in cache if provided
  if (cache != null) {
    cache.setCache(visibleDateTimeRange, frame);
  }

  return frame;
}

/// An event plus the values [defaultMultiDayFrameGenerator] needs while sorting
/// and placing it. Computed once per event so the sort comparator and layout
/// loop reuse them instead of recomputing timezone conversions.
class _FrameEntry {
  _FrameEntry({
    required this.event,
    required this.start,
    required this.roundedEnd,
    required this.durationMicroseconds,
  });

  final CalendarEvent event;

  /// The event start as an [InternalDateTime].
  final InternalDateTime start;

  /// The event end rounded to the end of the day (unless it sits on a day boundary).
  final InternalDateTime roundedEnd;

  /// The event duration in microseconds, used as the primary sort key.
  final int durationMicroseconds;
}

/// A cache for [MultiDayLayoutFrame]s.
///
/// This is used to cache layout frames that are recalculated often.
class MultiDayLayoutFrameCache {
  final Map<String, MultiDayLayoutFrame> _cache = {};

  /// Generates a cache key based on the parameters.
  String _generateCacheKey(DateTimeRange visibleDateTimeRange) {
    return '${visibleDateTimeRange.start.toIso8601String()}_${visibleDateTimeRange.end.toIso8601String()}';
  }

  /// Gets the cached layout frame if it exists.
  MultiDayLayoutFrame? getCache(DateTimeRange visibleDateTimeRange) {
    final key = _generateCacheKey(visibleDateTimeRange);
    return _cache[key];
  }

  void setCache(DateTimeRange visibleDateTimeRange, MultiDayLayoutFrame frame) {
    final key = _generateCacheKey(visibleDateTimeRange);
    _cache[key] = frame;
  }

  void removeCache(DateTimeRange visibleDateTimeRange) {
    final key = _generateCacheKey(visibleDateTimeRange);
    _cache.remove(key);
  }

  /// Clears all cached data.
  void clearAll() => _cache.clear();
}

/// Frame containing all the data to layout the [CalendarEvent]s with [MultiDayLayout].
@immutable
class MultiDayLayoutFrame {
  /// The range of dates that this frame is for.
  ///
  /// ex. 1 Week (7 days).
  final InternalDateTimeRange dateTimeRange;

  /// The sorted events for this frame that will be used to generate [MultiDayEventTile]s.
  final List<CalendarEvent> events;

  /// The layout information for each event in this frame.
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
  InternalDateTime dateFromColumn(int column) =>
      InternalDateTime.fromDateTime(dateTimeRange.start.add(Duration(days: column)));

  /// Returns the visible events and their layout information based on the provided max number of rows.
  ///
  /// If [maxNumberOfRows] is null, all events are returned.
  (List<CalendarEvent> events, List<EventLayoutInformation> layoutInfo) visibleEvents(int? maxNumberOfRows) {
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

  /// Returns the events that should be displayed in the given column.
  List<CalendarEvent> eventsForColumn(int column) {
    return layoutInfo.where((info) => info.columns.contains(column)).map((info) {
      return events.firstWhere((event) => event.id == info.id);
    }).toList();
  }
}

/// Contains all the data needed to layout a single event with the [MultiDayLayout].
@immutable
class EventLayoutInformation {
  /// The id of the event.
  final String id;

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
    required String id,
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

  /// Checks if this event overlaps with another [EventLayoutInformation].
  ///
  /// Two events are considered overlapping if their column ranges intersect.
  /// This method compares the start and end columns of both events to determine
  /// if there is any overlap.
  ///
  /// ## Returns:
  /// - `true` if the events overlap; otherwise, `false`.
  bool overlaps(EventLayoutInformation other) {
    return !(end < other.start || start > other.end);
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
  final InternalDateTimeRange dateTimeRange;

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
