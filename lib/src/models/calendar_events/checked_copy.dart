import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// Copies used by the calendar's own drag and resize handling.
extension CheckedEventCopy on CalendarEvent {
  /// [CalendarEvent.copyWith], checking in debug mode that the override kept
  /// the state it takes no parameter for.
  ///
  /// [CalendarEvent.id] and [CalendarEvent.multiDayRule] are carried over by the
  /// base implementation, so a subclass that omits them returns a copy with a
  /// new identity or without its rule.
  CalendarEvent checkedCopyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
  }) {
    final copy = copyWith(dateTimeRange: dateTimeRange, interaction: interaction);

    assert(
      copy.id == id,
      '$runtimeType.copyWith did not forward id, so every drag and resize produces a copy the calendar '
      'reads as a different event. Add "id: id" to the override.',
    );
    assert(
      copy.multiDayRule == multiDayRule,
      '$runtimeType.copyWith did not forward multiDayRule, so every drag and resize produces a copy that '
      'falls back to the view configuration\'s rule. Add "multiDayRule: multiDayRule" to the override.',
    );

    return copy;
  }
}
