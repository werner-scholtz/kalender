// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// When [KalenderController] disposes a view controller it replaced.
void main() {
  final week = MultiDayViewConfiguration.week(displayRange: year2025DisplayRange);
  final month = MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange);

  bool isDisposed(ViewController viewController) {
    try {
      viewController.floatingVisibleRange.addListener(() {});
      return false;
    } on FlutterError {
      return true;
    }
  }

  testWidgets('a switch while a view shows the old view controller disposes it after the frame', (tester) async {
    final eventsController = DefaultEventsController();
    final kalenderController = KalenderController(viewConfiguration: week);
    addTearDown(eventsController.dispose);
    addTearDown(kalenderController.dispose);
    await pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      header: const KalenderHeader(),
      body: const KalenderBody(),
    );
    final old = kalenderController.viewController;

    kalenderController.viewConfiguration = month;
    final beforeFrame = isDisposed(old);
    await tester.pump();

    expect((beforeFrame, isDisposed(old)), (false, true));
  });

  test('a switch without a view disposes the old view controller at once', () {
    final kalenderController = KalenderController(viewConfiguration: week);
    addTearDown(kalenderController.dispose);
    final old = kalenderController.viewController;

    kalenderController.viewConfiguration = month;

    expect(isDisposed(old), isTrue);
  });

  testWidgets('the controller disposes the view controller a removed view showed', (tester) async {
    final eventsController = DefaultEventsController();
    final kalenderController = KalenderController(viewConfiguration: week);
    addTearDown(eventsController.dispose);
    await pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      body: const KalenderBody(),
    );
    final shown = kalenderController.viewController;
    await tester.pumpWidget(const SizedBox());
    final afterUnmount = isDisposed(shown);

    kalenderController.dispose();

    expect((afterUnmount, isDisposed(shown)), (false, true));
  });
}
