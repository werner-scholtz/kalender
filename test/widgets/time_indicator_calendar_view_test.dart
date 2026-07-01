import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';

import '../utilities.dart';

/// End-to-end regression coverage for the time indicator inside a real
/// [CalendarView], targeting the manifestations reported in
/// https://github.com/werner-scholtz/kalender/issues/261 (a follow-up to the
/// `isSameDay` timezone bug in #254):
///
///   * the indicator showing up on the wrong day (dates other than "today"),
///   * the indicator appearing on days that are several pages ahead,
///   * the indicator not showing up at all on the correct day.
///
/// The isolated positioner widgets are already covered elsewhere; these tests
/// exercise the layer users actually hit — a full `CalendarView` + `CalendarBody`
/// where the real `TimeIndicator` is positioned by `TimeIndicatorPositioner`.
///
/// A `nowCallback` fixes "today" so the assertions are deterministic regardless
/// of the machine's clock, and the suite is run across the timezone matrix via
/// `tool/test_timezones_linux.dart` to cover the "far from GMT" condition that
/// made the original bug visible.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  // A known Monday and the week that starts on it.
  final monday = DateTime(2026, 4, 13);
  final weekRange = DateTimeRange(start: monday, end: monday.add(const Duration(days: 7)));

  Future<void> pumpCalendarView(
    WidgetTester tester,
    ViewConfiguration viewConfiguration,
  ) =>
      pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: viewConfiguration,
          body: const CalendarBody(),
        ),
      );

  group('TimeIndicator in CalendarView (#261)', () {
    // For each weekday, "today" is fixed to that day at noon (well within the
    // default time-of-day range so the indicator is drawn). The indicator must
    // render exactly once and sit in that weekday's column — never on another.
    for (var weekday = 0; weekday < 7; weekday++) {
      final today = monday.add(Duration(days: weekday));

      testWidgets('renders in the correct column for weekday $weekday', (tester) async {
        await pumpCalendarView(
          tester,
          MultiDayViewConfiguration.week(
            displayRange: weekRange,
            initialDateTime: monday,
            nowCallback: () => DateTime(today.year, today.month, today.day, 12),
          ),
        );

        // Guards "indicator not showing up at all on the correct day".
        final indicator = find.byType(TimeIndicator);
        expect(indicator, findsOneWidget, reason: 'The time indicator should be visible on today.');

        // Guards "indicator on the wrong day / several days ahead": the drawn
        // indicator must line up with the weekday's column. Derive the column
        // geometry from the positioner so the assertion is independent of the
        // timeline gutter width.
        final positionerRect = tester.getRect(find.byType(TimeIndicatorPositioner));
        final dayWidth = positionerRect.width / 7;
        final expectedLeft = positionerRect.left + weekday * dayWidth;
        final indicatorRect = tester.getRect(indicator);

        expect(
          indicatorRect.left,
          closeTo(expectedLeft, 1.0),
          reason: 'Indicator should be in weekday $weekday\'s column.',
        );
        expect(
          indicatorRect.width,
          closeTo(dayWidth, 1.0),
          reason: 'Indicator should span exactly one day column.',
        );
      });
    }

    testWidgets('single-day view shows the indicator when today is the visible day', (tester) async {
      await pumpCalendarView(
        tester,
        MultiDayViewConfiguration.singleDay(
          displayRange: weekRange,
          initialDateTime: monday,
          nowCallback: () => DateTime(monday.year, monday.month, monday.day, 12),
        ),
      );

      expect(find.byType(TimeIndicator), findsOneWidget);
    });

    testWidgets('single-day view hides the indicator when today is several days ahead', (tester) async {
      // "today" is three days past the visible day — the classic #261 symptom
      // was the indicator leaking onto pages that aren't today. It must be hidden.
      final threeDaysAhead = monday.add(const Duration(days: 3));

      await pumpCalendarView(
        tester,
        MultiDayViewConfiguration.singleDay(
          displayRange: weekRange,
          initialDateTime: monday,
          nowCallback: () => DateTime(threeDaysAhead.year, threeDaysAhead.month, threeDaysAhead.day, 12),
        ),
      );

      expect(
        find.byType(TimeIndicator),
        findsNothing,
        reason: 'The indicator must not appear on a day that is not today.',
      );
    });
  });
}
