// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Covers the regression where [TileComponents.overlayTileBuilder] was ignored, and overlay tiles rendered with
/// [TileComponents.tileBuilder] instead.
void main() {
  const headerConfiguration = MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1);

  /// Builds a week view whose header overflows, then opens the overlay.
  Future<void> pumpAndOpenOverlay(WidgetTester tester, TileComponents tileComponents) async {
    final eventsController = DefaultEventsController();
    final monday = DateTime(2025, 1, 6);
    final kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.week(displayRange: year2025DisplayRange, initialDateTime: monday),
    );

    final end = monday.copyWith(day: monday.day + 2);
    eventsController.addEvents([KalenderEvent(start: monday, end: end), KalenderEvent(start: monday, end: end)]);

    tester.setViewSize(const Size(800, 600));

    await pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      views: [
        MultiDayViewParts(
          header: MultiDayHeader(configuration: headerConfiguration, tileComponents: tileComponents),
          body: MultiDayBody(tileComponents: tileComponents),
        ),
      ],
    );

    final date = kalenderController.floatingVisibleRange.value.dates().first;
    await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(date)));
    await tester.pumpAndSettle();
    expect(find.byType(MultiDayOverlay), findsOne);
  }

  group('overlayTileBuilder', () {
    testWidgets('renders the overlay tiles when provided', (tester) async {
      await pumpAndOpenOverlay(
        tester,
        TileComponents(
          tileBuilder: (context, event, tileRange) => const Text('normal'),
          overlayTileBuilder: (context, event, tileRange) => const Text('overlay'),
        ),
      );

      expect(find.text('overlay'), findsNWidgets(2));
    });

    testWidgets('falls back to tileBuilder when omitted', (tester) async {
      await pumpAndOpenOverlay(
        tester,
        TileComponents(tileBuilder: (context, event, tileRange) => const Text('normal')),
      );

      expect(find.text('normal'), findsWidgets);
    });
  });
}
