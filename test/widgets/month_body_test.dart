import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/components/month_day_header.dart' show MonthDayHeader;
import 'package:kalender/src/widgets/components/month_grid.dart' show MonthGrid;
import 'package:kalender/src/widgets/internal_components/week_day_headers.dart' show WeekDayHeaders;
import 'package:kalender/src/widgets/month/month_body.dart' show MonthBody, MonthWeek;

import '../utilities.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Asserts that [MonthBody] and [MonthGrid] are rendered and that the correct
/// number of [MonthWeek] rows are visible.
void _expectMonthRows(WidgetTester tester, int expectedRows) {
  expect(find.byType(MonthBody), findsOneWidget, reason: 'MonthBody should be rendered');
  expect(find.byType(MonthGrid), findsOneWidget, reason: 'MonthGrid should be rendered');
  expect(
    find.byType(MonthWeek),
    findsNWidgets(expectedRows),
    reason: 'Expected $expectedRows MonthWeek rows',
  );
}

void main() {
  group('MonthBody Tests', () {
    late DefaultEventsController eventsController;
    late CalendarController calendarController;

    // Wide enough to cover every test month.
    final displayRange = DateTimeRange(start: DateTime(2023), end: DateTime(2026));

    setUp(() {
      eventsController = DefaultEventsController();
      calendarController = CalendarController();
    });

    // All cases use firstDayOfWeek = DateTime.monday (the default).
    Future<void> pumpMonthView(WidgetTester tester, DateTime initialDateTime) =>
        pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: MonthViewConfiguration.singleMonth(
              displayRange: displayRange,
              initialDateTime: initialDateTime,
            ),
            body: const CalendarBody(),
          ),
        );

    // ---------------------------------------------------------------------------
    // Row count (firstDayOfWeek = Monday / default)
    //
    // 5-row month — January 2025: Jan 1 is Wednesday.
    //   startOfWeek = Dec 30;  Dec 30 + 35 days = Feb 3 > Jan 31  → 5 rows.
    //
    // 6-row month — October 2023: Oct 1 is Sunday.
    //   startOfWeek = Sep 25;  Sep 25 + 35 days = Oct 30 < Oct 31 → 6 rows.
    // ---------------------------------------------------------------------------

    final rowCountCases = <({String name, DateTime initialDateTime, int expectedRows})>[
      (name: 'January 2025', initialDateTime: DateTime(2025, 1), expectedRows: 5),
      (name: 'October 2023', initialDateTime: DateTime(2023, 10), expectedRows: 6),
    ];

    for (final c in rowCountCases) {
      testWidgets('renders ${c.expectedRows} week rows for ${c.name}', (tester) async {
        await pumpMonthView(tester, c.initialDateTime);
        _expectMonthRows(tester, c.expectedRows);
      });
    }

    // ---------------------------------------------------------------------------
    // Per-row structure
    // ---------------------------------------------------------------------------

    testWidgets('each week row renders 7 day-number headers', (tester) async {
      const rows = 5; // January 2025 → 5 rows
      await pumpMonthView(tester, DateTime(2025, 1));

      _expectMonthRows(tester, rows);

      // Each MonthWeek contains exactly one WeekDayHeaders widget …
      expect(
        find.byType(WeekDayHeaders),
        findsNWidgets(rows),
        reason: 'Each week row should contain a WeekDayHeaders widget',
      );

      // … which in turn renders one MonthDayHeader per day of the week.
      expect(
        find.byType(MonthDayHeader),
        findsNWidgets(rows * DateTime.daysPerWeek),
        reason: 'Each week row should render ${DateTime.daysPerWeek} day headers',
      );
    });
  });
}
