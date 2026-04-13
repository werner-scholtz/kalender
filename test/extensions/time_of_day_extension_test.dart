import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender_extensions.dart';

void main() {
  group('TimeOfDayExtension', () {
    group('toInternalDateTime', () {
      test('sets the correct hour and minute', () {
        const timeOfDay = TimeOfDay(hour: 14, minute: 30);
        final input = InternalDateTime(2024, 6, 15, 9, 0);
        final result = timeOfDay.toInternalDateTime(input);

        expect(result.year, 2024);
        expect(result.month, 6);
        expect(result.day, 15);
        expect(result.hour, 14);
        expect(result.minute, 30);
      });

      test('zeroes out second, millisecond, and microsecond', () {
        const timeOfDay = TimeOfDay(hour: 10, minute: 15);
        final input = InternalDateTime.fromDateTime(
          DateTime(2024, 6, 15, 9, 45, 30, 500, 250),
        );
        final result = timeOfDay.toInternalDateTime(input);

        expect(result.second, 0, reason: 'second should be zeroed');
        expect(result.millisecond, 0, reason: 'millisecond should be zeroed');
        expect(result.microsecond, 0, reason: 'microsecond should be zeroed');
      });
    });

    group('toDateTime', () {
      test('sets the correct hour and minute', () {
        const timeOfDay = TimeOfDay(hour: 8, minute: 0);
        final input = DateTime(2024, 6, 15, 22, 45);
        final result = timeOfDay.toDateTime(input);

        expect(result.year, 2024);
        expect(result.month, 6);
        expect(result.day, 15);
        expect(result.hour, 8);
        expect(result.minute, 0);
      });

      test('zeroes out second, millisecond, and microsecond', () {
        const timeOfDay = TimeOfDay(hour: 12, minute: 30);
        final input = DateTime(2024, 6, 15, 9, 45, 30, 500, 250);
        final result = timeOfDay.toDateTime(input);

        expect(result.second, 0, reason: 'second should be zeroed');
        expect(result.millisecond, 0, reason: 'millisecond should be zeroed');
        expect(result.microsecond, 0, reason: 'microsecond should be zeroed');
      });
    });
  });
}
