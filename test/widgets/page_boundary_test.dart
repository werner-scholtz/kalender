// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// The last page of a displayRange is reachable and rendered.
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
  });

  Future<void> pump(WidgetTester tester, ViewConfiguration config) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: config,
        body: const KalenderBody(),
      ),
    );
  }

  bool visibleRangeContains(DateTime date) {
    final range = kalenderController.floatingVisibleRange.value!;
    return range.dates().any((d) => d.year == date.year && d.month == date.month && d.day == date.day);
  }

  testWidgets('week view can navigate to the final in-range week', (tester) async {
    // June 18 is in the same week as the range end (June 20), the last week of the range.
    final lastWeekDate = DateTime(2025, 6, 18);
    await pump(
      tester,
      MultiDayViewConfiguration.week(
        displayRange: KalenderDateTimeRange(start: DateTime(2025, 6, 1), end: DateTime(2025, 6, 20)),
        initialDateTime: DateTime(2025, 6, 1),
      ),
    );

    kalenderController.jumpToDate(lastWeekDate);
    await tester.pumpAndSettle();

    expect(visibleRangeContains(lastWeekDate), isTrue, reason: 'The last week of the range should be reachable');
  });

  testWidgets('month view can navigate to the final in-range month', (tester) async {
    await pump(
      tester,
      MonthViewConfiguration.singleMonth(
        displayRange: KalenderDateTimeRange(start: DateTime(2025, 5, 10), end: DateTime(2025, 6, 20)),
        initialDateTime: DateTime(2025, 5, 15),
      ),
    );

    kalenderController.jumpToDate(DateTime(2025, 6, 15));
    await tester.pumpAndSettle();

    final range = kalenderController.floatingVisibleRange.value!;
    expect(range.dominantMonthDate.month, 6, reason: 'The last month of the range should be reachable');
  });

  testWidgets('free scroll stops at the end of the range', (tester) async {
    // 2025-06-01 through 2025-06-07, the end exclusive at midnight.
    await pump(
      tester,
      MultiDayViewConfiguration.freeScroll(
        numberOfDays: 3,
        displayRange: KalenderDateTimeRange(start: DateTime(2025, 6), end: DateTime(2025, 6, 8)),
        initialDateTime: DateTime(2025, 6),
      ),
    );

    final viewController = kalenderController.viewController! as MultiDayViewController;
    expect(viewController.numberOfPages, 7, reason: 'one column per day in the range, and no more');

    final last = viewController.viewConfiguration.pageIndexCalculator.rangeFromIndex(
      viewController.numberOfPages - 1,
      null,
    );
    expect(last.start, FloatingDateTime(2025, 6, 7), reason: 'the last column is the last day of the range');
  });

  testWidgets('paginated schedule renders a single-month range', (tester) async {
    await pump(
      tester,
      ScheduleViewConfiguration.paginated(
        displayRange: KalenderDateTimeRange(start: DateTime(2025, 6, 1), end: DateTime(2025, 6, 30)),
        initialDateTime: DateTime(2025, 6, 1),
      ),
    );

    expect(find.byType(SchedulePositionList), findsWidgets, reason: 'A single-month schedule must render its page');
  });
}
