import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';

final locationsToTest = [
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

  group('Check that the eventStore was setup correctly.', () {
    test('Check that all locations where added successfully', () {
      expect(locations, controller.eventStore.locations);
    });

    test('Check that requesting an event with a new location works', () {
      final range = InternalDateTimeRange(start: InternalDateTime(2024, 1, 15), end: InternalDateTime(2024, 1, 16));
      final newLocation = getLocation('Asia/Tokyo');
      controller.eventsFromDateTimeRange(range, location: newLocation);
      expect(
        controller.eventStore.locations.contains(newLocation),
        isTrue,
        reason: 'The new location should be added to the event store when requesting events with'
            ' a location that was not previously added.',
      );
    });
  });

  for (final location in locations) {
    group('Adding, Removing and fetching events for $location', () {
      test('Add event shorter than a day', () {
        final start = TZDateTime(location, 2024, 1, 15, 10);
        final end = TZDateTime(location, 2024, 1, 15, 11);
        final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
        final id = controller.addEvent(event);
        expect(controller.byId(id), event, reason: 'The event should be retrievable by its id after being added.');

        final range = InternalDateTimeRange(
          start: InternalDateTime.fromExternal(start, location: location),
          end: InternalDateTime.fromExternal(end, location: location),
        );

        final allEvents = controller.eventsFromDateTimeRange(range, location: location);
        expect(allEvents, contains(event));
        final multiDayEvents = controller.eventsFromDateTimeRange(range, location: location, includeDayEvents: false);
        expect(multiDayEvents, isEmpty);
        final dayEvents = controller.eventsFromDateTimeRange(range, location: location, includeMultiDayEvents: false);
        expect(dayEvents, contains(event));
      });

      test('Add event longer than or equal to a day', () {
        final start = TZDateTime(location, 2024, 1, 15);
        final end = TZDateTime(location, 2024, 1, 16);
        final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
        final id = controller.addEvent(event);
        expect(controller.byId(id), event, reason: 'The event should be retrievable by its id after being added.');

        final range = InternalDateTimeRange(
          start: InternalDateTime.fromExternal(start, location: location),
          end: InternalDateTime.fromExternal(end, location: location),
        );
        final allEvents = controller.eventsFromDateTimeRange(range, location: location);
        expect(allEvents, contains(event));
        final multiDayEvents = controller.eventsFromDateTimeRange(range, location: location, includeDayEvents: false);
        expect(multiDayEvents, contains(event));
        final dayEvents = controller.eventsFromDateTimeRange(range, location: location, includeMultiDayEvents: false);
        expect(dayEvents, isEmpty);
      });

      test('Zero duration events', () {
        final start = TZDateTime(location, 2024, 1, 15);
        final end = TZDateTime(location, 2024, 1, 15);
        final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
        final id = controller.addEvent(event);
        expect(controller.byId(id), event, reason: 'The event should be retrievable by its id after being added.');

        final range = InternalDateTimeRange(
          start: InternalDateTime.fromExternal(start, location: location),
          end: InternalDateTime.fromExternal(end, location: location),
        );
        final allEvents = controller.eventsFromDateTimeRange(range, location: location);
        expect(allEvents, contains(event));
        final multiDayEvents = controller.eventsFromDateTimeRange(range, location: location, includeDayEvents: false);
        expect(multiDayEvents, isEmpty);
        final dayEvents = controller.eventsFromDateTimeRange(range, location: location, includeMultiDayEvents: false);
        expect(dayEvents, contains(event));
      });

      test('Removing events', () {
        final start = TZDateTime(location, 2024, 1, 15);
        final end = TZDateTime(location, 2024, 1, 16);
        final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
        final id = controller.addEvent(event);
        expect(controller.byId(id), event, reason: 'The event should be retrievable by its id after being added.');

        controller.removeById(id);
        expect(controller.byId(id), isNull,
            reason: 'The event should not be retrievable by its id after being removed.');
      });

      test('Updating events', () {
        final start = TZDateTime(location, 2024, 1, 15);
        final end = TZDateTime(location, 2024, 1, 16);
        final event = CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
        final id = controller.addEvent(event);
        expect(controller.byId(id), event, reason: 'The event should be retrievable by its id after being added.');

        final newStart = TZDateTime(location, 2024, 1, 17);
        final newEnd = TZDateTime(location, 2024, 1, 18);
        final updatedEvent = CalendarEvent(dateTimeRange: DateTimeRange(start: newStart, end: newEnd));
        controller.updateEvent(event: event, updatedEvent: updatedEvent);

        expect(controller.byId(id), updatedEvent,
            reason: 'The event should be retrievable by its id after being updated.');

        final range = InternalDateTimeRange(
          start: InternalDateTime.fromExternal(newStart, location: location),
          end: InternalDateTime.fromExternal(newEnd, location: location),
        );
        final allEvents = controller.eventsFromDateTimeRange(range, location: location);
        expect(allEvents, contains(updatedEvent));
        final multiDayEvents = controller.eventsFromDateTimeRange(range, location: location, includeDayEvents: false);
        expect(multiDayEvents, contains(updatedEvent));
        final dayEvents = controller.eventsFromDateTimeRange(range, location: location, includeMultiDayEvents: false);
        expect(dayEvents, isEmpty);
      });
    });
  }

  // TODO: add edge case tests.
}
