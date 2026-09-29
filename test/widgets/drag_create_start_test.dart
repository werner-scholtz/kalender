// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// An event created by a drag starts where the pointer went down.
void main() {
  for (final kind in [PointerDeviceKind.mouse, PointerDeviceKind.touch]) {
    for (final gesture in EventInteractionGesture.values) {
      testWidgets('${kind.name}, ${gesture.name}', (tester) async {
        final eventsController = DefaultEventsController();
        final kalenderController = KalenderController(
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: year2025DisplayRange,
            initialDateTime: DateTime(2025, 3, 24),
            initialHeightPerMinute: 1,
          ),
        );
        addTearDown(eventsController.dispose);
        addTearDown(kalenderController.dispose);
        KalenderEvent? created;
        await pumpKalender(
          tester,
          eventsController: eventsController,
          kalenderController: kalenderController,
          interaction: KalenderInteraction(inputMode: InputMode.precise, createEventGesture: gesture),
          callbacks: KalenderCallbacks(onEventCreated: (event) => created = event),
        );

        final body = tester.getRect(find.byType(MultiDayBody));
        final drag = await tester.startGesture(body.topCenter + const Offset(0, 120), kind: kind);
        await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
        for (var i = 0; i < 12; i++) {
          await drag.moveBy(const Offset(0, 10));
          await tester.pump(const Duration(milliseconds: 20));
        }
        await drag.up();
        await tester.pumpAndSettle();

        final start = created?.start.toLocal();
        expect([start?.hour, start?.minute], [2, 0]);
      });
    }
  }
}
