import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/extensions/internal.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  setUpAll(tz.initializeTimeZones);

  group('InternalDateTime', () {
    group('fromDateTime', () {
      test('creates an InternalDateTime from a local DateTime preserving components', () {
        final local = DateTime(2024, 3, 20, 14, 45, 30);
        final internal = InternalDateTime.fromDateTime(local);

        expect(internal.year, local.year);
        expect(internal.month, local.month);
        expect(internal.day, local.day);
        expect(internal.hour, local.hour);
        expect(internal.minute, local.minute);
        expect(internal.second, local.second);
        expect(internal.isUtc, true);
      });

      test('creates an InternalDateTime from a UTC DateTime preserving components', () {
        final utc = DateTime.utc(2024, 7, 4, 18, 0);
        final internal = InternalDateTime.fromDateTime(utc);

        expect(internal.year, utc.year);
        expect(internal.month, utc.month);
        expect(internal.day, utc.day);
        expect(internal.hour, utc.hour);
        expect(internal.minute, utc.minute);
        expect(internal.isUtc, true);
      });

      test('creates an InternalDateTime from a TZDateTime preserving components', () {
        final location = getLocation('America/New_York');
        // TZDateTime(location, 2024, 7, 4, 22, 30) represents 10:30 PM in New York
        // which is 2024-07-05 02:30 UTC — but InternalDateTime should preserve
        // the 2024-07-04 22:30 components, not the UTC representation.
        final tzDate = TZDateTime(location, 2024, 7, 4, 22, 30);
        final internal = InternalDateTime.fromDateTime(tzDate);

        expect(internal.year, 2024);
        expect(internal.month, 7);
        expect(internal.day, 4);
        expect(internal.hour, 22);
        expect(internal.minute, 30);
        expect(internal.isUtc, true);
      });

      test('creates an InternalDateTime from a TZDateTime with negative UTC offset', () {
        final location = getLocation('Pacific/Honolulu'); // UTC-10
        final tzDate = TZDateTime(location, 2024, 1, 1, 1, 0); // 1 AM in Honolulu
        // In UTC this would be 2024-01-01 11:00
        final internal = InternalDateTime.fromDateTime(tzDate);

        expect(internal.year, 2024);
        expect(internal.month, 1);
        expect(internal.day, 1);
        expect(internal.hour, 1);
        expect(internal.minute, 0);
      });

      test('creates an InternalDateTime from a TZDateTime with positive UTC offset', () {
        final location = getLocation('Asia/Tokyo'); // UTC+9
        final tzDate = TZDateTime(location, 2024, 1, 1, 2, 0); // 2 AM in Tokyo
        // In UTC this would be 2023-12-31 17:00 — different day!
        final internal = InternalDateTime.fromDateTime(tzDate);

        expect(internal.year, 2024);
        expect(internal.month, 1);
        expect(internal.day, 1);
        expect(internal.hour, 2);
        expect(internal.minute, 0);
      });
    });

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

        expect(result is TZDateTime, true);
        expect(result.year, 2024);
        expect(result.month, 6);
        expect(result.day, 15);
        expect(result.hour, 10);
        expect(result.minute, 30);
      });

      test('returns a TZDateTime with correct timezone for different locations', () {
        final newYork = getLocation('America/New_York');
        final tokyo = getLocation('Asia/Tokyo');
        final internal = InternalDateTime(2024, 1, 15, 12, 0);

        final nyResult = internal.forLocation(location: newYork) as TZDateTime;
        final tokyoResult = internal.forLocation(location: tokyo) as TZDateTime;

        // Both should have the same date/time components
        expect(nyResult.year, 2024);
        expect(tokyoResult.year, 2024);
        expect(nyResult.hour, 12);
        expect(tokyoResult.hour, 12);

        // But different UTC offsets
        expect(nyResult.timeZone.offset, isNot(equals(tokyoResult.timeZone.offset)));
      });
    });

    group('isToday', () {
      test('returns true for today without location', () {
        final now = DateTime.now();
        final internal = InternalDateTime(now.year, now.month, now.day);

        expect(internal.isToday(), true);
      });

      test('returns false for yesterday without location', () {
        final now = DateTime.now();
        final yesterday = now.copyWith(day: now.day - 1);
        final internal = InternalDateTime(yesterday.year, yesterday.month, yesterday.day);

        expect(internal.isToday(), false);
      });

      test('returns false for tomorrow without location', () {
        final now = DateTime.now();
        final tomorrow = now.copyWith(day: now.day + 1);
        final internal = InternalDateTime(tomorrow.year, tomorrow.month, tomorrow.day);

        expect(internal.isToday(), false);
      });

      test('returns true for today with a specific location', () {
        final location = getLocation('America/New_York');
        final nowInNY = TZDateTime.now(location);
        final internal = InternalDateTime(nowInNY.year, nowInNY.month, nowInNY.day);

        expect(internal.isToday(location: location), true);
      });

      test('returns false for yesterday with a specific location', () {
        final location = getLocation('America/New_York');
        final nowInNY = TZDateTime.now(location);
        final yesterday = nowInNY.copyWith(day: nowInNY.day - 1);
        final internal = InternalDateTime(yesterday.year, yesterday.month, yesterday.day);

        expect(internal.isToday(location: location), false);
      });

      test('returns true regardless of time component if same day', () {
        final now = DateTime.now();
        final internal = InternalDateTime(now.year, now.month, now.day, 23, 59, 59);

        expect(internal.isToday(), true);
      });
    });

    group('type checks', () {
      test('is a subclass of DateTime', () {
        final internal = InternalDateTime(2024);
        expect(internal, isA<DateTime>());
      });

      test('is recognized as InternalDateTime via is check', () {
        final DateTime date = InternalDateTime(2024);
        expect(date is InternalDateTime, true);
      });
    });
  });
}
