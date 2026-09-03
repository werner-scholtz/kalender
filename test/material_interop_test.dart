import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/material.dart';

void main() {
  group('date range', () {
    final start = DateTime.utc(2026, 3, 1, 9);
    final end = DateTime.utc(2026, 3, 1, 17);

    test('converts to Material and back', () {
      final range = KalenderDateTimeRange(start: start, end: end);
      final material = range.toDateTimeRange();

      expect(material.start, start);
      expect(material.end, end);
      expect(material.toKalenderDateTimeRange(), range);
    });

    test('converts a Material range that carries a subtype', () {
      final material = DateTimeRange<DateTime>(start: start, end: end);
      expect(material.toKalenderDateTimeRange(), KalenderDateTimeRange(start: start, end: end));
    });
  });

  group('time of day', () {
    test('converts to Material and back', () {
      const time = KalenderTime(hour: 7, minute: 30);
      final material = time.toTimeOfDay();

      expect(material.hour, 7);
      expect(material.minute, 30);
      expect(material.toKalenderTime(), time);
    });

    test('midnight survives the round trip', () {
      const time = KalenderTime(hour: 0, minute: 0);
      expect(time.toTimeOfDay().toKalenderTime(), time);
    });
  });
}
