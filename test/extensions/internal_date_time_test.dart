import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  setUpAll(tz.initializeTimeZones);

  group('InternalDateTime', () {
    // ── Constructor ──────────────────────────────────────────────────────

    group('constructor', () {
      test('creates a UTC DateTime with the given components', () {
        final dt = InternalDateTime(2024, 3, 15, 10, 30, 45, 100, 200);

        expect(dt.year, 2024);
        expect(dt.month, 3);
        expect(dt.day, 15);
        expect(dt.hour, 10);
        expect(dt.minute, 30);
        expect(dt.second, 45);
        expect(dt.millisecond, 100);
        expect(dt.microsecond, 200);
        expect(dt.isUtc, true);
      });

      test('defaults omitted components to zero / one', () {
        final dt = InternalDateTime(2024);

        expect(dt.year, 2024);
        expect(dt.month, 1);
        expect(dt.day, 1);
        expect(dt.hour, 0);
        expect(dt.minute, 0);
        expect(dt.second, 0);
        expect(dt.millisecond, 0);
        expect(dt.microsecond, 0);
      });

      test('is a subclass of DateTime', () {
        expect(InternalDateTime(2024), isA<DateTime>());
      });
    });

    // ── fromDateTime ─────────────────────────────────────────────────────

    group('fromDateTime', () {
      test('preserves components of a local DateTime', () {
        final local = DateTime(2024, 6, 20, 14, 45, 30, 500, 700);
        final internal = InternalDateTime.fromDateTime(local);

        expect(internal.year, 2024);
        expect(internal.month, 6);
        expect(internal.day, 20);
        expect(internal.hour, 14);
        expect(internal.minute, 45);
        expect(internal.second, 30);
        expect(internal.millisecond, 500);
        expect(internal.microsecond, 700);
        expect(internal.isUtc, true);
      });

      test('preserves components of a UTC DateTime', () {
        final utc = DateTime.utc(2024, 12, 31, 23, 59, 59);
        final internal = InternalDateTime.fromDateTime(utc);

        expect(internal.year, 2024);
        expect(internal.month, 12);
        expect(internal.day, 31);
        expect(internal.hour, 23);
        expect(internal.minute, 59);
        expect(internal.second, 59);
      });

      test('preserves components of a TZDateTime', () {
        final location = getLocation('America/New_York');
        final tzDate = TZDateTime(location, 2024, 7, 4, 22, 30);
        final internal = InternalDateTime.fromDateTime(tzDate);

        expect(internal.year, 2024);
        expect(internal.month, 7);
        expect(internal.day, 4);
        expect(internal.hour, 22);
        expect(internal.minute, 30);
      });
    });

    // ── fromExternal ─────────────────────────────────────────────────────

    group('fromExternal', () {
      test('returns the same instance if already an InternalDateTime', () {
        final internal = InternalDateTime(2024, 5, 10, 8, 0);
        final result = InternalDateTime.fromExternal(internal);

        expect(identical(result, internal), true);
      });

      test('converts a local DateTime via local timezone when no location is given', () {
        // Create a UTC DateTime and convert through fromExternal without a location.
        // This should convert to local first, then store those components.
        final utc = DateTime.utc(2024, 6, 15, 12, 0);
        final result = InternalDateTime.fromExternal(utc);
        final expectedLocal = utc.toLocal();

        expect(result.year, expectedLocal.year);
        expect(result.month, expectedLocal.month);
        expect(result.day, expectedLocal.day);
        expect(result.hour, expectedLocal.hour);
        expect(result.minute, expectedLocal.minute);
      });

      test('converts a UTC DateTime to the specified location', () {
        final location = getLocation('Asia/Tokyo'); // UTC+9
        final utc = DateTime.utc(2024, 1, 1, 0, 0); // midnight UTC
        final result = InternalDateTime.fromExternal(utc, location: location);

        // In Tokyo this is Jan 1 09:00
        expect(result.year, 2024);
        expect(result.month, 1);
        expect(result.day, 1);
        expect(result.hour, 9);
        expect(result.minute, 0);
      });

      test('converts a UTC DateTime that crosses day boundary in target location', () {
        final location = getLocation('Pacific/Honolulu'); // UTC-10
        final utc = DateTime.utc(2024, 3, 1, 5, 0); // 5 AM UTC on Mar 1
        final result = InternalDateTime.fromExternal(utc, location: location);

        // In Honolulu this is Feb 29 19:00 (2024 is a leap year)
        expect(result.year, 2024);
        expect(result.month, 2);
        expect(result.day, 29);
        expect(result.hour, 19);
      });
    });

    // ── startOfDay ───────────────────────────────────────────────────────

    group('startOfDay', () {
      test('returns midnight of the same date', () {
        final dt = InternalDateTime(2024, 3, 15, 14, 30, 45);
        final sod = dt.startOfDay;

        expect(sod.year, 2024);
        expect(sod.month, 3);
        expect(sod.day, 15);
        expect(sod.hour, 0);
        expect(sod.minute, 0);
        expect(sod.second, 0);
        expect(sod.millisecond, 0);
        expect(sod.microsecond, 0);
      });

      test('is idempotent for midnight', () {
        final midnight = InternalDateTime(2024, 1, 1);
        expect(midnight.startOfDay, midnight);
      });

      test('returns an InternalDateTime', () {
        expect(InternalDateTime(2024, 5, 1, 12).startOfDay, isA<InternalDateTime>());
      });
    });

    // ── endOfDay ─────────────────────────────────────────────────────────

    group('endOfDay', () {
      test('returns midnight of the next day', () {
        final dt = InternalDateTime(2024, 3, 15, 14, 30);
        final eod = dt.endOfDay;

        expect(eod.year, 2024);
        expect(eod.month, 3);
        expect(eod.day, 16);
        expect(eod.hour, 0);
        expect(eod.minute, 0);
        expect(eod.second, 0);
      });

      test('wraps month correctly on last day of month', () {
        final dt = InternalDateTime(2024, 1, 31, 10, 0);
        final eod = dt.endOfDay;

        expect(eod.year, 2024);
        expect(eod.month, 2);
        expect(eod.day, 1);
      });

      test('wraps year correctly on Dec 31', () {
        final dt = InternalDateTime(2024, 12, 31, 23, 59);
        final eod = dt.endOfDay;

        expect(eod.year, 2025);
        expect(eod.month, 1);
        expect(eod.day, 1);
      });

      test('returns an InternalDateTime', () {
        expect(InternalDateTime(2024).endOfDay, isA<InternalDateTime>());
      });
    });

    // ── dayRange ─────────────────────────────────────────────────────────

    group('dayRange', () {
      test('covers the full day as a half-open range', () {
        final dt = InternalDateTime(2024, 6, 15, 10, 30);
        final range = dt.dayRange;

        expect(range.start, InternalDateTime(2024, 6, 15));
        expect(range.end, InternalDateTime(2024, 6, 16));
      });

      test('range duration is exactly 24 hours', () {
        final range = InternalDateTime(2024, 3, 10).dayRange;
        expect(range.end.difference(range.start), const Duration(hours: 24));
      });
    });

    // ── startOfMonth / endOfMonth / monthRange ───────────────────────────

    group('startOfMonth', () {
      test('returns the first day of the month at midnight', () {
        final dt = InternalDateTime(2024, 7, 20, 15, 45);
        final som = dt.startOfMonth;

        expect(som.year, 2024);
        expect(som.month, 7);
        expect(som.day, 1);
        expect(som.hour, 0);
      });
    });

    group('endOfMonth', () {
      test('returns the first day of the next month at midnight', () {
        final dt = InternalDateTime(2024, 1, 15);
        final eom = dt.endOfMonth;

        expect(eom.year, 2024);
        expect(eom.month, 2);
        expect(eom.day, 1);
      });

      test('wraps year correctly for December', () {
        final dt = InternalDateTime(2024, 12, 25);
        final eom = dt.endOfMonth;

        expect(eom.year, 2025);
        expect(eom.month, 1);
        expect(eom.day, 1);
      });
    });

    group('monthRange', () {
      test('covers the full month as a half-open range', () {
        final range = InternalDateTime(2024, 2, 10).monthRange;

        expect(range.start, InternalDateTime(2024, 2, 1));
        expect(range.end, InternalDateTime(2024, 3, 1));
      });

      test('February in a leap year has 29 days', () {
        final range = InternalDateTime(2024, 2, 1).monthRange;
        expect(range.end.difference(range.start).inDays, 29);
      });

      test('February in a non-leap year has 28 days', () {
        final range = InternalDateTime(2023, 2, 1).monthRange;
        expect(range.end.difference(range.start).inDays, 28);
      });
    });

    // ── startOfYear / endOfYear / yearRange ──────────────────────────────

    group('startOfYear', () {
      test('returns January 1st at midnight', () {
        final soy = InternalDateTime(2024, 8, 20, 10, 30).startOfYear;

        expect(soy.year, 2024);
        expect(soy.month, 1);
        expect(soy.day, 1);
        expect(soy.hour, 0);
      });
    });

    group('endOfYear', () {
      test('returns January 1st of the next year at midnight', () {
        final eoy = InternalDateTime(2024, 5, 15).endOfYear;

        expect(eoy.year, 2025);
        expect(eoy.month, 1);
        expect(eoy.day, 1);
      });
    });

    group('yearRange', () {
      test('covers the full year as a half-open range', () {
        final range = InternalDateTime(2024, 6, 1).yearRange;

        expect(range.start, InternalDateTime(2024, 1, 1));
        expect(range.end, InternalDateTime(2025, 1, 1));
      });

      test('leap year has 366 days', () {
        final range = InternalDateTime(2024, 1, 1).yearRange;
        expect(range.end.difference(range.start).inDays, 366);
      });

      test('non-leap year has 365 days', () {
        final range = InternalDateTime(2023, 1, 1).yearRange;
        expect(range.end.difference(range.start).inDays, 365);
      });
    });

    // ── isStartOfDay ─────────────────────────────────────────────────────

    group('isStartOfDay', () {
      test('returns true for midnight', () {
        expect(InternalDateTime(2024, 1, 1).isStartOfDay, true);
      });

      test('returns false when hour is non-zero', () {
        expect(InternalDateTime(2024, 1, 1, 1).isStartOfDay, false);
      });

      test('returns false when minute is non-zero', () {
        expect(InternalDateTime(2024, 1, 1, 0, 1).isStartOfDay, false);
      });

      test('returns false when second is non-zero', () {
        expect(InternalDateTime(2024, 1, 1, 0, 0, 1).isStartOfDay, false);
      });

      test('returns false when millisecond is non-zero', () {
        expect(InternalDateTime(2024, 1, 1, 0, 0, 0, 1).isStartOfDay, false);
      });

      test('returns false when microsecond is non-zero', () {
        expect(InternalDateTime(2024, 1, 1, 0, 0, 0, 0, 1).isStartOfDay, false);
      });
    });

    // ── startOfWeek / endOfWeek / weekRange ──────────────────────────────

    group('startOfWeek', () {
      test('returns Monday for a Wednesday (default firstDayOfWeek)', () {
        // 2024-01-10 is a Wednesday
        final dt = InternalDateTime(2024, 1, 10, 14, 30);
        final sow = dt.startOfWeek();

        expect(sow.year, 2024);
        expect(sow.month, 1);
        expect(sow.day, 8); // Monday
        expect(sow.weekday, DateTime.monday);
        expect(sow.hour, 0);
      });

      test('returns Monday for a Monday', () {
        // 2024-01-08 is a Monday
        final dt = InternalDateTime(2024, 1, 8);
        final sow = dt.startOfWeek();

        expect(sow.day, 8);
        expect(sow.weekday, DateTime.monday);
      });

      test('returns Monday for a Sunday', () {
        // 2024-01-14 is a Sunday
        final dt = InternalDateTime(2024, 1, 14);
        final sow = dt.startOfWeek();

        expect(sow.day, 8); // Monday Jan 8
        expect(sow.weekday, DateTime.monday);
      });

      test('returns Sunday when firstDayOfWeek is Sunday', () {
        // 2024-01-10 is a Wednesday
        final dt = InternalDateTime(2024, 1, 10);
        final sow = dt.startOfWeek(firstDayOfWeek: DateTime.sunday);

        expect(sow.day, 7); // Sunday Jan 7
        expect(sow.weekday, DateTime.sunday);
      });

      test('returns Saturday when firstDayOfWeek is Saturday', () {
        // 2024-01-10 is a Wednesday
        final dt = InternalDateTime(2024, 1, 10);
        final sow = dt.startOfWeek(firstDayOfWeek: DateTime.saturday);

        expect(sow.day, 6); // Saturday Jan 6
        expect(sow.weekday, DateTime.saturday);
      });

      test('can cross month boundary backward', () {
        // 2024-03-01 is a Friday
        final dt = InternalDateTime(2024, 3, 1);
        final sow = dt.startOfWeek();

        expect(sow.year, 2024);
        expect(sow.month, 2);
        expect(sow.day, 26); // Monday Feb 26
      });

      test('can cross year boundary backward', () {
        // 2024-01-01 is a Monday — but let's pick Jan 3 (Wednesday)
        final dt = InternalDateTime(2024, 1, 3);
        final sow = dt.startOfWeek();

        expect(sow.year, 2024);
        expect(sow.month, 1);
        expect(sow.day, 1); // Monday Jan 1

        // 2025-01-01 is a Wednesday
        final dt2 = InternalDateTime(2025, 1, 1);
        final sow2 = dt2.startOfWeek();

        expect(sow2.year, 2024);
        expect(sow2.month, 12);
        expect(sow2.day, 30); // Monday Dec 30
      });
    });

    group('endOfWeek', () {
      test('returns next Monday for a Wednesday (default firstDayOfWeek)', () {
        // 2024-01-10 is a Wednesday
        final dt = InternalDateTime(2024, 1, 10);
        final eow = dt.endOfWeek();

        expect(eow.year, 2024);
        expect(eow.month, 1);
        expect(eow.day, 15); // next Monday
        expect(eow.weekday, DateTime.monday);
        expect(eow.hour, 0);
      });

      test('returns next Monday for a Monday', () {
        // 2024-01-08 is a Monday
        final dt = InternalDateTime(2024, 1, 8);
        final eow = dt.endOfWeek();

        expect(eow.day, 15);
      });

      test('returns next Monday for a Sunday', () {
        // 2024-01-14 is a Sunday
        final dt = InternalDateTime(2024, 1, 14);
        final eow = dt.endOfWeek();

        expect(eow.day, 15);
      });

      test('returns next Sunday when firstDayOfWeek is Sunday', () {
        // 2024-01-10 is a Wednesday
        final dt = InternalDateTime(2024, 1, 10);
        final eow = dt.endOfWeek(firstDayOfWeek: DateTime.sunday);

        expect(eow.day, 14); // Sunday Jan 14
        expect(eow.weekday, DateTime.sunday);
      });

      test('can cross month boundary forward', () {
        // 2024-01-29 is a Monday
        final dt = InternalDateTime(2024, 1, 29);
        final eow = dt.endOfWeek();

        expect(eow.year, 2024);
        expect(eow.month, 2);
        expect(eow.day, 5); // Monday Feb 5
      });
    });

    group('weekRange', () {
      test('covers a full 7-day week', () {
        final range = InternalDateTime(2024, 1, 10).weekRange();

        expect(range.end.difference(range.start).inDays, 7);
      });

      test('start and end match startOfWeek and endOfWeek', () {
        final dt = InternalDateTime(2024, 6, 12);
        final range = dt.weekRange(firstDayOfWeek: DateTime.sunday);

        expect(range.start, dt.startOfWeek(firstDayOfWeek: DateTime.sunday));
        expect(range.end, dt.endOfWeek(firstDayOfWeek: DateTime.sunday));
      });
    });

    // ── forLocation ──────────────────────────────────────────────────────

    group('forLocation', () {
      test('returns a local DateTime when location is null', () {
        final internal = InternalDateTime(2024, 6, 15, 10, 30);
        final result = internal.forLocation();

        expect(result.isUtc, false);
        expect(result.year, 2024);
        expect(result.month, 6);
        expect(result.day, 15);
        expect(result.hour, 10);
        expect(result.minute, 30);
      });

      test('returns a TZDateTime when location is provided', () {
        final location = getLocation('America/New_York');
        final internal = InternalDateTime(2024, 6, 15, 10, 30);
        final result = internal.forLocation(location: location);

        expect(result, isA<TZDateTime>());
        expect(result.year, 2024);
        expect(result.month, 6);
        expect(result.day, 15);
        expect(result.hour, 10);
        expect(result.minute, 30);
      });

      test('different locations produce different UTC offsets', () {
        final newYork = getLocation('America/New_York');
        final tokyo = getLocation('Asia/Tokyo');
        final internal = InternalDateTime(2024, 1, 15, 12, 0);

        final nyResult = internal.forLocation(location: newYork) as TZDateTime;
        final tokyoResult = internal.forLocation(location: tokyo) as TZDateTime;

        expect(nyResult.timeZone.offset, isNot(equals(tokyoResult.timeZone.offset)));
      });
    });

    // ── isToday ──────────────────────────────────────────────────────────

    group('isToday', () {
      test('returns true for today without location', () {
        final now = DateTime.now();
        final internal = InternalDateTime(now.year, now.month, now.day);

        expect(internal.isToday(), true);
      });

      test('returns false for yesterday without location', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final internal = InternalDateTime(yesterday.year, yesterday.month, yesterday.day);

        expect(internal.isToday(), false);
      });

      test('returns false for tomorrow without location', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final internal = InternalDateTime(tomorrow.year, tomorrow.month, tomorrow.day);

        expect(internal.isToday(), false);
      });

      test('returns true for today with a specific location', () {
        final location = getLocation('America/New_York');
        final nowInNY = TZDateTime.now(location);
        final internal = InternalDateTime(nowInNY.year, nowInNY.month, nowInNY.day);

        expect(internal.isToday(location: location), true);
      });

      test('returns true regardless of time component if same day', () {
        final now = DateTime.now();
        final internal = InternalDateTime(now.year, now.month, now.day, 23, 59, 59);

        expect(internal.isToday(), true);
      });
    });

    // ── isSameDay ────────────────────────────────────────────────────────

    group('isSameDay', () {
      test('returns true for the same date with different times', () {
        final a = InternalDateTime(2024, 1, 15, 10, 30);
        final b = InternalDateTime(2024, 1, 15, 22, 0);

        expect(a.isSameDay(b), true);
      });

      test('returns false for different days', () {
        expect(InternalDateTime(2024, 1, 15).isSameDay(InternalDateTime(2024, 1, 16)), false);
      });

      test('returns false for different months', () {
        expect(InternalDateTime(2024, 1, 15).isSameDay(InternalDateTime(2024, 2, 15)), false);
      });

      test('returns false for different years', () {
        expect(InternalDateTime(2024, 1, 15).isSameDay(InternalDateTime(2025, 1, 15)), false);
      });

      test('is symmetric', () {
        final a = InternalDateTime(2024, 5, 20, 8, 0);
        final b = InternalDateTime(2024, 5, 20, 18, 0);

        expect(a.isSameDay(b), b.isSameDay(a));
      });
    });

    // ── isWithin ─────────────────────────────────────────────────────────

    group('isWithin', () {
      final rangeStart = InternalDateTime(2024, 1, 10);
      final rangeEnd = InternalDateTime(2024, 1, 20);
      final range = InternalDateTimeRange(start: rangeStart, end: rangeEnd);

      test('returns true for a date strictly inside the range', () {
        final date = InternalDateTime(2024, 1, 15);
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
        final before = InternalDateTime(2024, 1, 5);
        expect(before.isWithin(range), false);
      });

      test('returns false for a date after the range', () {
        final after = InternalDateTime(2024, 1, 25);
        expect(after.isWithin(range), false);
      });

      test('strictly exclusive with both flags false', () {
        expect(rangeStart.isWithin(range, includeStart: false, includeEnd: false), false);
        expect(rangeEnd.isWithin(range, includeStart: false, includeEnd: false), false);
        // A date inside should still be within
        expect(InternalDateTime(2024, 1, 15).isWithin(range, includeStart: false, includeEnd: false), true);
      });
    });

    // ── weekNumber ───────────────────────────────────────────────────────

    group('weekNumber', () {
      test('January 1, 2024 (Monday) is week 1', () {
        expect(InternalDateTime(2024, 1, 1).weekNumber, 1);
      });

      test('December 31, 2024 (Tuesday) is week 1 of next year', () {
        // 2024-12-31 is a Tuesday; Jan 1, 2025 is a Wednesday.
        // The ISO week for Dec 31, 2024 is week 1 of 2025.
        expect(InternalDateTime(2024, 12, 31).weekNumber, 1);
      });

      test('December 28 is always in the last week of its year', () {
        // By ISO 8601, Dec 28 is always in the last week of the year.
        expect(InternalDateTime(2024, 12, 28).weekNumber, 52);
        expect(InternalDateTime(2023, 12, 28).weekNumber, 52);
      });

      test('January 1, 2023 (Sunday) is week 52 of 2022', () {
        // Jan 1, 2023 is a Sunday, which belongs to ISO week 52 of 2022.
        expect(InternalDateTime(2023, 1, 1).weekNumber, 52);
      });

      test('January 4 is always in week 1', () {
        // By ISO 8601, January 4 is always in week 1.
        expect(InternalDateTime(2024, 1, 4).weekNumber, 1);
        expect(InternalDateTime(2023, 1, 4).weekNumber, 1);
        expect(InternalDateTime(2022, 1, 4).weekNumber, 1);
      });

      test('known week numbers for specific dates', () {
        // 2024-03-01 is a Friday in week 9
        expect(InternalDateTime(2024, 3, 1).weekNumber, 9);
        // 2024-07-01 is a Monday in week 27
        expect(InternalDateTime(2024, 7, 1).weekNumber, 27);
      });

      test('week 53 exists in years where Jan 1 or Dec 31 is Thursday', () {
        // 2015: Jan 1 is Thursday → has week 53
        expect(InternalDateTime(2015, 12, 31).weekNumber, 53);
        // 2020: Dec 31 is Thursday → has week 53
        expect(InternalDateTime(2020, 12, 31).weekNumber, 53);
      });
    });

    // ── ordinalDate ──────────────────────────────────────────────────────

    group('ordinalDate', () {
      test('January 1 is ordinal day 1', () {
        expect(InternalDateTime(2024, 1, 1).ordinalDate, 1);
      });

      test('February 1 is ordinal day 32', () {
        expect(InternalDateTime(2024, 2, 1).ordinalDate, 32);
      });

      test('March 1 in a leap year is ordinal day 61', () {
        expect(InternalDateTime(2024, 3, 1).ordinalDate, 61);
      });

      test('March 1 in a non-leap year is ordinal day 60', () {
        expect(InternalDateTime(2023, 3, 1).ordinalDate, 60);
      });

      test('December 31 in a leap year is ordinal day 366', () {
        expect(InternalDateTime(2024, 12, 31).ordinalDate, 366);
      });

      test('December 31 in a non-leap year is ordinal day 365', () {
        expect(InternalDateTime(2023, 12, 31).ordinalDate, 365);
      });

      test('July 4 is ordinal day 186 in a leap year', () {
        // Jan(31) + Feb(29) + Mar(31) + Apr(30) + May(31) + Jun(30) + 4 = 186
        expect(InternalDateTime(2024, 7, 4).ordinalDate, 186);
      });
    });

    // ── isLeapYear ───────────────────────────────────────────────────────

    group('isLeapYear', () {
      test('returns true for years divisible by 4', () {
        expect(InternalDateTime(2024).isLeapYear, true);
        expect(InternalDateTime(2028).isLeapYear, true);
      });

      test('returns false for years divisible by 100 but not 400', () {
        expect(InternalDateTime(1900).isLeapYear, false);
        expect(InternalDateTime(2100).isLeapYear, false);
      });

      test('returns true for years divisible by 400', () {
        expect(InternalDateTime(2000).isLeapYear, true);
        expect(InternalDateTime(2400).isLeapYear, true);
      });

      test('returns false for common non-leap years', () {
        expect(InternalDateTime(2023).isLeapYear, false);
        expect(InternalDateTime(2025).isLeapYear, false);
      });
    });

    // ── add ──────────────────────────────────────────────────────────────

    group('add', () {
      test('adds a positive duration', () {
        final dt = InternalDateTime(2024, 1, 1, 10, 0);
        final result = dt.add(const Duration(hours: 5));

        expect(result, isA<InternalDateTime>());
        expect(result.hour, 15);
        expect(result.day, 1);
      });

      test('adding duration crosses day boundary', () {
        final dt = InternalDateTime(2024, 1, 1, 23, 0);
        final result = dt.add(const Duration(hours: 3));

        expect(result.year, 2024);
        expect(result.month, 1);
        expect(result.day, 2);
        expect(result.hour, 2);
      });

      test('adding days works correctly', () {
        final dt = InternalDateTime(2024, 2, 28);
        final result = dt.add(const Duration(days: 1));

        // 2024 is a leap year
        expect(result.month, 2);
        expect(result.day, 29);
      });

      test('adding zero duration returns equivalent InternalDateTime', () {
        final dt = InternalDateTime(2024, 6, 15, 12, 30);
        final result = dt.add(Duration.zero);

        expect(result.isAtSameMomentAs(dt), true);
        expect(result, isA<InternalDateTime>());
      });
    });

    // ── subtract ─────────────────────────────────────────────────────────

    group('subtract', () {
      test('subtracts a positive duration', () {
        final dt = InternalDateTime(2024, 1, 1, 10, 0);
        final result = dt.subtract(const Duration(hours: 5));

        expect(result, isA<InternalDateTime>());
        expect(result.hour, 5);
        expect(result.day, 1);
      });

      test('subtracting duration crosses day boundary backward', () {
        final dt = InternalDateTime(2024, 1, 2, 1, 0);
        final result = dt.subtract(const Duration(hours: 3));

        expect(result.year, 2024);
        expect(result.month, 1);
        expect(result.day, 1);
        expect(result.hour, 22);
      });

      test('subtracting days works correctly across month boundary', () {
        final dt = InternalDateTime(2024, 3, 1);
        final result = dt.subtract(const Duration(days: 1));

        // 2024 is a leap year
        expect(result.month, 2);
        expect(result.day, 29);
      });

      test('subtracting zero duration returns equivalent InternalDateTime', () {
        final dt = InternalDateTime(2024, 6, 15, 12, 30);
        final result = dt.subtract(Duration.zero);

        expect(result.isAtSameMomentAs(dt), true);
        expect(result, isA<InternalDateTime>());
      });
    });

    // ── difference ───────────────────────────────────────────────────────

    group('difference', () {
      test('returns positive duration when other is earlier', () {
        final a = InternalDateTime(2024, 1, 2);
        final b = InternalDateTime(2024, 1, 1);

        expect(a.difference(b), const Duration(days: 1));
      });

      test('returns negative duration when other is later', () {
        final a = InternalDateTime(2024, 1, 1);
        final b = InternalDateTime(2024, 1, 2);

        expect(a.difference(b), const Duration(days: -1));
      });

      test('returns zero for the same instant', () {
        final dt = InternalDateTime(2024, 6, 15, 10, 30);
        expect(dt.difference(InternalDateTime(2024, 6, 15, 10, 30)), Duration.zero);
      });

      test('handles hour-level differences', () {
        final a = InternalDateTime(2024, 1, 1, 14, 0);
        final b = InternalDateTime(2024, 1, 1, 10, 0);

        expect(a.difference(b), const Duration(hours: 4));
      });

      test('works across month boundaries', () {
        final a = InternalDateTime(2024, 3, 1);
        final b = InternalDateTime(2024, 2, 1);

        // Feb 2024 has 29 days (leap year)
        expect(a.difference(b), const Duration(days: 29));
      });

      test('works with a plain DateTime argument', () {
        final internal = InternalDateTime(2024, 1, 2);
        final plain = DateTime.utc(2024, 1, 1);

        expect(internal.difference(plain), const Duration(days: 1));
      });
    });

    // ── copyWith ─────────────────────────────────────────────────────────

    group('copyWith', () {
      test('returns an InternalDateTime', () {
        final dt = InternalDateTime(2024, 6, 15, 10, 30);
        expect(dt.copyWith(), isA<InternalDateTime>());
      });

      test('copies all fields when no arguments are given', () {
        final dt = InternalDateTime(2024, 3, 15, 10, 30, 45, 100, 200);
        final copy = dt.copyWith();

        expect(copy.year, 2024);
        expect(copy.month, 3);
        expect(copy.day, 15);
        expect(copy.hour, 10);
        expect(copy.minute, 30);
        expect(copy.second, 45);
        expect(copy.millisecond, 100);
        expect(copy.microsecond, 200);
        expect(copy.isAtSameMomentAs(dt), true);
      });

      test('replaces year', () {
        final dt = InternalDateTime(2024, 6, 15);
        expect(dt.copyWith(year: 2025).year, 2025);
        expect(dt.copyWith(year: 2025).month, 6);
      });

      test('replaces month', () {
        final dt = InternalDateTime(2024, 6, 15);
        expect(dt.copyWith(month: 12).month, 12);
        expect(dt.copyWith(month: 12).day, 15);
      });

      test('replaces day', () {
        final dt = InternalDateTime(2024, 6, 15);
        expect(dt.copyWith(day: 28).day, 28);
      });

      test('replaces hour', () {
        final dt = InternalDateTime(2024, 6, 15, 10);
        expect(dt.copyWith(hour: 23).hour, 23);
      });

      test('replaces minute', () {
        final dt = InternalDateTime(2024, 6, 15, 10, 30);
        expect(dt.copyWith(minute: 59).minute, 59);
      });

      test('replaces second', () {
        final dt = InternalDateTime(2024, 6, 15, 10, 30, 45);
        expect(dt.copyWith(second: 0).second, 0);
      });

      test('replaces millisecond', () {
        final dt = InternalDateTime(2024, 6, 15, 10, 30, 45, 100);
        expect(dt.copyWith(millisecond: 999).millisecond, 999);
      });

      test('replaces microsecond', () {
        final dt = InternalDateTime(2024, 6, 15, 10, 30, 45, 100, 200);
        expect(dt.copyWith(microsecond: 500).microsecond, 500);
      });

      test('replaces multiple fields at once', () {
        final dt = InternalDateTime(2024, 1, 1, 0, 0, 0);
        final copy = dt.copyWith(year: 2025, month: 12, day: 31, hour: 23, minute: 59, second: 59);

        expect(copy.year, 2025);
        expect(copy.month, 12);
        expect(copy.day, 31);
        expect(copy.hour, 23);
        expect(copy.minute, 59);
        expect(copy.second, 59);
      });

      test('handles day overflow into next month', () {
        final dt = InternalDateTime(2024, 1, 15);
        final copy = dt.copyWith(day: 32);

        // DateTime normalizes day 32 of January → Feb 1
        expect(copy.month, 2);
        expect(copy.day, 1);
      });
    });
  });
}
