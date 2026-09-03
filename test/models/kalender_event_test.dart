import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart';

void main() {
  initializeTimeZones();

  /// A UTC [Location] so that wall-clock arithmetic equals the UTC inputs,
  /// making [KalenderEvent] location-aware getters deterministic regardless of
  /// the `TZ` the test suite is run under.
  final utcLocation = getLocation('Etc/UTC');

  KalenderEvent eventUtc(DateTime start, DateTime end, {String? id, EventInteraction? interaction}) {
    return KalenderEvent(
      id: id,
      start: start,
      end: end,
      interaction: interaction,
    );
  }

  // ─── Construction & storage ────────────────────────────────────────────────

  group('construction', () {
    test('start and end are stored in UTC', () {
      // A non-UTC (local) input must be normalised to UTC on construction.
      final local = DateTime(2024, 1, 15, 9);
      final event = KalenderEvent(start: local, end: local.add(const Duration(hours: 1)));
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

  // ─── withDateTimeRange ─────────────────────────────────────────────────────

  group('withDateTimeRange', () {
    final original = eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 15, 10), id: 'original');

    test('preserves the id so selection/layout lookups stay stable', () {
      final copy = original.withDateTimeRange(
        KalenderDateTimeRange(start: DateTime.utc(2024, 2, 1, 8), end: DateTime.utc(2024, 2, 1, 9)),
      );
      expect(copy.id, equals('original'));
    });

    test('replaces the dateTimeRange', () {
      final newRange = KalenderDateTimeRange(start: DateTime.utc(2024, 2, 1, 8), end: DateTime.utc(2024, 2, 1, 9));
      final copy = original.withDateTimeRange(newRange);
      expect(copy.start, equals(newRange.start));
      expect(copy.end, equals(newRange.end));
    });

    test('keeps the interaction, which it takes no parameter for', () {
      final locked = eventUtc(
        DateTime.utc(2024, 1, 15, 9),
        DateTime.utc(2024, 1, 15, 10),
        interaction: EventInteraction.fromCanModify(false),
      );
      final copy = locked.withDateTimeRange(
        KalenderDateTimeRange(start: DateTime.utc(2024, 2, 1, 8), end: DateTime.utc(2024, 2, 1, 9)),
      );
      expect(copy.interaction, equals(EventInteraction.fromCanModify(false)));
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
        event.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
        isFalse,
      );
    });

    test('exactly 24h is multi-day', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15), DateTime.utc(2024, 1, 16));
      expect(
        event.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
        isTrue,
      );
    });

    test('longer than 24h is multi-day', () {
      final event = eventUtc(DateTime.utc(2024, 1, 15, 9), DateTime.utc(2024, 1, 17, 9));
      expect(
        event.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
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
        event.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
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
          event.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
          equals(event.duration.inDays > 0),
          reason: 'changed for ${range.first} to ${range.last}',
        );
      }
    });
  });

  group('MultiDayRule.calendarDays', () {
    KalenderEvent event(DateTime start, DateTime end) {
      return KalenderEvent(
        start: start,
        end: end,
        multiDayRule: const MultiDayRule.calendarDays(),
      );
    }

    test('a short event crossing midnight is multi-day', () {
      final crossing = event(DateTime.utc(2024, 1, 15, 23), DateTime.utc(2024, 1, 16, 1));
      expect(
        crossing.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
        isTrue,
      );
    });

    test('a long event inside one calendar day is not multi-day', () {
      final within = event(DateTime.utc(2024, 1, 15, 8), DateTime.utc(2024, 1, 15, 18));
      expect(
        within.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
        isFalse,
      );
    });

    test('a full day stays multi-day so it remains in the header', () {
      final fullDay = event(DateTime.utc(2024, 1, 15), DateTime.utc(2024, 1, 16));
      expect(
        fullDay.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
        isTrue,
      );
    });
  });

  group('the view rule versus the event override', () {
    final crossing = KalenderDateTimeRange(start: DateTime.utc(2024, 1, 15, 23), end: DateTime.utc(2024, 1, 16, 1));

    test('an event with no rule of its own follows the one it is given', () {
      final event = KalenderEvent(start: crossing.start, end: crossing.end);
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
      final strict =
          KalenderEvent(start: crossing.start, end: crossing.end, multiDayRule: const MultiDayRule.calendarDays());
      expect(
        strict.spansMultipleDays(
          location: utcLocation,
          defaultRule: const MultiDayRule.minimumDuration(Duration(hours: 24)),
        ),
        isTrue,
        reason: 'the event asked for calendar days',
      );

      final loose = KalenderEvent(
        start: crossing.start,
        end: crossing.end,
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
      final crossing = KalenderDateTimeRange(start: DateTime.utc(2024, 1, 15, 23), end: DateTime.utc(2024, 1, 16, 1));
      expect(
        KalenderEvent(start: crossing.start, end: crossing.end)
            .spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
        isFalse,
      );
      expect(
        KalenderEvent(start: crossing.start, end: crossing.end, multiDayRule: const MultiDayRule.calendarDays())
            .spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
        isTrue,
      );
    });

    test('per app, via a subclass that fixes the rule', () {
      final event = _CalendarDayEvent(
        start: DateTime.utc(2024, 1, 15, 23),
        end: DateTime.utc(2024, 1, 16, 1),
      );
      expect(
        event.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
        isTrue,
      );
    });

    test('fully custom, by overriding spansMultipleDays', () {
      final fullDay = KalenderDateTimeRange(start: DateTime.utc(2024, 1, 15), end: DateTime.utc(2024, 1, 16));
      expect(
        KalenderEvent(start: fullDay.start, end: fullDay.end)
            .spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
        isTrue,
      );
      expect(
        _StrictMultiDayEvent(start: fullDay.start, end: fullDay.end)
            .spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule),
        isFalse,
      );
    });

    test('copyWith carries the rule, and takes no parameter for it', () {
      // carryOver reapplies it, so a subclass never forwards it by hand.
      final event = KalenderEvent(
        start: DateTime.utc(2024, 1, 15),
        end: DateTime.utc(2024, 1, 16),
        multiDayRule: const MultiDayRule.calendarDays(),
      );
      expect(
        event.withDateTimeRange(KalenderDateTimeRange(start: DateTime.utc(2024, 2), end: DateTime.utc(2024, 2, 2))),
        isA<KalenderEvent>().having((e) => e.multiDayRule, 'multiDayRule', const MultiDayRule.calendarDays()),
      );
    });

    test('a subclass keeps the rule without mentioning it', () {
      // The pattern the Custom Events guide documents. copyWithData rebuilds
      // only the title, and carryOver puts the rule back.
      final event = _DataEvent(
        start: DateTime.utc(2024, 1, 15),
        end: DateTime.utc(2024, 1, 16),
        title: 'Night shift',
        multiDayRule: const MultiDayRule.calendarDays(),
      );

      final moved = event.withDateTimeRange(
        KalenderDateTimeRange(start: DateTime.utc(2024, 2), end: DateTime.utc(2024, 2, 2)),
      ) as _DataEvent;
      expect(moved.multiDayRule, const MultiDayRule.calendarDays());
      expect(moved.title, 'Night shift');
    });

    test('the rule participates in layoutEquals, since it decides the lane', () {
      final range = KalenderDateTimeRange(start: DateTime.utc(2024, 1, 15, 23), end: DateTime.utc(2024, 1, 16, 1));
      final a = KalenderEvent(id: 'same', start: range.start, end: range.end);
      final b = KalenderEvent(
        id: 'same',
        start: range.start,
        end: range.end,
        multiDayRule: const MultiDayRule.calendarDays(),
      );
      expect(a.layoutEquals(b), isFalse);
      expect(a, isNot(equals(b)));
    });
  });

  group('isAllDay', () {
    final shortRange = KalenderDateTimeRange(start: DateTime.utc(2024, 1, 15, 9), end: DateTime.utc(2024, 1, 15, 10));

    test('defaults to false and changes nothing', () {
      final event = KalenderEvent(start: shortRange.start, end: shortRange.end);
      expect(event.isAllDay, isFalse);
      expect(event.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule), isFalse);
    });

    test('a one-hour event set all-day belongs in the header lane', () {
      // No MultiDayRule can express this: the event is under 24 hours and sits
      // inside one calendar day, so before the flag it needed an override of
      // spansMultipleDays.
      final event = KalenderEvent(start: shortRange.start, end: shortRange.end, isAllDay: true);
      expect(event.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule), isTrue);
      expect(event.spansMultipleDays(location: utcLocation, defaultRule: const MultiDayRule.calendarDays()), isTrue);
    });

    test('outranks a per-event rule that says otherwise', () {
      final event = KalenderEvent(
        start: shortRange.start,
        end: shortRange.end,
        isAllDay: true,
        multiDayRule: const MultiDayRule.minimumDuration(Duration(days: 7)),
      );
      expect(event.spansMultipleDays(location: utcLocation, defaultRule: kDefaultMultiDayRule), isTrue);
    });

    test('leaves the date range alone', () {
      final event = KalenderEvent(start: shortRange.start, end: shortRange.end, isAllDay: true);
      expect(event.dateTimeRange, equals(shortRange));
    });

    test('survives a drag', () {
      final event = KalenderEvent(start: shortRange.start, end: shortRange.end, isAllDay: true);
      final moved = event.withDateTimeRange(
        KalenderDateTimeRange(start: DateTime.utc(2024, 1, 16, 9), end: DateTime.utc(2024, 1, 16, 10)),
      );
      expect(moved.isAllDay, isTrue);
    });

    test('participates in layoutEquals, since it decides the lane', () {
      final a = KalenderEvent(id: 'same', start: shortRange.start, end: shortRange.end);
      final b = KalenderEvent(id: 'same', start: shortRange.start, end: shortRange.end, isAllDay: true);
      expect(a.layoutEquals(b), isFalse);
      expect(a, isNot(equals(b)));
    });

    test('the controller sorts it into the multi-day lane', () {
      final controller = DefaultEventsController();
      addTearDown(controller.dispose);

      final timed = KalenderEvent(start: shortRange.start, end: shortRange.end);
      final allDay = KalenderEvent(start: shortRange.start, end: shortRange.end, isAllDay: true);
      controller.addEvents([timed, allDay]);

      final day = InternalDateTimeRange(
        start: InternalDateTime.fromExternal(DateTime.utc(2024, 1, 15), location: utcLocation),
        end: InternalDateTime.fromExternal(DateTime.utc(2024, 1, 16), location: utcLocation),
      );

      expect(
        controller.eventsFromDateTimeRange(
          day,
          multiDayRule: kDefaultMultiDayRule,
          includeDayEvents: false,
          location: utcLocation,
        ),
        equals([allDay]),
      );
      expect(
        controller.eventsFromDateTimeRange(
          day,
          multiDayRule: kDefaultMultiDayRule,
          includeMultiDayEvents: false,
          location: utcLocation,
        ),
        equals([timed]),
      );
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
class _CalendarDayEvent extends KalenderEvent {
  _CalendarDayEvent({required super.start, required super.end})
      : super(multiDayRule: const MultiDayRule.calendarDays());

  @override
  _CalendarDayEvent copyWithData({required DateTime start, required DateTime end}) {
    return _CalendarDayEvent(start: start, end: end);
  }
}

/// Attaches data the way the Custom Events guide shows, forwarding the rule.
class _DataEvent extends KalenderEvent {
  _DataEvent({
    required super.start,
    required super.end,
    required this.title,
    super.multiDayRule,
  });

  final String title;

  @override
  _DataEvent copyWithData({required DateTime start, required DateTime end}) {
    return _DataEvent(start: start, end: end, title: title);
  }
}

/// Replaces the rule entirely with a strict "more than one calendar day".
class _StrictMultiDayEvent extends KalenderEvent {
  _StrictMultiDayEvent({required super.start, required super.end});

  @override
  _StrictMultiDayEvent copyWithData({required DateTime start, required DateTime end}) {
    return _StrictMultiDayEvent(start: start, end: end);
  }

  @override
  bool spansMultipleDays({required Location? location, required MultiDayRule defaultRule}) {
    return datesSpanned(location: location).length > 1;
  }
}
