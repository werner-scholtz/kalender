import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/kalender_time.dart';

void main() {
  group('KalenderTime', () {
    test('holds the values it was given', () {
      const time = KalenderTime(hour: 14, minute: 30);
      expect(time.hour, 14);
      expect(time.minute, 30);
    });

    test('names the units of a day', () {
      expect(KalenderTime.hoursPerDay, 24);
      expect(KalenderTime.minutesPerHour, 60);
    });

    group('fromDateTime', () {
      test('takes the hour and minute', () {
        final time = KalenderTime.fromDateTime(DateTime(2024, 6, 15, 9, 45));
        expect(time, const KalenderTime(hour: 9, minute: 45));
      });

      test('drops second and below', () {
        final time = KalenderTime.fromDateTime(DateTime(2024, 6, 15, 9, 45, 30, 500, 250));
        expect(time, const KalenderTime(hour: 9, minute: 45));
      });

      test('reads a UTC DateTime in UTC', () {
        final time = KalenderTime.fromDateTime(DateTime.utc(2024, 6, 15, 23, 15));
        expect(time, const KalenderTime(hour: 23, minute: 15));
      });
    });

    test('now is not outside the times taken either side of it', () {
      final before = KalenderTime.fromDateTime(DateTime.now());
      final now = KalenderTime.now();
      final after = KalenderTime.fromDateTime(DateTime.now());

      expect(now.isBefore(before), isFalse);
      expect(now.isAfter(after), isFalse);
    });

    group('replacing', () {
      const time = KalenderTime(hour: 9, minute: 30);

      test('replaces the hour', () {
        expect(time.replacing(hour: 14), const KalenderTime(hour: 14, minute: 30));
      });

      test('replaces the minute', () {
        expect(time.replacing(minute: 45), const KalenderTime(hour: 9, minute: 45));
      });

      test('replaces both', () {
        expect(time.replacing(hour: 0, minute: 0), const KalenderTime(hour: 0, minute: 0));
      });

      test('returns an equal time when given nothing', () {
        expect(time.replacing(), time);
      });

      test('accepts the bounds of the day', () {
        expect(() => time.replacing(hour: 0, minute: 0), returnsNormally);
        expect(() => time.replacing(hour: 23, minute: 59), returnsNormally);
      });

      test('rejects an hour outside the day', () {
        expect(() => time.replacing(hour: 24), throwsAssertionError);
        expect(() => time.replacing(hour: -1), throwsAssertionError);
      });

      test('rejects a minute outside the hour', () {
        expect(() => time.replacing(minute: 60), throwsAssertionError);
        expect(() => time.replacing(minute: -1), throwsAssertionError);
      });
    });

    group('compareTo', () {
      test('orders by hour', () {
        expect(const KalenderTime(hour: 9, minute: 0).compareTo(const KalenderTime(hour: 10, minute: 0)), isNegative);
        expect(const KalenderTime(hour: 10, minute: 0).compareTo(const KalenderTime(hour: 9, minute: 0)), isPositive);
      });

      test('orders by minute when the hour matches', () {
        expect(const KalenderTime(hour: 9, minute: 15).compareTo(const KalenderTime(hour: 9, minute: 30)), isNegative);
        expect(const KalenderTime(hour: 9, minute: 30).compareTo(const KalenderTime(hour: 9, minute: 15)), isPositive);
      });

      test('the hour wins over the minute', () {
        expect(const KalenderTime(hour: 9, minute: 59).compareTo(const KalenderTime(hour: 10, minute: 0)), isNegative);
      });

      test('is zero for the same time', () {
        expect(const KalenderTime(hour: 9, minute: 30).compareTo(const KalenderTime(hour: 9, minute: 30)), 0);
      });

      test('sorts a list into time order', () {
        final times = [
          const KalenderTime(hour: 23, minute: 59),
          const KalenderTime(hour: 9, minute: 30),
          const KalenderTime(hour: 0, minute: 0),
          const KalenderTime(hour: 9, minute: 15),
        ]..sort();

        expect(times, [
          const KalenderTime(hour: 0, minute: 0),
          const KalenderTime(hour: 9, minute: 15),
          const KalenderTime(hour: 9, minute: 30),
          const KalenderTime(hour: 23, minute: 59),
        ]);
      });
    });

    group('isBefore, isAfter and isAtSameTimeAs', () {
      const earlier = KalenderTime(hour: 9, minute: 15);
      const later = KalenderTime(hour: 9, minute: 30);

      test('isBefore holds only for an earlier time', () {
        expect(earlier.isBefore(later), isTrue);
        expect(later.isBefore(earlier), isFalse);
        expect(earlier.isBefore(earlier), isFalse);
      });

      test('isAfter holds only for a later time', () {
        expect(later.isAfter(earlier), isTrue);
        expect(earlier.isAfter(later), isFalse);
        expect(later.isAfter(later), isFalse);
      });

      test('isAtSameTimeAs holds only for the same time', () {
        expect(earlier.isAtSameTimeAs(const KalenderTime(hour: 9, minute: 15)), isTrue);
        expect(earlier.isAtSameTimeAs(later), isFalse);
      });
    });

    group('equality', () {
      test('equal values are equal and hash alike', () {
        const a = KalenderTime(hour: 9, minute: 30);
        const b = KalenderTime(hour: 9, minute: 30);
        expect(a, b);
        expect(a.hashCode, b.hashCode);
      });

      test('a differing hour or minute is not equal', () {
        const time = KalenderTime(hour: 9, minute: 30);
        expect(time, isNot(const KalenderTime(hour: 10, minute: 30)));
        expect(time, isNot(const KalenderTime(hour: 9, minute: 31)));
      });
    });

    group('toString', () {
      test('pads both parts to two digits', () {
        expect(const KalenderTime(hour: 9, minute: 5).toString(), '09:05');
        expect(const KalenderTime(hour: 0, minute: 0).toString(), '00:00');
        expect(const KalenderTime(hour: 23, minute: 59).toString(), '23:59');
      });
    });

    group('toInternalDateTime', () {
      test('sets the correct hour and minute', () {
        const timeOfDay = KalenderTime(hour: 14, minute: 30);
        final input = InternalDateTime(2024, 6, 15, 9, 0);
        final result = timeOfDay.toInternalDateTime(input);

        expect(result.year, 2024);
        expect(result.month, 6);
        expect(result.day, 15);
        expect(result.hour, 14);
        expect(result.minute, 30);
      });

      test('zeroes out second, millisecond, and microsecond', () {
        const timeOfDay = KalenderTime(hour: 10, minute: 15);
        final input = InternalDateTime.fromDateTime(
          DateTime(2024, 6, 15, 9, 45, 30, 500, 250),
        );
        final result = timeOfDay.toInternalDateTime(input);

        expect(result.second, 0, reason: 'second should be zeroed');
        expect(result.millisecond, 0, reason: 'millisecond should be zeroed');
        expect(result.microsecond, 0, reason: 'microsecond should be zeroed');
      });
    });

    group('toDateTime', () {
      test('sets the correct hour and minute', () {
        const timeOfDay = KalenderTime(hour: 8, minute: 0);
        final input = DateTime(2024, 6, 15, 22, 45);
        final result = timeOfDay.toDateTime(input);

        expect(result.year, 2024);
        expect(result.month, 6);
        expect(result.day, 15);
        expect(result.hour, 8);
        expect(result.minute, 0);
      });

      test('zeroes out second, millisecond, and microsecond', () {
        const timeOfDay = KalenderTime(hour: 12, minute: 30);
        final input = DateTime(2024, 6, 15, 9, 45, 30, 500, 250);
        final result = timeOfDay.toDateTime(input);

        expect(result.second, 0, reason: 'second should be zeroed');
        expect(result.millisecond, 0, reason: 'millisecond should be zeroed');
        expect(result.microsecond, 0, reason: 'microsecond should be zeroed');
      });
    });
  });
}
