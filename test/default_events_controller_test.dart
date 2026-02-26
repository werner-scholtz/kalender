import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';

const locationsToTest = [
  'UTC',
  'Africa/Johannesburg',
  'America/New_York',
  'Europe/London',
  'Australia/Sydney',
];

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

  // ─── EventStore setup ────────────────────────────────────────────────────

  group('EventStore setup', () {
    test('All pre-configured locations are registered', () {
      expect(locations, controller.eventStore.locations);
    });

    test('Querying with an unknown location registers it on-demand', () {
      final range = InternalDateTimeRange(start: InternalDateTime(2024, 1, 15), end: InternalDateTime(2024, 1, 16));
      final newLocation = getLocation('Asia/Tokyo');
      controller.eventsFromDateTimeRange(range, location: newLocation);
      expect(
        controller.eventStore.locations.contains(newLocation),
        isTrue,
        reason: 'The new location should be added to the event store the first time it is queried.',
      );
    });
  });

  // ─── addEvents (batch) ───────────────────────────────────────────────────

  group('addEvents', () {
    test('Returns one id per event and all events are retrievable', () {
      final events = List.generate(5, (i) {
        final start = DateTime.utc(2024, 2, i + 1, 9);
        final end = DateTime.utc(2024, 2, i + 1, 10);
        return CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      });
      final ids = controller.addEvents(events);
      expect(ids.length, events.length);
      for (var i = 0; i < ids.length; i++) {
        expect(controller.byId(ids[i]), events[i], reason: 'Event $i should be retrievable by its assigned id.');
      }
    });

    test('All added events appear in the events iterable', () {
      final events = List.generate(3, (i) {
        final start = DateTime.utc(2024, 3, i + 1, 8);
        final end = DateTime.utc(2024, 3, i + 1, 9);
        return CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      });
      controller.addEvents(events);
      for (final event in events) {
        expect(controller.events, contains(event));
      }
    });
  });

  // ─── byId edge cases ─────────────────────────────────────────────────────

  group('byId', () {
    test('Returns null for a non-existent id', () {
      expect(controller.byId('non-existent-id'), isNull);
    });

    test('Returns null after the event has been removed', () {
      final start = DateTime.utc(2024, 1, 10, 10);
      final end = DateTime.utc(2024, 1, 10, 11);
      final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      final id = controller.addEvent(event);
      controller.removeById(id);
      expect(controller.byId(id), isNull);
    });
  });

  // ─── removeEvent ─────────────────────────────────────────────────────────

  group('removeEvent', () {
    test('Removes event by object reference', () {
      final start = DateTime.utc(2024, 1, 10, 10);
      final end = DateTime.utc(2024, 1, 10, 11);
      final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      final id = controller.addEvent(event);
      controller.removeEvent(event);
      expect(controller.byId(id), isNull);
      expect(controller.events, isNot(contains(event)));
    });
  });

  // ─── removeEvents ────────────────────────────────────────────────────────

  group('removeEvents', () {
    test('Removes the specified events and leaves unaffected ones', () {
      final events = List.generate(4, (i) {
        final start = DateTime.utc(2024, 4, i + 1, 9);
        final end = DateTime.utc(2024, 4, i + 1, 10);
        return CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      });
      final ids = controller.addEvents(events);
      controller.removeEvents(events.take(2).toList());
      expect(controller.byId(ids[0]), isNull, reason: 'First removed event should no longer be retrievable.');
      expect(controller.byId(ids[1]), isNull, reason: 'Second removed event should no longer be retrievable.');
      expect(controller.byId(ids[2]), events[2], reason: 'Third event should still be retrievable.');
      expect(controller.byId(ids[3]), events[3], reason: 'Fourth event should still be retrievable.');
    });

    test('Removing an empty list leaves events unchanged', () {
      final start = DateTime.utc(2024, 4, 10, 9);
      final end = DateTime.utc(2024, 4, 10, 10);
      final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      final id = controller.addEvent(event);
      controller.removeEvents([]);
      expect(controller.byId(id), event);
    });
  });

  // ─── removeWhere ─────────────────────────────────────────────────────────

  group('removeWhere', () {
    test('Removes only events matching the predicate', () {
      final start1 = DateTime.utc(2024, 5, 1, 9);
      final end1 = DateTime.utc(2024, 5, 1, 10);
      final event1 = CalendarEvent(dateTimeRange: DateTimeRange(start: start1, end: end1));

      final start2 = DateTime.utc(2024, 5, 2, 9);
      final end2 = DateTime.utc(2024, 5, 2, 10);
      final event2 = CalendarEvent(dateTimeRange: DateTimeRange(start: start2, end: end2));

      final id1 = controller.addEvent(event1);
      final id2 = controller.addEvent(event2);

      controller.removeWhere((key, _) => key == id1);

      expect(controller.byId(id1), isNull, reason: 'event1 should be removed.');
      expect(controller.byId(id2), event2, reason: 'event2 should be unaffected.');
    });

    test('Removes all events when predicate always returns true', () {
      final events = List.generate(3, (i) {
        final start = DateTime.utc(2024, 5, i + 10, 9);
        final end = DateTime.utc(2024, 5, i + 10, 10);
        return CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      });
      controller.addEvents(events);
      controller.removeWhere((_, __) => true);
      expect(controller.events, isEmpty);
    });
  });

  // ─── clearEvents ─────────────────────────────────────────────────────────

  group('clearEvents', () {
    test('Removes all events', () {
      final events = List.generate(5, (i) {
        final start = DateTime.utc(2024, 6, i + 1, 9);
        final end = DateTime.utc(2024, 6, i + 1, 10);
        return CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      });
      controller.addEvents(events);
      expect(controller.events, isNotEmpty);
      controller.clearEvents();
      expect(controller.events, isEmpty);
    });

    test('Adding events after clearEvents works correctly', () {
      final start = DateTime.utc(2024, 7, 1, 9);
      final end = DateTime.utc(2024, 7, 1, 10);
      controller.addEvent(CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end)));
      controller.clearEvents();

      final start2 = DateTime.utc(2024, 7, 5, 14);
      final end2 = DateTime.utc(2024, 7, 5, 15);
      final secondEvent = CalendarEvent(dateTimeRange: DateTimeRange(start: start2, end: end2));
      final id = controller.addEvent(secondEvent);
      expect(controller.byId(id), secondEvent);
      expect(controller.events.length, 1);
    });
  });

  // ─── ChangeNotifier ──────────────────────────────────────────────────────

  group('ChangeNotifier', () {
    test('addEvent notifies listeners', () {
      var notified = false;
      controller.addListener(() => notified = true);
      final start = DateTime.utc(2024, 8, 1, 9);
      final end = DateTime.utc(2024, 8, 1, 10);
      controller.addEvent(CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end)));
      expect(notified, isTrue);
    });

    test('addEvents notifies listeners', () {
      var notified = false;
      controller.addListener(() => notified = true);
      final events = List.generate(2, (i) {
        final start = DateTime.utc(2024, 8, i + 5, 9);
        final end = DateTime.utc(2024, 8, i + 5, 10);
        return CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      });
      controller.addEvents(events);
      expect(notified, isTrue);
    });

    test('removeEvent notifies listeners', () {
      var notified = false;
      final start = DateTime.utc(2024, 8, 2, 9);
      final end = DateTime.utc(2024, 8, 2, 10);
      final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      controller.addEvent(event);
      controller.addListener(() => notified = true);
      controller.removeEvent(event);
      expect(notified, isTrue);
    });

    test('removeById notifies listeners', () {
      var notified = false;
      final start = DateTime.utc(2024, 8, 9, 9);
      final end = DateTime.utc(2024, 8, 9, 10);
      final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      final id = controller.addEvent(event);
      controller.addListener(() => notified = true);
      controller.removeById(id);
      expect(notified, isTrue);
    });

    test('clearEvents notifies listeners', () {
      var notified = false;
      controller.addListener(() => notified = true);
      controller.clearEvents();
      expect(notified, isTrue);
    });

    test('updateEvent notifies listeners', () {
      var notified = false;
      final start = DateTime.utc(2024, 8, 3, 9);
      final end = DateTime.utc(2024, 8, 3, 10);
      final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      controller.addEvent(event);
      controller.addListener(() => notified = true);
      final updatedEvent = CalendarEvent(
        dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 8, 3, 11), end: DateTime.utc(2024, 8, 3, 12)),
      );
      controller.updateEvent(event: event, updatedEvent: updatedEvent);
      expect(notified, isTrue);
    });
  });

  // ─── eventsFromDateTimeRange edge cases ──────────────────────────────────

  group('eventsFromDateTimeRange edge cases', () {
    test('Event not returned for a range it does not overlap', () {
      final start = DateTime.utc(2024, 9, 1, 10);
      final end = DateTime.utc(2024, 9, 1, 11);
      final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      controller.addEvent(event);
      final range = InternalDateTimeRange(start: InternalDateTime(2024, 9, 10), end: InternalDateTime(2024, 9, 11));
      expect(controller.eventsFromDateTimeRange(range), isNot(contains(event)));
    });

    test('Multiple events in the same range are all returned', () {
      final events = List.generate(3, (i) {
        final start = DateTime.utc(2024, 10, 5, 9 + i);
        final end = DateTime.utc(2024, 10, 5, 10 + i);
        return CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      });
      controller.addEvents(events);
      final range = InternalDateTimeRange(start: InternalDateTime(2024, 10, 5), end: InternalDateTime(2024, 10, 6));
      final result = controller.eventsFromDateTimeRange(range);
      for (final event in events) {
        expect(result, contains(event));
      }
    });

    test('Removed event is no longer returned from range query', () {
      final start = DateTime.utc(2024, 11, 1, 10);
      final end = DateTime.utc(2024, 11, 1, 11);
      final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      controller.addEvent(event);
      controller.removeEvent(event);
      final range = InternalDateTimeRange(start: InternalDateTime(2024, 11, 1), end: InternalDateTime(2024, 11, 2));
      expect(controller.eventsFromDateTimeRange(range), isNot(contains(event)));
    });

    test('Updated event is found in new range but not old range', () {
      final start = DateTime.utc(2024, 12, 1, 10);
      final end = DateTime.utc(2024, 12, 1, 11);
      final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      controller.addEvent(event);

      final newStart = DateTime.utc(2024, 12, 20, 14);
      final newEnd = DateTime.utc(2024, 12, 20, 15);
      final updatedEvent = CalendarEvent(dateTimeRange: DateTimeRange(start: newStart, end: newEnd));
      controller.updateEvent(event: event, updatedEvent: updatedEvent);

      final oldRange = InternalDateTimeRange(
        start: InternalDateTime(2024, 12, 1),
        end: InternalDateTime(2024, 12, 2),
      );
      final newRange = InternalDateTimeRange(
        start: InternalDateTime(2024, 12, 20),
        end: InternalDateTime(2024, 12, 21),
      );
      expect(controller.eventsFromDateTimeRange(oldRange), isNot(contains(updatedEvent)));
      expect(controller.eventsFromDateTimeRange(newRange), contains(updatedEvent));
    });

    test('Both filters disabled returns empty iterable', () {
      final start = DateTime.utc(2024, 9, 5, 10);
      final end = DateTime.utc(2024, 9, 5, 11);
      final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
      controller.addEvent(event);
      final range = InternalDateTimeRange(start: InternalDateTime(2024, 9, 5), end: InternalDateTime(2024, 9, 6));
      final result = controller.eventsFromDateTimeRange(range, includeMultiDayEvents: false, includeDayEvents: false);
      expect(result, isEmpty);
    });
  });

  // ─── Per-location: add / remove / fetch ──────────────────────────────────

  for (final location in locations) {
    group('[$location] Adding, removing and fetching events', () {
      test('Short event (< 1 day)', () {
        final start = TZDateTime(location, 2024, 1, 15, 10);
        final end = TZDateTime(location, 2024, 1, 15, 11);
        final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
        final id = controller.addEvent(event);
        expect(controller.byId(id), event, reason: 'Event should be retrievable by its id after being added.');

        final range = InternalDateTimeRange(
          start: InternalDateTime.fromExternal(start, location: location),
          end: InternalDateTime.fromExternal(end, location: location),
        );
        expect(controller.eventsFromDateTimeRange(range, location: location), contains(event));
        expect(
          controller.eventsFromDateTimeRange(range, location: location, includeDayEvents: false),
          isEmpty,
        );
        expect(
          controller.eventsFromDateTimeRange(range, location: location, includeMultiDayEvents: false),
          contains(event),
        );
      });

      test('Multi-day event (>= 1 day)', () {
        final start = TZDateTime(location, 2024, 1, 15);
        final end = TZDateTime(location, 2024, 1, 16);
        final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
        final id = controller.addEvent(event);
        expect(controller.byId(id), event, reason: 'Event should be retrievable by its id after being added.');

        final range = InternalDateTimeRange(
          start: InternalDateTime.fromExternal(start, location: location),
          end: InternalDateTime.fromExternal(end, location: location),
        );
        expect(controller.eventsFromDateTimeRange(range, location: location), contains(event));
        expect(
          controller.eventsFromDateTimeRange(range, location: location, includeDayEvents: false),
          contains(event),
        );
        expect(
          controller.eventsFromDateTimeRange(range, location: location, includeMultiDayEvents: false),
          isEmpty,
        );
      });

      test('Zero-duration event', () {
        final start = TZDateTime(location, 2024, 1, 15);
        final end = TZDateTime(location, 2024, 1, 15);
        final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
        final id = controller.addEvent(event);
        expect(controller.byId(id), event, reason: 'Event should be retrievable by its id after being added.');

        final range = InternalDateTimeRange(
          start: InternalDateTime.fromExternal(start, location: location),
          end: InternalDateTime.fromExternal(end, location: location),
        );
        expect(controller.eventsFromDateTimeRange(range, location: location), contains(event));
        expect(
          controller.eventsFromDateTimeRange(range, location: location, includeDayEvents: false),
          isEmpty,
        );
        expect(
          controller.eventsFromDateTimeRange(range, location: location, includeMultiDayEvents: false),
          contains(event),
        );
      });

      test('Remove event by id', () {
        final start = TZDateTime(location, 2024, 1, 15);
        final end = TZDateTime(location, 2024, 1, 16);
        final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
        final id = controller.addEvent(event);
        controller.removeById(id);
        expect(controller.byId(id), isNull, reason: 'Event should not be retrievable after removal.');
      });

      test('Remove event by reference', () {
        final start = TZDateTime(location, 2024, 2, 5);
        final end = TZDateTime(location, 2024, 2, 6);
        final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
        final id = controller.addEvent(event);
        controller.removeEvent(event);
        expect(controller.byId(id), isNull, reason: 'Event should not be retrievable after removal by reference.');
        expect(controller.events, isNot(contains(event)));
      });

      test('Update event: id preserved and new range is queryable', () {
        final start = TZDateTime(location, 2024, 1, 15);
        final end = TZDateTime(location, 2024, 1, 16);
        final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
        final id = controller.addEvent(event);

        final newStart = TZDateTime(location, 2024, 1, 17);
        final newEnd = TZDateTime(location, 2024, 1, 18);
        final updatedEvent = CalendarEvent(dateTimeRange: DateTimeRange(start: newStart, end: newEnd));
        controller.updateEvent(event: event, updatedEvent: updatedEvent);

        expect(updatedEvent.id, id, reason: 'Updated event should retain the original id.');
        expect(controller.byId(id), updatedEvent, reason: 'Updated event should be retrievable by original id.');

        final oldRange = InternalDateTimeRange(
          start: InternalDateTime.fromExternal(start, location: location),
          end: InternalDateTime.fromExternal(end, location: location),
        );
        final newRange = InternalDateTimeRange(
          start: InternalDateTime.fromExternal(newStart, location: location),
          end: InternalDateTime.fromExternal(newEnd, location: location),
        );
        expect(
          controller.eventsFromDateTimeRange(oldRange, location: location),
          isNot(contains(updatedEvent)),
          reason: 'Updated event should not appear in its old range.',
        );
        expect(
          controller.eventsFromDateTimeRange(newRange, location: location),
          contains(updatedEvent),
        );
        expect(
          controller.eventsFromDateTimeRange(newRange, location: location, includeDayEvents: false),
          contains(updatedEvent),
        );
        expect(
          controller.eventsFromDateTimeRange(newRange, location: location, includeMultiDayEvents: false),
          isEmpty,
        );
      });
    });
  }
}
