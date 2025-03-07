import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kalender/kalender_extensions.dart';

import 'utilities.dart';

Future<void> main() async {
  testWithTimeZones(
    body: (timezone, testDates) {
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

      group('startOfWeek', () {
        test('Every day of the week', () {
          final monday = DateTime(2025, 2, 24);
          final tuesday = monday.addDays(1);
          final wednesday = monday.addDays(2);
          final thursday = monday.addDays(3);
          final friday = monday.addDays(4);
          final saturday = monday.addDays(5);
          final sunday = monday.addDays(6);

          expect(monday.startOfWeek, monday);
          expect(tuesday.startOfWeek, monday);
          expect(wednesday.startOfWeek, monday);
          expect(thursday.startOfWeek, monday);
          expect(friday.startOfWeek, monday);
          expect(saturday.startOfWeek, monday);
          expect(sunday.startOfWeek, monday);
        });
      });

      group('endOfWeek', () {
        test('Every day of the week', () {
          final monday = DateTime(2025, 2, 24);
          final tuesday = monday.addDays(1);
          final wednesday = monday.addDays(2);
          final thursday = monday.addDays(3);
          final friday = monday.addDays(4);
          final saturday = monday.addDays(5);
          final sunday = monday.addDays(6);

          final endOfWeek = DateTime(2025, 3, 3);

          expect(monday.endOfWeek, endOfWeek);
          expect(tuesday.endOfWeek, endOfWeek);
          expect(wednesday.endOfWeek, endOfWeek);
          expect(thursday.endOfWeek, endOfWeek);
          expect(friday.endOfWeek, endOfWeek);
          expect(saturday.endOfWeek, endOfWeek);
          expect(sunday.endOfWeek, endOfWeek);
        });
      });

      group('weekRange', () {
        test('Every day of the week', () {
          final monday = DateTime(2025, 2, 24);
          final tuesday = monday.addDays(1);
          final wednesday = monday.addDays(2);
          final thursday = monday.addDays(3);
          final friday = monday.addDays(4);
          final saturday = monday.addDays(5);
          final sunday = monday.addDays(6);
          final endOfWeek = DateTime(2025, 3, 3);

          final weekRange = DateTimeRange(start: monday, end: endOfWeek);

          expect(monday.weekRange, weekRange);
          expect(tuesday.weekRange, weekRange);
          expect(wednesday.weekRange, weekRange);
          expect(thursday.weekRange, weekRange);
          expect(friday.weekRange, weekRange);
          expect(saturday.weekRange, weekRange);
          expect(sunday.weekRange, weekRange);
        });
      });

      group('workWeekRange', () {
        test('Every day of the week', () {
          final monday = DateTime(2025, 2, 24);
          final tuesday = monday.addDays(1);
          final wednesday = monday.addDays(2);
          final thursday = monday.addDays(3);
          final friday = monday.addDays(4);
          final saturday = monday.addDays(5);
          final sunday = monday.addDays(6);

          final workWeekRange = DateTimeRange(start: monday, end: saturday);

          expect(monday.workWeekRange, workWeekRange);
          expect(tuesday.workWeekRange, workWeekRange);
          expect(wednesday.workWeekRange, workWeekRange);
          expect(thursday.workWeekRange, workWeekRange);
          expect(friday.workWeekRange, workWeekRange);
          expect(saturday.workWeekRange, workWeekRange);
          expect(sunday.workWeekRange, workWeekRange);
        });
      });

      test('addDays', () {
        final date = DateTime(2024, 1, 1);
        expect(date.addDays(10), DateTime(2024, 1, 11));
      });

      test('subtractDays', () {
        final date = DateTime(2024, 1, 1);
        expect(date.subtractDays(10), DateTime(2023, 12, 22));
      });

      group('customDateTimeRange()', () {
        test('Custom range', () {
          const numberOfDays = 15;
          final start = DateTime(2024, 1, 1);
          final end = DateTime(2024, 1, 16);
          final range = start.customDateTimeRange(numberOfDays);
          expect(range.start, start);
          expect(range.end, end);
        });

        test('Custom range - negative', () {
          const numberOfDays = -15;
          final start = DateTime(2024, 1, 16);
          final end = DateTime(2024, 1, 1);
          final range = start.customDateTimeRange(numberOfDays);
          expect(range.start, end);
          expect(range.end, start);
        });
      });

      group('asUtc', () {
        test('asUtc', () {
          final date = DateTime(2024, 1, 15, 10, 30);
          final utc = date.asUtc;
          expect(utc.year, date.year);
          expect(utc.month, date.month);
          expect(utc.day, date.day);
          expect(utc.hour, date.hour);
          expect(utc.minute, date.minute);
          expect(utc.second, date.second);
          expect(utc.millisecond, date.millisecond);
          expect(utc.microsecond, date.microsecond);
          expect(utc.isUtc, isTrue);
        });
      });
      group('asLocal', () {
        test('asLocal', () {
          final date = DateTime.utc(2024, 1, 15, 10, 30);
          final local = date.asLocal;
          expect(local.year, date.year);
          expect(local.month, date.month);
          expect(local.day, date.day);
          expect(local.hour, date.hour);
          expect(local.minute, date.minute);
          expect(local.second, date.second);
          expect(local.millisecond, date.millisecond);
          expect(local.microsecond, date.microsecond);
          expect(local.isUtc, isFalse);
        });
      });
    },
  );
}
