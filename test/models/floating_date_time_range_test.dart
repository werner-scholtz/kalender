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

  group('FloatingDateTimeRange', () {
    group('constructor', () {
      test('wraps start and end as FloatingDateTime', () {
        final range = FloatingDateTimeRange(start: DateTime(2024, 1, 10, 8, 30), end: DateTime(2024, 1, 20, 17, 0));

        expect(range.start, FloatingDateTime(2024, 1, 10, 8, 30));
        expect(range.end, FloatingDateTime(2024, 1, 20, 17));
      });

      test('preserves components from UTC DateTimes', () {
        final range = FloatingDateTimeRange(start: DateTime.utc(2024, 6, 1, 12), end: DateTime.utc(2024, 6, 30, 18));

        expect(range.start, FloatingDateTime(2024, 6, 1, 12));
        expect(range.end, FloatingDateTime(2024, 6, 30, 18));
      });
    });

    group('fromDateTimeRange', () {
      test('creates from a Flutter KalenderDateTimeRange', () {
        final flutterRange = KalenderDateTimeRange(start: DateTime(2024, 3, 1), end: DateTime(2024, 3, 31));
        final range = FloatingDateTimeRange.fromDateTimeRange(flutterRange);

        expect(range.start, FloatingDateTime(2024, 3, 1));
        expect(range.end, FloatingDateTime(2024, 3, 31));
      });
    });

    group('forLocation', () {
      test('returns a local KalenderDateTimeRange when location is null', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 6, 15, 10, 0),
          end: FloatingDateTime(2024, 6, 15, 18, 0),
        );
        final result = range.forLocation();

        expect(result.start.isUtc, false);
        expect(result.end.isUtc, false);
        expect(result.start.hour, 10);
        expect(result.end.hour, 18);
      });

      test('returns a TZDateTime KalenderDateTimeRange when location is provided', () {
        final location = getLocation('America/New_York');
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 6, 15, 10, 0),
          end: FloatingDateTime(2024, 6, 15, 18, 0),
        );
        final result = range.forLocation(location: location);

        expect(result.start, isA<TZDateTime>());
        expect(result.end, isA<TZDateTime>());
        expect(result.start.hour, 10);
        expect(result.end.hour, 18);
      });
    });

    group('dates', () {
      test('returns a single date when start and end are on the same day', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 1, 15, 10, 0),
          end: FloatingDateTime(2024, 1, 15, 18, 0),
        );
        final result = range.dates();

        expect(result, [FloatingDateTime(2024, 1, 15)]);
      });

      test('returns all days in a multi-day range (exclusive end)', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 10), end: FloatingDateTime(2024, 1, 13));
        final result = range.dates();

        expect(result, [FloatingDateTime(2024, 1, 10), FloatingDateTime(2024, 1, 11), FloatingDateTime(2024, 1, 12)]);
      });

      test('returns all days in a multi-day range (inclusive end)', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 10), end: FloatingDateTime(2024, 1, 13));
        final result = range.dates(inclusive: true);

        expect(result.length, 4);
        expect(result.last, FloatingDateTime(2024, 1, 13));
      });

      test('all returned dates are at midnight', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 1, 10, 14, 30),
          end: FloatingDateTime(2024, 1, 12, 8, 0),
        );
        for (final date in range.dates()) {
          expect(date.isStartOfDay, true);
        }
      });

      test('handles month boundary crossing', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 30), end: FloatingDateTime(2024, 2, 2));
        final result = range.dates();

        expect(result, [FloatingDateTime(2024, 1, 30), FloatingDateTime(2024, 1, 31), FloatingDateTime(2024, 2, 1)]);
      });

      test('handles leap year Feb 28 to Mar 1', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 2, 28), end: FloatingDateTime(2024, 3, 1));
        final result = range.dates();

        expect(result, [FloatingDateTime(2024, 2, 28), FloatingDateTime(2024, 2, 29)]);
      });

      test('single day range returns one date even with inclusive flag', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 5, 1, 10, 0),
          end: FloatingDateTime(2024, 5, 1, 20, 0),
        );

        expect(range.dates(inclusive: true).length, 1);
      });
    });

    group('rangeOnDate', () {
      final tenDays = FloatingDateTimeRange(
        start: FloatingDateTime(2024, 1, 10, 9, 0),
        end: FloatingDateTime(2024, 1, 20, 17, 0),
      );

      test('returns null for a date outside the range', () {
        expect(tenDays.rangeOnDate(FloatingDateTime(2024, 1, 5)), isNull);
        expect(tenDays.rangeOnDate(FloatingDateTime(2024, 1, 25)), isNull);
      });

      test('returns the full range when start and end are on the same day', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 1, 15, 9, 0),
          end: FloatingDateTime(2024, 1, 15, 17, 0),
        );

        expect(range.rangeOnDate(FloatingDateTime(2024, 1, 15)), range);
      });

      test('returns start to endOfDay for the start date', () {
        expect(
          tenDays.rangeOnDate(FloatingDateTime(2024, 1, 10)),
          FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 10, 9, 0), end: FloatingDateTime(2024, 1, 11)),
        );
      });

      test('returns startOfDay to end for the end date', () {
        expect(
          tenDays.rangeOnDate(FloatingDateTime(2024, 1, 20)),
          FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 20), end: FloatingDateTime(2024, 1, 20, 17, 0)),
        );
      });

      test('returns full day range for a date in the middle', () {
        expect(
          tenDays.rangeOnDate(FloatingDateTime(2024, 1, 15)),
          FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 15), end: FloatingDateTime(2024, 1, 16)),
        );
      });
    });

    group('overlaps', () {
      FloatingDateTimeRange january(int startDay, int endDay) =>
          FloatingDateTimeRange(start: FloatingDateTime(2024, 1, startDay), end: FloatingDateTime(2024, 1, endDay));

      final cases = [
        (name: 'overlapping ranges', a: january(1, 10), b: january(5, 15), touching: false, expected: true),
        (name: 'a range containing the other', a: january(1, 31), b: january(10, 20), touching: false, expected: true),
        (name: 'a range inside the other', a: january(10, 20), b: january(1, 31), touching: false, expected: true),
        (name: 'non-overlapping ranges', a: january(1, 5), b: january(10, 15), touching: false, expected: false),
        (
          name: 'touching ranges without touching flag',
          a: january(1, 5),
          b: january(5, 10),
          touching: false,
          expected: false,
        ),
        (
          name: 'touching ranges with touching flag',
          a: january(1, 5),
          b: january(5, 10),
          touching: true,
          expected: true,
        ),
        (
          name: 'end-to-start touching with touching flag',
          a: january(5, 10),
          b: january(1, 5),
          touching: true,
          expected: true,
        ),
        (name: 'identical ranges', a: january(1, 10), b: january(1, 10), touching: false, expected: true),
      ];

      for (final c in cases) {
        test('returns ${c.expected} for ${c.name}', () {
          expect(c.a.overlaps(c.b, touching: c.touching), c.expected);
        });
      }
    });

    group('monthDifference', () {
      final cases = [
        (
          name: 'within the same year',
          start: FloatingDateTime(2024, 1, 1),
          end: FloatingDateTime(2024, 6, 1),
          expected: 5,
        ),
        (name: 'across years', start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2025, 6, 1), expected: 17),
        (
          name: 'for adjacent months',
          start: FloatingDateTime(2024, 3, 15),
          end: FloatingDateTime(2024, 4, 15),
          expected: 1,
        ),
        (
          name: 'for exactly one year',
          start: FloatingDateTime(2024, 1, 1),
          end: FloatingDateTime(2025, 1, 1),
          expected: 12,
        ),
        (
          name: 'across the year boundary',
          start: FloatingDateTime(2024, 11, 1),
          end: FloatingDateTime(2025, 2, 1),
          expected: 3,
        ),
      ];

      for (final c in cases) {
        test('returns ${c.expected} ${c.name}', () {
          expect(FloatingDateTimeRange(start: c.start, end: c.end).monthDifference, c.expected);
        });
      }
    });

    group('dominantMonthDate', () {
      test('returns current month for a range within one month', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 3, 5), end: FloatingDateTime(2024, 3, 25));

        final result = range.dominantMonthDate;
        expect(result.year, 2024);
        expect(result.month, 3);
        expect(result.day, 1);
      });

      test('returns the month with the most days for a cross-month range', () {
        // Jan 25 to Feb 5 → 7 days in Jan (25-31), 4 days in Feb (1-4) → Jan dominates
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 25), end: FloatingDateTime(2024, 2, 5));

        final result = range.dominantMonthDate;
        expect(result.month, 1);
      });

      test('returns the earlier month when days are equal (stable reduce)', () {
        // Jan 29 to Feb 4 → 3 days in Jan (29-31), 3 days in Feb (1-3)
        // reduce keeps 'a' when equal, so Jan wins
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 29), end: FloatingDateTime(2024, 2, 4));

        final result = range.dominantMonthDate;
        expect(result.month, 1);
      });
    });

    group('weekNumbers', () {
      test('returns a single week number when range fits within one week', () {
        // Mon Jan 6 to Sun Jan 12, 2025 — ISO week 2
        final range = FloatingDateTimeRange(start: FloatingDateTime(2025, 1, 6), end: FloatingDateTime(2025, 1, 12));
        final (first, last) = range.weekNumbers;

        expect(first, 2);
        expect(last, isNull);
      });

      test('returns two week numbers when range spans multiple weeks', () {
        // Mon Jan 6 to Tue Jan 14, 2025 — 8 dates → ISO weeks 2 and 3
        final range = FloatingDateTimeRange(start: FloatingDateTime(2025, 1, 6), end: FloatingDateTime(2025, 1, 14));
        final (first, last) = range.weekNumbers;

        expect(first, 2);
        expect(last, 3);
      });

      test('treats midnight end as the previous day', () {
        // Mon Jan 6 to Mon Jan 13 at midnight — end is startOfDay so treated as Jan 12
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2025, 1, 6),
          end: FloatingDateTime(2025, 1, 13, 0, 0, 0),
        );
        final (first, last) = range.weekNumbers;

        expect(first, 2);
        expect(last, isNull);
      });

      test('handles cross-year range', () {
        // Dec 22, 2024 (Sun) to Jan 6, 2025 (Mon) — >7 days, cross-year
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 12, 22), end: FloatingDateTime(2025, 1, 6));
        final (first, last) = range.weekNumbers;

        expect(first, FloatingDateTime(2024, 12, 22).weekNumber);
        expect(last, FloatingDateTime(2025, 1, 6).weekNumber);
      });
    });
  });
}
