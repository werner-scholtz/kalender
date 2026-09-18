// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';

import '../utilities.dart';

/// [ResizeDetector] is findable without a key.
///
/// It is exported and carries [ResizeDetector.event] and [ResizeDetector.direction],
/// so a predicate picks out one handle where the type alone matches several.
/// Making either field private, or dropping the export, breaks these tests.
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;
  late String eventId;
  late String otherId;

  final interaction = KalenderInteraction(allowResizing: true, allowRescheduling: true, inputMode: InputMode.precise);

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
    eventId = eventsController.addEvent(KalenderEvent(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 4)));
    otherId = eventsController.addEvent(KalenderEvent(start: DateTime(2025, 1, 1, 10), end: DateTime(2025, 1, 1, 14)));
  });

  tearDown(() {
    eventsController.dispose();
    kalenderController.dispose();
  });

  Future<void> pumpAndHover(WidgetTester tester) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: MultiDayViewConfiguration.singleDay(
          displayRange: year2025DisplayRange,
          initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
          initialHeightPerMinute: 1,
          initialDateTime: DateTime(2025, 1, 1),
        ),
        body: KalenderBody(
          interaction: interaction,
          multiDayTileComponents: TileComponents(
            tileBuilder: (context, event, tileRange) => const SizedBox.expand(),
            verticalResizeHandle: const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.hoverOn(find.byKey(DayEventTile.tileKey(eventId)), await tester.createMouseGesture());
  }

  testWidgets('the type alone matches more than one handle', (tester) async {
    await pumpAndHover(tester);

    expect(find.byType(ResizeDetector), findsNWidgets(2));
  });

  testWidgets('the event and the direction narrow it to one', (tester) async {
    await pumpAndHover(tester);

    expect(resizeHandleFor(eventId, ResizeDirection.top), findsOneWidget);
    expect(resizeHandleFor(eventId, ResizeDirection.bottom), findsOneWidget);

    // The tile that is not hovered contributes no handles.
    expect(resizeHandleFor(otherId, ResizeDirection.top), findsNothing);
    expect(resizeHandleFor(otherId, ResizeDirection.bottom), findsNothing);
  });

  testWidgets('scoping to a tile finds only that tile\'s handles', (tester) async {
    await pumpAndHover(tester);

    // The recipe for a tree where the same event could be built more than once,
    // which a page kept alive or an overlay can do.
    final tile = find.byKey(DayEventTile.tileKey(eventId));
    final other = find.byKey(DayEventTile.tileKey(otherId));

    expect(find.descendant(of: tile, matching: find.byType(ResizeDetector)), findsNWidgets(2));
    expect(find.descendant(of: other, matching: find.byType(ResizeDetector)), findsNothing);
  });
}
