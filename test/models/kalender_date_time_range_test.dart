import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  final start = DateTime.utc(2025, 1, 15, 9);
  final end = DateTime.utc(2025, 1, 15, 17);

  group('KalenderDateTimeRange', () {
    test('holds the values it was given', () {
      final range = KalenderDateTimeRange(start: start, end: end);
      expect(range.start, start);
      expect(range.end, end);
    });

    test('duration is the span between start and end', () {
      final range = KalenderDateTimeRange(start: start, end: end);
      expect(range.duration, const Duration(hours: 8));
    });

    test('duration is zero for an empty range', () {
      expect(KalenderDateTimeRange(start: start, end: start).duration, Duration.zero);
    });

    test('rejects an end before the start', () {
      expect(() => KalenderDateTimeRange(start: end, end: start), throwsAssertionError);
    });

    test('accepts an end equal to the start', () {
      expect(() => KalenderDateTimeRange(start: start, end: start), returnsNormally);
    });

    test('equal values are equal and hash alike', () {
      final a = KalenderDateTimeRange(start: start, end: end);
      final b = KalenderDateTimeRange(start: start, end: end);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('differing values are not equal', () {
      final a = KalenderDateTimeRange(start: start, end: end);
      expect(a, isNot(KalenderDateTimeRange(start: start, end: end.add(const Duration(hours: 1)))));
      expect(a, isNot(KalenderDateTimeRange(start: start.subtract(const Duration(hours: 1)), end: end)));
    });

    test('an InternalDateTimeRange with the same values is not equal', () {
      final range = KalenderDateTimeRange(start: start, end: end);
      expect(range, isNot(InternalDateTimeRange(start: start, end: end)));
    });

    test('toString names both ends', () {
      expect(KalenderDateTimeRange(start: start, end: end).toString(), '$start - $end');
    });
  });
}
