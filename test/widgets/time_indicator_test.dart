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

void main() {
  group('TimeIndicatorPositioner', () {
    final key = UniqueKey();
    final now = FloatingDateTime.fromDateTime(DateTime.now()).startOfWeek();
    final range = FloatingDateTimeRange(start: now, end: now.endOfWeek());
    final viewConfiguration = MultiDayViewConfiguration.week(displayRange: range.forLocation());

    for (final (index, date) in range.dates().map(FloatingDateTime.fromDateTime).indexed) {
      testWidgets('for date index: ($index)', (tester) async {
        await pumpAndSettleWithMaterialApp(
          tester,
          SizedBox(
            width: 700,
            height: 100,
            child: Stack(
              children: [
                TimeIndicatorPositioner(
                  viewController: MultiDayViewController(
                    viewConfiguration: viewConfiguration,
                    floatingVisibleRange: ValueNotifier(range),
                    visibleEvents: ValueNotifier(<KalenderEvent>{}),
                  ),
                  initialPage: 0,
                  dateOverride: date,
                  childOverride: SizedBox(key: key),
                ),
              ],
            ),
          ),
        );
        final finder = find.byKey(key);
        expect(finder, findsOneWidget);
        expect(tester.getTopLeft(finder).dx, index * 100.0);
      });
    }
  });
}
