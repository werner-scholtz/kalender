// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// The views read the current time from package:clock when no nowCallback is set.

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';

import '../utilities.dart';

void main() {
  // Noon on a Wednesday, in a year the test does not run in.
  final now = DateTime(2031, 3, 5, 12);

  testWidgets('a default week view opens on the week of the clock with the indicator in its day', (tester) async {
    await withClock(Clock.fixed(now), () async {
      final controller = KalenderController(viewConfiguration: MultiDayViewConfiguration.week());
      await pumpKalender(
        tester,
        eventsController: DefaultEventsController(),
        kalenderController: controller,
        views: bodyOnlyViews,
      );

      expect(
        controller.floatingVisibleRange.value,
        FloatingDateTimeRange(start: FloatingDateTime(2031, 3, 3), end: FloatingDateTime(2031, 3, 10)),
      );

      final positioner = tester.getRect(find.byType(TimeIndicatorPositioner));
      final dayWidth = positioner.width / 7;
      final indicator = tester.getRect(find.byType(TimeIndicator));
      expect(indicator.left, closeTo(positioner.left + 2 * dayWidth, 1.0));
    });
  });
}
