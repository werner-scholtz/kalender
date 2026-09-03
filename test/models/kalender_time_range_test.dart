import 'package:flutter_test/flutter_test.dart';
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
  });
}
