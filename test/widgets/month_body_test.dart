import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/week_day_headers.dart' show WeekDayHeaders;

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
    Future<void> pumpMonthView(
      WidgetTester tester,
      DateTime initialDateTime, {
      bool showWeekNumbers = false,
      CalendarComponents? components,
    }) =>
        pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: MonthViewConfiguration.singleMonth(
              displayRange: displayRange,
              initialDateTime: initialDateTime,
              showWeekNumbers: showWeekNumbers,
            ),
            components: components,
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
    // Regression: https://github.com/werner-scholtz/kalender/issues/266
    //
    // A displayRange that spans exactly one calendar month must still render a
    // page. Previously the single-month page was dropped (itemCount was off by
    // one), leaving a blank view.
    // ---------------------------------------------------------------------------

    testWidgets('renders a month when the displayRange spans a single month', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: DateTimeRange(start: DateTime(2026, 5), end: DateTime(2026, 5, 31)),
            initialDateTime: DateTime(2026, 5),
          ),
          body: const CalendarBody(),
        ),
      );

      // May 2026: May 1 is Friday → startOfWeek Apr 27; Apr 27 + 35 days = Jun 1 > May 31 → 5 rows.
      _expectMonthRows(tester, 5);
    });

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

    testWidgets('does not render week numbers by default', (tester) async {
      await pumpMonthView(tester, DateTime(2025, 1));

      expect(
        find.byType(WeekNumber),
        findsNothing,
        reason: 'Week numbers should be hidden in month view unless explicitly enabled',
      );
    });

    testWidgets('renders one week number per row when enabled', (tester) async {
      const rows = 5; // January 2025 → 5 rows
      await pumpMonthView(
        tester,
        DateTime(2025, 1),
        showWeekNumbers: true,
      );

      _expectMonthRows(tester, rows);

      expect(
        find.byType(WeekNumber),
        findsNWidgets(rows),
        reason: 'Expected one week number per month row when enabled',
      );
    });

    testWidgets('keeps the month grid at 7 day columns when week numbers are enabled', (tester) async {
      await pumpMonthView(
        tester,
        DateTime(2025, 1),
        showWeekNumbers: true,
      );

      expect(
        find.byType(VerticalDivider),
        findsNWidgets(8),
        reason: 'Week numbers should use a leading gutter, not an extra day column',
      );
    });

    testWidgets('applies custom week number alignment from style', (tester) async {
      const rows = 5;
      final components = CalendarComponents(
        monthComponentStyles: const MonthComponentStyles(
          bodyStyles: MonthBodyComponentStyles(
            weekNumberStyle: WeekNumberStyle(alignment: Alignment.topCenter),
          ),
        ),
      );

      await pumpMonthView(
        tester,
        DateTime(2025, 1),
        showWeekNumbers: true,
        components: components,
      );

      expect(
        find.descendant(
          of: find.byType(WeekNumber),
          matching: find.byWidgetPredicate(
            (widget) => widget is Align && widget.alignment == Alignment.topCenter,
          ),
        ),
        findsNWidgets(rows),
        reason: 'Month week numbers should respect the configured vertical alignment',
      );
    });
  });
}
