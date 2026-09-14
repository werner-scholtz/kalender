import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

void main() {
  setUpAll(tz.initializeTimeZones);

  group('FloatingDateTimeRange', () {
    // ── Constructor ────────────────────────────────────────────────────

    group('constructor', () {
      test('wraps start and end as FloatingDateTime', () {
        final range = FloatingDateTimeRange(start: DateTime(2024, 1, 10, 8, 30), end: DateTime(2024, 1, 20, 17, 0));

        expect(range.start, isA<FloatingDateTime>());
        expect(range.end, isA<FloatingDateTime>());
        expect(range.start.year, 2024);
        expect(range.start.month, 1);
        expect(range.start.day, 10);
        expect(range.start.hour, 8);
        expect(range.end.day, 20);
        expect(range.end.hour, 17);
      });

      test('preserves components from UTC DateTimes', () {
        final range = FloatingDateTimeRange(start: DateTime.utc(2024, 6, 1, 12), end: DateTime.utc(2024, 6, 30, 18));

        expect(range.start.month, 6);
        expect(range.start.day, 1);
        expect(range.end.day, 30);
      });
    });

    // ── fromDateTimeRange ────────────────────────────────────────────────

    group('fromDateTimeRange', () {
      test('creates from a Flutter KalenderDateTimeRange', () {
        final flutterRange = KalenderDateTimeRange(start: DateTime(2024, 3, 1), end: DateTime(2024, 3, 31));
        final range = FloatingDateTimeRange.fromDateTimeRange(flutterRange);

        expect(range.start, isA<FloatingDateTime>());
        expect(range.end, isA<FloatingDateTime>());
        expect(range.start.month, 3);
        expect(range.start.day, 1);
        expect(range.end.day, 31);
      });
    });

    // ── forLocation ──────────────────────────────────────────────────────

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

    // ── dates ────────────────────────────────────────────────────────────

    group('dates', () {
      test('returns a single date when start and end are on the same day', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 1, 15, 10, 0),
          end: FloatingDateTime(2024, 1, 15, 18, 0),
        );
        final result = range.dates();

        expect(result.length, 1);
        expect(result.first, FloatingDateTime(2024, 1, 15));
      });

      test('returns all days in a multi-day range (exclusive end)', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 10), end: FloatingDateTime(2024, 1, 13));
        final result = range.dates();

        expect(result.length, 3);
        expect(result[0], FloatingDateTime(2024, 1, 10));
        expect(result[1], FloatingDateTime(2024, 1, 11));
        expect(result[2], FloatingDateTime(2024, 1, 12));
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

        expect(result.length, 3);
        expect(result[0], FloatingDateTime(2024, 1, 30));
        expect(result[1], FloatingDateTime(2024, 1, 31));
        expect(result[2], FloatingDateTime(2024, 2, 1));
      });

      test('handles leap year Feb 28 to Mar 1', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 2, 28), end: FloatingDateTime(2024, 3, 1));
        final result = range.dates();

        expect(result.length, 2);
        expect(result[0], FloatingDateTime(2024, 2, 28));
        expect(result[1], FloatingDateTime(2024, 2, 29));
      });

      test('single day range returns one date even with inclusive flag', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 5, 1, 10, 0),
          end: FloatingDateTime(2024, 5, 1, 20, 0),
        );

        expect(range.dates(inclusive: true).length, 1);
      });
    });

    // ── rangeOnDate ──────────────────────────────────────────────

    group('rangeOnDate', () {
      test('returns null for a date outside the range', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 1, 10, 9, 0),
          end: FloatingDateTime(2024, 1, 20, 17, 0),
        );

        expect(range.rangeOnDate(FloatingDateTime(2024, 1, 5)), isNull);
        expect(range.rangeOnDate(FloatingDateTime(2024, 1, 25)), isNull);
      });

      test('returns the full range when start and end are on the same day', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 1, 15, 9, 0),
          end: FloatingDateTime(2024, 1, 15, 17, 0),
        );
        final result = range.rangeOnDate(FloatingDateTime(2024, 1, 15));

        expect(result, isNotNull);
        expect(result!.start, range.start);
        expect(result.end, range.end);
      });

      test('returns start to endOfDay for the start date', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 1, 10, 9, 0),
          end: FloatingDateTime(2024, 1, 20, 17, 0),
        );
        final result = range.rangeOnDate(FloatingDateTime(2024, 1, 10));

        expect(result, isNotNull);
        expect(result!.start, FloatingDateTime(2024, 1, 10, 9, 0));
        expect(result.end, FloatingDateTime(2024, 1, 11)); // endOfDay
      });

      test('returns startOfDay to end for the end date', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 1, 10, 9, 0),
          end: FloatingDateTime(2024, 1, 20, 17, 0),
        );
        final result = range.rangeOnDate(FloatingDateTime(2024, 1, 20));

        expect(result, isNotNull);
        expect(result!.start, FloatingDateTime(2024, 1, 20)); // startOfDay
        expect(result.end, FloatingDateTime(2024, 1, 20, 17, 0));
      });

      test('returns full day range for a date in the middle', () {
        final range = FloatingDateTimeRange(
          start: FloatingDateTime(2024, 1, 10, 9, 0),
          end: FloatingDateTime(2024, 1, 20, 17, 0),
        );
        final result = range.rangeOnDate(FloatingDateTime(2024, 1, 15));

        expect(result, isNotNull);
        expect(result!.start, FloatingDateTime(2024, 1, 15));
        expect(result.end, FloatingDateTime(2024, 1, 16));
      });
    });

    // ── overlaps ─────────────────────────────────────────────────────────

    group('overlaps', () {
      test('returns true for overlapping ranges', () {
        final a = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2024, 1, 10));
        final b = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 5), end: FloatingDateTime(2024, 1, 15));

        expect(a.overlaps(b), true);
      });

      test('returns true when one range contains the other', () {
        final outer = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2024, 1, 31));
        final inner = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 10), end: FloatingDateTime(2024, 1, 20));

        expect(outer.overlaps(inner), true);
        expect(inner.overlaps(outer), true);
      });

      test('returns false for non-overlapping ranges', () {
        final a = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2024, 1, 5));
        final b = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 10), end: FloatingDateTime(2024, 1, 15));

        expect(a.overlaps(b), false);
      });

      test('returns false for touching ranges without touching flag', () {
        final a = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2024, 1, 5));
        final b = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 5), end: FloatingDateTime(2024, 1, 10));

        expect(a.overlaps(b), false);
      });

      test('returns true for touching ranges with touching flag', () {
        final a = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2024, 1, 5));
        final b = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 5), end: FloatingDateTime(2024, 1, 10));

        expect(a.overlaps(b, touching: true), true);
      });

      test('touching flag detects end-to-start touching', () {
        final a = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 5), end: FloatingDateTime(2024, 1, 10));
        final b = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2024, 1, 5));

        expect(a.overlaps(b, touching: true), true);
      });

      test('returns true for identical ranges', () {
        final a = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2024, 1, 10));
        final b = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2024, 1, 10));

        expect(a.overlaps(b), true);
      });
    });

    // ── monthDifference ──────────────────────────────────────────────────

    group('monthDifference', () {
      test('returns correct difference within the same year', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2024, 6, 1));

        expect(range.monthDifference, 5);
      });

      test('returns correct difference across years', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2025, 6, 1));

        expect(range.monthDifference, 17);
      });

      test('returns 1 for adjacent months', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 3, 15), end: FloatingDateTime(2024, 4, 15));

        expect(range.monthDifference, 1);
      });

      test('returns 12 for exactly one year', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 1, 1), end: FloatingDateTime(2025, 1, 1));

        expect(range.monthDifference, 12);
      });

      test('returns correct difference across year boundary (Dec to Jan)', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2024, 11, 1), end: FloatingDateTime(2025, 2, 1));

        expect(range.monthDifference, 3);
      });
    });

    // ── dominantMonthDate ────────────────────────────────────────────────

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

    // ── weekNumbers ──────────────────────────────────────────────────────

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

      test('single day range returns one week number', () {
        final range = FloatingDateTimeRange(start: FloatingDateTime(2025, 1, 8), end: FloatingDateTime(2025, 1, 9));
        final (first, last) = range.weekNumbers;

        expect(first, 2);
        expect(last, isNull);
      });
    });
  });
}
