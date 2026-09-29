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

/// Which day tiles repaint while an event is dragged.
void main() {
  final monday = DateTime(2025, 3, 24);
  final thursday = DateTime(2025, 3, 27);

  testWidgets('a drag does not repaint the tiles of other days', (tester) async {
    final eventsController = DefaultEventsController();
    final dragged = eventsController.addEvent(
      KalenderEvent(start: monday.copyWith(hour: 6), end: monday.copyWith(hour: 8)),
    );
    final other = eventsController.addEvent(
      KalenderEvent(start: thursday.copyWith(hour: 6), end: thursday.copyWith(hour: 8)),
    );
    final paints = <String, int>{};

    await pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: KalenderController(
        viewConfiguration: MultiDayViewConfiguration.week(
          initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: KalenderDateTimeRange(start: monday, end: DateTime(2025, 3, 31)),
          initialDateTime: monday,
        ),
      ),
      views: [
        MultiDayViewParts(
          body: MultiDayBody(
            interaction: KalenderInteraction(
              inputMode: InputMode.precise,
              modifyEventGesture: EventInteractionGesture.tap,
            ),
            tileComponents: TileComponents(
              tileBuilder: (context, event, tileRange) => CustomPaint(
                painter: _CountingPainter(() => paints.update(event.id, (n) => n + 1, ifAbsent: () => 1)),
              ),
            ),
          ),
        ),
      ],
    );

    final gesture = await tester.startGesture(tester.getCenter(find.byKey(DayEventTile.tileKey(dragged))));
    await tester.pump(const Duration(milliseconds: 100));
    await gesture.moveBy(const Offset(0, 20));
    await tester.pumpAndSettle();
    final before = paints[other];

    for (var i = 0; i < 5; i++) {
      await gesture.moveBy(const Offset(0, 20));
      await tester.pump();
    }

    expect(paints[other], before);
    await gesture.up();
  });
}

class _CountingPainter extends CustomPainter {
  _CountingPainter(this.onPaint);

  final VoidCallback onPaint;

  @override
  void paint(Canvas canvas, Size size) => onPaint();

  @override
  bool shouldRepaint(_CountingPainter oldDelegate) => false;
}
