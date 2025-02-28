import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kalender/kalender_extensions.dart';

import 'data.dart';

Future<void> main() async {
  final timezone = Platform.environment['TZ'] ?? 'UTC';
  group(timezone, () {
    final isUtc = timezone == 'UTC';
    final testDates = isUtc ? datesToTest.map((e) => e.toUtc()) : datesToTest;
    group('isToday', () {
      test('Is today - local', () {
        final now = DateTime.now();
        expect(now.isToday, isTrue);
      });

      test('Is not today - local', () {
        final pastDate = DateTime(2023, 1, 1);
        expect(pastDate.isToday, isFalse);
      });

      test('Is today - utc', () {
        final now = DateTime.now().toUtc();
        expect(now.isToday, isTrue);
      });

      test('Is not today - utc', () {
        final pastDate = DateTime.utc(2023, 1, 1);
        expect(pastDate.isToday, isFalse);
      });
    });

    group('isSameDay()', () {
      test('Same day - local', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final sameDay = DateTime(2024, 1, 15);
        expect(date.isSameDay(sameDay), isTrue);
      });

      test('Not same day - local', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final notSameDay = DateTime(2024, 1, 16);
        expect(date.isSameDay(notSameDay), isFalse);
      });

      test('Same day - utc', () {
        final date = DateTime.utc(2024, 1, 15, 10, 30);
        final sameDay = DateTime.utc(2024, 1, 15);
        expect(date.isSameDay(sameDay), isTrue);
      });

      test('Not same day - utc', () {
        final date = DateTime.utc(2024, 1, 15, 10, 30);
        final notSameDay = DateTime.utc(2024, 1, 16);
        expect(date.isSameDay(notSameDay), isFalse);
      });

      test('Same day - to utc', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final sameDay = date.toUtc();
        expect(date.isSameDay(sameDay), isTrue);
      });

      test('Not same day - to utc', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final notSameDay = date.toUtc().copyWith(day: date.day + 1);
        expect(date.isSameDay(notSameDay), isFalse);
      });
    });

    group('startOfDay', () {
      test('Start of day - local time', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final start = date.startOfDay;
        expect(start.year, 2024);
        expect(start.month, 1);
        expect(start.day, 15);
        expect(start.hour, 0);
        expect(start.minute, 0);
        expect(start.second, 0);
        expect(start.millisecond, 0);
        expect(start.microsecond, 0);
        expect(start.isUtc, date.isUtc);
        expect(start.timeZoneOffset, date.timeZoneOffset);
      });

      for (final date in testDates) {
        test('Start of day - $date', () {
          final start = date.startOfDay;
          expect(start.year, date.year);
          expect(start.month, date.month);
          expect(start.day, date.day);

          // Since the start of the day might be different depending on the DST, we can't check the hour.
          // expect(start.hour, 0);
          expect(start.minute, 0);
          expect(start.second, 0);
          expect(start.millisecond, 0);
          expect(start.microsecond, 0);
          expect(start.isUtc, date.isUtc);
        });
      }
    });

    group('endOfDay', () {
      test('Start of day - local', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final start = date.startOfDay;
        expect(start.year, 2024);
        expect(start.month, 1);
        expect(start.day, 15);
        expect(start.hour, 0);
        expect(start.minute, 0);
        expect(start.second, 0);
        expect(start.millisecond, 0);
        expect(start.microsecond, 0);
        expect(start.isUtc, date.isUtc);
        expect(start.timeZoneOffset, date.timeZoneOffset);
      });
    });

    group('dayRange', () {
      test('Day range - local', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final range = date.dayRange;
        expect(range.start.year, 2024);
        expect(range.start.month, 1);
        expect(range.start.day, 15);
        expect(range.start.hour, 0);
        expect(range.start.minute, 0);
        expect(range.start.second, 0);
        expect(range.start.millisecond, 0);
        expect(range.start.microsecond, 0);
        expect(range.start.isUtc, date.isUtc);
        expect(range.start.timeZoneOffset, date.timeZoneOffset);

        expect(range.end.year, 2024);
        expect(range.end.month, 1);
        expect(range.end.day, 16); // Next day
        expect(range.end.hour, 0);
        expect(range.end.minute, 0);
        expect(range.end.second, 0);
        expect(range.end.millisecond, 0);
        expect(range.end.microsecond, 0);
        expect(range.end.isUtc, date.isUtc);
        expect(range.end.timeZoneOffset, date.timeZoneOffset);
      });
    });

    group('startOfMonth', () {
      test('Start of Month - local', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final startOfMonth = date.startOfMonth;
        expect(startOfMonth, DateTime(2024, 1, 1));
      });
    });

    group('endOfMonth', () {
      test('End of Month - local', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final endOfMonth = date.endOfMonth;
        expect(endOfMonth, DateTime(2024, 2, 1));
      });
    });

    group('monthRange', () {
      test('Month Range - local', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final range = date.monthRange;
        expect(range.start.year, 2024);
        expect(range.start.month, 1);
        expect(range.start.day, 1);
        expect(range.start.hour, 0);
        expect(range.start.minute, 0);
        expect(range.start.second, 0);
        expect(range.start.millisecond, 0);
        expect(range.start.microsecond, 0);
        expect(range.start.isUtc, date.isUtc);
        expect(range.start.timeZoneOffset, date.timeZoneOffset);

        expect(range.end.year, 2024);
        expect(range.end.month, 2);
        expect(range.end.day, 1); // Next month
        expect(range.end.hour, 0);
        expect(range.end.minute, 0);
        expect(range.end.second, 0);
        expect(range.end.millisecond, 0);
        expect(range.end.microsecond, 0);
        expect(range.end.isUtc, date.isUtc);
        expect(range.end.timeZoneOffset, date.timeZoneOffset);
      });
    });

    group('startOfYear', () {
      test('Start of Year - local', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final startOfYear = date.startOfYear;
        expect(startOfYear, DateTime(2024, 1, 1));
      });
    });

    group('endOfYear', () {
      test('End of Year - local', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final endOfYear = date.endOfYear;
        expect(endOfYear, DateTime(2025, 1, 1));
      });
    });

    group('yearRange', () {
      test('Year range - local', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final range = date.yearRange;
        expect(range.start.year, 2024);
        expect(range.start.month, 1);
        expect(range.start.day, 1);
        expect(range.start.hour, 0);
        expect(range.start.minute, 0);
        expect(range.start.second, 0);
        expect(range.start.millisecond, 0);
        expect(range.start.microsecond, 0);
        expect(range.start.isUtc, date.isUtc);
        expect(range.start.timeZoneOffset, date.timeZoneOffset);

        expect(range.end.year, 2025);
        expect(range.end.month, 1);
        expect(range.end.day, 1); // Next year
        expect(range.end.hour, 0);
        expect(range.end.minute, 0);
        expect(range.end.second, 0);
        expect(range.end.millisecond, 0);
        expect(range.end.microsecond, 0);
        expect(range.end.isUtc, date.isUtc);
        expect(range.end.timeZoneOffset, date.timeZoneOffset);
      });
    });

    group('isWithin()', () {
      test('Is within - local', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
        expect(date.isWithin(range), isTrue, reason: '$date is within $range');
        expect(date.isWithin(range, includeStart: false), isTrue, reason: '$date is within $range');
        expect(date.isWithin(range, includeEnd: true), isTrue, reason: '$date is within $range');
      });

      test('Same moment as start - local', () {
        final date = DateTime(2024, 1, 1);
        final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
        expect(date.isWithin(range), isTrue);
        expect(date.isWithin(range, includeStart: false), isFalse, reason: '$date is not within $range');
      });

      test('Same moment as end - local', () {
        final date = DateTime(2024, 1, 31);
        final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
        expect(date.isWithin(range), isFalse);
        expect(date.isWithin(range, includeEnd: true), isTrue, reason: '$date is within $range');
      });
    });

    test('startOfDay', () {
      final date = DateTime(2024, 1, 1, 5);
      final startOfDay = date.startOfDay;
      expect(startOfDay, DateTime(2024, 1, 1));
    });

    test('endOfDay', () {
      final date = DateTime(2024, 1, 1, 5);
      final startOfDay = date.endOfDay;
      expect(startOfDay, DateTime(2024, 1, 2));
    });

    test('dayRange', () {
      final date = DateTime(2024, 1, 1);
      final dayRange = date.dayRange;
      expect(
        dayRange,
        DateTimeRange(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 1, 2),
        ),
      );
    });

    test('addDays', () {
      final date = DateTime(2024, 1, 1);
      final added = date.addDays(10);
      expect(
        added,
        DateTime(2024, 1, 11),
      );
    });

    test('subtractDays', () {
      final date = DateTime(2024, 1, 1);
      final added = date.subtractDays(10);
      expect(
        added,
        DateTime(2023, 12, 22),
      );
    });

    test('startOfWeekWithOffset', () {
      final date = DateTime(2024, 1, 1);
      for (var i = 1; i <= 7; i++) {
        final startOfWeek = date.startOfWeekWithOffset(i);
        expect(startOfWeek.weekday, i);
      }
    });

    test('endOfWeekWithOffset', () {
      final date = DateTime(2024, 1, 1);
      for (var i = 1; i <= 7; i++) {
        final startOfWeek = date.endOfWeekWithOffset(i);
        expect(startOfWeek.weekday, i);
      }
    });

    test('weekRangeWithOffset', () {
      final date = DateTime(2024, 1, 1);
      for (var i = 1; i <= 7; i++) {
        final week = date.weekRangeWithOffset(i);
        expect(week.dayDifference, 7);

        final dateIsAfterStart = (date.isAfter(week.start) || date.isAtSameMomentAs(week.start));

        final dateIsBeforeEnd = (date.isAfter(week.start) || date.isAtSameMomentAs(week.start));

        final dateIsDuringWeek = dateIsAfterStart && dateIsBeforeEnd;

        expect(dateIsDuringWeek, true);
      }
    });

    /// TODO: add more tests.
  });
}
