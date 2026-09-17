// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  final range = KalenderDateTimeRange(start: DateTime(2026, 8), end: DateTime(2026, 11));
  final now = DateTime(2026, 9, 16, 12);

  final configurations = <ViewConfiguration>[
    MonthViewConfiguration.singleMonth(displayRange: range, initialDateTime: now),
    MultiDayViewConfiguration.week(displayRange: range, initialDateTime: now),
    ScheduleViewConfiguration.continuous(displayRange: range, initialDateTime: now),
  ];

  for (final configuration in configurations) {
    testWidgets('a view shorter than its header lays out without errors, ${configuration.name}', (tester) async {
      final eventsController = DefaultEventsController();
      final kalenderController = KalenderController();
      addTearDown(eventsController.dispose);
      addTearDown(kalenderController.dispose);

      await pumpAndSettleWithMaterialApp(
        tester,
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 1,
            child: KalenderView(
              eventsController: eventsController,
              kalenderController: kalenderController,
              viewConfiguration: configuration,
              header: const KalenderHeader(),
              body: const KalenderBody(),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  }
}
