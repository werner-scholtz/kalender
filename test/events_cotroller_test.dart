import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions/internal.dart';

import 'utilities.dart';

void main() {
  testWithTimeZones(
    body: (timezone, testDates) {
      final eventsController = DefaultEventsController();

      group('Test DefaultEventsController', () {
        test('addEvent', () {
          // Add multiple events to the controller
          eventsController.addEvents(
            testDates.map((date) {
              final local = date.asLocal;
              final range = DateTimeRange(start: local.startOfDay, end: local.endOfDay);
              return CalendarEvent(dateTimeRange: range);
            }).toList(),
          );

          expect(eventsController.events.length, testDates.length);

          // Add single day events to the controller
          eventsController.addEvents(
            testDates.map(
              (date) {
                final local = date.asLocal.startOfDay;
                final range = DateTimeRange(start: local.copyWith(hour: 1), end: local.copyWith(hour: 2));
                return CalendarEvent(dateTimeRange: range);
              },
            ).toList(),
          );

          expect(eventsController.events.length, testDates.length * 2);

          // Add zero duration events (start of day) to the controller
          eventsController.addEvents(
            testDates.map(
              (date) {
                final local = date.asLocal.startOfDay;
                final range = DateTimeRange(start: local, end: local);
                return CalendarEvent(dateTimeRange: range);
              },
            ).toList(),
          );

          expect(eventsController.events.length, testDates.length * 3);

          // Add zero duration events (during the day) to the controller
          eventsController.addEvents(
            testDates.map(
              (date) {
                final local = date.asLocal.startOfDay;
                final range = DateTimeRange(start: local.copyWith(hour: 1), end: local.copyWith(hour: 1));
                return CalendarEvent(dateTimeRange: range);
              },
            ).toList(),
          );

          expect(eventsController.events.length, testDates.length * 4);
        });
        group('eventsFromDateTimeRange', () {
          test('only includeMultiDayEvents', () {
            for (final date in testDates) {
              final range = DateTimeRange(start: date.asUtc.startOfDay, end: date.asUtc.endOfDay);
              final events = eventsController.eventsFromDateTimeRange(
                range,
                includeMultiDayEvents: true,
                includeDayEvents: false,
              );

              expect(events.length, 1);
            }
          });
          test('only includeDayEvents', () {
            for (final date in testDates) {
              final range = DateTimeRange(start: date.asUtc.startOfDay, end: date.asUtc.endOfDay);
              final events = eventsController.eventsFromDateTimeRange(
                range,
                includeMultiDayEvents: false,
                includeDayEvents: true,
              );

              expect(events.length, 3);
            }
          });
          test('includeDayEvents & includeMultiDayEvents', () {
            for (final date in testDates) {
              final range = DateTimeRange(start: date.asUtc.startOfDay, end: date.asUtc.endOfDay);
              final events = eventsController.eventsFromDateTimeRange(
                range,
                includeMultiDayEvents: true,
                includeDayEvents: true,
              );

              expect(events.length, 4);
            }
          });
        });
        group('removeEvent', () {
          test('remove single event', () {
            final initialCount = eventsController.events.length;
            final eventToRemove = eventsController.events.first;

            eventsController.removeEvent(eventToRemove);

            expect(eventsController.events.length, initialCount - 1);
            expect(eventsController.events.contains(eventToRemove), false);
          });

          test('removing non-existent event', () {
            final initialCount = eventsController.events.length;
            final fakeEvent = CalendarEvent(
              dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 2)),
            );

            try {
              eventsController.removeEvent(fakeEvent);
            } catch (e) {
              expect(e, isA<AssertionError>());
            }

            expect(eventsController.events.length, initialCount);
          });
        });

        group('removeEvents', () {
          test('removes multiple events', () {
            final initialCount = eventsController.events.length;
            final eventsToRemove = eventsController.events.take(2).toList();
            eventsController.removeEvents(eventsToRemove);
            expect(eventsController.events.length, initialCount - 2);
            for (final event in eventsToRemove) {
              expect(eventsController.events.contains(event), false);
            }
          });

          test('remove empty list', () {
            final initialCount = eventsController.events.length;
            eventsController.removeEvents([]);
            expect(eventsController.events.length, initialCount);
          });
        });

        group('removeById', () {
          test('removes event by valid id', () {
            final initialCount = eventsController.events.length;
            final eventToRemove = eventsController.events.first;
            final eventId = eventToRemove.id;

            eventsController.removeById(eventId);

            expect(eventsController.events.length, initialCount - 1);
            expect(eventsController.byId(eventId), null);
          });

          test('removing by non-existent id does not affect other events', () {
            final initialCount = eventsController.events.length;
            const nonExistentId = 99999;

            try {
              eventsController.removeById(nonExistentId);
            } catch (e) {
              expect(e, isA<AssertionError>());
            }

            expect(eventsController.events.length, initialCount);
          });
        });

        group('clearEvents', () {
          test('removes all events', () {
            expect(eventsController.events.isNotEmpty, true);

            eventsController.clearEvents();

            expect(eventsController.events.isEmpty, true);
            expect(eventsController.events.length, 0);
          });
        });

        group('updateEvent', () {
          test('updates event with new data', () {
            // Add a fresh event to update
            final originalEvent = CalendarEvent(
              dateTimeRange: DateTimeRange(
                start: DateTime(2025, 6, 1, 10),
                end: DateTime(2025, 6, 1, 11),
              ),
            );
            eventsController.addEvent(originalEvent);

            final updatedEvent = CalendarEvent(
              dateTimeRange: DateTimeRange(
                start: DateTime(2025, 6, 1, 14),
                end: DateTime(2025, 6, 1, 15),
              ),
            );

            eventsController.updateEvent(
              event: originalEvent,
              updatedEvent: updatedEvent,
            );

            // The updated event should have the same id as the original
            expect(updatedEvent.id, originalEvent.id);

            // The updated event should be retrievable by id
            final retrievedEvent = eventsController.byId(originalEvent.id);
            expect(retrievedEvent, isNotNull);
            expect(retrievedEvent!.dateTimeRange.start, DateTime(2025, 6, 1, 14));
            expect(retrievedEvent.dateTimeRange.end, DateTime(2025, 6, 1, 15));
          });

          test('update preserves event id', () {
            final originalEvent = CalendarEvent(
              dateTimeRange: DateTimeRange(
                start: DateTime(2025, 6, 2, 10),
                end: DateTime(2025, 6, 2, 11),
              ),
            );
            final eventId = eventsController.addEvent(originalEvent);

            final updatedEvent = CalendarEvent(
              dateTimeRange: DateTimeRange(
                start: DateTime(2025, 6, 2, 16),
                end: DateTime(2025, 6, 2, 17),
              ),
            );

            eventsController.updateEvent(
              event: originalEvent,
              updatedEvent: updatedEvent,
            );

            expect(updatedEvent.id, eventId);
            expect(eventsController.byId(eventId), updatedEvent);
          });
        });

        group('byId', () {
          test('retrieves event by valid id', () {
            final event = CalendarEvent(
              dateTimeRange: DateTimeRange(
                start: DateTime(2025, 7, 1, 9),
                end: DateTime(2025, 7, 1, 10),
              ),
            );
            final eventId = eventsController.addEvent(event);
            final retrievedEvent = eventsController.byId(eventId);

            expect(retrievedEvent, isNotNull);
            expect(retrievedEvent!.id, eventId);
            expect(retrievedEvent.dateTimeRange, event.dateTimeRange);
          });

          test('returns null for non-existent id', () {
            const nonExistentId = 88888;
            final retrievedEvent = eventsController.byId(nonExistentId);
            expect(retrievedEvent, null);
          });

          test('returns null for removed event id', () {
            final event = CalendarEvent(
              dateTimeRange: DateTimeRange(
                start: DateTime(2025, 7, 2, 9),
                end: DateTime(2025, 7, 2, 10),
              ),
            );
            final eventId = eventsController.addEvent(event);

            // Verify event exists
            expect(eventsController.byId(eventId), isNotNull);

            // Remove the event
            eventsController.removeById(eventId);

            // Verify event is no longer retrievable
            expect(eventsController.byId(eventId), null);
          });
        });
      });
    },
  );
}
