// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

import '../utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 1, 1),
      ),
    );
  });

  tearDown(() {
    kalenderController.dispose();
    eventsController.dispose();
  });

  Widget buildCalendar(KalenderSnapping snapping) {
    return KalenderView(
      eventsController: eventsController,
      kalenderController: kalenderController,
      body: KalenderBody(snapping: snapping),
    );
  }

  KalenderSnapping resolvedSnapping(WidgetTester tester) {
    return tester.widget<Snapping>(find.byType(Snapping)).notifier!.value;
  }

  /// 00:08 with a 15 minute interval. [EventSnapStrategy.interval] moves it to
  /// 00:15 and [EventSnapStrategy.none] leaves it alone, so the result names the
  /// strategy in use by behavior rather than by identity alone.
  FloatingDateTime applyStrategy(KalenderSnapping snapping) {
    return snapping.eventSnapStrategy.snap(
      cursorDate: FloatingDateTime(2025, 1, 1, 0, 8),
      startOfDay: FloatingDateTime(2025, 1, 1),
      snapIntervalMinutes: 15,
    );
  }

  testWidgets('the initial eventSnapStrategy reaches the widget tree', (tester) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      buildCalendar(const KalenderSnapping(eventSnapStrategy: EventSnapStrategy.none())),
    );

    expect(applyStrategy(resolvedSnapping(tester)), equals(FloatingDateTime(2025, 1, 1, 0, 8)));
  });

  testWidgets('changing only eventSnapStrategy updates the widget tree', (tester) async {
    await pumpAndSettleWithMaterialApp(tester, buildCalendar(const KalenderSnapping()));

    expect(applyStrategy(resolvedSnapping(tester)), equals(FloatingDateTime(2025, 1, 1, 0, 15)));

    await pumpAndSettleWithMaterialApp(
      tester,
      buildCalendar(const KalenderSnapping(eventSnapStrategy: EventSnapStrategy.none())),
    );

    expect(
      applyStrategy(resolvedSnapping(tester)),
      equals(FloatingDateTime(2025, 1, 1, 0, 8)),
      reason: 'the new strategy should be in effect, so 00:08 is left alone',
    );
  });

  testWidgets('changing eventSnapStrategy alongside another field updates the widget tree', (tester) async {
    await pumpAndSettleWithMaterialApp(tester, buildCalendar(const KalenderSnapping()));

    await pumpAndSettleWithMaterialApp(
      tester,
      buildCalendar(const KalenderSnapping(snapIntervalMinutes: 30, eventSnapStrategy: EventSnapStrategy.none())),
    );

    final snapping = resolvedSnapping(tester);
    expect(snapping.snapIntervalMinutes, equals(30));
    expect(applyStrategy(snapping), equals(FloatingDateTime(2025, 1, 1, 0, 8)));
  });
}
