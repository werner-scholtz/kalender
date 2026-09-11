import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/models/kalender_date_time_range.dart';
import 'package:kalender/src/models/kalender_time.dart';
import 'package:kalender/src/models/kalender_time_range.dart';

void main() {
  group('KalenderTimeRange Tests', () {
    group('Functions', () {
      const start = KalenderTime(hour: 10, minute: 20);
      const end = KalenderTime(hour: 12, minute: 30);
      final timeOfDayRange = KalenderTimeRange(start: start, end: end);

      test('Start and End', () {
        expect(timeOfDayRange.start, start);
        expect(timeOfDayRange.end, end);
      });

      test('duration', () {
        expect(timeOfDayRange.duration, const Duration(hours: 2, minutes: 11));
      });

      test('coversWholeDay', () {
        expect(timeOfDayRange.coversWholeDay, isFalse);
        expect(KalenderTimeRange.allDay().coversWholeDay, isTrue);
        expect(
          KalenderTimeRange(start: const KalenderTime(hour: 0, minute: 0), end: const KalenderTime(hour: 23, minute: 0))
              .coversWholeDay,
          isFalse,
        );
      });

      test('coversWholeDay is false when the range starts after midnight', () {
        final range = KalenderTimeRange(
          start: const KalenderTime(hour: 0, minute: 30),
          end: const KalenderTime(hour: 23, minute: 59),
        );
        expect(range.coversWholeDay, isFalse);
      });
    });

    group('Constructors', () {
      test('KalenderTimeRange.allDay', () {
        final allDay = KalenderTimeRange.allDay();
        expect(allDay.start, const KalenderTime(hour: 0, minute: 0));
        expect(allDay.end, const KalenderTime(hour: 23, minute: 59));
      });

      test('KalenderTimeRange.forHour', () {
        final hour = KalenderTimeRange.forHour(10);
        expect(hour.start, const KalenderTime(hour: 10, minute: 0));
        expect(hour.end, const KalenderTime(hour: 10, minute: 59));
      });
    });

    group('splitIntoSegments', () {
      test('perfect division', () {
        final range = KalenderTimeRange(
          start: const KalenderTime(hour: 8, minute: 0),
          end: const KalenderTime(hour: 9, minute: 59),
        );
        final segments = range.splitIntoSegments(30);
        expect(segments.length, 4);

        expect(
          segments[0],
          KalenderTimeRange(
            start: const KalenderTime(hour: 8, minute: 0),
            end: const KalenderTime(hour: 8, minute: 29),
          ),
        );
        expect(
          segments[1],
          KalenderTimeRange(
            start: const KalenderTime(hour: 8, minute: 30),
            end: const KalenderTime(hour: 8, minute: 59),
          ),
        );
        expect(
          segments[2],
          KalenderTimeRange(
            start: const KalenderTime(hour: 9, minute: 0),
            end: const KalenderTime(hour: 9, minute: 29),
          ),
        );
        expect(
          segments[3],
          KalenderTimeRange(
            start: const KalenderTime(hour: 9, minute: 30),
            end: const KalenderTime(hour: 9, minute: 59),
          ),
        );
      });

      test('last segment shorter', () {
        final range = KalenderTimeRange(
          start: const KalenderTime(hour: 10, minute: 0),
          end: const KalenderTime(hour: 11, minute: 30),
        );
        final segments = range.splitIntoSegments(60);
        expect(segments.length, 2);
        expect(
          segments[0],
          KalenderTimeRange(
            start: const KalenderTime(hour: 10, minute: 0),
            end: const KalenderTime(hour: 10, minute: 59),
          ),
        );
        expect(
          segments[1],
          KalenderTimeRange(
            start: const KalenderTime(hour: 11, minute: 0),
            end: const KalenderTime(hour: 11, minute: 30),
          ),
        );
      });

      test('range shorter than segment length', () {
        final range = KalenderTimeRange(
          start: const KalenderTime(hour: 10, minute: 0),
          end: const KalenderTime(hour: 10, minute: 30),
        );
        final segments = range.splitIntoSegments(60);
        expect(segments.length, 1);
        expect(
          segments[0],
          KalenderTimeRange(
            start: const KalenderTime(hour: 10, minute: 0),
            end: const KalenderTime(hour: 10, minute: 30),
          ),
        );
      });

      test('single point in time range', () {
        final range = KalenderTimeRange(
          start: const KalenderTime(hour: 10, minute: 0),
          end: const KalenderTime(hour: 10, minute: 0),
        );
        final segments = range.splitIntoSegments(30);
        expect(segments.length, 1);
        expect(
          segments[0],
          KalenderTimeRange(
            start: const KalenderTime(hour: 10, minute: 0),
            end: const KalenderTime(hour: 10, minute: 0),
          ),
        );
      });

      test('documentation example', () {
        final range = KalenderTimeRange(
          start: const KalenderTime(hour: 10, minute: 0),
          end: const KalenderTime(hour: 11, minute: 30),
        );
        final segments = range.splitIntoSegments(30);
        expect(segments.length, 4);
        expect(
          segments[0],
          KalenderTimeRange(
            start: const KalenderTime(hour: 10, minute: 0),
            end: const KalenderTime(hour: 10, minute: 29),
          ),
        );
        expect(
          segments[1],
          KalenderTimeRange(
            start: const KalenderTime(hour: 10, minute: 30),
            end: const KalenderTime(hour: 10, minute: 59),
          ),
        );
        expect(
          segments[2],
          KalenderTimeRange(
            start: const KalenderTime(hour: 11, minute: 0),
            end: const KalenderTime(hour: 11, minute: 29),
          ),
        );
        expect(
          segments[3],
          KalenderTimeRange(
            start: const KalenderTime(hour: 11, minute: 30),
            end: const KalenderTime(hour: 11, minute: 30),
          ),
        );
      });
    });

    group('fromDateTimeRange', () {
      test('takes the hour and minute of each end', () {
        final range = KalenderTimeRange.fromDateTimeRange(
          KalenderDateTimeRange(start: DateTime(2024, 6, 15, 9, 15), end: DateTime(2024, 6, 15, 17, 45)),
        );

        expect(range.start, const KalenderTime(hour: 9, minute: 15));
        expect(range.end, const KalenderTime(hour: 17, minute: 45));
      });

      test('drops second and below', () {
        final range = KalenderTimeRange.fromDateTimeRange(
          KalenderDateTimeRange(
            start: DateTime(2024, 6, 15, 9, 15, 30, 500, 250),
            end: DateTime(2024, 6, 15, 17, 45, 30, 500, 250),
          ),
        );

        expect(range.start, const KalenderTime(hour: 9, minute: 15));
        expect(range.end, const KalenderTime(hour: 17, minute: 45));
      });

      test('a range that starts and ends at the same time of day is empty', () {
        final range = KalenderTimeRange.fromDateTimeRange(
          KalenderDateTimeRange(start: DateTime(2024, 6, 15, 9), end: DateTime(2024, 6, 15, 9)),
        );

        expect(range.start, range.end);
        expect(range.duration, const Duration(minutes: 1));
      });
    });

    group('bounds', () {
      test('rejects an end hour before the start hour', () {
        expect(
          () => KalenderTimeRange(
            start: const KalenderTime(hour: 12, minute: 0),
            end: const KalenderTime(hour: 10, minute: 0),
          ),
          throwsAssertionError,
        );
      });

      test('rejects an end minute before the start minute within the same hour', () {
        expect(
          () => KalenderTimeRange(
            start: const KalenderTime(hour: 10, minute: 30),
            end: const KalenderTime(hour: 10, minute: 15),
          ),
          throwsAssertionError,
        );
      });

      test('accepts an end equal to the start', () {
        expect(
          () => KalenderTimeRange(
            start: const KalenderTime(hour: 10, minute: 30),
            end: const KalenderTime(hour: 10, minute: 30),
          ),
          returnsNormally,
        );
      });
    });

    group('equality', () {
      test('equal values are equal and hash alike', () {
        final a = KalenderTimeRange(
          start: const KalenderTime(hour: 9, minute: 0),
          end: const KalenderTime(hour: 17, minute: 0),
        );
        final b = KalenderTimeRange(
          start: const KalenderTime(hour: 9, minute: 0),
          end: const KalenderTime(hour: 17, minute: 0),
        );

        expect(a, b);
        expect(a.hashCode, b.hashCode);
      });

      test('a differing start or end is not equal', () {
        final range = KalenderTimeRange(
          start: const KalenderTime(hour: 9, minute: 0),
          end: const KalenderTime(hour: 17, minute: 0),
        );

        expect(
          range,
          isNot(
            KalenderTimeRange(
              start: const KalenderTime(hour: 10, minute: 0),
              end: const KalenderTime(hour: 17, minute: 0),
            ),
          ),
        );
        expect(
          range,
          isNot(
            KalenderTimeRange(
              start: const KalenderTime(hour: 9, minute: 0),
              end: const KalenderTime(hour: 18, minute: 0),
            ),
          ),
        );
      });
    });

    group('toString', () {
      test('names both ends', () {
        final range = KalenderTimeRange(
          start: const KalenderTime(hour: 9, minute: 5),
          end: const KalenderTime(hour: 17, minute: 0),
        );

        expect(range.toString(), '09:05 - 17:00');
      });
    });
  });
}
