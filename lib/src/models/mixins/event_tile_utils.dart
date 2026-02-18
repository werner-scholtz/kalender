import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// A mixin that provides useful utilities for day-based event tiles.
///
/// This mixin is intended to be used with widgets that are descendants of a [CalendarView]
/// specifically for widgets built by [TileComponents.tileBuilder] in a day-based view.
///
/// Example usage:
/// ```dart
/// class DayEventTileExample extends StatelessWidget with DayEventTileUtils {
///   @override
///   final CalendarEvent event;
///
///   @override
///   final DateTimeRange tileRange;
///
///   const DayEventTileExample({
///     super.key,
///     required this.event,
///     required this.tileRange,
///   });
///
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onTapUp: (details) {
///         final dateTime = getDateTimeFromPosition(context, details.localPosition);
///         print('Tapped on: $dateTime');
///         final nearbyEvents = getNearbyEvents(
///           context,
///           includeMultiDayEvents: true,
///           before: const Duration(minutes: 15),
///           after: const Duration(minutes: 15),
///         );
///         print('Nearby events: $nearbyEvents');
///       },
///       child: Container(color: Colors.red),
///     );
///   }
/// }
/// ```
// ignore: library_private_types_in_public_api
mixin DayEventTileUtils {
  /// The [CalendarEvent] that the tile is representing.
  ///
  /// This is provided by a [TileComponents.tileBuilder] and represents
  /// the event data that this tile is displaying.
  CalendarEvent get event;

  /// The [DateTimeRange] that the tile is being displayed within.
  ///
  /// This represents the time span that the tile is displayed on,
  /// as provided by the [TileComponents.tileBuilder]. For day views, this is
  /// typically a single day's range.
  InternalDateTimeRange get tileRange;

  /// Get the [DateTimeRange] of the event clipped to the current display date.
  ///
  /// This returns the portion of the event that falls within the current
  /// tile's date, which is useful for events that span multiple days but
  /// you only want the portion visible on the current day.
  ///
  /// Returns the event's time range intersected with the tile's date.
  DateTimeRange get eventRangeOnDate {
    // TODO: Get the location somehow.
    return event.internalRange().dateTimeRangeOnDate(tileRange.start.startOfDay)!;
  }

  /// Fetches a list of [CalendarEvent]s that are chronologically close to the current [event].
  ///
  /// This is useful for finding events that are displayed near the current event.
  ///
  /// [context] The [BuildContext] of the widget (required for accessing the events controller)
  /// [before] Duration to look for events before the current event's start time.
  /// [after] Duration to look for events after the current event's end time.
  /// [includeMultiDayEvents] Whether to include events that span multiple days.
  /// [includeSelf] Whether to include the current event in the results.
  ///
  /// Example usage:
  /// ```dart
  /// // Find events within 30 minutes before and after
  /// final nearbyEvents = getNearbyEvents(
  ///   context,
  ///   before: Duration(minutes: 30),
  ///   after: Duration(minutes: 30),
  /// );
  /// ```
  List<CalendarEvent> nearbyEvents(
    BuildContext context, {
    Duration before = Duration.zero,
    Duration after = Duration.zero,
    bool includeMultiDayEvents = false,
    bool includeSelf = false,
  }) {
    final eventsController = context.eventsController();
    final eventRangeOnDate =
        event.internalRange(location: context.location).dateTimeRangeOnDate(tileRange.start.startOfDay)!;
    final range = InternalDateTimeRange(
      start: eventRangeOnDate.start.subtract(before),
      end: eventRangeOnDate.end.add(after),
    );
    final events = eventsController
        .eventsFromDateTimeRange(range, includeMultiDayEvents: includeMultiDayEvents, location: context.location)
        .toList();
    if (!includeSelf) events.removeWhere((e) => e.id == event.id);
    return events;
  }

  /// Converts a local tap position within the tile into a specific [DateTime].
  ///
  /// This is particularly useful for determining the exact time of a tap or gesture
  /// on the event tile.
  ///
  ///
  /// [context] The [BuildContext] of the widget (required for accessing height calculations)
  /// [localPosition] The offset from the top-left corner of the tile.
  ///
  /// Example usage:
  /// ```dart
  /// GestureDetector(
  ///   onTapUp: (details) {
  ///     final tappedTime = getDateTimeFromPosition(context, details.localPosition);
  ///     // tappedTime now contains the specific time that was tapped
  ///   },
  ///   child: eventTile,
  /// )
  /// ```
  DateTime dateTimeFromPosition(BuildContext context, Offset localPosition) {
    final minutes = (localPosition.dy / context.heightPerMinute).round();
    final dateTime = eventRangeOnDate.start.add(Duration(minutes: minutes));
    return dateTime.asLocal;
  }
}

/// A mixin that provides useful utilities for multi-day event tiles.
///
/// This mixin is intended to be used with widgets that represent events spanning
/// multiple days, typically in month views or multi-day header calendar layouts.
///
/// Example usage:
/// ```dart
/// class MultiDayEventTileExample extends StatelessWidget with MultiDayEventTileUtils {
///   @override
///   final CalendarEvent event;
///
///   @override
///   final DateTimeRange tileRange;
///
///   const MultiDayEventTileExample({
///     super.key,
///     required this.event,
///     required this.tileRange,
///   });
///
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onTapUp: (details) {
///         final dateTime = dateFromPosition(context, details.localPosition);
///         print('Tapped on: $dateTime');
///         final events = nearbyEvents(
///           context,
///           includeMultiDayEvents: true,
///           before: const Duration(minutes: 15),
///           after: const Duration(minutes: 15),
///         );
///         print('Nearby events: $events');
///       },
///       child: Container(color: Colors.red),
///     );
///   }
/// }
/// ```
// ignore: library_private_types_in_public_api
mixin MultiDayEventTileUtils {
  /// The [CalendarEvent] that the tile is representing.
  ///
  /// This event may span multiple days and is provided by [TileComponents.tileBuilder].
  CalendarEvent get event;

  /// The [DateTimeRange] that the tile is being displayed within.
  ///
  /// For multi-day events, this typically represents the visible portion
  /// of the event within the current view (e.g., a week or month).
  DateTimeRange get tileRange;

  /// Fetches a list of [CalendarEvent]s that are chronologically close to the current [event].
  ///
  /// This method is optimized for multi-day events and can search across
  /// both single-day and multi-day events.
  ///
  ///[context] The [BuildContext] of the widget
  ///[before] Duration to look for events before the current event (default: Duration.zero)
  ///[after] Duration to look for events after the current event (default: Duration.zero)
  ///[includeMultiDayEvents] Whether to include other multi-day events (default: true)
  ///[includeDayEvents] Whether to include single-day events (default: true)
  ///[includeSelf] Whether to include the current event in results (default: false)
  List<CalendarEvent> nearbyEvents(
    BuildContext context, {
    Duration before = Duration.zero,
    Duration after = Duration.zero,
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
    bool includeSelf = false,
  }) {
    final eventsController = context.eventsController();
    final range = event.internalRange(location: context.location);
    final events = eventsController
        .eventsFromDateTimeRange(
          range,
          includeMultiDayEvents: includeMultiDayEvents,
          includeDayEvents: includeDayEvents,
          location: context.location,
        )
        .toList();
    if (!includeSelf) events.removeWhere((e) => e.id == event.id);
    return events;
  }

  /// Converts a horizontal position within the tile into a specific date.
  ///
  /// This is useful for multi-day event tiles where you want to determine
  /// which specific date was tapped when the event spans multiple days.
  ///
  /// [context] The [BuildContext] of the widget
  /// [localPosition] The offset from the top-left corner of the tile
  ///
  /// Example usage:
  /// ```dart
  /// GestureDetector(
  ///   onTapUp: (details) {
  ///     final date = getDateFromPosition(context, details.localPosition);
  ///     print('Tapped on: ${date.toString()}');
  ///   },
  ///   child: multiDayEventTile,
  /// )
  /// ```
  DateTime dateFromPosition(BuildContext context, Offset localPosition) {
    // TODO: ensure this works as expected.
    final renderBox = context.findRenderObject() as RenderBox;
    final tileRangeAsUtc = tileRange.asUtc;
    final start = event.internalStart(location: context.location);
    final end = event.internalEnd(location: context.location);
    final range = InternalDateTimeRange(
      start: start.isBefore(tileRangeAsUtc.start) ? tileRangeAsUtc.start : start,
      end: end.isAfter(tileRangeAsUtc.end) ? tileRangeAsUtc.end : end,
    );
    final numberOfDays = range.dates().length;
    final dateClicked = localPosition.dx ~/ (renderBox.size.width / numberOfDays);
    final date = InternalDateTime.fromDateTime(range.start.copyWith(day: range.start.day + dateClicked))
        .startOfDay
        .forLocation(location: context.location);
    return date;
  }
}
