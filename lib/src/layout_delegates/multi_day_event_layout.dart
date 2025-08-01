import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_event_tile.dart';

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
typedef GenerateMultiDayLayoutFrame<T extends Object?> = MultiDayLayoutFrame<T> Function({
  required DateTimeRange visibleDateTimeRange,
  required List<CalendarEvent<T>> events,
  required TextDirection textDirection,
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
MultiDayLayoutFrame<T> defaultMultiDayFrameGenerator<T extends Object?>({
  required DateTimeRange visibleDateTimeRange,
  required List<CalendarEvent<T>> events,
  required TextDirection textDirection,
  int Function(CalendarEvent<T>, CalendarEvent<T>)? eventComparator,
}) {
  // A list of dates that are visible in the current date range.
  final dates = visibleDateTimeRange.dates();
  // Take the text direction into account to determine the order of the dates.
  final visibleDates = textDirection == TextDirection.ltr ? dates : dates.reversed.toList();

  // Sort the events.
  final sortedEvents = events.toList()
    ..sort(
      eventComparator ??
          (a, b) {
            // Sort by duration (descending)
            final comparison = b.duration.compareTo(a.duration);
            if (comparison != 0) return comparison;

            final aStart = a.dateTimeRangeAsUtc.start;
            final bRange = b.dateTimeRangeAsUtc;
            final bStart = bRange.end == bRange.end.startOfDay ? bRange.end.startOfDay : bRange.end.endOfDay;

            // Sort by start time (ascending) if durations are equal
            return aStart.compareTo(bStart);
          },
    );

  // A list containing the layout information for each event.
  final layoutInfo = <EventLayoutInformation>[];
  final rowInfo = <int, List<EventLayoutInformation>>{};

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
    // Take the text direction into account so that the columns are in the correct order.
    final dates = textDirection == TextDirection.ltr ? range.dates() : range.dates().reversed.toList();
    for (final date in dates) {
      final index = visibleDates.indexOf(date);

      // If the date is not in the visible dates, we skip it.
      if (index == -1) continue;

      // Add the index to the columns list.
      columns.add(index);
    }

    // Create a preliminary layout information for the event.
    final preliminaryLayout = EventLayoutInformation.preliminary(id: event.id, columns: columns);

    // From all the existing layout info, find overlaps and determine the first available row.

    // List to store events that overlap with the current event.
    final overlaps = <EventLayoutInformation>[];
    // Tracks the highest row index occupied by overlapping events.
    var highestRow = 0;
    // Tracks the highest row index selected during overlap checks.
    var selectedRow = 0;
    // Stores the first row index that does not overlap with any other event.
    int? firstAvailableRow;

    // Iterate through all rows from 0 to maxRow to find overlaps and available rows.
    for (var row = 0; row <= maxRow; row++) {
      // Flag to indicate if the current row has any overlaps.
      var hasOverlap = false;

      // Get the layout information for the current row.
      final layoutInformationForRow = rowInfo[row] ?? <EventLayoutInformation>[];

      // Check each existing layout information in the row for overlaps with the current event.
      for (final info in layoutInformationForRow) {
        if (preliminaryLayout.overlaps(info)) {
          // Add the overlapping event to the overlaps list.
          overlaps.add(info);
          // Update the highest row index if the current event's row is greater.
          if (info.row > highestRow) highestRow = info.row;

          // Update the selected row index if the current event's row is greater.
          if (info.row > selectedRow) selectedRow = info.row;

          // If the current event overlaps with the current row, mark it as having an overlap.
          if (info.row == row) hasOverlap = true;
        }
      }

      // If no overlap is found for the current row and no available row has been set yet,
      // assign the current row as the first available row and break the loop.
      if (!hasOverlap) {
        firstAvailableRow = row;
        break;
      }
    }

    // If no row with space is found, use the next open row.
    final rowToUse = firstAvailableRow ?? highestRow + 1;

    // Create the final layout information for the event.
    final layout = preliminaryLayout.copyWith(row: rowToUse);

    // Update the max row.
    maxRow = max(maxRow, layout.row);

    // Update the map with the number of rows for each column.
    for (final column in columns) {
      columnRowMap[column] = max(columnRowMap[column] ?? 0, layout.row);
    }

    layoutInfo.add(layout);
    rowInfo.update(rowToUse, (value) => [...value, layout], ifAbsent: () => [layout]);
  }

  return MultiDayLayoutFrame(
    dateTimeRange: visibleDateTimeRange,
    layoutInfo: layoutInfo,
    events: events,
    totalNumberOfRows: maxRow + 1,
    columnRowMap: columnRowMap,
  );
}

/// Frame containing all the data to layout the [CalendarEvent]s with [MultiDayLayout].
@immutable
class MultiDayLayoutFrame<T> {
  /// The range of dates that this frame is for.
  ///
  /// ex. 1 Week (7 days).
  final DateTimeRange dateTimeRange;

  /// The sorted events for this frame that will be used to generate [MultiDayEventTile]s.
  final List<CalendarEvent<T>> events;

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

  /// Returns the events that should be displayed in the given column.
  List<CalendarEvent<T>> eventsForColumn(int column) {
    return layoutInfo.where((info) => info.columns.contains(column)).map((info) {
      return events.firstWhere((event) => event.id == info.id);
    }).toList();
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
