// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Covers the regression where [TileComponents.overlayTileBuilder] was ignored,
/// and overlay tiles rendered with [TileComponents.tileBuilder] instead.
void main() {
  const headerConfiguration = MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1);

  /// Builds a week view whose header overflows, then opens the overlay.
  Future<void> pumpAndOpenOverlay(WidgetTester tester, TileComponents tileComponents) async {
    final eventsController = DefaultEventsController();
    final kalenderController = KalenderController(viewConfiguration: MultiDayViewConfiguration.week());

    final now = FloatingDateTime.fromDateTime(DateTime.now()).startOfWeek();
    final startOfWeek = DateTime(now.year, now.month, now.day);
    final range = KalenderDateTimeRange(
      start: startOfWeek,
      end: startOfWeek.copyWith(day: startOfWeek.day + 2),
    );
    eventsController.addEvents([
      KalenderEvent(start: range.start, end: range.end),
      KalenderEvent(start: range.start, end: range.end),
    ]);

    tester.setViewSize(const Size(800, 600));

    await pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      header: KalenderHeader(multiDayHeaderConfiguration: headerConfiguration, multiDayTileComponents: tileComponents),
      body: KalenderBody(multiDayTileComponents: tileComponents),
    );

    final date = kalenderController.floatingVisibleRange.value!.dates().first;
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
