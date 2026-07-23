import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';

void main() {
  initializeTimeZones();

  /// A UTC [Location] so that wall-clock arithmetic equals the UTC inputs,
  /// making [CalendarEvent] location-aware getters deterministic regardless of
  /// the `TZ` the test suite is run under.
  final utcLocation = getLocation('Etc/UTC');

  CalendarEvent eventUtc(DateTime start, DateTime end, {String? id, EventInteraction? interaction}) {
    return CalendarEvent(
      id: id,
      dateTimeRange: DateTimeRange(start: start, end: end),
      interaction: interaction,
    );
  }

  // ─── Construction & storage ────────────────────────────────────────────────

  group('construction', () {
    test('start and end are stored in UTC', () {
      // A non-UTC (local) input must be normalised to UTC on construction.
      final local = DateTime(2024, 1, 15, 9);
      final event = CalendarEvent(dateTimeRange: DateTimeRange(start: local, end: local.add(const Duration(hours: 1))));
      expect(event.start.isUtc, isTrue);
      expect(event.end.isUtc, isTrue);
      expect(event.start, equals(local.toUtc()));
    });

    test('dateTimeRange getter round-trips the stored UTC range', () {
      final start = DateTime.utc(2024, 1, 15, 9);
      final end = DateTime.utc(2024, 1, 15, 10);
      final event = eventUtc(start, end);
      expect(event.dateTimeRange.start, equals(start));
      expect(event.dateTimeRange.end, equals(end));
    });

    test('duration reflects the UTC range', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 15, 11, 30));
      expect(event.duration, equals(const Duration(hours: 2, minutes: 30)));
    });

    test('interaction defaults to fully modifiable', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 15, 10));
      expect(event.interaction, equals(EventInteraction.fromCanModify(true)));
    });
  });

  // ─── ID generation ───────────────────────────────────────────────────────────

  group('id generation', () {
    test('auto-generates a 10-character alphanumeric id', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 15, 10));
      expect(event.id, hasLength(10));
      expect(event.id, matches(RegExp(r'^[a-zA-Z0-9]{10}$')));
    });

    test('generates distinct ids across many events', () {
      final ids = List.generate(
        1000,
        (_) => eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 15, 10)).id,
      ).toSet();
      // Collisions are statistically negligible for 10 chars of a 62-char alphabet.
      expect(ids, hasLength(1000));
    });

    test('honours an explicitly provided id', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 15, 10), id: 'fixed-id');
      expect(event.id, equals('fixed-id'));
    });
  });

  // ─── copyWith ──────────────────────────────────────────────────────────────

  group('copyWith', () {
    final original = eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 15, 10), id: 'original');

    test('preserves the id so selection/layout lookups stay stable', () {
      final copy = original.copyWith(
        dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 2, 1, 8), end: DateTime.utc(2024, 2, 1, 9)),
      );
      expect(copy.id, equals('original'));
    });

    test('replaces the dateTimeRange when provided', () {
      final newRange = DateTimeRange(start: DateTime.utc(2024, 2, 1, 8), end: DateTime.utc(2024, 2, 1, 9));
      final copy = original.copyWith(dateTimeRange: newRange);
      expect(copy.start, equals(newRange.start));
      expect(copy.end, equals(newRange.end));
    });

    test('replaces the interaction when provided', () {
      final copy = original.copyWith(interaction: EventInteraction.fromCanModify(false));
      expect(copy.interaction, equals(EventInteraction.fromCanModify(false)));
    });

    test('keeps the original range and interaction when no args are given', () {
      final copy = original.copyWith();
      expect(copy.start, equals(original.start));
      expect(copy.end, equals(original.end));
      expect(copy.interaction, equals(original.interaction));
    });
  });

  // ─── Equality / hashCode / layoutEquals ──────────────────────────────────────

  group('equality', () {
    final start = DateTime.utc(2024, 1, 15, 9);
    final end = DateTime.utc(2024, 1, 15, 10);

    test('events with equal id, range and interaction are equal', () {
      final a = eventUtc(start, end, id: 'same');
      final b = eventUtc(start, end, id: 'same');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differing id breaks equality', () {
      expect(eventUtc(start, end, id: 'a'), isNot(equals(eventUtc(start, end, id: 'b'))));
    });

    test('differing range breaks equality', () {
      final a = eventUtc(start, end, id: 'same');
      final b = eventUtc(start, end.add(const Duration(hours: 1)), id: 'same');
      expect(a, isNot(equals(b)));
    });

    test('differing interaction breaks equality', () {
      final a = eventUtc(start, end, id: 'same', interaction: EventInteraction.fromCanModify(true));
      final b = eventUtc(start, end, id: 'same', interaction: EventInteraction.fromCanModify(false));
      expect(a, isNot(equals(b)));
    });

    test('layoutEquals agrees with operator ==', () {
      final a = eventUtc(start, end, id: 'same');
      final b = eventUtc(start, end, id: 'same');
      expect(a.layoutEquals(b), isTrue);
      expect(a.layoutEquals(eventUtc(start, end, id: 'other')), isFalse);
    });
  });

  // ─── Location-aware range helpers ────────────────────────────────────────────

  group('internal range & datesSpanned (UTC location)', () {
    test('single-day event spans exactly one date', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 15, 17));
      final dates = event.datesSpanned(location: utcLocation);
      expect(dates, hasLength(1));
      expect(dates.single.day, equals(15));
    });

    test('multi-day event spans each calendar day it touches', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 17, 9));
      final dates = event.datesSpanned(location: utcLocation);
      expect(dates.map((d) => d.day), equals([15, 16, 17]));
    });

    test('internalStart/internalEnd round-trip the wall-clock components', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15, 9, 30), DateTime.utc(2024, 1, 15, 10, 45));
      final internalStart = event.internalStart(location: utcLocation);
      final internalEnd = event.internalEnd(location: utcLocation);
      expect([internalStart.hour, internalStart.minute], equals([9, 30]));
      expect([internalEnd.hour, internalEnd.minute], equals([10, 45]));
    });
  });

  // ─── spansMultipleDays ───────────────────────────────────────────────────────

  group('the default rule, minimumDuration(24h)', () {
    test('a short same-day event is not multi-day', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 15, 10));
      expect(
        event.spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isFalse,
      );
    });

    test('exactly 24h is multi-day', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15), DateTime.utc(2024, 1, 16));
      expect(
        event.spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isTrue,
      );
    });

    test('longer than 24h is multi-day', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 17, 9));
      expect(
        event.spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isTrue,
      );
    });

    test('a short event crossing midnight is not multi-day', () {
      // 2h long, so under the duration rule it stays in the day timeline even
      // though it occupies two calendar days. Use MultiDayRule.calendarDays()
      // to classify it the other way.
      final event = eventUtc(DateTime.utc(2024, 1, 15, 23), DateTime.utc(2024, 1, 16, 1));
      expect(event.datesSpanned(location: utcLocation), hasLength(2));
      expect(
        event.spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isFalse,
      );
    });

    test('matches the duration.inDays > 0 rule it replaced', () {
      // The evidence that swapping the getter for the rule changed no rendering.
      final ranges = [
        [DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 15, 10)],
        [DateTime.utc(2024, 1, 15, 8), DateTime.utc(2024, 1, 15, 18)],
        [DateTime.utc(2024, 1, 15, 23), DateTime.utc(2024, 1, 16, 1)],
        [DateTime.utc(2024, 1, 15), DateTime.utc(2024, 1, 16)],
        [DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 17, 9)],
        [DateTime.utc(2024, 1, 15), DateTime.utc(2024, 1, 15)],
        // Spring forward in Europe/Amsterdam, 2024-03-31.
        [DateTime.utc(2024, 3, 30, 23), DateTime.utc(2024, 3, 31, 22)],
      ];

      for (final range in ranges) {
        final event = eventUtc(range.first, range.last);
        expect(
          event.spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
          equals(event.duration.inDays > 0),
          reason: 'changed for ${range.first} to ${range.last}',
        );
      }
    });
  });

  group('MultiDayRule.calendarDays', () {
    CalendarEvent event(DateTime start, DateTime end) {
      return CalendarEvent(
        dateTimeRange: DateTimeRange(start: start, end: end),
        multiDayRule: const MultiDayRule.calendarDays(),
      );
    }

    test('a short event crossing midnight is multi-day', () {
      final crossing = event(DateTime.utc(2024, 1, 15, 23), DateTime.utc(2024, 1, 16, 1));
      expect(
        crossing.spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isTrue,
      );
    });

    test('a long event inside one calendar day is not multi-day', () {
      final within = event(DateTime.utc(2024, 1, 15, 8), DateTime.utc(2024, 1, 15, 18));
      expect(
        within.spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isFalse,
      );
    });

    test('a full day stays multi-day so it remains in the header', () {
      final fullDay = event(DateTime.utc(2024, 1, 15), DateTime.utc(2024, 1, 16));
      expect(
        fullDay.spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isTrue,
      );
    });
  });

  group('the view rule versus the event override', () {
    final crossing = DateTimeRange(start: DateTime.utc(2024, 1, 15, 23), end: DateTime.utc(2024, 1, 16, 1));

    test('an event with no rule of its own follows the one it is given', () {
      final event = CalendarEvent(dateTimeRange: crossing);
      expect(event.multiDayRule, isNull, reason: 'unset means "use the calendar\'s rule"');
      expect(
        event.spansMultipleDays(location: utcLocation, defaultRule: const MultiDayRule.calendarDays()),
        isTrue,
      );
      expect(
        event.spansMultipleDays(
          location: utcLocation,
          defaultRule: const MultiDayRule.minimumDuration(Duration(hours: 24)),
        ),
        isFalse,
      );
    });

    test('an event override beats the calendar rule, in both directions', () {
      final strict = CalendarEvent(dateTimeRange: crossing, multiDayRule: const MultiDayRule.calendarDays());
      expect(
        strict.spansMultipleDays(
          location: utcLocation,
          defaultRule: const MultiDayRule.minimumDuration(Duration(hours: 24)),
        ),
        isTrue,
        reason: 'the event asked for calendar days',
      );

      final loose = CalendarEvent(
        dateTimeRange: crossing,
        multiDayRule: const MultiDayRule.minimumDuration(Duration(hours: 24)),
      );
      expect(
        loose.spansMultipleDays(location: utcLocation, defaultRule: const MultiDayRule.calendarDays()),
        isFalse,
        reason: 'the event asked for a duration threshold',
      );
    });
  });

  group('choosing a rule', () {
    test('per event, via the constructor', () {
      final crossing = DateTimeRange(start: DateTime.utc(2024, 1, 15, 23), end: DateTime.utc(2024, 1, 16, 1));
      expect(
        CalendarEvent(dateTimeRange: crossing)
            .spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isFalse,
      );
      expect(
        CalendarEvent(dateTimeRange: crossing, multiDayRule: const MultiDayRule.calendarDays())
            .spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isTrue,
      );
    });

    test('per app, via a subclass that fixes the rule', () {
      final event = _CalendarDayEvent(
        dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 1, 15, 23), end: DateTime.utc(2024, 1, 16, 1)),
      );
      expect(
        event.spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isTrue,
      );
    });

    test('fully custom, by overriding spansMultipleDays', () {
      final fullDay = DateTimeRange(start: DateTime.utc(2024, 1, 15), end: DateTime.utc(2024, 1, 16));
      expect(
        CalendarEvent(dateTimeRange: fullDay)
            .spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isTrue,
      );
      expect(
        _StrictMultiDayEvent(dateTimeRange: fullDay)
            .spansMultipleDays(location: utcLocation, defaultRule: defaultMultiDayRule),
        isFalse,
      );
    });

    test('copyWith carries the rule, and takes no parameter for it', () {
      // A parameter here would invalidate every subclass override of copyWith,
      // which is the documented way to attach data to an event.
      final event = CalendarEvent(
        dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 1, 15), end: DateTime.utc(2024, 1, 16)),
        multiDayRule: const MultiDayRule.calendarDays(),
      );
      expect(event.copyWith().multiDayRule, const MultiDayRule.calendarDays());
      expect(
        event.copyWith(dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 2), end: DateTime.utc(2024, 2, 2))),
        isA<CalendarEvent>().having((e) => e.multiDayRule, 'multiDayRule', const MultiDayRule.calendarDays()),
      );
    });

    test('the rule participates in layoutEquals, since it decides the lane', () {
      final range = DateTimeRange(start: DateTime.utc(2024, 1, 15, 23), end: DateTime.utc(2024, 1, 16, 1));
      final a = CalendarEvent(id: 'same', dateTimeRange: range);
      final b = CalendarEvent(id: 'same', dateTimeRange: range, multiDayRule: const MultiDayRule.calendarDays());
      expect(a.layoutEquals(b), isFalse);
      expect(a, isNot(equals(b)));
    });
  });

  group('MultiDayRule equality', () {
    test('the same rule compares equal', () {
      expect(const MultiDayRule.calendarDays(), const MultiDayRule.calendarDays());
      expect(
        const MultiDayRule.minimumDuration(Duration(hours: 24)),
        const MultiDayRule.minimumDuration(Duration(hours: 24)),
      );
    });

    test('different rules do not', () {
      expect(const MultiDayRule.calendarDays(), isNot(const MultiDayRule.minimumDuration(Duration(hours: 24))));
      expect(
        const MultiDayRule.minimumDuration(Duration(hours: 24)),
        isNot(const MultiDayRule.minimumDuration(Duration(hours: 12))),
      );
    });
  });
}

/// Fixes the rule for a whole app in one place, the way a real subclass would.
class _CalendarDayEvent extends CalendarEvent {
  _CalendarDayEvent({required super.dateTimeRange}) : super(multiDayRule: const MultiDayRule.calendarDays());
}

/// Replaces the rule entirely with a strict "more than one calendar day".
class _StrictMultiDayEvent extends CalendarEvent {
  _StrictMultiDayEvent({required super.dateTimeRange});

  @override
  bool spansMultipleDays({required Location? location, required MultiDayRule defaultRule}) {
    return datesSpanned(location: location).length > 1;
  }
}
