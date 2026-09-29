// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  // 29 Jan 2025 is a Wednesday, in the last row of a five row January.
  final day = DateTime.utc(2025, 1, 29);

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = controllerWithOverflowOn(day);
    kalenderController = KalenderController(
      viewConfiguration: MonthViewConfiguration.singleMonth(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 1, 15),
      ),
    );
  });

  tearDown(() {
    kalenderController.dispose();
    eventsController.dispose();
  });

  /// The same calendar, same controllers and same configuration, rendered in
  /// [textDirection]. Nothing here recreates the view controller, so its layout
  /// frame cache carries over between directions.
  Widget build(TextDirection textDirection) {
    return Directionality(
      textDirection: textDirection,
      child: KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        views: bodyOnlyViews,
      ),
    );
  }

  testWidgets('flipping text direction on a live calendar keeps the overflow on the same date', (tester) async {
    tester.setViewSize(const Size(800, 600));

    await pumpAndSettleWithMaterialApp(tester, build(TextDirection.ltr));
    final ltr = januaryLastRowOverflowDates();
    expect(ltr, contains(day));

    await pumpAndSettleWithMaterialApp(tester, build(TextDirection.rtl));

    expect(
      januaryLastRowOverflowDates(),
      equals(ltr),
      reason: 'the cached frame is ordered by direction, so it must not be reused across a flip',
    );
  });
}
