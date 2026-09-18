// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

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
    tileBuilder: (context, event, tileRange) => Container(key: ValueKey('inner-${event.id}')),
  );

  Future<void> pumpFreeScroll(
    WidgetTester tester, {
    KalenderDateTimeRange? range,
    DateTime? initialDateTime,
    int numberOfDays = 7,
  }) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: MultiDayViewConfiguration.freeScroll(
          numberOfDays: numberOfDays,
          displayRange: range ?? displayRange,
          initialDateTime: initialDateTime ?? start,
          initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
        ),
        header: KalenderHeader(multiDayTileComponents: components),
        body: KalenderBody(multiDayTileComponents: components),
      ),
    );
  }

  MultiDayViewController viewController() => kalenderController.viewController as MultiDayViewController;

  testWidgets('a multi-day event renders as one continuous spanning tile', (tester) async {
    final id = eventsController.addEvent(KalenderEvent(start: start, end: start.add(const Duration(days: 4))));

    await pumpFreeScroll(tester);

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    final calWidth = tester.getSize(find.byType(KalenderView)).width;

    final tileWidth = tester.getSize(tile).width;
    // A single day column is ~calWidth/7. A spanning tile is clearly wider.
    expect(tileWidth, greaterThan(calWidth * 0.22));
    expect(tileWidth, lessThan(calWidth));
  });

  testWidgets('the spanning tile stays one tile and moves as the view scrolls', (tester) async {
    final id = eventsController.addEvent(
      KalenderEvent(start: start.add(const Duration(days: 1)), end: start.add(const Duration(days: 4))),
    );

    await pumpFreeScroll(tester);

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    final leftBefore = tester.getTopLeft(tile).dx;

    final pageController = viewController().pageController;
    pageController.jumpToPage((pageController.page ?? 0).round() + 1);
    await tester.pumpAndSettle();

    final leftAfter = tester.getTopLeft(tile).dx;
    expect(leftAfter, lessThan(leftBefore));
  });

  testWidgets('renders without blowing up on a multi-year display range', (tester) async {
    // A large range would make a whole-range strip millions of pixels wide, so
    // the band must window the days it renders.
    final bigRange = KalenderDateTimeRange(start: DateTime(2018), end: DateTime(2036));
    final id = eventsController.addEvent(KalenderEvent(start: DateTime(2026, 7, 6), end: DateTime(2026, 7, 9)));

    await pumpFreeScroll(tester, range: bigRange, initialDateTime: DateTime(2026, 7, 6), numberOfDays: 3);

    expect(find.byKey(MultiDayEventTile.tileKey(id)), findsOneWidget);
  });
}
