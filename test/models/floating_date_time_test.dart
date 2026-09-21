// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

void main() {
  setUpAll(tz.initializeTimeZones);

  group('FloatingDateTime', () {
    group('constructor', () {
      test('creates a UTC DateTime with the given components', () {
        expect(FloatingDateTime(2024, 3, 15, 10, 30, 45, 100, 200), DateTime.utc(2024, 3, 15, 10, 30, 45, 100, 200));
      });

      test('defaults omitted components to zero / one', () {
        expect(FloatingDateTime(2024), DateTime.utc(2024, 1, 1, 0, 0, 0, 0, 0));
      });

      test('is a subclass of DateTime', () {
        expect(FloatingDateTime(2024), isA<DateTime>());
      });
    });

    group('fromDateTime', () {
      test('preserves components of a local DateTime', () {
        final local = DateTime(2024, 6, 20, 14, 45, 30, 500, 700);
        expect(FloatingDateTime.fromDateTime(local), DateTime.utc(2024, 6, 20, 14, 45, 30, 500, 700));
      });

      test('preserves components of a UTC DateTime', () {
        final utc = DateTime.utc(2024, 12, 31, 23, 59, 59);
        expect(FloatingDateTime.fromDateTime(utc), FloatingDateTime(2024, 12, 31, 23, 59, 59));
      });

      test('preserves components of a TZDateTime', () {
        final location = getLocation('America/New_York');
        final tzDate = TZDateTime(location, 2024, 7, 4, 22, 30);
        expect(FloatingDateTime.fromDateTime(tzDate), FloatingDateTime(2024, 7, 4, 22, 30));
      });

      test('preserves components of a TZDateTime with a negative offset', () {
        final tzDate = TZDateTime(getLocation('Pacific/Honolulu'), 2024, 1, 1, 1);
        expect(FloatingDateTime.fromDateTime(tzDate), FloatingDateTime(2024, 1, 1, 1));
      });

      test('preserves components of a TZDateTime with a positive offset', () {
        final tzDate = TZDateTime(getLocation('Asia/Tokyo'), 2024, 1, 1, 2);
        expect(FloatingDateTime.fromDateTime(tzDate), FloatingDateTime(2024, 1, 1, 2));
      });
    });

    group('fromExternal', () {
      test('returns the same instance if already an FloatingDateTime', () {
        final internal = FloatingDateTime(2024, 5, 10, 8, 0);
        final result = FloatingDateTime.fromExternal(internal);

        expect(identical(result, internal), true);
      });

      test('converts a local DateTime via local timezone when no location is given', () {
        final utc = DateTime.utc(2024, 6, 15, 12, 0);
        expect(FloatingDateTime.fromExternal(utc), FloatingDateTime.fromDateTime(utc.toLocal()));
      });

      test('converts a UTC DateTime to the specified location', () {
        final location = getLocation('Asia/Tokyo'); // UTC+9
        final utc = DateTime.utc(2024, 1, 1, 0, 0);
        expect(FloatingDateTime.fromExternal(utc, location: location), FloatingDateTime(2024, 1, 1, 9, 0));
      });

      test('converts a UTC DateTime that crosses day boundary in target location', () {
        final location = getLocation('Pacific/Honolulu'); // UTC-10
        final utc = DateTime.utc(2024, 3, 1, 5, 0);
        // 2024 is a leap year.
        expect(FloatingDateTime.fromExternal(utc, location: location), FloatingDateTime(2024, 2, 29, 19));
      });
    });

    group('startOfDay', () {
      test('returns midnight of the same date', () {
        expect(
          FloatingDateTime(2024, 3, 15, 14, 30, 45).startOfDay,
          allOf(isA<FloatingDateTime>(), FloatingDateTime(2024, 3, 15)),
        );
      });

      test('is idempotent for midnight', () {
        final midnight = FloatingDateTime(2024, 1, 1);
        expect(midnight.startOfDay, midnight);
      });
    });

    group('endOfDay', () {
      test('returns midnight of the next day', () {
        expect(
          FloatingDateTime(2024, 3, 15, 14, 30).endOfDay,
          allOf(isA<FloatingDateTime>(), FloatingDateTime(2024, 3, 16)),
        );
      });

      test('wraps month correctly on last day of month', () {
        expect(FloatingDateTime(2024, 1, 31, 10, 0).endOfDay, FloatingDateTime(2024, 2, 1));
      });

      test('wraps year correctly on Dec 31', () {
        expect(FloatingDateTime(2024, 12, 31, 23, 59).endOfDay, FloatingDateTime(2025, 1, 1));
      });
    });

    group('dayRange', () {
      test('covers the full day as a half-open range', () {
        final dt = FloatingDateTime(2024, 6, 15, 10, 30);
        final range = dt.dayRange;

        expect(range.start, FloatingDateTime(2024, 6, 15));
        expect(range.end, FloatingDateTime(2024, 6, 16));
      });

      test('range duration is exactly 24 hours', () {
        final range = FloatingDateTime(2024, 3, 10).dayRange;
        expect(range.end.difference(range.start), const Duration(hours: 24));
      });
    });

    group('startOfMonth', () {
      test('returns the first day of the month at midnight', () {
        expect(FloatingDateTime(2024, 7, 20, 15, 45).startOfMonth, FloatingDateTime(2024, 7, 1));
      });
    });

    group('endOfMonth', () {
      test('returns the first day of the next month at midnight', () {
        expect(FloatingDateTime(2024, 1, 15).endOfMonth, FloatingDateTime(2024, 2, 1));
      });

      test('wraps year correctly for December', () {
        expect(FloatingDateTime(2024, 12, 25).endOfMonth, FloatingDateTime(2025, 1, 1));
      });
    });

    group('monthRange', () {
      test('covers the full month as a half-open range', () {
        final range = FloatingDateTime(2024, 2, 10).monthRange;

        expect(range.start, FloatingDateTime(2024, 2, 1));
        expect(range.end, FloatingDateTime(2024, 3, 1));
      });

      test('February in a leap year has 29 days', () {
        final range = FloatingDateTime(2024, 2, 1).monthRange;
        expect(range.end.difference(range.start).inDays, 29);
      });

      test('February in a non-leap year has 28 days', () {
        final range = FloatingDateTime(2023, 2, 1).monthRange;
        expect(range.end.difference(range.start).inDays, 28);
      });
    });

    group('startOfYear', () {
      test('returns January 1st at midnight', () {
        expect(FloatingDateTime(2024, 8, 20, 10, 30).startOfYear, FloatingDateTime(2024, 1, 1));
      });
    });

    group('endOfYear', () {
      test('returns January 1st of the next year at midnight', () {
        expect(FloatingDateTime(2024, 5, 15).endOfYear, FloatingDateTime(2025, 1, 1));
      });
    });

    group('yearRange', () {
      test('covers the full year as a half-open range', () {
        final range = FloatingDateTime(2024, 6, 1).yearRange;

        expect(range.start, FloatingDateTime(2024, 1, 1));
        expect(range.end, FloatingDateTime(2025, 1, 1));
      });

      test('leap year has 366 days', () {
        final range = FloatingDateTime(2024, 1, 1).yearRange;
        expect(range.end.difference(range.start).inDays, 366);
      });

      test('non-leap year has 365 days', () {
        final range = FloatingDateTime(2023, 1, 1).yearRange;
        expect(range.end.difference(range.start).inDays, 365);
      });
    });

    group('isStartOfDay', () {
      for (final (name, dateTime, expected) in [
        ('midnight', FloatingDateTime(2024, 1, 1), true),
        ('a non-zero hour', FloatingDateTime(2024, 1, 1, 1), false),
        ('a non-zero minute', FloatingDateTime(2024, 1, 1, 0, 1), false),
        ('a non-zero second', FloatingDateTime(2024, 1, 1, 0, 0, 1), false),
        ('a non-zero millisecond', FloatingDateTime(2024, 1, 1, 0, 0, 0, 1), false),
        ('a non-zero microsecond', FloatingDateTime(2024, 1, 1, 0, 0, 0, 0, 1), false),
      ]) {
        test('returns $expected for $name', () {
          expect(dateTime.isStartOfDay, expected);
        });
      }
    });

    // 2024-01-08 is a Monday, 2024-01-10 a Wednesday and 2024-01-14 a Sunday.
    final monday = FloatingDateTime(2024, 1, 8);
    final wednesday = FloatingDateTime(2024, 1, 10);
    final sunday = FloatingDateTime(2024, 1, 14);

    group('startOfWeek', () {
      test('returns Monday for a Wednesday (default firstDayOfWeek)', () {
        expect(wednesday.copyWith(hour: 14, minute: 30).startOfWeek(), monday);
      });

      test('returns Monday for a Monday', () {
        expect(monday.startOfWeek(), monday);
      });

      test('returns Monday for a Sunday', () {
        expect(sunday.startOfWeek(), monday);
      });

      test('returns Sunday when firstDayOfWeek is Sunday', () {
        expect(wednesday.startOfWeek(firstDayOfWeek: DateTime.sunday), FloatingDateTime(2024, 1, 7));
      });

      test('returns Saturday when firstDayOfWeek is Saturday', () {
        expect(wednesday.startOfWeek(firstDayOfWeek: DateTime.saturday), FloatingDateTime(2024, 1, 6));
      });

      test('can cross month boundary backward', () {
        // 2024-03-01 is a Friday
        expect(FloatingDateTime(2024, 3, 1).startOfWeek(), FloatingDateTime(2024, 2, 26));
      });

      test('can cross year boundary backward', () {
        // 2024-01-03 is a Wednesday
        expect(FloatingDateTime(2024, 1, 3).startOfWeek(), FloatingDateTime(2024, 1, 1));

        // 2025-01-01 is a Wednesday
        expect(FloatingDateTime(2025, 1, 1).startOfWeek(), FloatingDateTime(2024, 12, 30));
      });
    });

    group('endOfWeek', () {
      test('returns next Monday for a Wednesday (default firstDayOfWeek)', () {
        expect(wednesday.endOfWeek(), FloatingDateTime(2024, 1, 15));
      });

      test('returns next Monday for a Monday', () {
        expect(monday.endOfWeek(), FloatingDateTime(2024, 1, 15));
      });

      test('returns next Monday for a Sunday', () {
        expect(sunday.endOfWeek(), FloatingDateTime(2024, 1, 15));
      });

      test('returns next Sunday when firstDayOfWeek is Sunday', () {
        expect(wednesday.endOfWeek(firstDayOfWeek: DateTime.sunday), sunday);
      });

      test('can cross month boundary forward', () {
        // 2024-01-29 is a Monday
        expect(FloatingDateTime(2024, 1, 29).endOfWeek(), FloatingDateTime(2024, 2, 5));
      });
    });

    group('weekRange', () {
      test('covers a full 7-day week', () {
        final range = FloatingDateTime(2024, 1, 10).weekRange();

        expect(range.end.difference(range.start).inDays, 7);
      });

      test('start and end match startOfWeek and endOfWeek', () {
        final dt = FloatingDateTime(2024, 6, 12);
        final range = dt.weekRange(firstDayOfWeek: DateTime.sunday);

        expect(range.start, dt.startOfWeek(firstDayOfWeek: DateTime.sunday));
        expect(range.end, dt.endOfWeek(firstDayOfWeek: DateTime.sunday));
      });
    });

    group('forLocation', () {
      test('returns a local DateTime when location is null', () {
        expect(FloatingDateTime(2024, 6, 15, 10, 30).forLocation(), DateTime(2024, 6, 15, 10, 30));
      });

      test('returns a TZDateTime when location is provided', () {
        final location = getLocation('America/New_York');
        expect(
          FloatingDateTime(2024, 6, 15, 10, 30).forLocation(location: location),
          allOf(isA<TZDateTime>(), TZDateTime(location, 2024, 6, 15, 10, 30)),
        );
      });

      test('different locations keep the wall-clock time and differ in UTC offset', () {
        final newYork = getLocation('America/New_York');
        final tokyo = getLocation('Asia/Tokyo');
        final internal = FloatingDateTime(2024, 1, 15, 12, 0);

        final nyResult = internal.forLocation(location: newYork) as TZDateTime;
        final tokyoResult = internal.forLocation(location: tokyo) as TZDateTime;

        expect(nyResult, TZDateTime(newYork, 2024, 1, 15, 12));
        expect(tokyoResult, TZDateTime(tokyo, 2024, 1, 15, 12));
        expect(nyResult.timeZone.offset, isNot(equals(tokyoResult.timeZone.offset)));
      });
    });

    group('isToday', () {
      test('returns true for today without location', () {
        final now = DateTime.now();
        final internal = FloatingDateTime(now.year, now.month, now.day);

        expect(internal.isToday(), true);
      });

      test('returns false for yesterday without location', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final internal = FloatingDateTime(yesterday.year, yesterday.month, yesterday.day);

        expect(internal.isToday(), false);
      });

      test('returns false for tomorrow without location', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final internal = FloatingDateTime(tomorrow.year, tomorrow.month, tomorrow.day);

        expect(internal.isToday(), false);
      });

      test('returns true for today with a specific location', () {
        final location = getLocation('America/New_York');
        final nowInNY = TZDateTime.now(location);
        final internal = FloatingDateTime(nowInNY.year, nowInNY.month, nowInNY.day);

        expect(internal.isToday(location: location), true);
      });

      test('returns false for yesterday with a specific location', () {
        final location = getLocation('America/New_York');
        final nowInNY = TZDateTime.now(location);
        final yesterday = nowInNY.copyWith(day: nowInNY.day - 1);
        final internal = FloatingDateTime(yesterday.year, yesterday.month, yesterday.day);

        expect(internal.isToday(location: location), false);
      });

      test('returns true regardless of time component if same day', () {
        final now = DateTime.now();
        final internal = FloatingDateTime(now.year, now.month, now.day, 23, 59, 59);

        expect(internal.isToday(), true);
      });
    });

    group('isToday with explicit now', () {
      final cases = [
        (
          name: 'now is the same day',
          date: FloatingDateTime(2026, 4, 13),
          now: DateTime(2026, 4, 13, 14, 30),
          expected: true,
        ),
        (name: 'now is the next day', date: FloatingDateTime(2026, 4, 13), now: DateTime(2026, 4, 14), expected: false),
        (
          name: 'now is the previous day',
          date: FloatingDateTime(2026, 4, 13),
          now: DateTime(2026, 4, 12, 23, 59),
          expected: false,
        ),
        (
          name: 'the times of day differ',
          date: FloatingDateTime(2026, 4, 13, 23, 59, 59),
          now: DateTime(2026, 4, 13, 0, 0, 1),
          expected: true,
        ),
        (
          name: 'now is in a different month',
          date: FloatingDateTime(2026, 3, 15),
          now: DateTime(2026, 4, 15, 12),
          expected: false,
        ),
        (
          name: 'now is in a different year',
          date: FloatingDateTime(2025, 4, 13),
          now: DateTime(2026, 4, 13, 12),
          expected: false,
        ),
        (
          name: 'now is a UTC DateTime',
          date: FloatingDateTime(2026, 4, 13, 10),
          now: DateTime.utc(2026, 4, 13, 22),
          expected: true,
        ),
      ];

      for (final c in cases) {
        test('returns ${c.expected} when ${c.name}', () {
          expect(c.date.isToday(now: c.now), c.expected);
        });
      }

      test('now takes precedence over location', () {
        final date = FloatingDateTime(2026, 1, 15);
        expect(date.isToday(now: DateTime(2026, 1, 15, 12), location: getLocation('America/New_York')), true);
      });

      test('falls back to the clock when now is null', () {
        final now = DateTime.now();
        expect(FloatingDateTime(now.year, now.month, now.day).isToday(now: null), true);
      });
    });

    group('isSameDay', () {
      final cases = [
        (
          name: 'the same date at different times',
          a: FloatingDateTime(2024, 1, 15, 10, 30),
          b: FloatingDateTime(2024, 1, 15, 22),
          expected: true,
        ),
        (
          name: 'both at the start of the day',
          a: FloatingDateTime(2024, 6, 1),
          b: FloatingDateTime(2024, 6, 1),
          expected: true,
        ),
        (
          name: 'the start and the end of one day',
          a: FloatingDateTime(2024, 3, 10),
          b: FloatingDateTime(2024, 3, 10, 23, 59, 59),
          expected: true,
        ),
        (
          name: 'adjacent days at midnight',
          a: FloatingDateTime(2024, 3, 10, 23, 59, 59),
          b: FloatingDateTime(2024, 3, 11),
          expected: false,
        ),
        (name: 'different days', a: FloatingDateTime(2024, 1, 15), b: FloatingDateTime(2024, 1, 16), expected: false),
        (name: 'different months', a: FloatingDateTime(2024, 1, 15), b: FloatingDateTime(2024, 2, 15), expected: false),
        (name: 'different years', a: FloatingDateTime(2024, 1, 15), b: FloatingDateTime(2025, 1, 15), expected: false),
      ];

      for (final c in cases) {
        test('is ${c.expected} for ${c.name}, in both directions', () {
          expect(c.a.isSameDay(c.b), c.expected);
          expect(c.b.isSameDay(c.a), c.expected);
        });
      }

      // New York 22:00 and Tokyo 12:00 on 15 January are different instants on the same wall-clock day.
      test('compares the wall-clock day of TZDateTimes, not the instant', () {
        final newYork = getLocation('America/New_York');
        final tokyo = getLocation('Asia/Tokyo');
        final sameDay = FloatingDateTime.fromDateTime(TZDateTime(newYork, 2024, 1, 15, 22));
        expect(sameDay.isSameDay(FloatingDateTime.fromDateTime(TZDateTime(tokyo, 2024, 1, 15, 12))), true);

        final sameInstant = FloatingDateTime.fromDateTime(TZDateTime(newYork, 2024, 1, 15, 23));
        expect(sameInstant.isSameDay(FloatingDateTime.fromDateTime(TZDateTime(tokyo, 2024, 1, 16, 13))), false);
      });
    });

    group('isWithin', () {
      final rangeStart = FloatingDateTime(2024, 1, 10);
      final rangeEnd = FloatingDateTime(2024, 1, 20);
      final range = FloatingDateTimeRange(start: rangeStart, end: rangeEnd);

      test('returns true for a date strictly inside the range', () {
        final date = FloatingDateTime(2024, 1, 15);
        expect(date.isWithin(range), true);
      });

      test('returns true for start when includeStart is true (default)', () {
        expect(rangeStart.isWithin(range), true);
      });

      test('returns false for start when includeStart is false', () {
        expect(rangeStart.isWithin(range, includeStart: false), false);
      });

      test('returns false for end when includeEnd is false (default)', () {
        expect(rangeEnd.isWithin(range), false);
      });

      test('returns true for end when includeEnd is true', () {
        expect(rangeEnd.isWithin(range, includeEnd: true), true);
      });

      test('returns true for start and end when both are included', () {
        expect(rangeStart.isWithin(range, includeStart: true, includeEnd: true), true);
        expect(rangeEnd.isWithin(range, includeStart: true, includeEnd: true), true);
      });

      test('returns false for a date before the range', () {
        final before = FloatingDateTime(2024, 1, 5);
        expect(before.isWithin(range), false);
      });

      test('returns false for a date after the range', () {
        final after = FloatingDateTime(2024, 1, 25);
        expect(after.isWithin(range), false);
      });

      test('strictly exclusive with both flags false', () {
        expect(rangeStart.isWithin(range, includeStart: false, includeEnd: false), false);
        expect(rangeEnd.isWithin(range, includeStart: false, includeEnd: false), false);
        // A date inside should still be within
        expect(FloatingDateTime(2024, 1, 15).isWithin(range, includeStart: false, includeEnd: false), true);
      });
    });

    group('weekNumber', () {
      for (final (name, dateTime, expected) in [
        ('January 1, 2024 (Monday)', FloatingDateTime(2024, 1, 1), 1),
        ('December 31, 2024 (Tuesday), in week 1 of 2025', FloatingDateTime(2024, 12, 31), 1),
        ('December 28, 2024, always in the last week of its year', FloatingDateTime(2024, 12, 28), 52),
        ('December 28, 2023, always in the last week of its year', FloatingDateTime(2023, 12, 28), 52),
        ('January 1, 2023 (Sunday), in week 52 of 2022', FloatingDateTime(2023, 1, 1), 52),
        ('January 4, 2024, always in week 1', FloatingDateTime(2024, 1, 4), 1),
        ('January 4, 2023, always in week 1', FloatingDateTime(2023, 1, 4), 1),
        ('January 4, 2022, always in week 1', FloatingDateTime(2022, 1, 4), 1),
        ('March 1, 2024 (Friday)', FloatingDateTime(2024, 3, 1), 9),
        ('July 1, 2024 (Monday)', FloatingDateTime(2024, 7, 1), 27),
        ('December 31, 2015, in a year that starts on a Thursday', FloatingDateTime(2015, 12, 31), 53),
        ('December 31, 2020, in a year that ends on a Thursday', FloatingDateTime(2020, 12, 31), 53),
      ]) {
        test('$name is week $expected', () {
          expect(dateTime.weekNumber, expected);
        });
      }
    });

    group('ordinalDate', () {
      for (final (name, dateTime, expected) in [
        ('January 1', FloatingDateTime(2024, 1, 1), 1),
        ('February 1', FloatingDateTime(2024, 2, 1), 32),
        ('March 1 in a leap year', FloatingDateTime(2024, 3, 1), 61),
        ('March 1 in a non-leap year', FloatingDateTime(2023, 3, 1), 60),
        ('December 31 in a leap year', FloatingDateTime(2024, 12, 31), 366),
        ('December 31 in a non-leap year', FloatingDateTime(2023, 12, 31), 365),
        // Jan(31) + Feb(29) + Mar(31) + Apr(30) + May(31) + Jun(30) + 4 = 186
        ('July 4 in a leap year', FloatingDateTime(2024, 7, 4), 186),
      ]) {
        test('$name is ordinal day $expected', () {
          expect(dateTime.ordinalDate, expected);
        });
      }
    });

    group('isLeapYear', () {
      for (final (year, expected, rule) in [
        (2024, true, 'divisible by 4'),
        (2028, true, 'divisible by 4'),
        (1900, false, 'divisible by 100 but not 400'),
        (2100, false, 'divisible by 100 but not 400'),
        (2000, true, 'divisible by 400'),
        (2400, true, 'divisible by 400'),
        (2023, false, 'a common year'),
        (2025, false, 'a common year'),
      ]) {
        test('returns $expected for $year, $rule', () {
          expect(FloatingDateTime(year).isLeapYear, expected);
        });
      }
    });

    group('add', () {
      test('adds a positive duration', () {
        expect(
          FloatingDateTime(2024, 1, 1, 10, 0).add(const Duration(hours: 5)),
          allOf(isA<FloatingDateTime>(), FloatingDateTime(2024, 1, 1, 15)),
        );
      });

      test('adding duration crosses day boundary', () {
        expect(FloatingDateTime(2024, 1, 1, 23, 0).add(const Duration(hours: 3)), FloatingDateTime(2024, 1, 2, 2));
      });

      test('adding days works correctly', () {
        // 2024 is a leap year
        expect(FloatingDateTime(2024, 2, 28).add(const Duration(days: 1)), FloatingDateTime(2024, 2, 29));
      });
    });

    group('subtract', () {
      test('subtracts a positive duration', () {
        expect(
          FloatingDateTime(2024, 1, 1, 10, 0).subtract(const Duration(hours: 5)),
          allOf(isA<FloatingDateTime>(), FloatingDateTime(2024, 1, 1, 5)),
        );
      });

      test('subtracting duration crosses day boundary backward', () {
        expect(FloatingDateTime(2024, 1, 2, 1, 0).subtract(const Duration(hours: 3)), FloatingDateTime(2024, 1, 1, 22));
      });

      test('subtracting days works correctly across month boundary', () {
        // 2024 is a leap year
        expect(FloatingDateTime(2024, 3, 1).subtract(const Duration(days: 1)), FloatingDateTime(2024, 2, 29));
      });
    });

    group('copyWith', () {
      test('copies all fields when no arguments are given', () {
        final dt = FloatingDateTime(2024, 3, 15, 10, 30, 45, 100, 200);
        expect(dt.copyWith(), allOf(isA<FloatingDateTime>(), dt));
      });

      for (final (field, copy, expected) in [
        ('year', FloatingDateTime(2024, 6, 15).copyWith(year: 2025), FloatingDateTime(2025, 6, 15)),
        ('month', FloatingDateTime(2024, 6, 15).copyWith(month: 12), FloatingDateTime(2024, 12, 15)),
        ('day', FloatingDateTime(2024, 6, 15).copyWith(day: 28), FloatingDateTime(2024, 6, 28)),
        ('hour', FloatingDateTime(2024, 6, 15, 10).copyWith(hour: 23), FloatingDateTime(2024, 6, 15, 23)),
        ('minute', FloatingDateTime(2024, 6, 15, 10, 30).copyWith(minute: 59), FloatingDateTime(2024, 6, 15, 10, 59)),
        (
          'second',
          FloatingDateTime(2024, 6, 15, 10, 30, 45).copyWith(second: 0),
          FloatingDateTime(2024, 6, 15, 10, 30, 0),
        ),
        (
          'millisecond',
          FloatingDateTime(2024, 6, 15, 10, 30, 45, 100).copyWith(millisecond: 999),
          FloatingDateTime(2024, 6, 15, 10, 30, 45, 999),
        ),
        (
          'microsecond',
          FloatingDateTime(2024, 6, 15, 10, 30, 45, 100, 200).copyWith(microsecond: 500),
          FloatingDateTime(2024, 6, 15, 10, 30, 45, 100, 500),
        ),
      ]) {
        test('replaces $field', () {
          expect(copy, expected);
        });
      }

      test('replaces multiple fields at once', () {
        final dt = FloatingDateTime(2024, 1, 1, 0, 0, 0);
        expect(
          dt.copyWith(year: 2025, month: 12, day: 31, hour: 23, minute: 59, second: 59),
          FloatingDateTime(2025, 12, 31, 23, 59, 59),
        );
      });

      test('handles day overflow into next month', () {
        // DateTime normalizes day 32 of January → Feb 1
        expect(FloatingDateTime(2024, 1, 15).copyWith(day: 32), FloatingDateTime(2024, 2, 1));
      });
    });
  });
}
