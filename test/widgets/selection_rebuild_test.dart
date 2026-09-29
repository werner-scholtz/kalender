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
  final monday = DateTime(2025, 3, 24);
  final events = [
    for (final hour in [6, 9, 12])
      KalenderEvent(
        start: monday.copyWith(hour: hour),
        end: monday.copyWith(hour: hour + 2),
      ),
  ];

  /// Pumps a week view of [events] and returns its controller.
  Future<KalenderController> pumpWeek(WidgetTester tester, TileComponents tileComponents) async {
    final eventsController = DefaultEventsController()..addEvents(events);
    final kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.week(
        initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
        initialHeightPerMinute: 1,
        displayRange: KalenderDateTimeRange(start: monday, end: DateTime(2025, 3, 31)),
        initialDateTime: monday,
      ),
    );
    addTearDown(eventsController.dispose);
    addTearDown(kalenderController.dispose);
    await pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      views: [MultiDayViewParts(body: MultiDayBody(tileComponents: tileComponents))],
    );
    return kalenderController;
  }

  testWidgets('a selection change rebuilds only the tiles of the events it involves', (tester) async {
    final builds = <String, int>{};
    final kalenderController = await pumpWeek(
      tester,
      TileComponents(
        tileBuilder: (context, event, tileRange) {
          builds.update(event.id, (n) => n + 1, ifAbsent: () => 1);
          return const SizedBox.expand();
        },
        tileWhenDraggingBuilder: (context, event) {
          builds.update(event.id, (n) => n + 1, ifAbsent: () => 1);
          return const SizedBox.expand();
        },
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

  testWidgets('selecting the selected event internally shows its tile as dragged', (tester) async {
    final kalenderController = await pumpWeek(
      tester,
      TileComponents(
        tileBuilder: (context, event, tileRange) => const SizedBox.expand(),
        tileWhenDraggingBuilder: (context, event) => const Text('dragging'),
      ),
    );
    kalenderController.selectEvent(events.first);
    await tester.pumpAndSettle();

    kalenderController.selectEvent(events.first, internal: true);
    await tester.pumpAndSettle();

    expect(find.text('dragging'), findsOneWidget);
  });
}
