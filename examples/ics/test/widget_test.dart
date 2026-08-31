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
BEGIN:VEVENT
UID:a@example.com
DTSTAMP:20250101T000000Z
SUMMARY:All day
DTSTART;VALUE=DATE:20250115
DTEND;VALUE=DATE:20250116
END:VEVENT
BEGIN:VEVENT
UID:b@example.com
DTSTAMP:20250101T000000Z
SUMMARY:All day, no end
DTSTART;VALUE=DATE:20250117
END:VEVENT
END:VCALENDAR''';

void main() {
  test('parses masters and expands recurrence over the window', () {
    final sources = parseIcs(_sample);
    expect(sources.length, 4);

    // January 2025 has Mondays on the 6th, 13th, 20th and 27th.
    final window = DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 31));
    final events = expandEvents(sources, window);

    final weekly = events.where((e) => e.uid == 'w@example.com');
    expect(weekly.length, 4, reason: 'four Mondays in January');
    expect(events.length, 7, reason: 'four weekly instances, one single event and two all-day events');
  });

  test('exported .ics round-trips the recurrence rule', () {
    final ics = exportIcs(parseIcs(_sample));
    expect(ics, contains('RRULE:FREQ=WEEKLY;BYDAY=MO'));
    expect(ics, contains('SUMMARY:Weekly'));
  });

  group('all-day events', () {
    late List<IcsSource> sources;
    setUp(() => sources = parseIcs(_sample));

    IcsSource sourceFor(String uid) => sources.firstWhere((s) => s.uid == uid);

    test('a date-valued DTSTART is read as all-day', () {
      expect(sourceFor('a@example.com').isAllDay, isTrue);
      expect(sourceFor('s@example.com').isAllDay, isFalse, reason: 'DTSTART carries a time');
    });

    test('DTEND is exclusive, so one date-valued day ends at the next midnight', () {
      final source = sourceFor('a@example.com');
      expect(source.start, DateTime(2025, 1, 15));
      expect(source.end, DateTime(2025, 1, 16));
    });

    test('a missing DTEND means one day, not one hour', () {
      final source = sourceFor('b@example.com');
      expect(source.isAllDay, isTrue);
      expect(source.end.difference(source.start), const Duration(days: 1));
    });

    test('the flag reaches the CalendarEvent', () {
      final window = DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 31));
      final events = expandEvents(sources, window);
      expect(events.firstWhere((e) => e.uid == 'a@example.com').isAllDay, isTrue);
      expect(events.firstWhere((e) => e.uid == 's@example.com').isAllDay, isFalse);
    });

    test('export writes it back as VALUE=DATE, so it does not become a timed event', () {
      final ics = exportIcs(sources);
      expect(ics, contains('DTSTART;VALUE=DATE:20250115'));
      expect(ics, contains('DTEND;VALUE=DATE:20250116'));
      expect(ics, contains('DTSTART:20250110T120000'), reason: 'a timed event is unaffected');

      // And it survives the round trip.
      expect(parseIcs(ics).firstWhere((s) => s.uid == 'a@example.com').isAllDay, isTrue);
    });
  });

  test('expansion is bounded to the window', () {
    final sources = parseIcs(_sample);
    // A window in February: the single January event is outside it, and only the
    // February occurrences of the weekly event should be produced.
    final window = DateTimeRange(start: DateTime(2025, 2, 1), end: DateTime(2025, 2, 28));
    final events = expandEvents(sources, window);

    expect(events.any((e) => e.uid == 's@example.com'), isFalse, reason: 'single January event is outside the window');

    // February 2025 Mondays: 3, 10, 17, 24.
    final weekly = events.where((e) => e.uid == 'w@example.com');
    expect(weekly.length, 4);
    for (final event in weekly) {
      expect(event.dateTimeRange.start.isBefore(window.start), isFalse, reason: 'no instance before the window start');
    }
  });

  testWidgets('renders the calendar', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(KalenderView), findsOneWidget);
  });
}
