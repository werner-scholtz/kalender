import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kalender/kalender_extensions.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart' show ListEquality;

import 'utilities.dart';

Future<void> main() async {
  testWithTimeZones(
    body: (timezone, testDates) {
      group('isUtc', () {
        final start = DateTime.now();
        final end = start.copyWith(hour: start.hour + 1);
        test('start and end in local', () {
          expect(DateTimeRange(start: start, end: end).isUtc, isFalse);
        });
        test('start in utc and end in local', () {
          expect(DateTimeRange(start: start.toUtc(), end: end).isUtc, isFalse);
        });
        test('start in local and end in utc', () {
          expect(DateTimeRange(start: start, end: end.toUtc()).isUtc, isFalse);
        });
        test('start and end in utc', () {
          expect(DateTimeRange(start: start.toUtc(), end: end.toUtc()).isUtc, isTrue);
        });
      });

      group('monthDifference', () {
        test('Same month', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
          expect(range.monthDifference, 0);
        });
        test('One month difference', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 2, 1));
          expect(range.monthDifference, 1);
        });

        test('Several months difference', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 5, 1));
          expect(range.monthDifference, 4);
        });

        test('Across years', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2025, 1, 1));
          expect(range.monthDifference, 12);
        });

        test('Across years with different months', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2025, 6, 1));
          expect(range.monthDifference, 17);
        });

        test('Leap year', () {
          final range = DateTimeRange(start: DateTime(2024, 2, 29), end: DateTime(2024, 3, 1)); // Leap year
          expect(range.monthDifference, 1);
        });

        test('Different days of the month', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 15), end: DateTime(2024, 2, 20));
          expect(range.monthDifference, 1);
        });

        test('Same date across years', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2026, 1, 1));
          expect(range.monthDifference, 24);
        });
      });

      group('weekNumbers', () {
        test('Single week', () {
          final range = DateTimeRange(start: DateTime(2025, 1, 6), end: DateTime(2025, 1, 12));
          final (weekNumber, secondWeekNumber) = range.weekNumbers;
          expect(weekNumber, 2);
          expect(secondWeekNumber, null);
        });

        test('Single week - crosses year boundary', () {
          final range = DateTimeRange(start: DateTime(2024, 12, 30), end: DateTime(2025, 1, 5));
          final (weekNumber, secondWeekNumber) = range.weekNumbers;
          expect(weekNumber, 1);
          expect(secondWeekNumber, null);
        });

        test('Single week - tue to wed', () {
          final range = DateTimeRange(start: DateTime(2025, 1, 7), end: DateTime(2025, 1, 12));
          final (weekNumber, secondWeekNumber) = range.weekNumbers;
          expect(weekNumber, 2);
          expect(secondWeekNumber, null);
        });

        test('Multiple weeks', () {
          final range = DateTimeRange(start: DateTime(2025, 1, 6), end: DateTime(2025, 1, 14));
          final (weekNumber, secondWeekNumber) = range.weekNumbers;
          expect(weekNumber, 2);
          expect(secondWeekNumber, 3);
        });

        test('Multiple weeks - ends on monday', () {
          final range = DateTimeRange(start: DateTime(2025, 1, 6), end: DateTime(2025, 1, 13));
          final (weekNumber, secondWeekNumber) = range.weekNumbers;
          expect(weekNumber, 2);
          expect(secondWeekNumber, 3);
        });

        test('Multiple weeks - spans across years', () {
          final range = DateTimeRange(start: DateTime(2024, 12, 23), end: DateTime(2025, 12, 22));
          final (weekNumber, secondWeekNumber) = range.weekNumbers;
          expect(weekNumber, 52);
          expect(secondWeekNumber, 52);
        });
      });

      group('dates()', () {
        for (final date in testDates) {
          test('Same start and end date (inclusive)', () {
            final range = DateTimeRange(start: date, end: date);
            final dates = range.dates(inclusive: true);
            expect(dates, [date.startOfDay]);
          });

          test('Same start and end date (exclusive)', () {
            final range = DateTimeRange(start: date, end: date);
            final dates = range.dates(inclusive: false);
            expect(dates, [date.startOfDay]);
          });

          test('Start date before end date', () {
            final startDate = date.startOfDay;
            final endDate = startDate.copyWith(day: startDate.day + 3);
            final range = DateTimeRange(start: startDate, end: endDate);
            final expectedDates = [
              startDate,
              startDate.copyWith(day: startDate.day + 1),
              startDate.copyWith(day: startDate.day + 2),
              startDate.copyWith(day: startDate.day + 3),
            ];
            final dates = range.dates(inclusive: true);
            expect(const ListEquality<DateTime>().equals(dates, expectedDates), isTrue);
          });

          test('Start date before end date (exclusive)', () {
            final startDate = date.startOfDay;
            final endDate = startDate.copyWith(day: startDate.day + 3);
            final range = DateTimeRange(start: startDate, end: endDate);
            final expectedDates = [
              startDate,
              startDate.copyWith(day: startDate.day + 1),
              startDate.copyWith(day: startDate.day + 2),
            ];
            final dates = range.dates(inclusive: false);
            expect(const ListEquality<DateTime>().equals(dates, expectedDates), isTrue);
          });
        }
      });

      group('dateTimeRangeOnDate()', () {
        test('Date outside range', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
          final date = DateTime(2024, 2, 1);
          expect(range.dateTimeRangeOnDate(date), isNull);
        });

        test('Start and end on same day', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 1));
          final date = DateTime(2024, 1, 1);
          expect(range.dateTimeRangeOnDate(date), range); // Should return the same range
        });

        test('Date is start date', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
          final date = DateTime(2024, 1, 1);
          final expectedRange = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 2));
          expect(range.dateTimeRangeOnDate(date), expectedRange);
        });

        test('Date is end date', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
          final date = DateTime(2024, 1, 31);
          final expectedRange = DateTimeRange(start: DateTime(2024, 1, 31, 0, 0, 0, 0), end: DateTime(2024, 1, 31));
          expect(range.dateTimeRangeOnDate(date), expectedRange);
        });

        test('Date is within range', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
          final date = DateTime(2024, 1, 15);
          final expectedRange = DateTimeRange(start: DateTime(2024, 1, 15), end: DateTime(2024, 1, 16));
          expect(range.dateTimeRangeOnDate(date), expectedRange);
        });

        test('Date is within range, different times', () {
          final range = DateTimeRange(start: DateTime(2024, 1, 1, 10), end: DateTime(2024, 1, 31, 15));
          final date = DateTime(2024, 1, 15, 5);
          final expectedRange = DateTimeRange(start: DateTime(2024, 1, 15), end: DateTime(2024, 1, 16));
          expect(range.dateTimeRangeOnDate(date), expectedRange);
        });
      });

      group('overlaps()', () {
        test('No overlap - before', () {
          final range1 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
          final range2 = DateTimeRange(start: DateTime(2024, 1, 11), end: DateTime(2024, 1, 20));
          expect(range1.overlaps(range2), isFalse);
          expect(range2.overlaps(range1), isFalse);
        });

        test('No overlap - before (touching)', () {
          final range1 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
          final range2 = DateTimeRange(start: DateTime(2024, 1, 10), end: DateTime(2024, 1, 20));
          expect(range1.overlaps(range2), isFalse);
          expect(range2.overlaps(range1), isFalse);
          expect(range1.overlaps(range2, touching: true), isTrue);
          expect(range2.overlaps(range1, touching: true), isTrue);
        });

        test('No overlap - after', () {
          final range1 = DateTimeRange(start: DateTime(2024, 1, 11), end: DateTime(2024, 1, 20));
          final range2 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
          expect(range1.overlaps(range2), isFalse);
          expect(range2.overlaps(range1), isFalse);
        });

        test('No overlap - after (touching)', () {
          final range1 = DateTimeRange(start: DateTime(2024, 1, 10), end: DateTime(2024, 1, 20));
          final range2 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
          expect(range1.overlaps(range2), isFalse);
          expect(range2.overlaps(range1), isFalse);
          expect(range1.overlaps(range2, touching: true), isTrue);
          expect(range2.overlaps(range1, touching: true), isTrue);
        });

        test('Overlap', () {
          final range1 = DateTimeRange(start: DateTime(2024, 1, 5), end: DateTime(2024, 1, 15));
          final range2 = DateTimeRange(start: DateTime(2024, 1, 10), end: DateTime(2024, 1, 20));
          expect(range1.overlaps(range2), isTrue);
          expect(range2.overlaps(range1), isTrue);
        });

        test('Overlap - range1 contains range2', () {
          final range1 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
          final range2 = DateTimeRange(start: DateTime(2024, 1, 5), end: DateTime(2024, 1, 10));
          expect(range1.overlaps(range2), isTrue);
          expect(range2.overlaps(range1), isTrue);
        });

        test('Overlap - range2 contains range1', () {
          final range1 = DateTimeRange(start: DateTime(2024, 1, 5), end: DateTime(2024, 1, 10));
          final range2 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
          expect(range1.overlaps(range2), isTrue);
          expect(range2.overlaps(range1), isTrue);
        });

        test('Overlap - same end different start', () {
          final range1 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
          final range2 = DateTimeRange(start: DateTime(2024, 1, 2), end: DateTime(2024, 1, 10));
          expect(range1.overlaps(range2), isTrue);
          expect(range2.overlaps(range1), isTrue);
        });

        test('Overlap - range2 contains range1', () {
          final range1 = DateTimeRange(start: DateTime(2024, 1, 5), end: DateTime(2024, 1, 10));
          final range2 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31));
          expect(range1.overlaps(range2), isTrue);
          expect(range2.overlaps(range1), isTrue);
        });

        test('Same range', () {
          final range1 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
          final range2 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
          expect(range1.overlaps(range2), isTrue); // A range always overlaps itself
        });

        test('One range is zero duration', () {
          final range1 = DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 10));
          final range2 = DateTimeRange(start: DateTime(2024, 1, 5), end: DateTime(2024, 1, 5));
          expect(range1.overlaps(range2), isTrue);
          expect(range2.overlaps(range1), isTrue);
        });

        /// TODO: test asUtc and asLocal
      });
    },
  );
}
