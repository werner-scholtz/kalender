import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/models/time_of_day_range.dart';

void main() {
  group('TimeOfDayRange Tests', () {
    group('Functions', () {
      const start = TimeOfDay(hour: 10, minute: 20);
      const end = TimeOfDay(hour: 12, minute: 30);
      final timeOfDayRange = TimeOfDayRange(start: start, end: end);

      test('Start and End', () {
        expect(timeOfDayRange.start, start);
        expect(timeOfDayRange.end, end);
      });

      test('duration', () {
        expect(timeOfDayRange.duration, const Duration(hours: 2, minutes: 11));
      });
    });

    group('Constructors', () {
      test('TimeOfDayRange.allDay', () {
        final allDay = TimeOfDayRange.allDay();
        expect(allDay.start, const TimeOfDay(hour: 0, minute: 0));
        expect(allDay.end, const TimeOfDay(hour: 23, minute: 59));
      });

      test('TimeOfDayRange.forHour', () {
        final hour = TimeOfDayRange.forHour(10);
        expect(hour.start, const TimeOfDay(hour: 10, minute: 0));
        expect(hour.end, const TimeOfDay(hour: 10, minute: 59));
      });
    });

    group('splitIntoSegments', () {
      test('perfect division', () {
        final range = TimeOfDayRange(
          start: const TimeOfDay(hour: 8, minute: 0),
          end: const TimeOfDay(hour: 9, minute: 59),
        );
        final segments = range.splitIntoSegments(30);
        expect(segments.length, 4);

        expect(
          segments[0],
          TimeOfDayRange(start: const TimeOfDay(hour: 8, minute: 0), end: const TimeOfDay(hour: 8, minute: 29)),
        );
        expect(
          segments[1],
          TimeOfDayRange(start: const TimeOfDay(hour: 8, minute: 30), end: const TimeOfDay(hour: 8, minute: 59)),
        );
        expect(
          segments[2],
          TimeOfDayRange(start: const TimeOfDay(hour: 9, minute: 0), end: const TimeOfDay(hour: 9, minute: 29)),
        );
        expect(
          segments[3],
          TimeOfDayRange(start: const TimeOfDay(hour: 9, minute: 30), end: const TimeOfDay(hour: 9, minute: 59)),
        );
      });

      test('last segment shorter', () {
        final range = TimeOfDayRange(
          start: const TimeOfDay(hour: 10, minute: 0),
          end: const TimeOfDay(hour: 11, minute: 30),
        );
        final segments = range.splitIntoSegments(60);
        expect(segments.length, 2);
        expect(
          segments[0],
          TimeOfDayRange(start: const TimeOfDay(hour: 10, minute: 0), end: const TimeOfDay(hour: 10, minute: 59)),
        );
        expect(
          segments[1],
          TimeOfDayRange(start: const TimeOfDay(hour: 11, minute: 0), end: const TimeOfDay(hour: 11, minute: 30)),
        );
      });

      test('range shorter than segment length', () {
        final range = TimeOfDayRange(
          start: const TimeOfDay(hour: 10, minute: 0),
          end: const TimeOfDay(hour: 10, minute: 30),
        );
        final segments = range.splitIntoSegments(60);
        expect(segments.length, 1);
        expect(
          segments[0],
          TimeOfDayRange(start: const TimeOfDay(hour: 10, minute: 0), end: const TimeOfDay(hour: 10, minute: 30)),
        );
      });

      test('single point in time range', () {
        final range = TimeOfDayRange(
          start: const TimeOfDay(hour: 10, minute: 0),
          end: const TimeOfDay(hour: 10, minute: 0),
        );
        final segments = range.splitIntoSegments(30);
        expect(segments.length, 1);
        expect(
          segments[0],
          TimeOfDayRange(start: const TimeOfDay(hour: 10, minute: 0), end: const TimeOfDay(hour: 10, minute: 0)),
        );
      });

      test('documentation example', () {
        final range = TimeOfDayRange(
          start: const TimeOfDay(hour: 10, minute: 0),
          end: const TimeOfDay(hour: 11, minute: 30),
        );
        final segments = range.splitIntoSegments(30);
        expect(segments.length, 4);
        expect(
          segments[0],
          TimeOfDayRange(start: const TimeOfDay(hour: 10, minute: 0), end: const TimeOfDay(hour: 10, minute: 29)),
        );
        expect(
          segments[1],
          TimeOfDayRange(start: const TimeOfDay(hour: 10, minute: 30), end: const TimeOfDay(hour: 10, minute: 59)),
        );
        expect(
          segments[2],
          TimeOfDayRange(start: const TimeOfDay(hour: 11, minute: 0), end: const TimeOfDay(hour: 11, minute: 29)),
        );
        expect(
          segments[3],
          TimeOfDayRange(start: const TimeOfDay(hour: 11, minute: 30), end: const TimeOfDay(hour: 11, minute: 30)),
        );
      });
    });
  });
}
