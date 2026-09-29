// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/gestures.dart' show kLongPressTimeout;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ics/ics_calendar.dart';
import 'package:ics/ics_event.dart';
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
    final window = KalenderDateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 31));
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

    test('the flag reaches the KalenderEvent', () {
      final window = KalenderDateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 31));
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
    final window = KalenderDateTimeRange(start: DateTime(2025, 2, 1), end: DateTime(2025, 2, 28));
    final events = expandEvents(sources, window);

    expect(events.any((e) => e.uid == 's@example.com'), isFalse, reason: 'single January event is outside the window');

    // February 2025 Mondays: 3, 10, 17, 24.
    final weekly = events.where((e) => e.uid == 'w@example.com');
    expect(weekly.length, 4);
    for (final event in weekly) {
      expect(event.dateTimeRange.start.isBefore(window.start), isFalse, reason: 'no instance before the window start');
    }
  });

  test('an instance of a recurring event cannot be moved or resized', () {
    final window = KalenderDateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 31));
    final events = expandEvents(parseIcs(_sample), window);

    expect({
      for (final event in events) event.title: event.interaction
    }, {
      'Weekly': EventInteraction.allowNone(),
      'Single': EventInteraction(),
      'All day': EventInteraction(),
      'All day, no end': EventInteraction(),
    });
  });

  test('an import replaces the events with the same uid and adds the rest', () {
    const imported = '''BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//kalender//test//EN
BEGIN:VEVENT
UID:s@example.com
DTSTAMP:20250101T000000Z
SUMMARY:Single, moved
DTSTART:20250111T120000
DTEND:20250111T130000
END:VEVENT
BEGIN:VEVENT
UID:n@example.com
DTSTAMP:20250101T000000Z
SUMMARY:New
DTSTART:20250112T120000
DTEND:20250112T130000
END:VEVENT
END:VCALENDAR''';

    final sources = importIcs(parseIcs(_sample), imported);

    expect({
      for (final source in sources) source.uid: source.summary
    }, {
      'w@example.com': 'Weekly',
      'a@example.com': 'All day',
      'b@example.com': 'All day, no end',
      's@example.com': 'Single, moved',
      'n@example.com': 'New',
    });
  });

  test('an event created in the calendar exports as a single event', () {
    final created = IcsEvent(
      start: DateTime(2025, 1, 20, 14),
      end: DateTime(2025, 1, 20, 15),
      uid: 'c@example.com',
      title: 'Created',
      color: colorFor('c@example.com'),
    );

    final [source] = parseIcs(exportIcs([IcsSource.fromEvent(created)]));

    expect(
      (source.uid, source.summary, source.start, source.end, source.isAllDay, source.recurrence),
      ('c@example.com', 'Created', DateTime(2025, 1, 20, 14), DateTime(2025, 1, 20, 15), false, null),
    );
  });

  testWidgets('the Import dialog adds the pasted events', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    final now = DateTime.now();
    final day = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    await tester.tap(find.byTooltip('Import .ics'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(of: find.byType(ImportDialog), matching: find.byType(TextField)),
      'BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//kalender//test//EN\nBEGIN:VEVENT\nUID:p@example.com\n'
      'DTSTAMP:20250101T000000Z\nSUMMARY:Pasted\nDTSTART;VALUE=DATE:$day\nEND:VEVENT\nEND:VCALENDAR',
    );
    await tester.tap(find.text('Import').last);
    await tester.pumpAndSettle();

    expect(find.text('Pasted'), findsOneWidget);
  });

  testWidgets('dragging on an empty slot creates an event that is exported', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    final body = find.byType(MultiDayBody);
    // The Sunday column, which no event in the sample uses.
    final start = tester.getTopRight(body) + const Offset(-40, 40);

    final gesture = await tester.startGesture(start);
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
    await gesture.moveBy(const Offset(0, 60));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('New event'), findsOneWidget);

    await tester.tap(find.byTooltip('Export .ics'));
    await tester.pumpAndSettle();
    expect(find.textContaining('SUMMARY:New event'), findsOneWidget);
  });

  testWidgets('renders the calendar', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(KalenderView), findsOneWidget);
  });
}
