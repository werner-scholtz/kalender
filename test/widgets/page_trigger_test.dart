// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

// Holding a drag at the edge of the paged week view advances the page.
void main() {
  final start = DateTime(2025, 3, 24); // Monday
  final displayRange = KalenderDateTimeRange(start: start, end: start.add(const Duration(days: 28)));

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: displayRange,
        initialDateTime: start,
        initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
      ),
    );
  });

  final components = TileComponents(
    tileBuilder: (context, event, tileRange) => Container(key: ValueKey('inner-${event.id}'), color: Colors.red),
  );

  final precise = KalenderInteraction(
    inputMode: InputMode.precise,
    createEventGesture: EventInteractionGesture.tap,
    modifyEventGesture: EventInteractionGesture.tap,
  );

  Future<void> pumpWeek(WidgetTester tester) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        interaction: precise,
        views: [
          MultiDayViewParts(
            header: MultiDayHeader(tileComponents: components),
            body: MultiDayBody(tileComponents: components),
          ),
        ],
      ),
    );
  }

  testWidgets('dragging a header tile to the viewport edge advances the page', (tester) async {
    final id = eventsController.addEvent(
      KalenderEvent(start: start.add(const Duration(days: 1)), end: start.add(const Duration(days: 3))),
    );

    await pumpWeek(tester);

    final pageBefore = kalenderController.multiDayViewController.pageController.page ?? 0;

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    final headerRect = tester.getRect(find.byType(MultiDayHeader));
    final gesture = await tester.holdDragAt(tile, Offset(headerRect.right - 4, tester.getCenter(tile).dy));
    await gesture.up();
    await tester.pumpAndSettle();

    final pageAfter = kalenderController.multiDayViewController.pageController.page ?? 0;
    expect(pageAfter, greaterThan(pageBefore), reason: 'holding a drag at the header edge should advance the page');
  });

  testWidgets('dragging a body tile to the viewport edge advances the page', (tester) async {
    final eventStart = start.add(const Duration(days: 1, hours: 9));
    final id = eventsController.addEvent(
      KalenderEvent(start: eventStart, end: eventStart.add(const Duration(hours: 1))),
    );

    await pumpWeek(tester);

    final pageBefore = kalenderController.multiDayViewController.pageController.page ?? 0;

    final tile = find.byKey(DayEventTile.tileKey(id));
    final bodyRect = tester.getRect(find.byType(MultiDayBody));
    final gesture = await tester.holdDragAt(tile, Offset(bodyRect.right - 4, tester.getCenter(tile).dy));
    await gesture.up();
    await tester.pumpAndSettle();

    final pageAfter = kalenderController.multiDayViewController.pageController.page ?? 0;
    expect(pageAfter, greaterThan(pageBefore), reason: 'holding a drag at the body edge should advance the page');
  });
}
