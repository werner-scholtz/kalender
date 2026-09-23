// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;

import '../utilities.dart';

// Holding a drag at the top or bottom edge of the body scrolls it vertically.
void main() {
  final start = DateTime(2025, 3, 24); // Monday

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
  });

  final components = TileComponents(
    tileBuilder: (context, event, tileRange) => Container(key: ValueKey('inner-${event.id}'), color: Colors.red),
  );

  // Align the top of the viewport with [hour] so each test starts with room to
  // scroll in the direction it drags.
  Future<void> pumpWeek(WidgetTester tester, int hour) {
    kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: KalenderDateTimeRange(start: start, end: start.add(const Duration(days: 7))),
        initialDateTime: start,
        initialTimeOfDay: KalenderTime(hour: hour, minute: 0),
      ),
    );
    return pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      interaction: kPreciseInteraction,
      views: [
        MultiDayViewParts(
          header: const SizedBox.shrink(),
          body: MultiDayBody(tileComponents: components),
        ),
      ],
    );
  }

  final cases = [
    (
      edge: 'bottom',
      direction: 'down',
      viewHour: 0,
      eventHour: 1,
      targetY: (Rect body) => body.bottom - 2,
      scrolled: greaterThan,
    ),
    (
      edge: 'top',
      direction: 'up',
      viewHour: 12,
      eventHour: 12,
      targetY: (Rect body) => body.top + 2,
      scrolled: lessThan,
    ),
  ];

  for (final c in cases) {
    testWidgets('holding a drag at the ${c.edge} edge scrolls the body ${c.direction}', (tester) async {
      final eventStart = start.add(Duration(hours: c.eventHour));
      final id = eventsController.addEvent(
        KalenderEvent(start: eventStart, end: eventStart.add(const Duration(hours: 1))),
      );

      await pumpWeek(tester, c.viewHour);
      final offsetBefore = kalenderController.multiDayViewController.scrollController.offset;

      final tile = find.byKey(DayEventTile.tileKey(id));
      final bodyRect = tester.getRect(find.byType(MultiDayBody));
      final gesture = await tester.holdDragAt(tile, Offset(tester.getCenter(tile).dx, c.targetY(bodyRect)));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(kalenderController.multiDayViewController.scrollController.offset, c.scrolled(offsetBefore));
    });
  }
}
