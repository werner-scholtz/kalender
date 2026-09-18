// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';

/// The rule a calendar uses when nothing overrides it: 24 hours or longer.
///
/// {@category Events}
const kDefaultMultiDayRule = MultiDayRule.minimumDuration(Duration(hours: 24));

/// Decides whether an event belongs in the multi-day header lane rather than the day timeline.
///
/// Set on the view configuration. [KalenderEvent.multiDayRule] overrides it for a single event, and
/// [KalenderEvent.spansMultipleDays] replaces it for a rule none of these express.
///
/// {@category Events}
abstract class MultiDayRule {
  const MultiDayRule();

  /// Multi-day when the event lasts at least [minimum]. The default, at 24 hours.
  ///
  /// Elapsed time, so a 24-hour clock span across a DST change may not qualify.
  const factory MultiDayRule.minimumDuration(Duration minimum) = _MinimumDurationRule;

  /// Multi-day when the event covers part of more than one calendar day.
  ///
  /// Unlike [MultiDayRule.minimumDuration] this depends on where the day
  /// boundaries fall, so a short event crossing midnight counts.
  const factory MultiDayRule.calendarDays() = _CalendarDaysRule;

  /// Whether [event] is multi-day, with calendar days measured in [location].
  bool isMultiDay(KalenderEvent event, {required Location? location});
}

class _MinimumDurationRule extends MultiDayRule {
  const _MinimumDurationRule(this.minimum);

  final Duration minimum;

  @override
  bool isMultiDay(KalenderEvent event, {required Location? location}) => event.duration >= minimum;

  @override
  bool operator ==(Object other) => other is _MinimumDurationRule && other.minimum == minimum;

  @override
  int get hashCode => minimum.hashCode;
}

class _CalendarDaysRule extends MultiDayRule {
  const _CalendarDaysRule();

  @override
  bool isMultiDay(KalenderEvent event, {required Location? location}) {
    final range = event.floatingRange(location: location);
    if (range.dates().length > 1) return true;

    // `dates()` is half-open, so a full day (00:00 to the next 00:00) counts as
    // one day above. Keep it multi-day so all-day events stay in the header.
    final start = range.start;
    final end = range.end;
    return start.isStartOfDay && end.isStartOfDay && end.isAfter(start);
  }

  @override
  bool operator ==(Object other) => other is _CalendarDaysRule;

  @override
  int get hashCode => (_CalendarDaysRule).hashCode;
}
