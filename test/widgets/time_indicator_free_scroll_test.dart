// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';

import '../utilities.dart';

// The time indicator in a free scrolling view, which pages by the day while showing several days.
void main() {
  const numberOfDays = 5;
  final start = DateTime(2025, 3, 24); // Monday
  final displayRange = KalenderDateTimeRange(start: start, end: start.add(const Duration(days: 21)));
  final indicatorKey = UniqueKey();

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
  });

  final tiles = TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox());

  // [today] is the day the indicator marks. The view opens on [start].
  Future<void> pumpFreeScroll(WidgetTester tester, DateTime today) {
    kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.freeScroll(
        numberOfDays: numberOfDays,
        displayRange: displayRange,
        initialDateTime: start,
        initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
        nowCallback: () => today,
      ),
    );
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        components: KalenderComponents(
          multiDayComponents: MultiDayComponents(
            bodyComponents: MultiDayBodyComponents(
              timeIndicator: (context, timeOfDayRange, heightPerMinute, location) => SizedBox(key: indicatorKey),
            ),
          ),
        ),
        header: KalenderHeader(multiDayTileComponents: tiles),
        body: KalenderBody(multiDayTileComponents: tiles),
      ),
    );
  }

  /// The width of one day column in the body.
  double dayWidth(WidgetTester tester) {
    return tester.getSize(find.byType(TimeIndicatorPositioner)).width / numberOfDays;
  }

  for (var dayIndex = 0; dayIndex < numberOfDays; dayIndex++) {
    testWidgets('sits on day column $dayIndex when that day is today', (tester) async {
      await pumpFreeScroll(tester, start.add(Duration(days: dayIndex, hours: 12)));

      final positionerLeft = tester.getTopLeft(find.byType(TimeIndicatorPositioner)).dx;
      expect(
        tester.getTopLeft(find.byKey(indicatorKey)).dx - positionerLeft,
        moreOrLessEquals(dayIndex * dayWidth(tester), epsilon: 0.5),
      );
    });
  }

  testWidgets('is not built when today is past the trailing edge', (tester) async {
    // Day 5 is the first day off the right edge of a 5 day viewport.
    await pumpFreeScroll(tester, start.add(const Duration(days: 5, hours: 12)));

    expect(find.byKey(indicatorKey), findsNothing);
  });

  testWidgets('disappears once today scrolls off the leading edge', (tester) async {
    await pumpFreeScroll(tester, start.add(const Duration(hours: 12)));
    expect(find.byKey(indicatorKey), findsOneWidget);

    // Jump six days forward, so today is a day past the leading edge.
    kalenderController.multiDayViewController.pageController.jumpToPage(6);
    await tester.pumpAndSettle();

    expect(find.byKey(indicatorKey), findsNothing);
  });

  testWidgets('reappears when today scrolls back into the viewport', (tester) async {
    await pumpFreeScroll(tester, start.add(const Duration(hours: 12)));

    kalenderController.multiDayViewController.pageController.jumpToPage(6);
    await tester.pumpAndSettle();
    expect(find.byKey(indicatorKey), findsNothing);

    kalenderController.multiDayViewController.pageController.jumpToPage(0);
    await tester.pumpAndSettle();
    expect(find.byKey(indicatorKey), findsOneWidget);
  });
}
