// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

export 'package:kalender/kalender_extensions.dart';

/// {@category Appearance}
mixin EventTileUtils {
  /// The [KalenderEvent] that the tile is representing.
  ///
  /// This is provided by a [TileComponents.tileBuilder] and represents
  /// the event data that this tile is displaying.
  KalenderEvent get event;

  /// The [KalenderDateTimeRange] that the tile is being displayed within.
  ///
  /// This represents the time span that the tile is displayed on,
  /// as provided by the [TileComponents.tileBuilder]. For day views, this is
  /// typically a single day's range.
  ///
  /// The values are **wall-clock** [DateTime]s (local or [TZDateTime]),
  /// not UTC. See [floatingTileRange] to obtain an [FloatingDateTimeRange].
  KalenderDateTimeRange get tileRange;

  /// Converts [tileRange] into an [FloatingDateTimeRange] using the
  /// current [LocationProvider].
  ///
  /// This is useful when mixin helpers need DST-safe arithmetic on the
  /// tile's date boundaries (e.g. [DayEventTileUtils.eventRangeOnDate]).
  FloatingDateTimeRange floatingTileRange(BuildContext context) {
    final location = context.location;
    return FloatingDateTimeRange(
      start: FloatingDateTime.fromExternal(tileRange.start, location: location),
      end: FloatingDateTime.fromExternal(tileRange.end, location: location),
    );
  }
}

/// Utilities for a tile built by [TileComponents.tileBuilder] in a day-based view.
///
/// The tile must be a descendant of a [KalenderView].
///
/// ```dart
/// class DayEventTile extends StatelessWidget with DayEventTileUtils {
///   @override
///   final KalenderEvent event;
///
///   @override
///   final KalenderDateTimeRange tileRange;
///
///   const DayEventTile({super.key, required this.event, required this.tileRange});
///
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onTapUp: (details) => print(dateTimeFromPosition(context, details.localPosition)),
///       child: Container(color: Colors.red),
///     );
///   }
/// }
/// ```
///
/// {@category Appearance}
mixin DayEventTileUtils implements EventTileUtils {
  @override
  KalenderEvent get event;

  @override
  KalenderDateTimeRange get tileRange;

  @override
  FloatingDateTimeRange floatingTileRange(BuildContext context) {
    final location = context.location;
    return FloatingDateTimeRange(
      start: FloatingDateTime.fromExternal(tileRange.start, location: location),
      end: FloatingDateTime.fromExternal(tileRange.end, location: location),
    );
  }

  /// The part of the event's range that falls on the tile's date.
  FloatingDateTimeRange eventRangeOnDate(BuildContext context) {
    final location = context.location;
    return event.floatingRange(location: location).rangeOnDate(floatingTileRange(context).start.startOfDay)!;
  }

  /// The events that overlap [eventRangeOnDate] widened by [before] at the start and [after] at the end.
  ///
  /// [includeSelf] keeps [event] in the result.
  List<KalenderEvent> nearbyEvents(
    BuildContext context, {
    Duration before = Duration.zero,
    Duration after = Duration.zero,
    bool includeMultiDayEvents = false,
    bool includeSelf = false,
  }) {
    final eventsController = context.eventsController;
    final eventRange = eventRangeOnDate(context);
    final range = FloatingDateTimeRange(start: eventRange.start.subtract(before), end: eventRange.end.add(after));
    final events = eventsController
        .eventsInRange(
          range,
          multiDayRule: context.multiDayRule,
          includeMultiDayEvents: includeMultiDayEvents,
          location: context.location,
        )
        .toList();
    if (!includeSelf) events.removeWhere((e) => e.id == event.id);
    return events;
  }

  /// The [DateTime] at [localPosition], an offset from the top-left corner of the tile, rounded to the minute.
  DateTime dateTimeFromPosition(BuildContext context, Offset localPosition) {
    final minutes = (localPosition.dy / context.heightPerMinute).round();
    final dateTime = eventRangeOnDate(context).start.add(Duration(minutes: minutes));
    return dateTime;
  }
}

/// Utilities for a tile that represents an event spanning several days, in the month view or the multi-day
/// header.
///
/// Mixed in the same way as [DayEventTileUtils].
///
/// {@category Appearance}
mixin MultiDayEventTileUtils implements EventTileUtils {
  @override
  KalenderEvent get event;

  @override
  KalenderDateTimeRange get tileRange;

  @override
  FloatingDateTimeRange floatingTileRange(BuildContext context) {
    final location = context.location;
    return FloatingDateTimeRange(
      start: FloatingDateTime.fromExternal(tileRange.start, location: location),
      end: FloatingDateTime.fromExternal(tileRange.end, location: location),
    );
  }

  /// The events that overlap the event's range widened by [before] at the start and [after] at the end.
  ///
  /// [includeSelf] keeps [event] in the result.
  List<KalenderEvent> nearbyEvents(
    BuildContext context, {
    Duration before = Duration.zero,
    Duration after = Duration.zero,
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
    bool includeSelf = false,
  }) {
    final eventsController = context.eventsController;
    final range = event.floatingRange(location: context.location);
    final searcRange = FloatingDateTimeRange(start: range.start.subtract(before), end: range.end.add(after));
    final events = eventsController
        .eventsInRange(
          searcRange,
          multiDayRule: context.multiDayRule,
          includeMultiDayEvents: includeMultiDayEvents,
          includeDayEvents: includeDayEvents,
          location: context.location,
        )
        .toList();
    if (!includeSelf) events.removeWhere((e) => e.id == event.id);
    return events;
  }

  /// The start of the day at [localPosition], an offset from the top-left corner of the tile.
  ///
  /// A position outside the tile resolves to its first or last visible day.
  DateTime dateFromPosition(BuildContext context, Offset localPosition) {
    final renderBox = context.findRenderObject() as RenderBox;

    // Clip the event to the tile so the column width maps to the days actually
    // visible in this tile (events can start before / end after the tile).
    final start = event.floatingStart(location: context.location);
    final end = event.floatingEnd(location: context.location);
    final range = FloatingDateTimeRange(
      start: start.isBefore(tileRange.start) ? tileRange.start : start,
      end: end.isAfter(tileRange.end) ? tileRange.end : end,
    );

    final numberOfDays = range.dates().length;
    // Clamp so a tap on the trailing edge (dx == width) or just outside the tile
    // resolves to a day within the visible range rather than one day past it.
    final dateClicked = (localPosition.dx ~/ (renderBox.size.width / numberOfDays)).clamp(0, numberOfDays - 1);
    final date = FloatingDateTime.fromDateTime(
      range.start.copyWith(day: range.start.day + dateClicked),
    ).startOfDay.forLocation(location: context.location);
    return date;
  }
}
