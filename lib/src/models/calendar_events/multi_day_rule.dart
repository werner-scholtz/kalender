import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';

/// The rule a calendar uses when nothing overrides it: 24 hours or longer.
const defaultMultiDayRule = MultiDayRule.minimumDuration(Duration(hours: 24));

/// Decides whether an event belongs in the multi-day header lane rather than
/// the day timeline.
///
/// Set it once on the view configuration:
///
/// ```dart
/// MultiDayViewConfiguration.week(
///   multiDayRule: const MultiDayRule.calendarDays(),
/// )
/// ```
///
/// A single event can disagree with the rest through
/// [CalendarEvent.multiDayRule]. For a rule none of these express, override
/// [CalendarEvent.spansMultipleDays] rather than implementing this class.
///
/// This is a class rather than a function so that it has value equality. View
/// configurations are compared with `==` to decide whether the calendar needs
/// to rebuild, and a function field would defeat that.
abstract class MultiDayRule {
  const MultiDayRule();

  /// Multi-day when the event lasts at least [minimum]. The default, at 24 hours.
  ///
  /// Measures elapsed time rather than wall-clock time, and so ignores the
  /// location it is given. An event that reads as 24 hours on the clock is 23
  /// or 25 hours of elapsed time across a daylight saving change, and qualifies
  /// or not accordingly. Use [MultiDayRule.calendarDays] when the day
  /// boundaries are what matter.
  const factory MultiDayRule.minimumDuration(Duration minimum) = _MinimumDurationRule;

  /// Multi-day when the event covers part of more than one calendar day.
  ///
  /// Unlike [MultiDayRule.minimumDuration] this depends on where the day
  /// boundaries fall, so a short event crossing midnight counts.
  const factory MultiDayRule.calendarDays() = _CalendarDaysRule;

  /// Whether [event] is multi-day, with calendar days measured in [location].
  bool isMultiDay(CalendarEvent event, {required Location? location});
}

class _MinimumDurationRule extends MultiDayRule {
  const _MinimumDurationRule(this.minimum);

  final Duration minimum;

  @override
  bool isMultiDay(CalendarEvent event, {required Location? location}) => event.duration >= minimum;

  @override
  bool operator ==(Object other) => other is _MinimumDurationRule && other.minimum == minimum;

  @override
  int get hashCode => minimum.hashCode;
}

class _CalendarDaysRule extends MultiDayRule {
  const _CalendarDaysRule();

  @override
  bool isMultiDay(CalendarEvent event, {required Location? location}) {
    final range = event.internalRange(location: location);
    if (range.dates().length > 1) return true;

    // `dates()` is half-open, so a full day (00:00 to the next 00:00) counts as
    // one day above. Keep it multi-day so all-day events stay in the header.
    final start = range.start;
    final end = range.end;
    return start == start.startOfDay && end == end.startOfDay && end.isAfter(start);
  }

  @override
  bool operator ==(Object other) => other is _CalendarDaysRule;

  @override
  int get hashCode => (_CalendarDaysRule).hashCode;
}
