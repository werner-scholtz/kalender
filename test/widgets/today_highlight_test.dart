import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart' as tz;

import '../utilities.dart';

/// End-to-end regression coverage for "today" highlighting in a real
/// [CalendarView], targeting the timezone bug reported in:
///
///   * #254 — `isSameDay` produced wrong results for non-UTC timezones,
///   * #251 — wrong current-date highlighting (e.g. Dec 24 highlighted Dec 23),
///   * #248 — header dates compared against a local `DateTime.now()` incorrectly
///            near midnight in offset timezones.
///
/// The root cause was fixed by the `InternalDateTime` + `NowCallback` refactor in
/// `0.18.0`. The isolated component checks live in `now_callback_is_today_test.dart`;
/// these exercise the layer users actually hit — a full `CalendarView` — and are
/// run across the timezone matrix (`tool/test_timezones_linux.dart`) to cover the
/// non-UTC / near-midnight condition that made the original bug visible.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  Finder todayNumber(Key todayKey, int day) => find.descendant(
        of: find.byKey(todayKey),
        matching: find.text('$day'),
      );

  group('Today highlighting in CalendarView (#254 #248 #251)', () {
    // ── Month view ──────────────────────────────────────────────────────────
    group('MonthView', () {
      Future<void> pumpMonth(
        WidgetTester tester,
        DateTime month, {
        NowCallback? nowCallback,
      }) =>
          pumpAndSettleWithMaterialApp(
            tester,
            CalendarView(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: MonthViewConfiguration.singleMonth(
                displayRange: DateTimeRange(
                  start: DateTime(month.year, month.month - 1),
                  end: DateTime(month.year, month.month + 2),
                ),
                initialDateTime: month,
                nowCallback: nowCallback,
              ),
              body: const CalendarBody(),
            ),
          );

      testWidgets('highlights exactly the real today (default location path)', (tester) async {
        final now = DateTime.now();
        await pumpMonth(tester, DateTime(now.year, now.month));

        // Exactly one day is "today", and it carries today's day-of-month number.
        expect(find.byKey(MonthDayHeader.todayKey), findsOneWidget);
        expect(todayNumber(MonthDayHeader.todayKey, now.day), findsOneWidget);
      });

      testWidgets('highlights the callback day, not its neighbour (#251)', (tester) async {
        // The #251 report: current date Dec 24, but Dec 23 was highlighted.
        await pumpMonth(
          tester,
          DateTime(2025, 12),
          nowCallback: () => DateTime(2025, 12, 24, 10),
        );

        expect(find.byKey(MonthDayHeader.todayKey), findsOneWidget);
        expect(todayNumber(MonthDayHeader.todayKey, 24), findsOneWidget, reason: 'Dec 24 must be highlighted');
        expect(todayNumber(MonthDayHeader.todayKey, 23), findsNothing, reason: 'Dec 23 must not be highlighted');
      });

      testWidgets('highlights correctly on a month boundary', (tester) async {
        // Last day of the month — a classic near-midnight / offset failure point.
        await pumpMonth(
          tester,
          DateTime(2025, 12),
          nowCallback: () => DateTime(2025, 12, 31, 23),
        );

        expect(find.byKey(MonthDayHeader.todayKey), findsOneWidget);
        expect(todayNumber(MonthDayHeader.todayKey, 31), findsOneWidget);
      });

      // #248: a custom monthDayHeaderBuilder must receive a localized wall-clock
      // DateTime (via .forLocation()), not a raw UTC-flagged InternalDateTime, so
      // consumer comparisons against DateTime.now() behave correctly.
      testWidgets('custom builder receives localized (non-UTC) dates (#248)', (tester) async {
        final received = <DateTime>[];
        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: MonthViewConfiguration.singleMonth(
              displayRange: DateTimeRange(start: DateTime(2025, 11), end: DateTime(2026)),
              initialDateTime: DateTime(2025, 12),
            ),
            components: CalendarComponents(
              monthComponents: MonthComponents(
                bodyComponents: MonthBodyComponents(
                  monthDayHeaderBuilder: (date, style) {
                    received.add(date);
                    return MonthDayHeader(date: date, style: style);
                  },
                ),
              ),
            ),
            body: const CalendarBody(),
          ),
        );

        expect(received, isNotEmpty);
        // No local timezone is configured, so dates arrive as local wall-clock
        // (isUtc == false) rather than the UTC-flagged InternalDateTime.
        expect(
          received.every((d) => !d.isUtc),
          isTrue,
          reason: 'monthDayHeaderBuilder should receive localized (non-UTC) dates',
        );
      });

      testWidgets('custom builder receives TZDateTime for a configured location (#248)', (tester) async {
        tz.initializeTimeZones();
        final newYork = getLocation('America/New_York');
        final received = <DateTime>[];

        await pumpAndSettleWithMaterialApp(
          tester,
          CalendarView(
            eventsController: eventsController,
            calendarController: calendarController,
            location: newYork,
            viewConfiguration: MonthViewConfiguration.singleMonth(
              displayRange: DateTimeRange(start: DateTime(2025, 11), end: DateTime(2026)),
              initialDateTime: DateTime(2025, 12),
            ),
            components: CalendarComponents(
              monthComponents: MonthComponents(
                bodyComponents: MonthBodyComponents(
                  monthDayHeaderBuilder: (date, style) {
                    received.add(date);
                    return MonthDayHeader(date: date, style: style);
                  },
                ),
              ),
            ),
            body: const CalendarBody(),
          ),
        );

        expect(received, isNotEmpty);
        expect(
          received.every((d) => d is TZDateTime && d.location == newYork),
          isTrue,
          reason: 'monthDayHeaderBuilder should receive TZDateTime in the configured location',
        );
      });
    });

    // ── Multi-day (week) header ─────────────────────────────────────────────
    group('MultiDayView header', () {
      final monday = DateTime(2026, 4, 13);
      final weekRange = DateTimeRange(start: monday, end: monday.add(const Duration(days: 7)));

      Future<void> pumpWeek(
        WidgetTester tester, {
        NowCallback? nowCallback,
      }) =>
          pumpAndSettleWithMaterialApp(
            tester,
            CalendarView(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: MultiDayViewConfiguration.week(
                displayRange: weekRange,
                initialDateTime: monday,
                nowCallback: nowCallback,
              ),
              header: const CalendarHeader(),
              body: const CalendarBody(),
            ),
          );

      testWidgets('highlights exactly the callback day', (tester) async {
        // Wednesday of the visible week.
        await pumpWeek(tester, nowCallback: () => DateTime(2026, 4, 15, 12));

        expect(find.byKey(DayHeader.todayKey), findsOneWidget);
        expect(todayNumber(DayHeader.todayKey, 15), findsOneWidget);
      });

      testWidgets('does not highlight any day when today is outside the visible range', (tester) async {
        // "Today" is a week later — no header in view should be highlighted.
        await pumpWeek(tester, nowCallback: () => DateTime(2026, 4, 22, 12));

        expect(find.byKey(DayHeader.todayKey), findsNothing);
      });
    });
  });
}
