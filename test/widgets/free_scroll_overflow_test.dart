// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  final start = DateTime(2025, 3, 24); // Monday
  final displayRange = KalenderDateTimeRange(start: start, end: start.add(const Duration(days: 21)));

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = freeScrollController(displayRange: displayRange, initialDateTime: start);
  });

  Future<void> pumpFreeScroll(WidgetTester tester) {
    return pumpAndSettleWithMaterialApp(
      tester,
      freeScrollView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        headerConfiguration: const MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1),
      ),
    );
  }

  testWidgets('overflowing days show the "+N more" portal, which opens on tap', (tester) async {
    eventsController.addEvents([
      KalenderEvent(start: start, end: start.add(const Duration(days: 2))),
      KalenderEvent(start: start, end: start.add(const Duration(days: 2))),
    ]);

    await pumpFreeScroll(tester);

    expect(find.byType(MultiDayOverlayPortal), findsWidgets);
    expect(find.byType(MultiDayPortalOverlayButton), findsWidgets);

    final monday = FloatingDateTime.fromDateTime(start);
    final button = find.byKey(MultiDayPortalOverlayButton.getKey(monday));
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byType(MultiDayOverlay), findsOneWidget);
  });
}
