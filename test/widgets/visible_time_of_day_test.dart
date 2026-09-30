// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart';

import '../utilities.dart';

/// The time of day a multi-day view opens on and scrolls to.
void main() {
  tz.initializeTimeZones();

  testWidgets('a time of day the view cannot scroll to reports the time at the top', (tester) async {
    final eventsController = DefaultEventsController();
    final kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 6, 18),
        initialTimeOfDay: const KalenderTime(hour: 22, minute: 0),
        initialHeightPerMinute: 1,
      ),
    );
    addTearDown(eventsController.dispose);
    addTearDown(kalenderController.dispose);
    await pumpKalender(tester, eventsController: eventsController, kalenderController: kalenderController);

    final viewController = kalenderController.viewController as MultiDayViewController;
    final minutes = viewController.scrollController.position.maxScrollExtent.round();
    expect(kalenderController.visibleTimeOfDay.value, KalenderTime(hour: minutes ~/ 60, minute: minutes % 60));
  });

  for (final name in ['Etc/UTC', 'America/New_York', 'Asia/Tokyo', 'Pacific/Auckland']) {
    testWidgets('$name scrolls to 03:00', (tester) async {
      final location = getLocation(name);
      final eventsController = DefaultEventsController();
      final kalenderController = KalenderController(
        viewConfiguration: MultiDayViewConfiguration.week(
          displayRange: year2025DisplayRange,
          initialDateTime: DateTime.utc(2025, 6, 18),
          initialHeightPerMinute: 2,
        ),
        location: location,
      );
      addTearDown(eventsController.dispose);
      addTearDown(kalenderController.dispose);
      await pumpKalender(tester, eventsController: eventsController, kalenderController: kalenderController);

      kalenderController.animateToDateTime(TZDateTime(location, 2025, 6, 18, 3));
      await tester.pumpAndSettle();

      expect(kalenderController.visibleTimeOfDay.value, const KalenderTime(hour: 3, minute: 0));
    });
  }
}
