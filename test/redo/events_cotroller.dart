// TODO: REDO this test.

// final locationsToTest = [
//   'UTC',
//   'Africa/Johannesburg',
//   'America/New_York',
//   'Europe/London',
//   'Australia/Sydney',
// ];

// List<TZDateTime> dates(Location location) => datesToTest
//     .map(
//       (date) => TZDateTime(location, date.year, date.month, date.day, date.hour),
//     )
//     .toList();

// void main() {
//   initializeTimeZones();
//   final locations = locationsToTest.map(getLocation).toList();

//   final eventsController = DefaultEventsController();
//   for (final location in locations) {
//     final datesToTest = dates(location);

//     group('Test DefaultEventsController', () {
//       test('add event', () {
//         eventsController.clearEvents();

//         // Add multiple events to the controller (multi-day)
//         eventsController.addEvents(
//           datesToTest.map((date) {
//             final range = DateTimeRange(
//               start: DateTime(date.year, date.month, date.day),
//               end: DateTime(date.year, date.month, date.day + 1),
//             );
//             return CalendarEvent(dateTimeRange: range);
//           }).toList(),
//         );
//         expect(eventsController.events.length, datesToTest.length);

//         // Add single day events to the controller (single-day)
//         eventsController.addEvents(
//           datesToTest.map(
//             (date) {
//               final range = DateTimeRange(start: date.copyWith(hour: 1), end: date.copyWith(hour: 2));
//               return CalendarEvent(dateTimeRange: range);
//             },
//           ).toList(),
//         );
//         expect(eventsController.events.length, datesToTest.length * 2);

//         // Add zero duration events (start of day) to the controller (single-day)
//         eventsController.addEvents(
//           datesToTest.map(
//             (date) {
//               final start = DateTime(date.year, date.month, date.day);
//               final range = DateTimeRange(start: start, end: start);
//               return CalendarEvent(dateTimeRange: range);
//             },
//           ).toList(),
//         );
//         expect(eventsController.events.length, datesToTest.length * 3);

//         // Add zero duration events (during the day) to the controller (single-day)
//         eventsController.addEvents(
//           datesToTest.map(
//             (date) {
//               final range = DateTimeRange(start: date.copyWith(hour: 1), end: date.copyWith(hour: 1));
//               return CalendarEvent(dateTimeRange: range);
//             },
//           ).toList(),
//         );
//         expect(eventsController.events.length, datesToTest.length * 4);
//       });

//       group('eventsFromDateTimeRange', () {
//         test('only includeMultiDayEvents', () {
//           for (final date in datesToTest) {
//             final range = InternalDateTimeRange(
//               start: InternalDateTime(date.year, date.month, date.day),
//               end: InternalDateTime(date.year, date.month, date.day + 1),
//             );
//             final events = eventsController.eventsFromDateTimeRange(
//               range,
//               includeMultiDayEvents: true,
//               includeDayEvents: false,
//               location: null,
//             );

//             expect(events.length, 1, reason: 'Failed for date: $date in location: ${location.name}');
//           }
//         });
//         test('only includeDayEvents', () {
//           for (final date in datesToTest) {
//             final range = InternalDateTimeRange(
//               start: InternalDateTime(date.year, date.month, date.day),
//               end: InternalDateTime(date.year, date.month, date.day + 1),
//             );
//             final events = eventsController.eventsFromDateTimeRange(
//               range,
//               includeMultiDayEvents: false,
//               includeDayEvents: true,
//               location: null,
//             );

//             expect(events.length, 3, reason: 'Failed for date: $date in location: ${location.name}');
//           }
//         });

//         test('includeDayEvents & includeMultiDayEvents', () {
//           for (final date in datesToTest) {
//             final range = InternalDateTimeRange(
//               start: InternalDateTime(date.year, date.month, date.day),
//               end: InternalDateTime(date.year, date.month, date.day + 1),
//             );
//             final events = eventsController.eventsFromDateTimeRange(
//               range,
//               includeMultiDayEvents: true,
//               includeDayEvents: true,
//               location: null,
//             );

//             expect(events.length, 4, reason: 'Failed for date: $date in location: ${location.name}');
//           }
//         });
//       });

//       group('removeEvent', () {
//         test('remove single event', () {
//           final initialCount = eventsController.events.length;
//           final eventToRemove = eventsController.events.first;

//           eventsController.removeEvent(eventToRemove);

//           expect(eventsController.events.length, initialCount - 1);
//           expect(eventsController.events.contains(eventToRemove), false);
//         });

//         test('removing non-existent event', () {
//           final initialCount = eventsController.events.length;
//           final fakeEvent = CalendarEvent(
//             dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 2)),
//           );

//           try {
//             eventsController.removeEvent(fakeEvent);
//           } catch (e) {
//             expect(e, isA<AssertionError>());
//           }

//           expect(eventsController.events.length, initialCount);
//         });
//       });

//       group('removeEvents', () {
//         test('removes multiple events', () {
//           final initialCount = eventsController.events.length;
//           final eventsToRemove = eventsController.events.take(2).toList();
//           eventsController.removeEvents(eventsToRemove);
//           expect(eventsController.events.length, initialCount - 2);
//           for (final event in eventsToRemove) {
//             expect(eventsController.events.contains(event), false);
//           }
//         });

//         test('remove empty list', () {
//           final initialCount = eventsController.events.length;
//           eventsController.removeEvents([]);
//           expect(eventsController.events.length, initialCount);
//         });
//       });

//       group('removeById', () {
//         test('removes event by valid id', () {
//           final initialCount = eventsController.events.length;
//           final eventToRemove = eventsController.events.first;
//           final eventId = eventToRemove.id;

//           eventsController.removeById(eventId);

//           expect(eventsController.events.length, initialCount - 1);
//           expect(eventsController.byId(eventId), null);
//         });

//         test('removing by non-existent id does not affect other events', () {
//           final initialCount = eventsController.events.length;
//           const nonExistentId = 99999;

//           try {
//             eventsController.removeById(nonExistentId);
//           } catch (e) {
//             expect(e, isA<AssertionError>());
//           }

//           expect(eventsController.events.length, initialCount);
//         });
//       });
//       group('clearEvents', () {
//         test('removes all events', () {
//           expect(eventsController.events.isNotEmpty, true);

//           eventsController.clearEvents();

//           expect(eventsController.events.isEmpty, true);
//           expect(eventsController.events.length, 0);
//         });
//       });
//       group('updateEvent', () {
//         test('updates event with new data', () {
//           // Add a fresh event to update
//           final originalEvent = CalendarEvent(
//             dateTimeRange: DateTimeRange(
//               start: TZDateTime(location, 2025, 6, 1, 10),
//               end: TZDateTime(location, 2025, 6, 1, 11),
//             ),
//           );
//           eventsController.addEvent(originalEvent);

//           final updatedEvent = CalendarEvent(
//             dateTimeRange: DateTimeRange(
//               start: TZDateTime(location, 2025, 6, 1, 14),
//               end: TZDateTime(location, 2025, 6, 1, 15),
//             ),
//           );

//           eventsController.updateEvent(
//             event: originalEvent,
//             updatedEvent: updatedEvent,
//           );

//           // The updated event should have the same id as the original
//           expect(updatedEvent.id, originalEvent.id);

//           // The updated event should be retrievable by id
//           final retrievedEvent = eventsController.byId(originalEvent.id);
//           expect(retrievedEvent, isNotNull);
//           expect(retrievedEvent!.dateTimeRange.start.toUtc(), TZDateTime(location, 2025, 6, 1, 14).toUtc());
//           expect(retrievedEvent.dateTimeRange.end.toUtc(), TZDateTime(location, 2025, 6, 1, 15).toUtc());
//         });

//         test('update preserves event id', () {
//           final originalEvent = CalendarEvent(
//             dateTimeRange: DateTimeRange(
//               start: DateTime(2025, 6, 2, 10),
//               end: DateTime(2025, 6, 2, 11),
//             ),
//           );
//           final eventId = eventsController.addEvent(originalEvent);

//           final updatedEvent = CalendarEvent(
//             dateTimeRange: DateTimeRange(
//               start: DateTime(2025, 6, 2, 16),
//               end: DateTime(2025, 6, 2, 17),
//             ),
//           );

//           eventsController.updateEvent(
//             event: originalEvent,
//             updatedEvent: updatedEvent,
//           );

//           expect(updatedEvent.id, eventId);
//           expect(eventsController.byId(eventId), updatedEvent);
//         });
//       });

//       group('byId', () {
//         test('retrieves event by valid id', () {
//           final event = CalendarEvent(
//             dateTimeRange: DateTimeRange(
//               start: DateTime(2025, 7, 1, 9),
//               end: DateTime(2025, 7, 1, 10),
//             ),
//           );
//           final eventId = eventsController.addEvent(event);
//           final retrievedEvent = eventsController.byId(eventId);

//           expect(retrievedEvent, isNotNull);
//           expect(retrievedEvent!.id, eventId);
//           expect(retrievedEvent.dateTimeRange, event.dateTimeRange);
//         });

//         test('returns null for non-existent id', () {
//           const nonExistentId = 88888;
//           final retrievedEvent = eventsController.byId(nonExistentId);
//           expect(retrievedEvent, null);
//         });

//         test('returns null for removed event id', () {
//           final event = CalendarEvent(
//             dateTimeRange: DateTimeRange(
//               start: DateTime(2025, 7, 2, 9),
//               end: DateTime(2025, 7, 2, 10),
//             ),
//           );
//           final eventId = eventsController.addEvent(event);

//           // Verify event exists
//           expect(eventsController.byId(eventId), isNotNull);

//           // Remove the event
//           eventsController.removeById(eventId);

//           // Verify event is no longer retrievable
//           expect(eventsController.byId(eventId), null);
//         });
//       });
//     });
//   }
// }
