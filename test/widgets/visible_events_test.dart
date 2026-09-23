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
  final january = KalenderEvent(start: DateTime(2025, 1, 15, 9), end: DateTime(2025, 1, 15, 10));
  final march = KalenderEvent(start: DateTime(2025, 3, 12, 9), end: DateTime(2025, 3, 12, 10));

  for (final configuration in [
    MonthViewConfiguration.singleMonth(initialDateTime: DateTime(2025, 1, 15)),
    MultiDayViewConfiguration.week(initialDateTime: DateTime(2025, 1, 15)),
  ]) {
    testWidgets('${configuration.name} drops the events of the page it left', (tester) async {
      final eventsController = DefaultEventsController()..addEvents([january, march]);
      final kalenderController = KalenderController();
      addTearDown(eventsController.dispose);
      addTearDown(kalenderController.dispose);
      await pumpKalender(
        tester,
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: configuration,
        body: const KalenderBody(),
      );

      kalenderController.jumpToDate(DateTime(2025, 3, 12));
      await tester.pumpAndSettle();

      expect(kalenderController.visibleEvents.value, {march});
    });
  }
}
