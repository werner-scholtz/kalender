import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import 'utilities.dart';

void main() {
  testWithTimeZones(
    body: (timezone, testDates) {
      late DefaultEventsController eventsController;

      setUp(() {
        eventsController = DefaultEventsController();
      });

      group('DefaultEventsController', () {
        group('addEvent and addEvents', () {
          test('adds multiple events correctly', () {
            // Add multiple events to the controller
            eventsController.addEvents(
              testDates.map((date) {
                final local = date.asLocal;
                final range = DateTimeRange(start: local.startOfDay, end: local.endOfDay);
                return CalendarEvent(dateTimeRange: range);
              }).toList(),
            );

            expect(eventsController.events.length, testDates.length);
          });

          test('adds single day events correctly', () {
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

            expect(eventsController.events.length, testDates.length);
          });

          test('adds zero duration events at start of day', () {
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

            expect(eventsController.events.length, testDates.length);
          });

          test('adds zero duration events during the day', () {
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

            expect(eventsController.events.length, testDates.length);
          });

          test('accumulates events correctly when adding multiple times', () {
            const totalSets = 4;
            var expectedCount = 0;

            for (var i = 0; i < totalSets; i++) {
              eventsController.addEvents(
                testDates.map((date) {
                  final local = date.asLocal.startOfDay;
                  final start = i == 0 ? local : local.copyWith(hour: i);
                  final end = i == 0 ? local.endOfDay : local.copyWith(hour: i + 1);
                  return CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: end));
                }).toList(),
              );
              expectedCount += testDates.length;
              expect(eventsController.events.length, expectedCount);
            }
          });
        });
        group('eventsFromDateTimeRange', () {
          setUp(() {
            // Add test events for querying
            eventsController.addEvents([
              // Multi-day events
              ...testDates.map((date) {
                final local = date.asLocal;
                return CalendarEvent(
                  dateTimeRange: DateTimeRange(start: local.startOfDay, end: local.endOfDay),
                );
              }),
              // Single hour events
              ...testDates.map((date) {
                final local = date.asLocal.startOfDay;
                return CalendarEvent(
                  dateTimeRange: DateTimeRange(start: local.copyWith(hour: 1), end: local.copyWith(hour: 2)),
                );
              }),
              // Zero duration events at start of day
              ...testDates.map((date) {
                final local = date.asLocal.startOfDay;
                return CalendarEvent(
                  dateTimeRange: DateTimeRange(start: local, end: local),
                );
              }),
              // Zero duration events during the day
              ...testDates.map((date) {
                final local = date.asLocal.startOfDay;
                return CalendarEvent(
                  dateTimeRange: DateTimeRange(start: local.copyWith(hour: 1), end: local.copyWith(hour: 1)),
                );
              }),
            ]);
          });

          test('returns only multi-day events when includeMultiDayEvents is true', () {
            for (final date in testDates) {
              final range = DateTimeRange(start: date.asUtc.startOfDay, end: date.asUtc.endOfDay);
              final events = eventsController.eventsFromDateTimeRange(
                range,
                null,
                includeMultiDayEvents: true,
                includeDayEvents: false,
              );

              expect(events.length, 1, reason: 'Should return exactly 1 multi-day event for $date');
            }
          });

          test('returns only day events when includeDayEvents is true', () {
            for (final date in testDates) {
              final range = DateTimeRange(start: date.asUtc.startOfDay, end: date.asUtc.endOfDay);
              final events = eventsController.eventsFromDateTimeRange(
                range,
                null,
                includeMultiDayEvents: false,
                includeDayEvents: true,
              );

              expect(events.length, 3, reason: 'Should return exactly 3 day events for $date');
            }
          });

          test('returns all events when both flags are true', () {
            for (final date in testDates) {
              final range = DateTimeRange(start: date.asUtc.startOfDay, end: date.asUtc.endOfDay);
              final events = eventsController.eventsFromDateTimeRange(
                range,
                null,
                includeMultiDayEvents: true,
                includeDayEvents: true,
              );

              expect(events.length, 4, reason: 'Should return all 4 events for $date');
            }
          });
        });
        group('removeEvent', () {
          test('removes single event successfully', () {
            final event = CalendarEvent(
              dateTimeRange: DateTimeRange(
                start: DateTime(2025, 1, 1, 10),
                end: DateTime(2025, 1, 1, 11),
              ),
            );
            eventsController.addEvent(event);
            final initialCount = eventsController.events.length;

            eventsController.removeEvent(event);

            expect(eventsController.events.length, initialCount - 1);
            expect(eventsController.events.contains(event), false);
          });

          test('throws assertion error when removing non-existent event', () {
            final initialCount = eventsController.events.length;
            final fakeEvent = CalendarEvent(
              dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 2)),
            );

            expect(
              () => eventsController.removeEvent(fakeEvent),
              throwsA(isA<AssertionError>()),
              reason: 'Should throw AssertionError when removing non-existent event',
            );

            expect(eventsController.events.length, initialCount);
          });
        });

        group('removeEvents', () {
          test('removes multiple events successfully', () {
            final events = [
              CalendarEvent(
                dateTimeRange: DateTimeRange(
                  start: DateTime(2025, 1, 1, 10),
                  end: DateTime(2025, 1, 1, 11),
                ),
              ),
              CalendarEvent(
                dateTimeRange: DateTimeRange(
                  start: DateTime(2025, 1, 2, 10),
                  end: DateTime(2025, 1, 2, 11),
                ),
              ),
            ];
            eventsController.addEvents(events);
            final initialCount = eventsController.events.length;

            eventsController.removeEvents(events);

            expect(eventsController.events.length, initialCount - 2);
            for (final event in events) {
              expect(eventsController.events.contains(event), false);
            }
          });

          test('handles empty list without errors', () {
            final initialCount = eventsController.events.length;

            eventsController.removeEvents([]);

            expect(eventsController.events.length, initialCount);
          });
        });

        group('removeById', () {
          test('removes event by valid id successfully', () {
            final event = CalendarEvent(
              dateTimeRange: DateTimeRange(
                start: DateTime(2025, 1, 1, 10),
                end: DateTime(2025, 1, 1, 11),
              ),
            );
            final eventId = eventsController.addEvent(event);
            final initialCount = eventsController.events.length;

            eventsController.removeById(eventId);

            expect(eventsController.events.length, initialCount - 1);
            expect(eventsController.byId(eventId), null);
          });

          test('throws assertion error when removing by non-existent id', () {
            final initialCount = eventsController.events.length;
            const nonExistentId = 99999;

            expect(
              () => eventsController.removeById(nonExistentId),
              throwsA(isA<AssertionError>()),
              reason: 'Should throw AssertionError when removing by non-existent id',
            );

            expect(eventsController.events.length, initialCount);
          });
        });

        group('clearEvents', () {
          test('removes all events successfully', () {
            // Add some events first
            eventsController.addEvents([
              CalendarEvent(
                dateTimeRange: DateTimeRange(
                  start: DateTime(2025, 1, 1, 10),
                  end: DateTime(2025, 1, 1, 11),
                ),
              ),
              CalendarEvent(
                dateTimeRange: DateTimeRange(
                  start: DateTime(2025, 1, 2, 10),
                  end: DateTime(2025, 1, 2, 11),
                ),
              ),
            ]);
            expect(eventsController.events.isNotEmpty, true);

            eventsController.clearEvents();

            expect(eventsController.events.isEmpty, true);
            expect(eventsController.events.length, 0);
          });

          test('works correctly when no events exist', () {
            expect(eventsController.events.isEmpty, true);

            eventsController.clearEvents();

            expect(eventsController.events.isEmpty, true);
            expect(eventsController.events.length, 0);
          });
        });

        group('updateEvent', () {
          test('updates event with new data successfully', () {
            final originalEvent = CalendarEvent(
              dateTimeRange: DateTimeRange(
                start: DateTime(2025, 6, 1, 10),
                end: DateTime(2025, 6, 1, 11),
              ),
            );
            final originalId = eventsController.addEvent(originalEvent);

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
            expect(updatedEvent.id, originalId);

            // The updated event should be retrievable by id
            final retrievedEvent = eventsController.byId(originalId);
            expect(retrievedEvent, isNotNull);
            expect(retrievedEvent!.dateTimeRange.start, DateTime(2025, 6, 1, 14));
            expect(retrievedEvent.dateTimeRange.end, DateTime(2025, 6, 1, 15));
          });

          test('preserves event id after update', () {
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
          test('retrieves event by valid id successfully', () {
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
