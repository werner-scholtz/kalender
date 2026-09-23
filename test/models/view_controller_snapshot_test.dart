// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// [ViewController.snapshot] reports the date, time of day and zoom a view shows.
void main() {
  final range = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2026));
  final wednesday = DateTime(2025, 3, 5);
  const nineThirty = KalenderTime(hour: 9, minute: 30);

  for (final c in [
    (
      name: 'multi-day',
      configuration: MultiDayViewConfiguration.week(
        displayRange: range,
        initialDateTime: wednesday,
        initialTimeOfDay: nineThirty,
        initialHeightPerMinute: 1.2,
      ),
      expected: (FloatingDateTime(2025, 3, 3), nineThirty, 1.2),
    ),
    (
      name: 'month',
      configuration: MonthViewConfiguration.singleMonth(displayRange: range, initialDateTime: wednesday),
      expected: (FloatingDateTime(2025, 3), null, null),
    ),
    (
      name: 'continuous schedule',
      configuration: ScheduleViewConfiguration.continuous(displayRange: range, initialDateTime: wednesday),
      expected: (FloatingDateTime(2025, 3, 5), null, null),
    ),
    (
      name: 'paginated schedule',
      configuration: ScheduleViewConfiguration.paginated(displayRange: range, initialDateTime: wednesday),
      expected: (FloatingDateTime(2025, 3), null, null),
    ),
  ]) {
    test(c.name, () {
      final controller = KalenderController(viewConfiguration: c.configuration);
      addTearDown(controller.dispose);
      final viewController = c.configuration.createViewController(controller, null);
      addTearDown(viewController.dispose);

      final snapshot = viewController.snapshot();
      expect((snapshot.date, snapshot.timeOfDay, snapshot.heightPerMinute), c.expected);
    });
  }
}
