import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// The frame generator reverses its column order for right-to-left, so column 0
// holds the last date rather than the first. MultiDayLayoutFrame did not know
// the direction and always read a column back as `start + column days`, so in
// RTL every "+N more" button was attributed to the mirrored date. With events
// on Wed 29 Jan the buttons landed on the 30th and 31st.
void main() {
  group('MultiDayLayoutFrame.dateFromColumn', () {
    // Mon 27 Jan - Sun 2 Feb 2025, a single week row of the month grid.
    final week = InternalDateTimeRange(
      start: InternalDateTime.fromDateTime(DateTime.utc(2025, 1, 27)),
      end: InternalDateTime.fromDateTime(DateTime.utc(2025, 2, 3)),
    );

    MultiDayLayoutFrame frameFor(TextDirection textDirection) {
      return defaultMultiDayFrameGenerator(
        events: const [],
        visibleDateTimeRange: week,
        textDirection: textDirection,
        location: null,
      );
    }

    test('left to right reads columns from the start of the range', () {
      final frame = frameFor(TextDirection.ltr);

      expect(frame.dateFromColumn(0), InternalDateTime.fromDateTime(DateTime.utc(2025, 1, 27)));
      expect(frame.dateFromColumn(2), InternalDateTime.fromDateTime(DateTime.utc(2025, 1, 29)));
      expect(frame.dateFromColumn(6), InternalDateTime.fromDateTime(DateTime.utc(2025, 2, 2)));
    });

    test('right to left reads columns from the end of the range', () {
      final frame = frameFor(TextDirection.rtl);

      // Column 0 is the rightmost day of the range, not the leftmost.
      expect(frame.dateFromColumn(0), InternalDateTime.fromDateTime(DateTime.utc(2025, 2, 2)));
      expect(frame.dateFromColumn(4), InternalDateTime.fromDateTime(DateTime.utc(2025, 1, 29)));
      expect(frame.dateFromColumn(6), InternalDateTime.fromDateTime(DateTime.utc(2025, 1, 27)));
    });

    test('every column maps to a distinct date in both directions', () {
      for (final direction in TextDirection.values) {
        final frame = frameFor(direction);
        final dates = {for (var c = 0; c < 7; c++) frame.dateFromColumn(c)};
        expect(dates.length, 7, reason: '$direction should cover the week exactly once');
        expect(dates, week.dates().toSet(), reason: '$direction should cover the same days');
      }
    });
  });

  group('Month view overflow button dates', () {
    /// Opens a month view with [eventCount] events on [day] and returns the
    /// dates the "+N more" buttons were keyed to.
    Future<Set<DateTime>> buttonDates(
      WidgetTester tester, {
      required DateTime day,
      required TextDirection textDirection,
      int eventCount = 8,
    }) async {
      final dpi = tester.view.devicePixelRatio;
      tester.view.physicalSize = Size(800 * dpi, 600 * dpi);
      addTearDown(tester.view.resetPhysicalSize);

      final eventsController = DefaultEventsController();
      for (var i = 0; i < eventCount; i++) {
        eventsController.addEvent(
          CalendarEvent(dateTimeRange: DateTimeRange(start: day, end: day.add(const Duration(days: 1)))),
        );
      }

      await pumpAndSettleWithMaterialApp(
        tester,
        Directionality(
          textDirection: textDirection,
          child: CalendarView(
            eventsController: eventsController,
            calendarController: CalendarController(),
            viewConfiguration: MonthViewConfiguration.singleMonth(
              displayRange: year2025DisplayRange,
              initialDateTime: DateTime(2025, 1, 15),
            ),
            body: const CalendarBody(),
          ),
        ),
      );

      // The button for a date is keyed by that date, so probe the week the
      // events fall in and collect whichever ones rendered.
      final found = <DateTime>{};
      for (var d = 27; d <= 31; d++) {
        final date = DateTime.utc(2025, 1, d);
        if (find.byKey(MultiDayPortalOverlayButton.getKey(date)).evaluate().isNotEmpty) found.add(date);
      }
      return found;
    }

    // 29 Jan 2025 is a Wednesday, in the last row of a 5 row January.
    final day = DateTime.utc(2025, 1, 29);

    testWidgets('left to right attributes the button to the event day', (tester) async {
      final dates = await buttonDates(tester, day: day, textDirection: TextDirection.ltr);

      expect(dates, contains(day), reason: 'the day the events are on should overflow');
      expect(dates, isNot(contains(DateTime.utc(2025, 1, 31))), reason: 'a day with no events must not overflow');
    });

    testWidgets('right to left attributes the button to the same day', (tester) async {
      final dates = await buttonDates(tester, day: day, textDirection: TextDirection.rtl);

      expect(dates, contains(day), reason: 'direction must not change which date overflows');
      expect(dates, isNot(contains(DateTime.utc(2025, 1, 31))), reason: 'the mirrored date must not overflow');
    });

    testWidgets('both directions overflow exactly the same dates', (tester) async {
      final ltr = await buttonDates(tester, day: day, textDirection: TextDirection.ltr);
      final rtl = await buttonDates(tester, day: day, textDirection: TextDirection.rtl);

      expect(rtl, ltr, reason: 'text direction is a layout concern, it must not move dates');
    });
  });
}
