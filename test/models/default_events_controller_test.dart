// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart';

import '../utilities.dart';

void main() {
  initializeTimeZones();

  final locations = locationsToTest.map(getLocation).toList();
  late DefaultEventsController controller;

  setUp(() {
    controller = DefaultEventsController(locations: locations);
  });

  tearDown(() {
    controller.dispose();
  });

  group('EventStore setup', () {
    test('All pre-configured locations are registered', () {
      expect(locations, controller.eventStore.locations);
    });

    test('Querying with an unknown location registers it on-demand', () {
      final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 15), end: FloatingDateTime(2024, 1, 16));
      final newLocation = getLocation('Asia/Tokyo');
      controller.eventsInRange(multiDayRule: kDefaultMultiDayRule, range, location: newLocation);
      expect(
        controller.eventStore.locations.contains(newLocation),
        isTrue,
        reason: 'The new location should be added to the event store the first time it is queried.',
      );
    });
  });

  group('addEvents', () {
    test('Returns one id per event and all events are retrievable', () {
      final events = List.generate(5, (i) => _event(2, i + 1, 9));
      final ids = controller.addEvents(events);
      expect([for (final id in ids) controller.byId(id)], events);
    });

    test('All added events appear in the events iterable', () {
      final events = List.generate(3, (i) => _event(3, i + 1, 8));
      controller.addEvents(events);
      for (final event in events) {
        expect(controller.events, contains(event));
      }
    });
  });

  group('byId', () {
    test('Returns null for a non-existent id', () {
      expect(controller.byId('non-existent-id'), isNull);
    });

    test('Returns null after the event has been removed', () {
      final id = controller.addEvent(_event(1, 10, 10));
      controller.removeById(id);
      expect(controller.byId(id), isNull);
    });
  });

  group('removeEvent', () {
    test('Removes event by object reference', () {
      final event = _event(1, 10, 10);
      final id = controller.addEvent(event);
      controller.removeEvent(event);
      expect(controller.byId(id), isNull);
      expect(controller.events, isNot(contains(event)));
    });

    test('Purges a multi-day event from the index on every spanned date', () {
      // Spans Jan 10, 11, 12; removal must clear the id from all three date
      // buckets, not just the start day.
      final event = KalenderEvent(start: DateTime.utc(2024, 1, 10, 9), end: DateTime.utc(2024, 1, 12, 17));
      controller.addEvent(event);
      controller.removeEvent(event);

      for (final day in [10, 11, 12]) {
        final dayRange = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 1, day),
          end: FloatingDateTime(2024, 1, day + 1),
        );
        expect(
          controller.eventsInRange(multiDayRule: kDefaultMultiDayRule, dayRange),
          isEmpty,
          reason: 'Jan $day should hold no stale event ids after removal.',
        );
      }
    });
  });

  group('removeEvents', () {
    test('Removes the specified events and leaves unaffected ones', () {
      final events = List.generate(4, (i) => _event(4, i + 1, 9));
      final ids = controller.addEvents(events);
      controller.removeEvents(events.take(2).toList());
      expect([for (final id in ids) controller.byId(id)], [null, null, events[2], events[3]]);
    });

    test('Removing an empty list leaves events unchanged', () {
      final event = _event(4, 10, 9);
      final id = controller.addEvent(event);
      controller.removeEvents([]);
      expect(controller.byId(id), event);
    });
  });

  group('removeWhere', () {
    test('Removes only events matching the predicate', () {
      final event2 = _event(5, 2, 9);
      final id1 = controller.addEvent(_event(5, 1, 9));
      final id2 = controller.addEvent(event2);

      controller.removeWhere((key, _) => key == id1);

      expect(controller.byId(id1), isNull);
      expect(controller.byId(id2), event2);
    });

    test('Removes all events when predicate always returns true', () {
      controller.addEvents(List.generate(3, (i) => _event(5, i + 10, 9)));
      controller.removeWhere((_, __) => true);
      expect(controller.events, isEmpty);
    });
  });

  group('clearEvents', () {
    test('Removes all events', () {
      controller.addEvents(List.generate(5, (i) => _event(6, i + 1, 9)));
      expect(controller.events, isNotEmpty);
      controller.clearEvents();
      expect(controller.events, isEmpty);
    });
  });

  group('replaceEvents', () {
    test('Swaps the whole set: old events gone, new events present', () {
      final old = List.generate(3, (i) => _event(6, i + 1, 9));
      controller.addEvents(old);

      final replacement = List.generate(2, (i) => _event(7, i + 1, 9));
      final ids = controller.replaceEvents(replacement);

      expect(controller.events.length, replacement.length);
      for (final event in old) {
        expect(controller.events, isNot(contains(event)));
      }
      expect([for (final id in ids) controller.byId(id)], replacement);
    });

    test('Notifies listeners exactly once', () {
      controller.addEvents([_event(6, 1, 9)]);

      var count = 0;
      controller.addListener(() => count++);
      controller.replaceEvents([_event(7, 1, 9)]);
      expect(count, 1, reason: 'A single atomic update, not a clear followed by an add.');
    });

    test('Replacing with an empty list clears all events', () {
      controller.addEvents([_event(6, 1, 9)]);
      controller.replaceEvents([]);
      expect(controller.events, isEmpty);
    });
  });

  group('ChangeNotifier', () {
    final cases = <({String name, void Function() Function() arrange})>[
      (
        name: 'addEvent',
        arrange: () =>
            () => controller.addEvent(_event(8, 1, 9)),
      ),
      (
        name: 'addEvents',
        arrange: () =>
            () => controller.addEvents(List.generate(2, (i) => _event(8, i + 5, 9))),
      ),
      (
        name: 'removeEvent',
        arrange: () {
          final event = _event(8, 2, 9);
          controller.addEvent(event);
          return () => controller.removeEvent(event);
        },
      ),
      (
        name: 'removeById',
        arrange: () {
          final id = controller.addEvent(_event(8, 9, 9));
          return () => controller.removeById(id);
        },
      ),
      (name: 'clearEvents', arrange: () => controller.clearEvents),
      (
        name: 'updateEvent',
        arrange: () {
          final event = _event(8, 3, 9);
          controller.addEvent(event);
          return () => controller.updateEvent(event: event, updatedEvent: _event(8, 3, 11));
        },
      ),
    ];

    for (final (:name, :arrange) in cases) {
      test('$name notifies listeners', () {
        final act = arrange();
        var notified = false;
        controller.addListener(() => notified = true);
        act();
        expect(notified, isTrue);
      });
    }
  });

  group('eventsInRange edge cases', () {
    test('Event not returned for a range it does not overlap', () {
      final event = _event(9, 1, 10);
      controller.addEvent(event);
      final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 9, 10), end: FloatingDateTime(2024, 9, 11));
      expect(controller.eventsInRange(multiDayRule: kDefaultMultiDayRule, range), isNot(contains(event)));
    });

    test('Multiple events in the same range are all returned', () {
      final events = List.generate(3, (i) => _event(10, 5, 9 + i));
      controller.addEvents(events);
      final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 10, 5), end: FloatingDateTime(2024, 10, 6));
      final result = controller.eventsInRange(multiDayRule: kDefaultMultiDayRule, range);
      for (final event in events) {
        expect(result, contains(event));
      }
    });

    test('Removed event is no longer returned from range query', () {
      final event = _event(11, 1, 10);
      controller.addEvent(event);
      controller.removeEvent(event);
      final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 11, 1), end: FloatingDateTime(2024, 11, 2));
      expect(controller.eventsInRange(multiDayRule: kDefaultMultiDayRule, range), isNot(contains(event)));
    });

    test('Updated event is found in new range but not old range', () {
      final event = _event(12, 1, 10);
      controller.addEvent(event);

      final updatedEvent = _event(12, 20, 6);
      controller.updateEvent(event: event, updatedEvent: updatedEvent);

      final oldRange = FloatingDateTimeRange(start: FloatingDateTime(2024, 12, 1), end: FloatingDateTime(2024, 12, 2));
      final newRange = FloatingDateTimeRange(
        start: FloatingDateTime(2024, 12, 20),
        end: FloatingDateTime(2024, 12, 21),
      );
      expect(controller.eventsInRange(multiDayRule: kDefaultMultiDayRule, oldRange), isNot(contains(updatedEvent)));
      expect(controller.eventsInRange(multiDayRule: kDefaultMultiDayRule, newRange), contains(updatedEvent));
    });

    test('Both filters disabled returns empty iterable', () {
      controller.addEvent(_event(9, 5, 10));
      final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 9, 5), end: FloatingDateTime(2024, 9, 6));
      final result = controller.eventsInRange(
        multiDayRule: kDefaultMultiDayRule,
        range,
        includeMultiDayEvents: false,
        includeDayEvents: false,
      );
      expect(result, isEmpty);
    });
  });

  for (final location in locations) {
    group('[$location] Adding, removing and fetching events', () {
      Iterable<KalenderEvent> inRange(FloatingDateTimeRange range, {bool day = true, bool multi = true}) {
        return controller.eventsInRange(
          multiDayRule: kDefaultMultiDayRule,
          range,
          location: location,
          includeDayEvents: day,
          includeMultiDayEvents: multi,
        );
      }

      FloatingDateTimeRange floatingRange(TZDateTime start, TZDateTime end) => FloatingDateTimeRange(
        start: FloatingDateTime.fromExternal(start, location: location),
        end: FloatingDateTime.fromExternal(end, location: location),
      );

      final cases = [
        (
          name: 'Short event (< 1 day)',
          start: TZDateTime(location, 2024, 1, 15, 10),
          end: TZDateTime(location, 2024, 1, 15, 11),
          multiDay: false,
        ),
        (
          name: 'Multi-day event (>= 1 day)',
          start: TZDateTime(location, 2024, 1, 15),
          end: TZDateTime(location, 2024, 1, 16),
          multiDay: true,
        ),
        (
          name: 'Zero-duration event',
          start: TZDateTime(location, 2024, 1, 15),
          end: TZDateTime(location, 2024, 1, 15),
          multiDay: false,
        ),
      ];

      for (final (:name, :start, :end, :multiDay) in cases) {
        test(name, () {
          final event = KalenderEvent(start: start, end: end);
          final id = controller.addEvent(event);
          expect(controller.byId(id), event);

          final range = floatingRange(start, end);
          expect(inRange(range), contains(event));
          expect(inRange(range, day: false), multiDay ? contains(event) : isEmpty);
          expect(inRange(range, multi: false), multiDay ? isEmpty : contains(event));
        });
      }

      test('Update event: id preserved and new range is queryable', () {
        final start = TZDateTime(location, 2024, 1, 15);
        final end = TZDateTime(location, 2024, 1, 16);
        final event = KalenderEvent(start: start, end: end);
        final id = controller.addEvent(event);

        final newStart = TZDateTime(location, 2024, 1, 17);
        final newEnd = TZDateTime(location, 2024, 1, 18);
        final updatedEvent = KalenderEvent(start: newStart, end: newEnd);
        controller.updateEvent(event: event, updatedEvent: updatedEvent);

        expect(updatedEvent.id, id);
        expect(controller.byId(id), updatedEvent);

        final newRange = floatingRange(newStart, newEnd);
        expect(inRange(floatingRange(start, end)), isNot(contains(updatedEvent)));
        expect(inRange(newRange), contains(updatedEvent));
        expect(inRange(newRange, day: false), contains(updatedEvent));
        expect(inRange(newRange, multi: false), isEmpty);
      });
    });
  }
}

KalenderEvent _event(int month, int day, int hour) =>
    KalenderEvent(start: DateTime.utc(2024, month, day, hour), end: DateTime.utc(2024, month, day, hour + 1));
