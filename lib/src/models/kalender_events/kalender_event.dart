import 'dart:math';

import 'package:kalender/kalender.dart' show EventInteraction;
import 'package:kalender/src/models/kalender_events/multi_day_rule.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:meta/meta.dart';

/// Base class for events displayed in the calendar.
///
/// Stores a UTC date range, a unique [id], and an [interaction] config.
/// Extend this class to attach custom data (title, color, etc.).
///
/// ```dart
/// class Event extends KalenderEvent {
///   Event({
///     super.id,
///     required super.start,
///     required super.end,
///     required this.title,
///     super.interaction,
///     super.multiDayRule,
///   });
///   final String title;
///
///   @override
///   Event copyWithData({required DateTime start, required DateTime end}) {
///     return Event(start: start, end: end, title: title);
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
/// [copyWithData] rebuilds only what the subclass adds. [id], [interaction],
/// [multiDayRule] and [isAllDay] are reapplied by [carryOver] afterwards, so a
/// field added to this class later reaches every subclass without any of them
/// changing.
class KalenderEvent {
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
  /// an event that should be classified differently from the rest. For an event
  /// that is all-day by nature rather than by duration, set [isAllDay] instead.
  MultiDayRule? get multiDayRule => _multiDayRule;
  MultiDayRule? _multiDayRule;

  /// Whether this event occupies whole days rather than a span of time.
  ///
  /// True places the event in the multi-day header lane whatever its duration,
  /// and no [MultiDayRule] is consulted. False, the default, leaves the
  /// decision to [multiDayRule] or to the calendar's rule, so an event spanning
  /// several days still reaches the header without this being set.
  ///
  /// The date range is untouched. An all-day event keeps whatever start and end
  /// it was given, so an app that wants midnight to midnight supplies it.
  bool get isAllDay => _isAllDay;
  bool _isAllDay;

  /// Creates a [KalenderEvent].
  ///
  /// [start] and [end] are stored in UTC. A unique [id] is generated if omitted.
  /// [interaction] defaults to fully modifiable.
  KalenderEvent({
    String? id,
    required DateTime start,
    required DateTime end,
    EventInteraction? interaction,
    MultiDayRule? multiDayRule,
    bool isAllDay = false,
  })  : id = id ?? _createUniqueId(),
        start = start.toUtc(),
        end = end.toUtc(),
        _multiDayRule = multiDayRule,
        _isAllDay = isAllDay,
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

  /// The date range as a [KalenderDateTimeRange].
  KalenderDateTimeRange get dateTimeRange => KalenderDateTimeRange(start: start, end: end);

  /// The start as an [InternalDateTime], adjusted for [location].
  InternalDateTime internalStart({Location? location}) => InternalDateTime.fromExternal(start, location: location);

  /// The end as an [InternalDateTime], adjusted for [location].
  InternalDateTime internalEnd({Location? location}) => InternalDateTime.fromExternal(end, location: location);

  /// The full range as an [InternalDateTimeRange], adjusted for [location].
  InternalDateTimeRange internalRange({Location? location}) =>
      InternalDateTimeRange(start: internalStart(location: location), end: internalEnd(location: location));

  /// Total duration (UTC-based).
  Duration get duration => end.difference(start);

  /// Whether this event belongs in the multi-day header lane rather than the
  /// day timeline, with calendar days measured in [location].
  ///
  /// True whenever [isAllDay] is set. Otherwise applies [multiDayRule] when set,
  /// and [defaultRule] when not, which the calendar supplies from
  /// [ViewConfiguration.multiDayRule].
  ///
  /// Override for a rule no [MultiDayRule] expresses. An override decides on its
  /// own, so honour [isAllDay] or call `super` for it.
  bool spansMultipleDays({required Location? location, required MultiDayRule defaultRule}) {
    if (isAllDay) return true;
    return (multiDayRule ?? defaultRule).isMultiDay(this, location: location);
  }

  /// All dates this event spans, adjusted for [location].
  List<InternalDateTime> datesSpanned({Location? location}) => internalRange(location: location).dates();

  /// A copy of this event covering [dateTimeRange].
  ///
  /// The calendar calls this on every drag and resize. Override [copyWithData]
  /// rather than this: this calls it and then restores the state
  /// [KalenderEvent] holds, so a copy keeps its identity, its interaction
  /// config and its rule whatever the subclass returns.
  @nonVirtual
  KalenderEvent withDateTimeRange(KalenderDateTimeRange dateTimeRange) {
    final copy = copyWithData(start: dateTimeRange.start, end: dateTimeRange.end);

    assert(
      copy.runtimeType == runtimeType,
      '$runtimeType.copyWithData returned a ${copy.runtimeType}. Override copyWithData to return your own '
      'type, otherwise every drag and resize replaces the event with a plain KalenderEvent and the data '
      'your subclass adds is lost.',
    );

    return carryOver(copy);
  }

  /// Rebuilds this event covering [start] to [end], keeping the data this
  /// subclass adds.
  ///
  /// Override this and return a new instance of your own type. Do not forward
  /// [id], [interaction], [multiDayRule] or [isAllDay]: [withDateTimeRange]
  /// restores them through [carryOver] once this returns, which is what keeps a
  /// field added to [KalenderEvent] later from silently going missing.
  @protected
  @mustBeOverridden
  KalenderEvent copyWithData({required DateTime start, required DateTime end}) {
    return KalenderEvent(start: start, end: end);
  }

  /// Reapplies the state [KalenderEvent] holds to [copy], and returns it.
  ///
  /// [withDateTimeRange] calls this on whatever [copyWithData] returned. Call it
  /// from a `copyWith` of your own so that copy keeps its identity too:
  ///
  /// ```dart
  /// Event copyWith({String? title}) {
  ///   return carryOver(Event(start: start, end: end, title: title ?? this.title));
  /// }
  /// ```
  @protected
  T carryOver<T extends KalenderEvent>(T copy) {
    copy.id = id;
    copy._interaction = _interaction;
    copy._multiDayRule = _multiDayRule;
    copy._isAllDay = _isAllDay;
    return copy;
  }

  @override
  String toString() {
    return 'KalenderEvent ($id):'
        '\nstart:  $start'
        '\nend: $end';
  }

  /// Check equality based on [layoutEquals].
  @override
  bool operator ==(Object other) => other is KalenderEvent && layoutEquals(other);

  @override
  int get hashCode => Object.hash(id, start, end, interaction, multiDayRule, isAllDay);

  /// Compares layout-affecting properties ([id], [start], [end], [interaction],
  /// [multiDayRule], [isAllDay]).
  ///
  /// The last two count because they decide whether the event renders in the
  /// header or the day timeline.
  ///
  /// Override in subclasses that add properties affecting rendering.
  bool layoutEquals(KalenderEvent other) {
    return id == other.id &&
        start == other.start &&
        end == other.end &&
        interaction == other.interaction &&
        multiDayRule == other.multiDayRule &&
        isAllDay == other.isAllDay;
  }
}
