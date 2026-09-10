// The input for `fix_calendar_event.yaml`. Run `dart fix --compare-to-golden test_fixes`.

import 'package:kalender/kalender.dart';

final range = KalenderDateTimeRange(start: DateTime.utc(2025), end: DateTime.utc(2025, 1, 2));
final event = CalendarEvent(dateTimeRange: range);

// An argument that is not a variable is copied into both parameters.
KalenderDateTimeRange makeRange() => KalenderDateTimeRange(start: DateTime.utc(2025), end: DateTime.utc(2025, 1, 2));
final computed = CalendarEvent(dateTimeRange: makeRange());
