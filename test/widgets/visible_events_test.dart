// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// [KalenderController.visibleEvents] holds the events of the page on screen.
void main() {
  KalenderEvent timed(DateTime day) => KalenderEvent(start: day.copyWith(hour: 9), end: day.copyWith(hour: 10));
  KalenderEvent allDay(DateTime day) =>
      KalenderEvent(start: day, end: day.add(const Duration(days: 1)), isAllDay: true);

  final january = timed(DateTime(2025, 1, 15));
  final february = timed(DateTime(2025, 2, 12));
  final march = timed(DateTime(2025, 3, 12));
  final [allDay6, allDay13, allDay20] = [
    for (final day in [6, 13, 20]) allDay(DateTime(2025, 1, day)),
  ];

  final month = MonthViewConfiguration.singleMonth(initialDateTime: DateTime(2025, 1, 15));
  final cases = [
    (name: 'month, jump', configuration: month, target: DateTime(2025, 3, 12), animate: false, expected: {march}),
    (
      name: 'month, animate past a month',
      configuration: month,
      target: DateTime(2025, 3, 12),
      animate: true,
      expected: {march},
    ),
    (
      name: 'week, jump',
      configuration: MultiDayViewConfiguration.week(initialDateTime: DateTime(2025, 1, 15)),
      target: DateTime(2025, 3, 12),
      animate: false,
      expected: {march},
    ),
    (
      name: 'week, animate past a week',
      configuration: MultiDayViewConfiguration.week(initialDateTime: DateTime(2025, 1, 6)),
      target: DateTime(2025, 1, 20),
      animate: true,
      expected: {allDay20},
    ),
  ];

  for (final (:name, :configuration, :target, :animate, :expected) in cases) {
    testWidgets('$name drops the events of the pages it left', (tester) async {
      final eventsController = DefaultEventsController()
        ..addEvents([january, february, march, allDay6, allDay13, allDay20]);
      final kalenderController = KalenderController();
      addTearDown(eventsController.dispose);
      addTearDown(kalenderController.dispose);
      await pumpKalender(
        tester,
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: configuration,
        header: const KalenderHeader(),
        body: const KalenderBody(),
      );

      if (animate) {
        kalenderController.animateToDate(target);
      } else {
        kalenderController.jumpToDate(target);
      }
      await tester.pumpAndSettle();

      expect(kalenderController.visibleEvents.value, expected);
    });
  }
}
