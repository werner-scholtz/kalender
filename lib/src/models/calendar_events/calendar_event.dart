import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart' show EventInteraction;
import 'package:kalender/kalender_extensions.dart';

/// A class representing a object that can be displayed by the calendar.
///
/// TODO: Add example of how to extend this class.
class CalendarEvent {
  /// The start [DateTime] of the [CalendarEvent].
  final DateTime start;

  /// The end [DateTime] of the [CalendarEvent].
  final DateTime end;

  /// The interaction for the [CalendarEvent].
  final EventInteraction interaction;

  /// The id of the [CalendarEvent].
  late String id;

  // TODO(werner): Convert to this constructor, makes more sense in the long run.
  /*
  CalendarEvent({
    String? id,
    required DateTime start,
    required DateTime end,
    EventInteraction? interaction,
  })  : assert(start.isBefore(end), 'Start time must be before the end time.')
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

  /// The [InternalDateTime] representing the start of the [CalendarEvent].
  InternalDateTime internalStart({Location? location}) => InternalDateTime.fromExternal(start, location: location);

  /// The [InternalDateTime] representing the end of the [CalendarEvent].
  InternalDateTime internalEnd({Location? location}) => InternalDateTime.fromExternal(end, location: location);

  /// The [InternalDateTimeRange] of the [CalendarEvent].
  InternalDateTimeRange internalRange({Location? location}) =>
      InternalDateTimeRange(start: internalStart(location: location), end: internalEnd(location: location));

  /// The total duration of the [CalendarEvent] this uses utc time for the calculation.
  Duration get duration => dateTimeRange.duration;

  /// Whether the [CalendarEvent] is longer than a day.
  bool get isMultiDayEvent => duration.inDays > 0;

  /// The [InternalDateTime]s that the [CalendarEvent] spans.
  List<InternalDateTime> datesSpanned({Location? location}) => internalRange(location: location).dates();

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
  bool operator ==(Object other) => other is CalendarEvent && layoutEquals(other);

  @override
  int get hashCode => Object.hash(id, start, end, interaction);

  /// Compares properties that affect layout.
  ///
  /// Override this in subclasses if you have additional properties that affect
  /// how the event is rendered/positioned in the calendar.
  bool layoutEquals(CalendarEvent other) {
    return id == other.id && start == other.start && end == other.end && interaction == other.interaction;
  }
}
