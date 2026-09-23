// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Navigating to a date in the middle of a wide range, away from its boundaries, shows the page containing it.
void main() {
  group('Page navigation (preserved behaviour)', () {
    late DefaultEventsController eventsController;
    late KalenderController kalenderController;

    final wideRange = KalenderDateTimeRange(start: DateTime(2024), end: DateTime(2027));
    final target = DateTime(2025, 6, 18);

    setUp(() {
      eventsController = DefaultEventsController();
    });

    Future<void> pump(WidgetTester tester, ViewConfiguration config) {
      kalenderController = KalenderController(viewConfiguration: config);
      return pumpAndSettleWithMaterialApp(
        tester,
        KalenderView(
          eventsController: eventsController,
          kalenderController: kalenderController,
          body: const KalenderBody(),
        ),
      );
    }

    bool visibleRangeContains(DateTime date) {
      final range = kalenderController.floatingVisibleRange.value!;
      return range.dates().any((d) => d.year == date.year && d.month == date.month && d.day == date.day);
    }

    final multiDayCases = [
      (
        name: 'single day view lands on the requested mid-range day',
        config: MultiDayViewConfiguration.singleDay(displayRange: wideRange, initialDateTime: DateTime(2024, 1, 1)),
      ),
      (
        name: 'week view lands on the week containing a mid-range date',
        config: MultiDayViewConfiguration.week(displayRange: wideRange, initialDateTime: DateTime(2024, 1, 1)),
      ),
    ];

    for (final c in multiDayCases) {
      testWidgets(c.name, (tester) async {
        await pump(tester, c.config);
        kalenderController.jumpToDate(target);
        await tester.pumpAndSettle();
        expect(visibleRangeContains(target), isTrue);
      });
    }

    testWidgets('month view lands on the month containing a mid-range date', (tester) async {
      await pump(
        tester,
        MonthViewConfiguration.singleMonth(displayRange: wideRange, initialDateTime: DateTime(2024, 1, 1)),
      );
      kalenderController.jumpToDate(target);
      await tester.pumpAndSettle();
      final range = kalenderController.floatingVisibleRange.value!;
      expect(range.dominantMonthDate.year, target.year);
      expect(range.dominantMonthDate.month, target.month);
    });
  });
}
