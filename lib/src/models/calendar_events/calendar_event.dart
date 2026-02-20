import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart' show EventInteraction;
import 'package:kalender/kalender_extensions.dart';

/// Base class for events displayed in the calendar.
///
/// Stores a UTC date range, a unique [id], and an [interaction] config.
/// Extend this class to attach custom data (title, color, etc.).
///
/// ```dart
/// class Event extends CalendarEvent {
///   Event({required super.dateTimeRange, required this.title, super.interaction});
///   final String title;
///
///   @override
///   Event copyWith({DateTimeRange? dateTimeRange, EventInteraction? interaction, String? title}) =>
///       Event(
///         dateTimeRange: dateTimeRange ?? this.dateTimeRange,
///         interaction: interaction ?? this.interaction,
///         title: title ?? this.title,
///       )..id = id;
///
///   @override
///   bool operator ==(Object other) =>
///       super == other && other is Event && other.title == title;
///
///   @override
///   int get hashCode => Object.hash(super.hashCode, title);
/// }
/// ```
class CalendarEvent {
  /// The start of the event in UTC.
  final DateTime start;

  /// The end of the event in UTC.
  final DateTime end;

  /// Controls whether the event can be moved, resized, etc.
  final EventInteraction interaction;

  /// Unique identifier. Auto-generated if not provided.
  late String id;

  /// Creates a [CalendarEvent].
  ///
  /// [dateTimeRange] is stored in UTC. A unique [id] is generated if omitted.
  /// [interaction] defaults to fully modifiable.
  CalendarEvent({
    String? id,
    required DateTimeRange dateTimeRange,
    EventInteraction? interaction,
  })  : id = id ?? _createUniqueId(),
        start = dateTimeRange.start.toUtc(),
        end = dateTimeRange.end.toUtc(),
        interaction = interaction ?? EventInteraction.fromCanModify(true);

  // TODO: consider using a UUID package for more robust ID generation.
  static String _createUniqueId() {
    final rawRandom = Random();
    const alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final charCodes = List<int>.filled(10, 0);

    for (var i = 0; i < 10; i++) {
      charCodes[i] = alphabet.codeUnitAt(rawRandom.nextInt(62));
    }

    return String.fromCharCodes(charCodes);
  }

  /// The date range as a [DateTimeRange].
  DateTimeRange get dateTimeRange => DateTimeRange(start: start, end: end);

  /// The start as an [InternalDateTime], adjusted for [location].
  InternalDateTime internalStart({Location? location}) => InternalDateTime.fromExternal(start, location: location);

  /// The end as an [InternalDateTime], adjusted for [location].
  InternalDateTime internalEnd({Location? location}) => InternalDateTime.fromExternal(end, location: location);

  /// The full range as an [InternalDateTimeRange], adjusted for [location].
  InternalDateTimeRange internalRange({Location? location}) =>
      InternalDateTimeRange(start: internalStart(location: location), end: internalEnd(location: location));

  /// Total duration (UTC-based).
  Duration get duration => dateTimeRange.duration;

  /// Whether this event spans more than one day.
  bool get isMultiDayEvent => duration.inDays > 0;

  /// All dates this event spans, adjusted for [location].
  List<InternalDateTime> datesSpanned({Location? location}) => internalRange(location: location).dates();

  /// Returns a copy with the given fields replaced.
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

  /// Check equality based on [layoutEquals].
  @override
  bool operator ==(Object other) => other is CalendarEvent && layoutEquals(other);

  @override
  int get hashCode => Object.hash(id, start, end, interaction);

  /// Compares layout-affecting properties ([id], [start], [end], [interaction]).
  ///
  /// Override in subclasses that add properties affecting rendering.
  bool layoutEquals(CalendarEvent other) {
    return id == other.id && start == other.start && end == other.end && interaction == other.interaction;
  }
}
