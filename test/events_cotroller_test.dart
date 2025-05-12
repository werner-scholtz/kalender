import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

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
              final events = eventsController.eventsFromDateTimeRange(
                DateTimeRange(start: date.startOfDay, end: date.endOfDay),
                includeMultiDayEvents: true,
                includeDayEvents: false,
              );

              expect(events.length, 1);
            }
          });
          test('only includeDayEvents', () {
            for (final date in testDates) {
              final events = eventsController.eventsFromDateTimeRange(
                DateTimeRange(start: date.startOfDay, end: date.endOfDay),
                includeMultiDayEvents: false,
                includeDayEvents: true,
              );

              expect(events.length, 3);
            }
          });
          test('includeDayEvents & includeMultiDayEvents', () {
            for (final date in testDates) {
              final events = eventsController.eventsFromDateTimeRange(
                DateTimeRange(start: date.startOfDay, end: date.endOfDay),
                includeMultiDayEvents: true,
                includeDayEvents: true,
              );

              expect(events.length, 4);
            }
          });
        });
      });
    },
  );
}
