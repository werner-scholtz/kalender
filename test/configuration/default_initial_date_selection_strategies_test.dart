import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';

import '../utilities.dart';

void main() {
  initializeTimeZones();
  final locations = locationsToTest.map(getLocation).toList();

  for (final location in locations) {
    // A full-year display range expressed in the target location.
    final range = DateTimeRange(start: TZDateTime(location, 2025), end: TZDateTime(location, 2026));
    final visibleEvents = ValueNotifier(<CalendarEvent>{});

    // ── Controller builders ──────────────────────────────────────────────
    //
    // All controllers use initialDate = InternalDateTime(2025, 1, 1) which is
    // treated as a timezone-agnostic wall-clock value by page calculators.
    //
    // The dummy initial visibleDateTimeRange passed to each constructor is
    // immediately overwritten inside the constructor, so any sentinel value works.

    InternalDateTimeRange dummyRange() => InternalDateTimeRange(
          start: InternalDateTime(2025),
          end: InternalDateTime(2025, 2),
        );

    MonthViewController buildMonth() => MonthViewController(
          viewConfiguration: MonthViewConfiguration.singleMonth(displayRange: range),
          visibleDateTimeRange: ValueNotifier(dummyRange()),
          visibleEvents: visibleEvents,
          initialDate: InternalDateTime(2025, 1, 1),
        );

    MultiDayViewController buildWeek() => MultiDayViewController(
          viewConfiguration: MultiDayViewConfiguration.week(displayRange: range),
          visibleDateTimeRange: ValueNotifier(dummyRange()),
          visibleEvents: visibleEvents,
          initialDate: InternalDateTime(2025, 1, 1),
        );

    MultiDayViewController buildWorkWeek() => MultiDayViewController(
          viewConfiguration: MultiDayViewConfiguration.workWeek(displayRange: range),
          visibleDateTimeRange: ValueNotifier(dummyRange()),
          visibleEvents: visibleEvents,
          initialDate: InternalDateTime(2025, 1, 1),
        );

    MultiDayViewController buildDay() => MultiDayViewController(
          viewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: range),
          visibleDateTimeRange: ValueNotifier(dummyRange()),
          visibleEvents: visibleEvents,
          initialDate: InternalDateTime(2025, 1, 1),
        );

    MultiDayViewController buildCustomMultiDay() => MultiDayViewController(
          viewConfiguration: MultiDayViewConfiguration.custom(numberOfDays: 3, displayRange: range),
          visibleDateTimeRange: ValueNotifier(dummyRange()),
          visibleEvents: visibleEvents,
          initialDate: InternalDateTime(2025, 1, 1),
        );

    MultiDayViewController buildCustomSingleDay() => MultiDayViewController(
          viewConfiguration: MultiDayViewConfiguration.custom(numberOfDays: 1, displayRange: range),
          visibleDateTimeRange: ValueNotifier(dummyRange()),
          visibleEvents: visibleEvents,
          initialDate: InternalDateTime(2025, 1, 1),
        );

    ContinuousScheduleViewController buildSchedule() => ContinuousScheduleViewController(
          viewConfiguration: ScheduleViewConfiguration.continuous(displayRange: range),
          visibleDateTimeRange: ValueNotifier(dummyRange()),
          visibleEvents: visibleEvents,
          initialDate: InternalDateTime(2025, 1, 1),
        );

    // ── Expected starting dates ──────────────────────────────────────────
    //
    // Month / Week / WorkWeek use calendar-aligned page calculators that snap
    // to the ISO week boundary regardless of the TZDateTime UTC offset, so their
    // visible-range start is the same for ALL tested locations:
    //   • Month & Week & WorkWeek → Dec 30, 2024  (Monday of the week containing Jan 1)
    //   • Day / Custom(1)         → Jan  1, 2025
    //   • dominantMonthDate of the January month grid → Jan 1, 2025
    //
    // Custom(3) and Schedule anchor their page 0 to the raw display-range start.
    // For UTC+2/+11 locations that start resolves to Dec 31 instead of Jan 1,
    // shifting page boundaries. We therefore derive those starts from the
    // constructed controllers instead of hardcoding them.
    final monthOrWeekStart = InternalDateTime(2024, 12, 30);
    final dayStart = InternalDateTime(2025, 1, 1);
    final dominantJanuary = InternalDateTime(2025, 1, 1);

    // Location-dependent starts – built once, reused across all strategy groups.
    final customMultiStart = buildCustomMultiDay().visibleDateTimeRange.value!.start;
    final scheduleStart = buildSchedule().visibleDateTimeRange.value!.start;

    // ── kDefaultToMonthly ────────────────────────────────────────────────

    group('[$location] kDefaultToMonthly', () {
      final newConfig = MonthViewConfiguration.singleMonth(displayRange: range);

      test('from Month  → dominantMonthDate of visible range', () {
        final result = kDefaultToMonthly(oldViewController: buildMonth(), newViewConfiguration: newConfig);
        expect(result, dominantJanuary, reason: 'Month → Month: expected $dominantJanuary but got $result');
      });

      test('from Week   → visible-range start', () {
        final result = kDefaultToMonthly(oldViewController: buildWeek(), newViewConfiguration: newConfig);
        expect(result, monthOrWeekStart, reason: 'Week → Month: expected $monthOrWeekStart but got $result');
      });

      test('from WorkWeek → visible-range start', () {
        final result = kDefaultToMonthly(oldViewController: buildWorkWeek(), newViewConfiguration: newConfig);
        expect(result, monthOrWeekStart, reason: 'WorkWeek → Month: expected $monthOrWeekStart but got $result');
      });

      test('from Day → visible-range start', () {
        final result = kDefaultToMonthly(oldViewController: buildDay(), newViewConfiguration: newConfig);
        expect(result, dayStart, reason: 'Day → Month: expected $dayStart but got $result');
      });

      test('from Custom(3) → visible-range start', () {
        final result = kDefaultToMonthly(oldViewController: buildCustomMultiDay(), newViewConfiguration: newConfig);
        expect(result, customMultiStart, reason: 'Custom(3) → Month: expected $customMultiStart but got $result');
      });

      test('from Custom(1) → visible-range start', () {
        final result = kDefaultToMonthly(oldViewController: buildCustomSingleDay(), newViewConfiguration: newConfig);
        expect(result, dayStart, reason: 'Custom(1) → Month: expected $dayStart but got $result');
      });

      test('from Schedule → visible-range start', () {
        final result = kDefaultToMonthly(oldViewController: buildSchedule(), newViewConfiguration: newConfig);
        expect(result, scheduleStart, reason: 'Schedule → Month: expected $scheduleStart but got $result');
      });
    });

    // ── kDefaultToWeekly ─────────────────────────────────────────────────

    group('[$location] kDefaultToWeekly', () {
      final newConfig = MultiDayViewConfiguration.week(displayRange: range);

      test('from Month    → visible-range start', () {
        final result = kDefaultToWeekly(oldViewController: buildMonth(), newViewConfiguration: newConfig);
        expect(result, monthOrWeekStart, reason: 'Month → Week: expected $monthOrWeekStart but got $result');
      });

      test('from Week     → visible-range start', () {
        final result = kDefaultToWeekly(oldViewController: buildWeek(), newViewConfiguration: newConfig);
        expect(result, monthOrWeekStart, reason: 'Week → Week: expected $monthOrWeekStart but got $result');
      });

      test('from WorkWeek → visible-range start', () {
        final result = kDefaultToWeekly(oldViewController: buildWorkWeek(), newViewConfiguration: newConfig);
        expect(result, monthOrWeekStart, reason: 'WorkWeek → Week: expected $monthOrWeekStart but got $result');
      });

      test('from Day → visible-range start', () {
        final result = kDefaultToWeekly(oldViewController: buildDay(), newViewConfiguration: newConfig);
        expect(result, dayStart, reason: 'Day → Week: expected $dayStart but got $result');
      });

      test('from Custom(3) → visible-range start', () {
        final result = kDefaultToWeekly(oldViewController: buildCustomMultiDay(), newViewConfiguration: newConfig);
        expect(result, customMultiStart, reason: 'Custom(3) → Week: expected $customMultiStart but got $result');
      });

      test('from Custom(1) → visible-range start', () {
        final result = kDefaultToWeekly(oldViewController: buildCustomSingleDay(), newViewConfiguration: newConfig);
        expect(result, dayStart, reason: 'Custom(1) → Week: expected $dayStart but got $result');
      });

      test('from Schedule → visible-range start', () {
        final result = kDefaultToWeekly(oldViewController: buildSchedule(), newViewConfiguration: newConfig);
        expect(result, scheduleStart, reason: 'Schedule → Week: expected $scheduleStart but got $result');
      });
    });

    // ── kDefaultToDaily ──────────────────────────────────────────────────

    group('[$location] kDefaultToDaily', () {
      final newConfig = MultiDayViewConfiguration.singleDay(displayRange: range);

      test('from Month  → dominantMonthDate of visible range', () {
        final result = kDefaultToDaily(oldViewController: buildMonth(), newViewConfiguration: newConfig);
        expect(result, dominantJanuary, reason: 'Month → Day: expected $dominantJanuary but got $result');
      });

      test('from Week   → visible-range start', () {
        final result = kDefaultToDaily(oldViewController: buildWeek(), newViewConfiguration: newConfig);
        expect(result, monthOrWeekStart, reason: 'Week → Day: expected $monthOrWeekStart but got $result');
      });

      test('from WorkWeek → visible-range start', () {
        final result = kDefaultToDaily(oldViewController: buildWorkWeek(), newViewConfiguration: newConfig);
        expect(result, monthOrWeekStart, reason: 'WorkWeek → Day: expected $monthOrWeekStart but got $result');
      });

      test('from Day → visible-range start', () {
        final result = kDefaultToDaily(oldViewController: buildDay(), newViewConfiguration: newConfig);
        expect(result, dayStart, reason: 'Day → Day: expected $dayStart but got $result');
      });

      test('from Custom(3) → visible-range start', () {
        final result = kDefaultToDaily(oldViewController: buildCustomMultiDay(), newViewConfiguration: newConfig);
        expect(result, customMultiStart, reason: 'Custom(3) → Day: expected $customMultiStart but got $result');
      });

      test('from Custom(1) → visible-range start', () {
        final result = kDefaultToDaily(oldViewController: buildCustomSingleDay(), newViewConfiguration: newConfig);
        expect(result, dayStart, reason: 'Custom(1) → Day: expected $dayStart but got $result');
      });

      test('from Schedule → visible-range start', () {
        final result = kDefaultToDaily(oldViewController: buildSchedule(), newViewConfiguration: newConfig);
        expect(result, scheduleStart, reason: 'Schedule → Day: expected $scheduleStart but got $result');
      });
    });

    // ── kDefaultToSchedule ───────────────────────────────────────────────

    group('[$location] kDefaultToSchedule', () {
      final newConfig = ScheduleViewConfiguration.continuous(displayRange: range);

      test('from Month    → visible-range start', () {
        final result = kDefaultToSchedule(oldViewController: buildMonth(), newViewConfiguration: newConfig);
        expect(result, monthOrWeekStart, reason: 'Month → Schedule: expected $monthOrWeekStart but got $result');
      });

      test('from Week     → visible-range start', () {
        final result = kDefaultToSchedule(oldViewController: buildWeek(), newViewConfiguration: newConfig);
        expect(result, monthOrWeekStart, reason: 'Week → Schedule: expected $monthOrWeekStart but got $result');
      });

      test('from WorkWeek → visible-range start', () {
        final result = kDefaultToSchedule(oldViewController: buildWorkWeek(), newViewConfiguration: newConfig);
        expect(result, monthOrWeekStart, reason: 'WorkWeek → Schedule: expected $monthOrWeekStart but got $result');
      });

      test('from Day → visible-range start', () {
        final result = kDefaultToSchedule(oldViewController: buildDay(), newViewConfiguration: newConfig);
        expect(result, dayStart, reason: 'Day → Schedule: expected $dayStart but got $result');
      });

      test('from Custom(3) → visible-range start', () {
        final result = kDefaultToSchedule(oldViewController: buildCustomMultiDay(), newViewConfiguration: newConfig);
        expect(result, customMultiStart, reason: 'Custom(3) → Schedule: expected $customMultiStart but got $result');
      });

      test('from Custom(1) → visible-range start', () {
        final result = kDefaultToSchedule(oldViewController: buildCustomSingleDay(), newViewConfiguration: newConfig);
        expect(result, dayStart, reason: 'Custom(1) → Schedule: expected $dayStart but got $result');
      });

      test('from Schedule → visible-range start', () {
        final result = kDefaultToSchedule(oldViewController: buildSchedule(), newViewConfiguration: newConfig);
        expect(result, scheduleStart, reason: 'Schedule → Schedule: expected $scheduleStart but got $result');
      });
    });

    // ── kDefaultInitialDateSelectionStrategy (routing) ───────────────────
    //
    // Verifies that the general router delegates to the correct specific strategy
    // for each target ViewConfiguration type.  Using relational assertions
    // (router result == specific-strategy result) means these tests remain valid
    // even if an underlying strategy changes its return value.

    group('[$location] kDefaultInitialDateSelectionStrategy routing', () {
      // Use the week controller as a stable source throughout.
      final src = buildWeek;

      test('→ MonthViewConfiguration routes to kDefaultToMonthly', () {
        final cfg = MonthViewConfiguration.singleMonth(displayRange: range);
        expect(
          kDefaultInitialDateSelectionStrategy(oldViewController: src(), newViewConfiguration: cfg),
          kDefaultToMonthly(oldViewController: src(), newViewConfiguration: cfg),
        );
      });

      test('→ week MultiDayViewConfiguration routes to kDefaultToWeekly', () {
        final cfg = MultiDayViewConfiguration.week(displayRange: range);
        expect(
          kDefaultInitialDateSelectionStrategy(oldViewController: src(), newViewConfiguration: cfg),
          kDefaultToWeekly(oldViewController: src(), newViewConfiguration: cfg),
        );
      });

      test('→ workWeek MultiDayViewConfiguration routes to kDefaultToWeekly', () {
        final cfg = MultiDayViewConfiguration.workWeek(displayRange: range);
        expect(
          kDefaultInitialDateSelectionStrategy(oldViewController: src(), newViewConfiguration: cfg),
          kDefaultToWeekly(oldViewController: src(), newViewConfiguration: cfg),
        );
      });

      test('→ custom(3) MultiDayViewConfiguration routes to kDefaultToWeekly', () {
        final cfg = MultiDayViewConfiguration.custom(numberOfDays: 3, displayRange: range);
        expect(
          kDefaultInitialDateSelectionStrategy(oldViewController: src(), newViewConfiguration: cfg),
          kDefaultToWeekly(oldViewController: src(), newViewConfiguration: cfg),
        );
      });

      test('→ singleDay MultiDayViewConfiguration routes to kDefaultToDaily', () {
        final cfg = MultiDayViewConfiguration.singleDay(displayRange: range);
        expect(
          kDefaultInitialDateSelectionStrategy(oldViewController: src(), newViewConfiguration: cfg),
          kDefaultToDaily(oldViewController: src(), newViewConfiguration: cfg),
        );
      });

      test('→ custom(1) MultiDayViewConfiguration routes to kDefaultToDaily', () {
        final cfg = MultiDayViewConfiguration.custom(numberOfDays: 1, displayRange: range);
        expect(
          kDefaultInitialDateSelectionStrategy(oldViewController: src(), newViewConfiguration: cfg),
          kDefaultToDaily(oldViewController: src(), newViewConfiguration: cfg),
        );
      });

      test('→ ScheduleViewConfiguration routes to kDefaultToSchedule', () {
        final cfg = ScheduleViewConfiguration.continuous(displayRange: range);
        expect(
          kDefaultInitialDateSelectionStrategy(oldViewController: src(), newViewConfiguration: cfg),
          kDefaultToSchedule(oldViewController: src(), newViewConfiguration: cfg),
        );
      });
    });
  }
}

