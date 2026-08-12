import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart' show EventInteraction;
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/multi_day_rule.dart';
import 'package:meta/meta.dart';

/// Base class for events displayed in the calendar.
///
/// Stores a UTC date range, a unique [id], and an [interaction] config.
/// Extend this class to attach custom data (title, color, etc.).
///
/// ```dart
/// class Event extends CalendarEvent {
///   Event({
///     super.id,
///     required super.dateTimeRange,
///     required this.title,
///     super.interaction,
///     super.multiDayRule,
///   });
///   final String title;
///
///   @override
///   Event copyWithData({required DateTimeRange dateTimeRange}) {
///     return Event(dateTimeRange: dateTimeRange, title: title);
///   }
///
///   @override
///   bool operator ==(Object other) =>
///       super == other && other is Event && other.title == title;
///
///   @override
///   int get hashCode => Object.hash(super.hashCode, title);
/// }
/// ```
///
/// [copyWithData] rebuilds only what the subclass adds. [id], [interaction] and
/// [multiDayRule] are reapplied by [carryOver] afterwards, so a field added to
/// this class later reaches every subclass without any of them changing.
class CalendarEvent {
  /// The start of the event in UTC.
  final DateTime start;

  /// The end of the event in UTC.
  final DateTime end;

  /// Controls whether the event can be moved, resized, etc.
  EventInteraction get interaction => _interaction;
  EventInteraction _interaction;

  /// Unique identifier. Auto-generated if not provided.
  late String id;

  /// Overrides the calendar's rule for this event alone.
  ///
  /// Null, the default, uses [ViewConfiguration.multiDayRule]. Set it only for
  /// an event that should be classified differently from the rest, such as one
  /// that is all-day by nature rather than by duration.
  MultiDayRule? get multiDayRule => _multiDayRule;
  MultiDayRule? _multiDayRule;

  /// Creates a [CalendarEvent].
  ///
  /// [dateTimeRange] is stored in UTC. A unique [id] is generated if omitted.
  /// [interaction] defaults to fully modifiable.
  CalendarEvent({
    String? id,
    required DateTimeRange dateTimeRange,
    EventInteraction? interaction,
    MultiDayRule? multiDayRule,
  })  : id = id ?? _createUniqueId(),
        start = dateTimeRange.start.toUtc(),
        end = dateTimeRange.end.toUtc(),
        _multiDayRule = multiDayRule,
        _interaction = interaction ?? EventInteraction.fromCanModify(true);

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

  /// Whether this event belongs in the multi-day header lane rather than the
  /// day timeline, with calendar days measured in [location].
  ///
  /// Applies [multiDayRule] when set, otherwise [defaultRule], which the
  /// calendar supplies from [ViewConfiguration.multiDayRule].
  ///
  /// Override for a rule no [MultiDayRule] expresses.
  bool spansMultipleDays({required Location? location, required MultiDayRule defaultRule}) {
    return (multiDayRule ?? defaultRule).isMultiDay(this, location: location);
  }

  /// All dates this event spans, adjusted for [location].
  List<InternalDateTime> datesSpanned({Location? location}) => internalRange(location: location).dates();

  /// A copy of this event covering [dateTimeRange].
  ///
  /// The calendar calls this on every drag and resize. Override [copyWithData]
  /// rather than this: this calls it and then restores the state
  /// [CalendarEvent] holds, so a copy keeps its identity, its interaction
  /// config and its rule whatever the subclass returns.
  @nonVirtual
  CalendarEvent withDateTimeRange(DateTimeRange dateTimeRange) {
    final copy = copyWithData(dateTimeRange: dateTimeRange);

    assert(
      copy.runtimeType == runtimeType,
      '$runtimeType.copyWithData returned a ${copy.runtimeType}. Override copyWithData to return your own '
      'type, otherwise every drag and resize replaces the event with a plain CalendarEvent and the data '
      'your subclass adds is lost.',
    );

    return carryOver(copy);
  }

  /// Rebuilds this event covering [dateTimeRange], keeping the data this
  /// subclass adds.
  ///
  /// Override this and return a new instance of your own type. Do not forward
  /// [id], [interaction] or [multiDayRule]: [withDateTimeRange] restores them
  /// through [carryOver] once this returns, which is what keeps a field added
  /// to [CalendarEvent] later from silently going missing.
  @protected
  @mustBeOverridden
  CalendarEvent copyWithData({required DateTimeRange dateTimeRange}) {
    return CalendarEvent(dateTimeRange: dateTimeRange);
  }

  /// Reapplies the state [CalendarEvent] holds to [copy], and returns it.
  ///
  /// [withDateTimeRange] calls this on whatever [copyWithData] returned. Call it
  /// from a `copyWith` of your own so that copy keeps its identity too:
  ///
  /// ```dart
  /// Event copyWith({String? title}) {
  ///   return carryOver(Event(dateTimeRange: dateTimeRange, title: title ?? this.title));
  /// }
  /// ```
  @protected
  T carryOver<T extends CalendarEvent>(T copy) {
    copy.id = id;
    copy._interaction = _interaction;
    copy._multiDayRule = _multiDayRule;
    return copy;
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
  int get hashCode => Object.hash(id, start, end, interaction, multiDayRule);

  /// Compares layout-affecting properties ([id], [start], [end], [interaction],
  /// [multiDayRule]).
  ///
  /// [multiDayRule] counts because it decides whether the event renders in the
  /// header or the day timeline.
  ///
  /// Override in subclasses that add properties affecting rendering.
  bool layoutEquals(CalendarEvent other) {
    return id == other.id &&
        start == other.start &&
        end == other.end &&
        interaction == other.interaction &&
        multiDayRule == other.multiDayRule;
  }
}
