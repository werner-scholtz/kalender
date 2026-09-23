// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';

import '../utilities.dart';

/// The time indicator in a full [KalenderView] shows on today's column and nowhere else (#261).
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
  });

  // A known Monday and the week that starts on it.
  final monday = DateTime(2026, 4, 13);
  final weekRange = KalenderDateTimeRange(start: monday, end: monday.add(const Duration(days: 7)));

  Future<void> pumpCalendarView(WidgetTester tester, ViewConfiguration viewConfiguration) {
    kalenderController = KalenderController(viewConfiguration: viewConfiguration);
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        body: const KalenderBody(),
      ),
    );
  }

  group('TimeIndicator in KalenderView (#261)', () {
    // Noon is inside the default time-of-day range, so the indicator is drawn.
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

        final positionerRect = tester.getRect(find.byType(TimeIndicatorPositioner));
        final dayWidth = positionerRect.width / 7;
        final expectedLeft = positionerRect.left + weekday * dayWidth;
        final indicatorRect = tester.getRect(find.byType(TimeIndicator));

        expect(indicatorRect.left, closeTo(expectedLeft, 1.0));
        expect(indicatorRect.width, closeTo(dayWidth, 1.0));
      });
    }

    for (final (name, daysAhead, matcher) in [
      ('single-day view shows the indicator when today is the visible day', 0, findsOneWidget),
      ('single-day view hides the indicator when today is several days ahead', 3, findsNothing),
    ]) {
      testWidgets(name, (tester) async {
        final today = monday.add(Duration(days: daysAhead));

        await pumpCalendarView(
          tester,
          MultiDayViewConfiguration.singleDay(
            displayRange: weekRange,
            initialDateTime: monday,
            nowCallback: () => DateTime(today.year, today.month, today.day, 12),
          ),
        );

        expect(find.byType(TimeIndicator), matcher);
      });
    }
  });
}
