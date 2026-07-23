import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';

/// Decides whether an event belongs in the multi-day header lane rather than
/// the day timeline.
///
/// Set it per event, or fix it for a whole app by passing it from a subclass:
///
/// ```dart
/// class Event extends CalendarEvent {
///   Event({required super.dateTimeRange})
///       : super(multiDayRule: const MultiDayRule.calendarDays());
/// }
/// ```
///
/// This is a class rather than a function so that it has value equality.
/// Configurations holding a rule are compared with `==` to decide whether the
/// calendar needs to rebuild, and a function field would defeat that.
abstract class MultiDayRule {
  const MultiDayRule();

  /// Multi-day when the event lasts at least [minimum].
  ///
  /// The default, with a [minimum] of 24 hours.
  const factory MultiDayRule.minimumDuration(Duration minimum) = MinimumDurationRule;

  /// Multi-day when the event covers part of more than one calendar day.
  ///
  /// Unlike [MultiDayRule.minimumDuration] this depends on where the day
  /// boundaries fall, so a short event crossing midnight counts.
  const factory MultiDayRule.calendarDays() = CalendarDaysRule;

  /// Always multi-day, whatever the times say.
  ///
  /// For events that are all-day by nature rather than by duration, such as an
  /// `.ics` event with `DTSTART;VALUE=DATE`.
  const factory MultiDayRule.always() = AlwaysMultiDayRule;

  /// Whether [event] is multi-day, with calendar days measured in [location].
  bool test(CalendarEvent event, {required Location? location});
}

/// Multi-day when the event lasts at least [minimum]. Ignores [Location],
/// since duration does not depend on where the day boundaries fall.
class MinimumDurationRule extends MultiDayRule {
  const MinimumDurationRule(this.minimum);

  /// The shortest duration that counts as multi-day.
  final Duration minimum;

  @override
  bool test(CalendarEvent event, {required Location? location}) => event.duration >= minimum;

  @override
  bool operator ==(Object other) => other is MinimumDurationRule && other.minimum == minimum;

  @override
  int get hashCode => minimum.hashCode;
}

/// Multi-day when the event covers part of more than one calendar day.
class CalendarDaysRule extends MultiDayRule {
  const CalendarDaysRule();

  @override
  bool test(CalendarEvent event, {required Location? location}) {
    final range = event.internalRange(location: location);
    if (range.dates().length > 1) return true;

    // `dates()` is half-open, so a full day (00:00 to the next 00:00) counts as
    // one day above. Keep it multi-day so all-day events stay in the header.
    final start = range.start;
    final end = range.end;
    return start == start.startOfDay && end == end.startOfDay && end.isAfter(start);
  }

  @override
  bool operator ==(Object other) => other is CalendarDaysRule;

  @override
  int get hashCode => (CalendarDaysRule).hashCode;
}

/// Always multi-day.
class AlwaysMultiDayRule extends MultiDayRule {
  const AlwaysMultiDayRule();

  @override
  bool test(CalendarEvent event, {required Location? location}) => true;

  @override
  bool operator ==(Object other) => other is AlwaysMultiDayRule;

  @override
  int get hashCode => (AlwaysMultiDayRule).hashCode;
}
