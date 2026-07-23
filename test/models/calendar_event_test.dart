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

  // ─── isMultiDayEvent ─────────────────────────────────────────────────────────
  //
  // CHARACTERIZATION of the *current* implementation, which is defined purely on
  // the UTC `duration.inDays > 0`. This is location-independent and ignores
  // calendar-day boundaries. The `skip`ped group below records the agreed-upon
  // *desired* (location/calendar-day-aware) behaviour for when the getter is
  // reworked — see calendar_event.dart:89 and AGENTS.md "isMultiDayEvent".

  group('isMultiDayEvent (current UTC-duration behaviour)', () {
    test('a short same-day event is not multi-day', () {
      expect(eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 15, 10)).isMultiDayEvent, isFalse);
    });

    test('an event of exactly 24h is multi-day (inDays == 1)', () {
      expect(eventUtc(DateTime.utc(2024, 1, 15), DateTime.utc(2024, 1, 16)).isMultiDayEvent, isTrue);
    });

    test('an event longer than 24h is multi-day', () {
      expect(eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 17, 9)).isMultiDayEvent, isTrue);
    });

    test('a short event crossing midnight is NOT classed as multi-day (known limitation)', () {
      // 23:00 -> 01:00 next day is only 2h, so inDays == 0, even though it
      // occupies two calendar days. This is the cross-midnight bug.
      final event = eventUtc(DateTime.utc(2024, 1, 15, 23), DateTime.utc(2024, 1, 16, 1));
      expect(event.isMultiDayEvent, isFalse);
    });
  });

  group('isMultiDayEvent (desired location/calendar-day-aware behaviour)', () {
    test('a short event crossing midnight should be multi-day (spans two calendar days)', () {
      // 23:00 -> 01:00 next day occupies Jan 15 and Jan 16 in UTC.
      final event = eventUtc(DateTime.utc(2024, 1, 15, 23), DateTime.utc(2024, 1, 16, 1));
      expect(event.datesSpanned(location: utcLocation), hasLength(2));
      expect(event.isMultiDayEvent, isTrue);
    });

    test('a long event within a single calendar day should not be multi-day', () {
      // A 10-hour event entirely inside one day must remain a single-day event.
      final event = eventUtc(DateTime.utc(2024, 1, 15, 8), DateTime.utc(2024, 1, 15, 18));
      expect(event.isMultiDayEvent, isFalse);
    });
    },
    skip: 'Desired behaviour: reclassify isMultiDayEvent to be location/calendar-day-aware. '
        'Un-skip when spansMultipleDays lands with MultiDayRule.calendarDays().',
  );
}
