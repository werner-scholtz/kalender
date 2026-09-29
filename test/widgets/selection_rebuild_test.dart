// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Which tiles rebuild when the selected event changes.
void main() {
  testWidgets('a selection change rebuilds only the tiles of the events it involves', (tester) async {
    final monday = DateTime(2025, 3, 24);
    final eventsController = DefaultEventsController();
    final kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.week(
        initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
        initialHeightPerMinute: 1,
        displayRange: KalenderDateTimeRange(start: monday, end: DateTime(2025, 3, 31)),
        initialDateTime: monday,
      ),
    );
    final events = [
      for (final hour in [6, 9, 12])
        KalenderEvent(
          start: monday.copyWith(hour: hour),
          end: monday.copyWith(hour: hour + 2),
        ),
    ];
    eventsController.addEvents(events);
    final builds = <String, int>{};

    await pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      body: KalenderBody(
        multiDayTileComponents: TileComponents(
          tileBuilder: (context, event, tileRange) {
            builds.update(event.id, (n) => n + 1, ifAbsent: () => 1);
            return const SizedBox.expand();
          },
          tileWhenDraggingBuilder: (context, event) {
            builds.update(event.id, (n) => n + 1, ifAbsent: () => 1);
            return const SizedBox.expand();
          },
        ),
      ),
    );

    Future<Map<String, int>> rebuildsAfter(VoidCallback change) async {
      final before = Map.of(builds);
      change();
      await tester.pumpAndSettle();
      return {
        for (final event in events)
          if (builds[event.id] != before[event.id]) event.id: builds[event.id]! - before[event.id]!,
      };
    }

    final [first, second, third] = events;
    expect(await rebuildsAfter(() => kalenderController.selectEvent(first, internal: true)), {first.id: 1});
    expect(await rebuildsAfter(() => kalenderController.selectEvent(second, internal: true)), {
      first.id: 1,
      second.id: 1,
    });
    expect(await rebuildsAfter(kalenderController.deselectEvent), {second.id: 1});
    expect(builds.keys, contains(third.id));
  });
}
