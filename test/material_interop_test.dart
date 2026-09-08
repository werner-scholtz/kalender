import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/material.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart';

void main() {
  initializeTimeZones();

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
      // The extension is generic over DateTimeRange<T extends DateTime>, so a
      // range of TZDateTime converts and each end keeps its own type.
      final tokyo = getLocation('Asia/Tokyo');
      final material = DateTimeRange<TZDateTime>(
        start: TZDateTime(tokyo, 2026, 3, 1, 9),
        end: TZDateTime(tokyo, 2026, 3, 1, 17),
      );

      final range = material.toKalenderDateTimeRange();
      expect(range.start, isA<TZDateTime>());
      expect(range.start.toUtc(), DateTime.utc(2026, 3, 1, 0));
      expect(range.end.toUtc(), DateTime.utc(2026, 3, 1, 8));
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
