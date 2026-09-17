// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tile.dart';

import '../utilities.dart';

void main() {
  final event = KalenderEvent(start: DateTime.utc(2025, 1, 1, 9), end: DateTime.utc(2025, 1, 1, 10));
  final range = FloatingDateTimeRange(start: FloatingDateTime(2025), end: FloatingDateTime(2025, 1, 2));
  final tileComponents = TileComponents(tileBuilder: (context, event, range) => const SizedBox());

  Widget build(KalenderController controller, EventsController eventsController) {
    return TestProvider(
      kalenderController: controller,
      eventsController: eventsController,
      tileComponents: tileComponents,
      child: Tile(
        initialEvent: event,
        tileBuilder: tileComponents.tileBuilder,
        tileWhenDraggingBuilder: null,
        floatingRange: range,
      ),
    );
  }

  testWidgets('a dependency change adds no second listener', (tester) async {
    final controller = KalenderController();
    final eventsController = DefaultEventsController();
    addTearDown(controller.dispose);
    addTearDown(eventsController.dispose);

    await pumpAndSettleWithMaterialApp(tester, build(controller, eventsController));
    // TestProvider builds a new location notifier, so the tile's dependencies change.
    await pumpAndSettleWithMaterialApp(tester, build(controller, eventsController));
    await pumpAndSettleWithMaterialApp(tester, const SizedBox());

    expect(controller.selectedEvent.hasListeners, isFalse);
    expect(eventsController.hasListeners, isFalse);
  });

  testWidgets('swapping the controllers moves the listeners', (tester) async {
    final first = KalenderController();
    final firstEvents = DefaultEventsController();
    final second = KalenderController();
    final secondEvents = DefaultEventsController();
    for (final controller in [first, second]) {
      addTearDown(controller.dispose);
    }
    for (final controller in [firstEvents, secondEvents]) {
      addTearDown(controller.dispose);
    }

    await pumpAndSettleWithMaterialApp(tester, build(first, firstEvents));
    await pumpAndSettleWithMaterialApp(tester, build(second, secondEvents));

    expect(first.selectedEvent.hasListeners, isFalse);
    expect(firstEvents.hasListeners, isFalse);
    expect(second.selectedEvent.hasListeners, isTrue);
    expect(secondEvents.hasListeners, isTrue);
  });
}
