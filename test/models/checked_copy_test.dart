import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/checked_copy.dart';

/// A subclass whose `copyWith` forwards everything the base class carries over,
/// matching the documented example on [CalendarEvent].
class _GoodEvent extends CalendarEvent {
  _GoodEvent({
    super.id,
    required super.dateTimeRange,
    required this.title,
    super.interaction,
    super.multiDayRule,
  });

  final String title;

  @override
  _GoodEvent copyWith({DateTimeRange? dateTimeRange, EventInteraction? interaction, String? title}) => _GoodEvent(
        id: id,
        dateTimeRange: dateTimeRange ?? this.dateTimeRange,
        interaction: interaction ?? this.interaction,
        multiDayRule: multiDayRule,
        title: title ?? this.title,
      );
}

/// A subclass that omits `id`, so each copy is minted with a new identity.
class _DropsId extends CalendarEvent {
  _DropsId({required super.dateTimeRange, super.multiDayRule});

  @override
  _DropsId copyWith({DateTimeRange? dateTimeRange, EventInteraction? interaction}) =>
      _DropsId(dateTimeRange: dateTimeRange ?? this.dateTimeRange, multiDayRule: multiDayRule);
}

/// A subclass that omits `multiDayRule`, so each copy falls back to the view
/// configuration's rule.
class _DropsRule extends CalendarEvent {
  _DropsRule({super.id, required super.dateTimeRange, super.multiDayRule});

  @override
  _DropsRule copyWith({DateTimeRange? dateTimeRange, EventInteraction? interaction}) =>
      _DropsRule(id: id, dateTimeRange: dateTimeRange ?? this.dateTimeRange);
}

void main() {
  final range = DateTimeRange(start: DateTime.utc(2025, 1, 6, 9), end: DateTime.utc(2025, 1, 6, 10));
  final moved = DateTimeRange(start: DateTime.utc(2025, 1, 6, 11), end: DateTime.utc(2025, 1, 6, 12));

  group('checkedCopyWith', () {
    test('a base CalendarEvent keeps its id and rule', () {
      final event = CalendarEvent(dateTimeRange: range, multiDayRule: const MultiDayRule.calendarDays());
      final copy = event.checkedCopyWith(dateTimeRange: moved);

      expect(copy.id, equals(event.id));
      expect(copy.multiDayRule, equals(event.multiDayRule));
      expect(copy.dateTimeRange, equals(moved));
    });

    test('a subclass forwarding both fields does not trip the assert', () {
      final event = _GoodEvent(
        dateTimeRange: range,
        title: 'standup',
        multiDayRule: const MultiDayRule.calendarDays(),
      );
      final copy = event.checkedCopyWith(dateTimeRange: moved) as _GoodEvent;

      expect(copy.id, equals(event.id));
      expect(copy.multiDayRule, equals(event.multiDayRule));
      expect(copy.title, equals('standup'));
    });

    test('a subclass that drops id names the missing forward', () {
      final event = _DropsId(dateTimeRange: range);

      expect(
        () => event.checkedCopyWith(dateTimeRange: moved),
        throwsA(
          isA<AssertionError>().having((e) => e.message, 'message', allOf(contains('_DropsId'), contains('id: id'))),
        ),
      );
    });

    test('a subclass that drops multiDayRule names the missing forward', () {
      final event = _DropsRule(dateTimeRange: range, multiDayRule: const MultiDayRule.calendarDays());

      expect(
        () => event.checkedCopyWith(dateTimeRange: moved),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            allOf(contains('_DropsRule'), contains('multiDayRule: multiDayRule')),
          ),
        ),
      );
    });

    test('dropping multiDayRule is only caught when the event sets one', () {
      // The base default is null, so an override that omits the field still
      // produces an equal value and there is nothing to report.
      final event = _DropsRule(dateTimeRange: range);
      expect(() => event.checkedCopyWith(dateTimeRange: moved), returnsNormally);
    });
  });
}
