import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ics/ics_calendar.dart';
import 'package:ics/main.dart';
import 'package:kalender/kalender.dart';

const _sample = '''BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//kalender//test//EN
BEGIN:VEVENT
UID:w@example.com
DTSTAMP:20250101T000000Z
SUMMARY:Weekly
DTSTART:20250106T090000
DTEND:20250106T093000
RRULE:FREQ=WEEKLY;BYDAY=MO
END:VEVENT
BEGIN:VEVENT
UID:s@example.com
DTSTAMP:20250101T000000Z
SUMMARY:Single
DTSTART:20250110T120000
DTEND:20250110T130000
END:VEVENT
END:VCALENDAR''';

void main() {
  test('parses masters and expands recurrence over the window', () {
    final sources = parseIcs(_sample);
    expect(sources.length, 2);

    // January 2025 has Mondays on the 6th, 13th, 20th and 27th.
    final window = DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 31));
    final events = expandEvents(sources, window);

    final weekly = events.where((e) => e.uid == 'w@example.com');
    expect(weekly.length, 4, reason: 'four Mondays in January');
    expect(events.length, 5, reason: 'four weekly instances plus one single event');
  });

  test('exported .ics round-trips the recurrence rule', () {
    final ics = exportIcs(parseIcs(_sample));
    expect(ics, contains('RRULE:FREQ=WEEKLY;BYDAY=MO'));
    expect(ics, contains('SUMMARY:Weekly'));
  });

  testWidgets('renders the calendar', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(CalendarView), findsOneWidget);
  });
}
