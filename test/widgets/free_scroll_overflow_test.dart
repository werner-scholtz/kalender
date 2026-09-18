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
  final start = DateTime(2025, 3, 24); // Monday
  final displayRange = KalenderDateTimeRange(start: start, end: start.add(const Duration(days: 21)));

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
  });

  final components = TileComponents(
    tileBuilder: (context, event, tileRange) => Container(key: ValueKey('inner-${event.id}'), color: Colors.red),
  );

  const headerConfiguration = MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1);

  Future<void> pumpFreeScroll(WidgetTester tester) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: MultiDayViewConfiguration.freeScroll(
          numberOfDays: 7,
          displayRange: displayRange,
          initialDateTime: start,
          initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
        ),
        header: KalenderHeader(multiDayTileComponents: components, multiDayHeaderConfiguration: headerConfiguration),
        body: KalenderBody(multiDayTileComponents: components),
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
