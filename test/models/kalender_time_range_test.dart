// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/models/kalender_date_time_range.dart';
import 'package:kalender/src/models/kalender_time.dart';
import 'package:kalender/src/models/kalender_time_range.dart';

void main() {
  group('KalenderTimeRange', () {
    const start = KalenderTime(hour: 10, minute: 20);
    const end = KalenderTime(hour: 12, minute: 30);
    final timeOfDayRange = KalenderTimeRange(start: start, end: end);

    test('Start and End', () {
      expect(timeOfDayRange.start, start);
      expect(timeOfDayRange.end, end);
    });

    test('duration', () {
      expect(timeOfDayRange.duration, const Duration(hours: 2, minutes: 11));
    });

    test('coversWholeDay', () {
      expect(timeOfDayRange.coversWholeDay, isFalse);
      expect(KalenderTimeRange.allDay().coversWholeDay, isTrue);
      expect(_range(0, 0, 23, 0).coversWholeDay, isFalse);
      expect(_range(0, 30, 23, 59).coversWholeDay, isFalse);
    });

    group('Constructors', () {
      test('KalenderTimeRange.allDay', () {
        final allDay = KalenderTimeRange.allDay();
        expect(allDay.start, const KalenderTime(hour: 0, minute: 0));
        expect(allDay.end, const KalenderTime(hour: 23, minute: 59));
      });

      test('KalenderTimeRange.forHour', () {
        final hour = KalenderTimeRange.forHour(10);
        expect(hour.start, const KalenderTime(hour: 10, minute: 0));
        expect(hour.end, const KalenderTime(hour: 10, minute: 59));
      });
    });

    group('splitIntoSegments', () {
      test('perfect division', () {
        expect(_range(8, 0, 9, 59).splitIntoSegments(30), [
          _range(8, 0, 8, 29),
          _range(8, 30, 8, 59),
          _range(9, 0, 9, 29),
          _range(9, 30, 9, 59),
        ]);
      });

      test('last segment shorter', () {
        expect(_range(10, 0, 11, 30).splitIntoSegments(60), [_range(10, 0, 10, 59), _range(11, 0, 11, 30)]);
      });

      test('range shorter than segment length', () {
        expect(_range(10, 0, 10, 30).splitIntoSegments(60), [_range(10, 0, 10, 30)]);
      });

      test('single point in time range', () {
        expect(_range(10, 0, 10, 0).splitIntoSegments(30), [_range(10, 0, 10, 0)]);
      });

      test('documentation example', () {
        expect(_range(10, 0, 11, 30).splitIntoSegments(30), [
          _range(10, 0, 10, 29),
          _range(10, 30, 10, 59),
          _range(11, 0, 11, 29),
          _range(11, 30, 11, 30),
        ]);
      });
    });

    group('fromDateTimeRange', () {
      test('takes the hour and minute of each end', () {
        final range = KalenderTimeRange.fromDateTimeRange(
          KalenderDateTimeRange(start: DateTime(2024, 6, 15, 9, 15), end: DateTime(2024, 6, 15, 17, 45)),
        );

        expect(range.start, const KalenderTime(hour: 9, minute: 15));
        expect(range.end, const KalenderTime(hour: 17, minute: 45));
      });

      test('drops second and below', () {
        final range = KalenderTimeRange.fromDateTimeRange(
          KalenderDateTimeRange(
            start: DateTime(2024, 6, 15, 9, 15, 30, 500, 250),
            end: DateTime(2024, 6, 15, 17, 45, 30, 500, 250),
          ),
        );

        expect(range.start, const KalenderTime(hour: 9, minute: 15));
        expect(range.end, const KalenderTime(hour: 17, minute: 45));
      });

      test('a range that starts and ends at the same time of day is empty', () {
        final range = KalenderTimeRange.fromDateTimeRange(
          KalenderDateTimeRange(start: DateTime(2024, 6, 15, 9), end: DateTime(2024, 6, 15, 9)),
        );

        expect(range.start, range.end);
        expect(range.duration, const Duration(minutes: 1));
      });
    });

    group('bounds', () {
      test('rejects an end hour before the start hour', () {
        expect(() => _range(12, 0, 10, 0), throwsAssertionError);
      });

      test('rejects an end minute before the start minute within the same hour', () {
        expect(() => _range(10, 30, 10, 15), throwsAssertionError);
      });

      test('accepts an end equal to the start', () {
        expect(() => _range(10, 30, 10, 30), returnsNormally);
      });
    });

    group('equality', () {
      test('equal values are equal and hash alike', () {
        final a = _range(9, 0, 17, 0);
        final b = _range(9, 0, 17, 0);

        expect(a, b);
        expect(a.hashCode, b.hashCode);
      });

      test('a differing start or end is not equal', () {
        final range = _range(9, 0, 17, 0);

        expect(range, isNot(_range(10, 0, 17, 0)));
        expect(range, isNot(_range(9, 0, 18, 0)));
      });
    });

    group('toString', () {
      test('names both ends', () {
        expect(_range(9, 5, 17, 0).toString(), '09:05 - 17:00');
      });
    });
  });
}

KalenderTimeRange _range(int startHour, int startMinute, int endHour, int endMinute) => KalenderTimeRange(
  start: KalenderTime(hour: startHour, minute: startMinute),
  end: KalenderTime(hour: endHour, minute: endMinute),
);
