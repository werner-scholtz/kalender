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

    // ---------------------------------------------------------------------------
    // Regression: https://github.com/werner-scholtz/kalender/issues/255
    //
    // A month view showed a "+N more" overflow button (MultiDayPortalOverlayButton)
    // even when there were no events. A large tileHeight forces MonthBody to compute
    // maxNumberOfVerticalEvents == 0 (floor(cellHeight / tileHeight) - 1, clamped to
    // 0), which is the exact condition that used to produce the spurious buttons.
    //
    // Unlike the MultiDayEventLayoutWidget-level tests in
    // test/layout/multi_day_event_layout_test.dart, these drive the full CalendarView
    // month path so MonthBody itself derives the max from the cell height.
    // ---------------------------------------------------------------------------

    // A tileHeight far larger than any week-row height guarantees max == 0.
    const tallTileHeight = 1000.0;

    Future<void> pumpShortCellMonthView(WidgetTester tester, DateTime initialDateTime) =>
        pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: MonthViewConfiguration.singleMonth(
              displayRange: displayRange,
              initialDateTime: initialDateTime,
            ),
            body: const CalendarBody(
              monthBodyConfiguration: MonthBodyConfiguration(tileHeight: tallTileHeight),
            ),
          ),
        );

    testWidgets('shows no overflow button in month view when there are no events (#255)', (tester) async {
      // eventsController is empty – do not add any events.
      await pumpShortCellMonthView(tester, DateTime(2025, 1));

      // The month renders, but with zero events there must be no overflow buttons,
      // even though maxNumberOfVerticalEvents is 0.
      expect(find.byType(MonthBody), findsOneWidget);
      expect(find.byType(MultiDayPortalOverlayButton), findsNothing);
    });

    testWidgets('shows exactly one overflow button for a single event when max is 0 (#255)', (tester) async {
      // A single-day event on Jan 15, 2025 (within the displayed month).
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 15, 9),
            end: DateTime(2025, 1, 15, 10),
          ),
        ),
      );

      await pumpShortCellMonthView(tester, DateTime(2025, 1));

      // With max == 0 the single event is hidden behind exactly one overflow button;
      // every other (empty) day must stay button-free.
      expect(find.byType(MultiDayPortalOverlayButton), findsOneWidget);

      final button = tester.widget<MultiDayPortalOverlayButton>(find.byType(MultiDayPortalOverlayButton));
      expect(button.numberOfHiddenRows, greaterThan(0));
    });

    // ---------------------------------------------------------------------------
    // #235: a custom generateMultiDayLayoutFrame supplied to MonthBodyConfiguration
    // ---------------------------------------------------------------------------
    // Supplying a custom generateMultiDayLayoutFrame to MonthBodyConfiguration used
    // to throw a `_TypeError` at build time because the generator carried a `<T>`
    // type parameter that no longer matched the (now non-generic) typedef:
    //
    //   type '(... => MultiDayLayoutFrame<Todo>)' is not a subtype of type
    //   '(... => MultiDayLayoutFrame<Object?>)?'
    //
    // The generics were removed in 0.16.0, so the crash is structurally impossible.
    // These tests lock that in at the exact layer the reporter hit — a custom
    // generator wired through MonthBodyConfiguration in a full CalendarView month
    // view. The explicit closure signature (matching the current typedef) is itself
    // the regression guard: a return to a generic typedef would fail to compile.
    group('custom generateMultiDayLayoutFrame (#235)', () {
      late bool invoked;

      // A generator with the exact signature of the current typedef, delegating to
      // the real default implementation.
      MultiDayLayoutFrame customFrame({
        required InternalDateTimeRange visibleDateTimeRange,
        required List<CalendarEvent> events,
        required TextDirection textDirection,
        required Location? location,
        MultiDayLayoutFrameCache? cache,
      }) {
        invoked = true;
        return defaultMultiDayFrameGenerator(
          visibleDateTimeRange: visibleDateTimeRange,
          events: events,
          textDirection: textDirection,
          location: location,
          cache: cache,
        );
      }

      Future<void> pumpWithCustomFrame(WidgetTester tester, DateTime initialDateTime) =>
          pumpAndSettleWithMaterialApp(
            tester,
            CalendarView(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: MonthViewConfiguration.singleMonth(
                displayRange: displayRange,
                initialDateTime: initialDateTime,
              ),
              body: CalendarBody(
                monthBodyConfiguration: MonthBodyConfiguration(generateMultiDayLayoutFrame: customFrame),
              ),
            ),
          );

      setUp(() => invoked = false);

      testWidgets('renders month view without error and is invoked', (tester) async {
        final event = CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 15, 9),
            end: DateTime(2025, 1, 15, 10),
          ),
        );
        eventsController.addEvent(event);

        await pumpWithCustomFrame(tester, DateTime(2025, 1));

        // The core #235 assertion: no `_TypeError` (or anything else) during build.
        expect(tester.takeException(), isNull);
        // The custom generator was actually used, and its frame was consumed to
        // render the event tile.
        expect(invoked, isTrue, reason: 'custom generateMultiDayLayoutFrame should be called');
        expect(find.byType(MonthBody), findsOneWidget);
        // Month events render as MultiDayEventTile (keyed 'MultiDayEventTile-<id>').
        expect(find.byKey(Key('MultiDayEventTile-${event.id}')), findsOneWidget);
      });

      testWidgets('renders without error when there are no events', (tester) async {
        // eventsController is empty – exercises the empty-list path through a custom
        // generator.
        await pumpWithCustomFrame(tester, DateTime(2025, 1));

        expect(tester.takeException(), isNull);
        expect(invoked, isTrue, reason: 'custom generateMultiDayLayoutFrame should be called');
        expect(find.byType(MonthBody), findsOneWidget);
      });
    });
  });
}
