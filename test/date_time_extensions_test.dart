import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/extensions/internal.dart';

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
        final baseMonday = DateTime(2025, 2, 24);

        final tuesday = baseMonday.addDays(1);
        final wednesday = baseMonday.addDays(2);
        final thursday = baseMonday.addDays(3);
        final friday = baseMonday.addDays(4);
        final saturday = baseMonday.addDays(5);
        final sunday = baseMonday.addDays(6);

        final previousTuesday = baseMonday.subtractDays(6);
        final previousWednesday = baseMonday.subtractDays(5);
        final previousThursday = baseMonday.subtractDays(4);
        final previousFriday = baseMonday.subtractDays(3);
        final previousSaturday = baseMonday.subtractDays(2);
        final previousSunday = baseMonday.subtractDays(1);

        test('defaults to Monday as first day of the week', () {
          expect(baseMonday.startOfWeek(), baseMonday);
          expect(tuesday.startOfWeek(), baseMonday);
          expect(wednesday.startOfWeek(), baseMonday);
          expect(thursday.startOfWeek(), baseMonday);
          expect(friday.startOfWeek(), baseMonday);
          expect(saturday.startOfWeek(), baseMonday);
          expect(sunday.startOfWeek(), baseMonday);
        });

        test('uses Tuesday as first day of the week', () {
          expect(baseMonday.startOfWeek(firstDayOfWeek: DateTime.tuesday), previousTuesday);
          expect(tuesday.startOfWeek(firstDayOfWeek: DateTime.tuesday), tuesday);
          expect(wednesday.startOfWeek(firstDayOfWeek: DateTime.tuesday), tuesday);
          expect(thursday.startOfWeek(firstDayOfWeek: DateTime.tuesday), tuesday);
          expect(friday.startOfWeek(firstDayOfWeek: DateTime.tuesday), tuesday);
          expect(saturday.startOfWeek(firstDayOfWeek: DateTime.tuesday), tuesday);
          expect(sunday.startOfWeek(firstDayOfWeek: DateTime.tuesday), tuesday);
        });

        test('uses Wednesday as first day of the week', () {
          expect(baseMonday.startOfWeek(firstDayOfWeek: DateTime.wednesday), previousWednesday);
          expect(tuesday.startOfWeek(firstDayOfWeek: DateTime.wednesday), previousWednesday);
          expect(wednesday.startOfWeek(firstDayOfWeek: DateTime.wednesday), wednesday);
          expect(thursday.startOfWeek(firstDayOfWeek: DateTime.wednesday), wednesday);
          expect(friday.startOfWeek(firstDayOfWeek: DateTime.wednesday), wednesday);
          expect(saturday.startOfWeek(firstDayOfWeek: DateTime.wednesday), wednesday);
          expect(sunday.startOfWeek(firstDayOfWeek: DateTime.wednesday), wednesday);
        });

        test('uses Thursday as first day of the week', () {
          expect(baseMonday.startOfWeek(firstDayOfWeek: DateTime.thursday), previousThursday);
          expect(tuesday.startOfWeek(firstDayOfWeek: DateTime.thursday), previousThursday);
          expect(wednesday.startOfWeek(firstDayOfWeek: DateTime.thursday), previousThursday);
          expect(thursday.startOfWeek(firstDayOfWeek: DateTime.thursday), thursday);
          expect(friday.startOfWeek(firstDayOfWeek: DateTime.thursday), thursday);
          expect(saturday.startOfWeek(firstDayOfWeek: DateTime.thursday), thursday);
          expect(sunday.startOfWeek(firstDayOfWeek: DateTime.thursday), thursday);
        });

        test('uses Friday as first day of the week', () {
          expect(baseMonday.startOfWeek(firstDayOfWeek: DateTime.friday), previousFriday);
          expect(tuesday.startOfWeek(firstDayOfWeek: DateTime.friday), previousFriday);
          expect(wednesday.startOfWeek(firstDayOfWeek: DateTime.friday), previousFriday);
          expect(thursday.startOfWeek(firstDayOfWeek: DateTime.friday), previousFriday);
          expect(friday.startOfWeek(firstDayOfWeek: DateTime.friday), friday);
          expect(saturday.startOfWeek(firstDayOfWeek: DateTime.friday), friday);
          expect(sunday.startOfWeek(firstDayOfWeek: DateTime.friday), friday);
        });

        test('uses Saturday as first day of the week', () {
          expect(baseMonday.startOfWeek(firstDayOfWeek: DateTime.saturday), previousSaturday);
          expect(tuesday.startOfWeek(firstDayOfWeek: DateTime.saturday), previousSaturday);
          expect(wednesday.startOfWeek(firstDayOfWeek: DateTime.saturday), previousSaturday);
          expect(thursday.startOfWeek(firstDayOfWeek: DateTime.saturday), previousSaturday);
          expect(friday.startOfWeek(firstDayOfWeek: DateTime.saturday), previousSaturday);
          expect(saturday.startOfWeek(firstDayOfWeek: DateTime.saturday), saturday);
          expect(sunday.startOfWeek(firstDayOfWeek: DateTime.saturday), saturday);
        });

        test('uses Sunday as first day of the week', () {
          expect(baseMonday.startOfWeek(firstDayOfWeek: DateTime.sunday), previousSunday);
          expect(tuesday.startOfWeek(firstDayOfWeek: DateTime.sunday), previousSunday);
          expect(wednesday.startOfWeek(firstDayOfWeek: DateTime.sunday), previousSunday);
          expect(thursday.startOfWeek(firstDayOfWeek: DateTime.sunday), previousSunday);
          expect(friday.startOfWeek(firstDayOfWeek: DateTime.sunday), previousSunday);
          expect(saturday.startOfWeek(firstDayOfWeek: DateTime.sunday), previousSunday);
          expect(sunday.startOfWeek(firstDayOfWeek: DateTime.sunday), sunday);
        });
      });

      group('endOfWeek()', () {
        final baseMonday = DateTime(2025, 2, 24);

        final tuesday = baseMonday.addDays(1);
        final wednesday = baseMonday.addDays(2);
        final thursday = baseMonday.addDays(3);
        final friday = baseMonday.addDays(4);
        final saturday = baseMonday.addDays(5);
        final sunday = baseMonday.addDays(6);

        final defaultEndOfWeek = DateTime(2025, 3, 3);
        final nextTuesday = DateTime(2025, 3, 4);
        final nextWednesday = DateTime(2025, 3, 5);
        final nextThursday = DateTime(2025, 3, 6);
        final nextFriday = DateTime(2025, 3, 7);
        final nextSaturday = DateTime(2025, 3, 8);
        final nextSunday = DateTime(2025, 3, 9);

        test('defaults to Monday-Sunday week', () {
          expect(baseMonday.endOfWeek(), defaultEndOfWeek);
          expect(tuesday.endOfWeek(), defaultEndOfWeek);
          expect(wednesday.endOfWeek(), defaultEndOfWeek);
          expect(thursday.endOfWeek(), defaultEndOfWeek);
          expect(friday.endOfWeek(), defaultEndOfWeek);
          expect(saturday.endOfWeek(), defaultEndOfWeek);
          expect(sunday.endOfWeek(), defaultEndOfWeek);
        });

        test('uses Tuesday as first day of week', () {
          expect(baseMonday.endOfWeek(firstDayOfWeek: DateTime.tuesday), tuesday);
          expect(tuesday.endOfWeek(firstDayOfWeek: DateTime.tuesday), nextTuesday);
          expect(wednesday.endOfWeek(firstDayOfWeek: DateTime.tuesday), nextTuesday);
          expect(thursday.endOfWeek(firstDayOfWeek: DateTime.tuesday), nextTuesday);
          expect(friday.endOfWeek(firstDayOfWeek: DateTime.tuesday), nextTuesday);
          expect(saturday.endOfWeek(firstDayOfWeek: DateTime.tuesday), nextTuesday);
          expect(sunday.endOfWeek(firstDayOfWeek: DateTime.tuesday), nextTuesday);
        });

        test('uses Wednesday as first day of week', () {
          expect(baseMonday.endOfWeek(firstDayOfWeek: DateTime.wednesday), wednesday);
          expect(tuesday.endOfWeek(firstDayOfWeek: DateTime.wednesday), wednesday);
          expect(wednesday.endOfWeek(firstDayOfWeek: DateTime.wednesday), nextWednesday);
          expect(thursday.endOfWeek(firstDayOfWeek: DateTime.wednesday), nextWednesday);
          expect(friday.endOfWeek(firstDayOfWeek: DateTime.wednesday), nextWednesday);
          expect(saturday.endOfWeek(firstDayOfWeek: DateTime.wednesday), nextWednesday);
          expect(sunday.endOfWeek(firstDayOfWeek: DateTime.wednesday), nextWednesday);
        });

        test('uses Thursday as first day of week', () {
          expect(baseMonday.endOfWeek(firstDayOfWeek: DateTime.thursday), thursday);
          expect(tuesday.endOfWeek(firstDayOfWeek: DateTime.thursday), thursday);
          expect(wednesday.endOfWeek(firstDayOfWeek: DateTime.thursday), thursday);
          expect(thursday.endOfWeek(firstDayOfWeek: DateTime.thursday), nextThursday);
          expect(friday.endOfWeek(firstDayOfWeek: DateTime.thursday), nextThursday);
          expect(saturday.endOfWeek(firstDayOfWeek: DateTime.thursday), nextThursday);
          expect(sunday.endOfWeek(firstDayOfWeek: DateTime.thursday), nextThursday);
        });

        test('uses Friday as first day of week', () {
          expect(baseMonday.endOfWeek(firstDayOfWeek: DateTime.friday), friday);
          expect(tuesday.endOfWeek(firstDayOfWeek: DateTime.friday), friday);
          expect(wednesday.endOfWeek(firstDayOfWeek: DateTime.friday), friday);
          expect(thursday.endOfWeek(firstDayOfWeek: DateTime.friday), friday);
          expect(friday.endOfWeek(firstDayOfWeek: DateTime.friday), nextFriday);
          expect(saturday.endOfWeek(firstDayOfWeek: DateTime.friday), nextFriday);
          expect(sunday.endOfWeek(firstDayOfWeek: DateTime.friday), nextFriday);
        });

        test('uses Saturday as first day of week', () {
          expect(baseMonday.endOfWeek(firstDayOfWeek: DateTime.saturday), saturday);
          expect(tuesday.endOfWeek(firstDayOfWeek: DateTime.saturday), saturday);
          expect(wednesday.endOfWeek(firstDayOfWeek: DateTime.saturday), saturday);
          expect(thursday.endOfWeek(firstDayOfWeek: DateTime.saturday), saturday);
          expect(friday.endOfWeek(firstDayOfWeek: DateTime.saturday), saturday);
          expect(saturday.endOfWeek(firstDayOfWeek: DateTime.saturday), nextSaturday);
          expect(sunday.endOfWeek(firstDayOfWeek: DateTime.saturday), nextSaturday);
        });

        test('uses Sunday as first day of week', () {
          expect(baseMonday.endOfWeek(firstDayOfWeek: DateTime.sunday), sunday);
          expect(tuesday.endOfWeek(firstDayOfWeek: DateTime.sunday), sunday);
          expect(wednesday.endOfWeek(firstDayOfWeek: DateTime.sunday), sunday);
          expect(thursday.endOfWeek(firstDayOfWeek: DateTime.sunday), sunday);
          expect(friday.endOfWeek(firstDayOfWeek: DateTime.sunday), sunday);
          expect(saturday.endOfWeek(firstDayOfWeek: DateTime.sunday), sunday);
          expect(sunday.endOfWeek(firstDayOfWeek: DateTime.sunday), nextSunday);
        });
      });

      group('weekRange()', () {
        final baseMonday = DateTime(2025, 2, 24);

        // Week days after baseMonday
        final tuesday = baseMonday.addDays(1);
        final wednesday = baseMonday.addDays(2);
        final thursday = baseMonday.addDays(3);
        final friday = baseMonday.addDays(4);
        final saturday = baseMonday.addDays(5);
        final sunday = baseMonday.addDays(6);

        // Previous week days
        final previousTuesday = baseMonday.subtractDays(6);
        final previousWednesday = baseMonday.subtractDays(5);
        final previousThursday = baseMonday.subtractDays(4);
        final previousFriday = baseMonday.subtractDays(3);
        final previousSaturday = baseMonday.subtractDays(2);
        final previousSunday = baseMonday.subtractDays(1);

        final mondayToSundayRange = DateTimeRange(
          start: baseMonday,
          end: DateTime(2025, 3, 3),
        );

        test('defaults to Monday as first day of week', () {
          expect(baseMonday.weekRange(), mondayToSundayRange);
          expect(tuesday.weekRange(), mondayToSundayRange);
          expect(wednesday.weekRange(), mondayToSundayRange);
          expect(thursday.weekRange(), mondayToSundayRange);
          expect(friday.weekRange(), mondayToSundayRange);
          expect(saturday.weekRange(), mondayToSundayRange);
          expect(sunday.weekRange(), mondayToSundayRange);
        });

        test('uses Tuesday as first day of week', () {
          final range = DateTimeRange(
            start: tuesday,
            end: DateTime(2025, 3, 4),
          );

          final rangePreviousTuesday = DateTimeRange(
            start: previousTuesday,
            end: tuesday,
          );

          expect(baseMonday.weekRange(firstDayOfWeek: DateTime.tuesday), rangePreviousTuesday);
          expect(tuesday.weekRange(firstDayOfWeek: DateTime.tuesday), range);
          expect(wednesday.weekRange(firstDayOfWeek: DateTime.tuesday), range);
          expect(thursday.weekRange(firstDayOfWeek: DateTime.tuesday), range);
          expect(friday.weekRange(firstDayOfWeek: DateTime.tuesday), range);
          expect(saturday.weekRange(firstDayOfWeek: DateTime.tuesday), range);
          expect(sunday.weekRange(firstDayOfWeek: DateTime.tuesday), range);
        });

        test('uses Wednesday as first day of week', () {
          final range = DateTimeRange(
            start: wednesday,
            end: DateTime(2025, 3, 5),
          );

          final rangePreviousWednesday = DateTimeRange(
            start: previousWednesday,
            end: wednesday,
          );

          expect(baseMonday.weekRange(firstDayOfWeek: DateTime.wednesday), rangePreviousWednesday);
          expect(tuesday.weekRange(firstDayOfWeek: DateTime.wednesday), rangePreviousWednesday);
          expect(wednesday.weekRange(firstDayOfWeek: DateTime.wednesday), range);
          expect(thursday.weekRange(firstDayOfWeek: DateTime.wednesday), range);
          expect(friday.weekRange(firstDayOfWeek: DateTime.wednesday), range);
          expect(saturday.weekRange(firstDayOfWeek: DateTime.wednesday), range);
          expect(sunday.weekRange(firstDayOfWeek: DateTime.wednesday), range);
        });

        test('uses Thursday as first day of week', () {
          final range = DateTimeRange(
            start: thursday,
            end: DateTime(2025, 3, 6),
          );

          final rangePreviousThursday = DateTimeRange(
            start: previousThursday,
            end: thursday,
          );

          expect(baseMonday.weekRange(firstDayOfWeek: DateTime.thursday), rangePreviousThursday);
          expect(tuesday.weekRange(firstDayOfWeek: DateTime.thursday), rangePreviousThursday);
          expect(wednesday.weekRange(firstDayOfWeek: DateTime.thursday), rangePreviousThursday);
          expect(thursday.weekRange(firstDayOfWeek: DateTime.thursday), range);
          expect(friday.weekRange(firstDayOfWeek: DateTime.thursday), range);
          expect(saturday.weekRange(firstDayOfWeek: DateTime.thursday), range);
          expect(sunday.weekRange(firstDayOfWeek: DateTime.thursday), range);
        });

        test('uses Friday as first day of week', () {
          final range = DateTimeRange(
            start: friday,
            end: DateTime(2025, 3, 7),
          );

          final rangePreviousFriday = DateTimeRange(
            start: previousFriday,
            end: friday,
          );

          expect(baseMonday.weekRange(firstDayOfWeek: DateTime.friday), rangePreviousFriday);
          expect(tuesday.weekRange(firstDayOfWeek: DateTime.friday), rangePreviousFriday);
          expect(wednesday.weekRange(firstDayOfWeek: DateTime.friday), rangePreviousFriday);
          expect(thursday.weekRange(firstDayOfWeek: DateTime.friday), rangePreviousFriday);
          expect(friday.weekRange(firstDayOfWeek: DateTime.friday), range);
          expect(saturday.weekRange(firstDayOfWeek: DateTime.friday), range);
          expect(sunday.weekRange(firstDayOfWeek: DateTime.friday), range);
        });

        test('uses Saturday as first day of week', () {
          final range = DateTimeRange(
            start: saturday,
            end: DateTime(2025, 3, 8),
          );

          final rangePreviousSaturday = DateTimeRange(
            start: previousSaturday,
            end: saturday,
          );

          expect(baseMonday.weekRange(firstDayOfWeek: DateTime.saturday), rangePreviousSaturday);
          expect(tuesday.weekRange(firstDayOfWeek: DateTime.saturday), rangePreviousSaturday);
          expect(wednesday.weekRange(firstDayOfWeek: DateTime.saturday), rangePreviousSaturday);
          expect(thursday.weekRange(firstDayOfWeek: DateTime.saturday), rangePreviousSaturday);
          expect(friday.weekRange(firstDayOfWeek: DateTime.saturday), rangePreviousSaturday);
          expect(saturday.weekRange(firstDayOfWeek: DateTime.saturday), range);
          expect(sunday.weekRange(firstDayOfWeek: DateTime.saturday), range);
        });

        test('uses Sunday as first day of week', () {
          final range = DateTimeRange(
            start: sunday,
            end: DateTime(2025, 3, 9),
          );

          final rangePreviousSunday = DateTimeRange(
            start: previousSunday,
            end: sunday,
          );

          expect(baseMonday.weekRange(firstDayOfWeek: DateTime.sunday), rangePreviousSunday);
          expect(tuesday.weekRange(firstDayOfWeek: DateTime.sunday), rangePreviousSunday);
          expect(wednesday.weekRange(firstDayOfWeek: DateTime.sunday), rangePreviousSunday);
          expect(thursday.weekRange(firstDayOfWeek: DateTime.sunday), rangePreviousSunday);
          expect(friday.weekRange(firstDayOfWeek: DateTime.sunday), rangePreviousSunday);
          expect(saturday.weekRange(firstDayOfWeek: DateTime.sunday), rangePreviousSunday);
          expect(sunday.weekRange(firstDayOfWeek: DateTime.sunday), range);
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
