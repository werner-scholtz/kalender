import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// App-level tests for the page that sits at the very end of a `displayRange`.
///
/// Before treating `numberOfPages` as a count, every paginated view dropped its
/// final in-range page (and a single-page range rendered nothing at all). These
/// tests navigate to / render that last page and assert it is actually shown, so
/// they fail on the old behaviour and pass once the off-by-one is fixed.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  Future<void> pump(WidgetTester tester, ViewConfiguration config) {
    return pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: config,
        body: const CalendarBody(),
      ),
    );
  }

  bool visibleRangeContains(DateTime date) {
    final range = calendarController.internalDateTimeRange.value!;
    return range.dates().any((d) => d.year == date.year && d.month == date.month && d.day == date.day);
  }

  testWidgets('week view can navigate to the final in-range week', (tester) async {
    // June 18 and the range end (June 20) are in the same — and therefore the
    // last — week of the range.
    final lastWeekDate = DateTime(2025, 6, 18);
    await pump(
      tester,
      MultiDayViewConfiguration.week(
        displayRange: DateTimeRange(start: DateTime(2025, 6, 1), end: DateTime(2025, 6, 20)),
        initialDateTime: DateTime(2025, 6, 1),
      ),
    );

    calendarController.jumpToDate(lastWeekDate);
    await tester.pumpAndSettle();

    expect(visibleRangeContains(lastWeekDate), isTrue, reason: 'The last week of the range should be reachable');
  });

  testWidgets('month view can navigate to the final in-range month', (tester) async {
    // Range spans May–June 2025; June is the last month.
    await pump(
      tester,
      MonthViewConfiguration.singleMonth(
        displayRange: DateTimeRange(start: DateTime(2025, 5, 10), end: DateTime(2025, 6, 20)),
        initialDateTime: DateTime(2025, 5, 15),
      ),
    );

    calendarController.jumpToDate(DateTime(2025, 6, 15));
    await tester.pumpAndSettle();

    final range = calendarController.internalDateTimeRange.value!;
    expect(range.dominantMonthDate.month, 6, reason: 'The last month of the range should be reachable');
  });

  testWidgets('paginated schedule renders a single-month range', (tester) async {
    await pump(
      tester,
      ScheduleViewConfiguration.paginated(
        displayRange: DateTimeRange(start: DateTime(2025, 6, 1), end: DateTime(2025, 6, 30)),
        initialDateTime: DateTime(2025, 6, 1),
      ),
    );

    // With itemCount off by one this PageView had 0 pages and rendered nothing.
    expect(find.byType(SchedulePositionList), findsWidgets, reason: 'A single-month schedule must render its page');
  });
}
