import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/internal_date_time.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/standalone.dart';

void main() {
  initializeTimeZones();

  group('Internal DateTime tests', () {
    test('InternalDateTime from DateTime', () {
      final dateTime = DateTime(2024, 6, 1, 12, 0);
      final internalDateTime = InternalDateTime.from(dateTime);
      expect(internalDateTime.toString(), '2024-06-01 12:00:00.000Z');
      expect(internalDateTime.asLocal(null), dateTime);
    });

    test('InternalDateTime from TZDateTime', () {
      final location = getLocation('America/New_York');
      final dateTime = TZDateTime(location, 2024, 6, 1, 12, 0);
      final internalDateTime = InternalDateTime.from(dateTime);
      expect(internalDateTime.toString(), '2024-06-01 12:00:00.000Z');
      expect(internalDateTime.asLocal(location), dateTime);
    });
  });
}
