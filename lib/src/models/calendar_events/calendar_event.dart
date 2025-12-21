import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart' show EventInteraction;
import 'package:kalender/kalender_extensions.dart';

/// A class representing a object that can be displayed by the calendar.
///
/// A calendar event requires a [DateTimeRange] this is used by the [CalendarView] to render the event.
///
/// Any calculations done with the [_dateTimeRange] should be done in utc time and then converted back to local time.
class CalendarEvent {
  /// The start [DateTime] of the [CalendarEvent].
  final DateTime start;

  /// The end [DateTime] of the [CalendarEvent].
  final DateTime end;

  /// The interaction for the [CalendarEvent].
  final EventInteraction interaction;

  /// The id of the [CalendarEvent].
  late final String id;

/*
  CalendarEvent({
    String? id,
    required DateTime start,
    required DateTime end,
    EventInteraction? interaction,
  })  : assert(!end.isBefore(start), 'The end date cannot be before the start date.'),
  id = id ?? _createUniqueId(),
        start = start.toUtc(),
        end = end.toUtc(),
        interaction = interaction ?? EventInteraction.fromCanModify(true);*/

  CalendarEvent({
    String? id,
    required DateTimeRange dateTimeRange,
    EventInteraction? interaction,
  })  : id = id ?? _createUniqueId(),
        start = dateTimeRange.start.toUtc(),
        end = dateTimeRange.end.toUtc(),
        interaction = interaction ?? EventInteraction.fromCanModify(true);

  static String _createUniqueId() {
    final rawRandom = Random();
    const alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final charCodes = List<int>.filled(10, 0);

    for (var i = 0; i < 10; i++) {
      charCodes[i] = alphabet.codeUnitAt(rawRandom.nextInt(62));
    }

    return String.fromCharCodes(charCodes);
  }

  /// The [DateTimeRange] of the [CalendarEvent].
  DateTimeRange get dateTimeRange => DateTimeRange(start: start, end: end);

  InternalDateTime internalStart({Location? location}) =>
      InternalDateTime.fromDateTime(start.forLocation(location: location));
  InternalDateTime internalEnd({Location? location}) =>
      InternalDateTime.fromDateTime(end.forLocation(location: location));
  InternalDateTimeRange internalRange({Location? location}) {
    return InternalDateTimeRange(start: internalStart(location: location), end: internalEnd(location: location));
  }

  /// The total duration of the [CalendarEvent] this uses utc time for the calculation.
  Duration get duration => dateTimeRange.duration;

  /// Whether the [CalendarEvent] is longer than a day.
  bool get isMultiDayEvent => duration.inDays > 0;

  /// The [DateTime]s that the [CalendarEvent] spans.
  List<InternalDateTime> datesSpanned({Location? location}) =>
      internalRange(location: location).dates().map((e) => InternalDateTime(e.year, e.month, e.day)).toList();

  /// Copy the [CalendarEvent] with the new values.
  CalendarEvent copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
  }) {
    return CalendarEvent(
      dateTimeRange: dateTimeRange ?? DateTimeRange(start: start, end: end),
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  String toString() {
    return 'CalendarEvent ($id):'
        '\nstart:  $start'
        '\nend: $end';
  }

  /// Check if the [CalendarEvent] is equal to another [CalendarEvent].
  @override
  bool operator ==(Object other) {
    return other is CalendarEvent &&
        other.id == id &&
        other.start == start &&
        other.end == end &&
        other.interaction == interaction;
  }

  @override
  int get hashCode => Object.hash(id, start, end, interaction);
}
