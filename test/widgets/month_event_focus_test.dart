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
  testWidgets('#233 selected event focus lands on the event row', (tester) async {
    final eventsController = DefaultEventsController();
    final kalenderController = KalenderController(
      viewConfiguration: MonthViewConfiguration.singleMonth(
        displayRange: KalenderDateTimeRange(start: DateTime(2024, 12), end: DateTime(2025, 3)),
        initialDateTime: DateTime(2025, 1),
      ),
    );

    // Two events covering the same days (Tue–Thu of the first full week) so they
    // stack: one on row 0, one on row 1.
    final range = KalenderDateTimeRange(start: DateTime(2025, 1, 7), end: DateTime(2025, 1, 10));
    final eventA = KalenderEvent(start: range.start, end: range.end);
    final eventB = KalenderEvent(start: range.start, end: range.end);
    eventsController.addEvent(eventA);
    eventsController.addEvent(eventB);

    final tiles = TileComponents(
      tileBuilder: (context, event, tileRange) => SizedBox.expand(key: ValueKey('tile-${event.id}')),
      dropTargetTile: (context, event) => SizedBox.expand(key: ValueKey('drop-${event.id}')),
    );

    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        views: [
          MonthViewParts(
            header: const SizedBox.shrink(),
            body: MonthBody(tileComponents: tiles),
          ),
        ],
      ),
    );

    final topA = tester.getRect(find.byKey(ValueKey('tile-${eventA.id}'))).top;
    final topB = tester.getRect(find.byKey(ValueKey('tile-${eventB.id}'))).top;
    expect(topA, isNot(moreOrLessEquals(topB, epsilon: 1.0)), reason: 'The two events should stack on separate rows');

    Future<double> dropTopFor(KalenderEvent event) async {
      kalenderController.selectEvent(event);
      await tester.pumpAndSettle();
      return tester.getRect(find.byKey(ValueKey('drop-${event.id}'))).top;
    }

    expect(await dropTopFor(eventA), moreOrLessEquals(topA, epsilon: 1.0), reason: 'Focus must align with event A row');
    expect(await dropTopFor(eventB), moreOrLessEquals(topB, epsilon: 1.0), reason: 'Focus must align with event B row');
  });
}
