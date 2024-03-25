import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart';

/// Test different timezones.
void timezoneTest(Function(Location zone, TZDateTime now) test) {
  tz.initializeTimeZones();
  final timezones = [
    'Africa/Johannesburg',
    'Asia/Hong_Kong',
    'America/New_York',
    'Canada/Newfoundland',
    'Europe/Berlin',
    'Australia/Sydney',
  ];

  for (final timezone in timezones) {
    final zone = getLocation(timezone);
    final now = TZDateTime.from(DateTime(2024, 1, 1), zone);
    test(zone, now);
  }
}
