// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

// A change to the events clears the free-scroll header's layout-frame cache for every window, not only the visible one.
void main() {
  final displayRange = KalenderDateTimeRange(start: DateTime(2018), end: DateTime(2036));
  final initial = DateTime(2026, 7, 10);

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = freeScrollController(displayRange: displayRange, initialDateTime: initial, numberOfDays: 3);
  });

  Future<void> pumpFreeScroll(WidgetTester tester) {
    return pumpAndSettleWithMaterialApp(
      tester,
      freeScrollView(eventsController: eventsController, kalenderController: kalenderController),
    );
  }

  testWidgets('multi-day event stays visible when scrolling back to windows cached before it existed', (tester) async {
    await pumpFreeScroll(tester);

    final pageController = kalenderController.multiDayViewController.pageController;
    final base = (pageController.page ?? 0).round();
    pageController.jumpToPage(base - 2);
    await tester.pumpAndSettle();
    pageController.jumpToPage(base);
    await tester.pumpAndSettle();

    final id = eventsController.addEvent(KalenderEvent(start: initial, end: initial.add(const Duration(days: 3))));
    await tester.pumpAndSettle();

    final tile = MultiDayEventTile.tileKey(id);
    expect(find.byKey(tile), findsOneWidget, reason: 'visible at the initial position');

    pageController.jumpToPage(base - 1);
    await tester.pumpAndSettle();
    expect(find.byKey(tile), findsOneWidget, reason: 'still visible one day back');

    pageController.jumpToPage(base - 2);
    await tester.pumpAndSettle();
    expect(find.byKey(tile), findsOneWidget, reason: 'still visible two days back');
  });
}
