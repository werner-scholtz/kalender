import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart';

import '../utilities.dart';

/// The week number label reads `32 - 33` when the visible range crosses a week
/// boundary. Its gutter is sized by the timeline rather than by the label, so
/// that string wraps, and the wrapped lines have to stay centred.
void main() {
  group('WeekNumber label', () {
    late KalenderController calendarController;
    late DefaultEventsController eventsController;

    setUpAll(tz.initializeTimeZones);

    setUp(() {
      calendarController = KalenderController();
      eventsController = DefaultEventsController();
    });

    // Pinned to UTC so the dates below land in the week they read as, whichever
    // of the six timezones CI is running under.
    Future<void> pumpWeekNumber(WidgetTester tester, KalenderDateTimeRange range) {
      return pumpAndSettleWithMaterialApp(
        tester,
        TestProvider(
          calendarController: calendarController,
          eventsController: eventsController,
          tileComponents: TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox()),
          location: getLocation('Etc/UTC'),
          child: WeekNumber(visibleDateTimeRange: range),
        ),
      );
    }

    Text labelOf(WidgetTester tester) {
      return tester.widget<Text>(find.descendant(of: find.byType(WeekNumber), matching: find.byType(Text)));
    }

    // 4 Aug 2025 is a Monday, so this range sits inside one ISO week.
    testWidgets('a single week renders one number', (tester) async {
      await pumpWeekNumber(
        tester,
        KalenderDateTimeRange(start: DateTime.utc(2025, 8, 4), end: DateTime.utc(2025, 8, 11)),
      );

      expect(labelOf(tester).data, isNot(contains('-')));
    });

    // 6 Aug 2025 is a Wednesday, so seven days from it cross into the next week.
    testWidgets('a range crossing a week boundary renders both numbers', (tester) async {
      await pumpWeekNumber(
        tester,
        KalenderDateTimeRange(start: DateTime.utc(2025, 8, 6), end: DateTime.utc(2025, 8, 13)),
      );

      expect(labelOf(tester).data, contains('-'));
    });

    testWidgets('the label is centred, so a wrapped second line does not sit left', (tester) async {
      await pumpWeekNumber(
        tester,
        KalenderDateTimeRange(start: DateTime.utc(2025, 8, 6), end: DateTime.utc(2025, 8, 13)),
      );

      expect(
        labelOf(tester).textAlign,
        TextAlign.center,
        reason: 'without this the short line of a wrapped two-week label aligns to the leading edge',
      );
    });
  });
}
