import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Characterization tests for page navigation that must hold regardless of the
/// page-count convention.
///
/// These navigate to a date in the **middle** of a wide range, well away from
/// the range boundary. The visible page must always contain the requested date.
/// They are expected to pass both before and after the `numberOfPages` change,
/// proving that change does not alter normal (non-boundary) navigation.
void main() {
  group('Page navigation (preserved behaviour)', () {
    late DefaultEventsController eventsController;
    late CalendarController calendarController;

    // A wide range so the target date is nowhere near the first/last page.
    final wideRange = DateTimeRange(start: DateTime(2024), end: DateTime(2027));
    // A Wednesday, comfortably inside the range.
    final target = DateTime(2025, 6, 18);

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

    testWidgets('single day view lands on the requested mid-range day', (tester) async {
      await pump(
        tester,
        MultiDayViewConfiguration.singleDay(displayRange: wideRange, initialDateTime: DateTime(2024, 1, 1)),
      );
      calendarController.jumpToDate(target);
      await tester.pumpAndSettle();
      expect(visibleRangeContains(target), isTrue);
    });

    testWidgets('week view lands on the week containing a mid-range date', (tester) async {
      await pump(
        tester,
        MultiDayViewConfiguration.week(displayRange: wideRange, initialDateTime: DateTime(2024, 1, 1)),
      );
      calendarController.jumpToDate(target);
      await tester.pumpAndSettle();
      expect(visibleRangeContains(target), isTrue);
    });

    testWidgets('month view lands on the month containing a mid-range date', (tester) async {
      await pump(
        tester,
        MonthViewConfiguration.singleMonth(displayRange: wideRange, initialDateTime: DateTime(2024, 1, 1)),
      );
      calendarController.jumpToDate(target);
      await tester.pumpAndSettle();
      final range = calendarController.internalDateTimeRange.value!;
      expect(range.dominantMonthDate.year, target.year);
      expect(range.dominantMonthDate.month, target.month);
    });
  });
}
