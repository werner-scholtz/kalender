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
    tileBuilder: (context, event, tileRange) => Container(key: ValueKey('inner-${event.id}'), color: Colors.red),
  );

  final precise = KalenderInteraction(
    inputMode: InputMode.precise,
    createEventGesture: EventInteractionGesture.tap,
    modifyEventGesture: EventInteractionGesture.tap,
  );

  MultiDayViewController viewController() => kalenderController.viewController as MultiDayViewController;

  Future<void> pumpFreeScroll(WidgetTester tester, KalenderCallbacks callbacks) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: MultiDayViewConfiguration.freeScroll(
          numberOfDays: 7,
          displayRange: displayRange,
          initialDateTime: start,
          initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
        ),
        callbacks: callbacks,
        header: KalenderHeader(multiDayTileComponents: components, interaction: precise),
        body: KalenderBody(multiDayTileComponents: components, interaction: precise),
      ),
    );
  }

  testWidgets('dragging across the header creates a multi-day event', (tester) async {
    KalenderEvent? created;
    KalenderEvent? confirmed;

    await pumpFreeScroll(
      tester,
      KalenderCallbacks(
        onEventCreate: (event) {
          created = event;
          return event;
        },
        onEventCreated: (event) => confirmed = event,
      ),
    );

    expect(created, isNull);
    expect(confirmed, isNull);

    final headerRect = tester.getRect(find.byType(KalenderHeader));
    final startPoint = Offset(headerRect.left + headerRect.width * 0.25, headerRect.bottom - 4);
    await tester.dragFrom(startPoint, Offset(headerRect.width * 0.4, 0));
    await tester.pumpAndSettle();

    expect(created, isNotNull);
    expect(confirmed, isNotNull);
    expect(created!.spansMultipleDays(location: null, defaultRule: kDefaultMultiDayRule), isTrue);
  });

  testWidgets('dragging an existing multi-day tile reschedules it', (tester) async {
    KalenderEvent? changedBefore;
    KalenderEvent? changedAfter;

    final id = eventsController.addEvent(
      KalenderEvent(start: start.add(const Duration(days: 1)), end: start.add(const Duration(days: 4))),
    );

    await pumpFreeScroll(
      tester,
      KalenderCallbacks(
        onEventChange: (event) => changedBefore = event,
        onEventChanged: (_, updated) => changedAfter = updated,
      ),
    );

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    expect(changedBefore, isNull);
    expect(changedAfter, isNull);

    final dayWidth = tester.getSize(find.byType(KalenderView)).width / 7;
    await tester.drag(tile, Offset(dayWidth, 0));
    await tester.pumpAndSettle();

    expect(changedBefore, isNotNull);
    expect(changedAfter, isNotNull);
  });

  testWidgets('dragging an event to the viewport edge scrolls to adjacent days', (tester) async {
    final id = eventsController.addEvent(
      KalenderEvent(start: start.add(const Duration(days: 1)), end: start.add(const Duration(days: 3))),
    );

    await pumpFreeScroll(tester, KalenderCallbacks(onEventChange: (event) => event, onEventChanged: (_, __) {}));

    final controller = viewController().pageController;
    final pageBefore = controller.page ?? 0;

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    final headerRect = tester.getRect(find.byType(KalenderHeader));
    final tileCenter = tester.getCenter(tile);

    final gesture = await tester.startGesture(tileCenter);
    await tester.pump();
    await gesture.moveTo(Offset(headerRect.right - 2, tileCenter.dy));
    await tester.pump(); // the edge trigger's drag target starts its timer
    // The trigger fires after its 750ms delay, then the page animates (300ms).
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 350));
    await gesture.up();
    await tester.pumpAndSettle();

    final pageAfter = viewController().pageController.page ?? 0;
    expect(pageAfter, greaterThan(pageBefore), reason: 'holding a drag at the edge should scroll toward it');
  });
}
