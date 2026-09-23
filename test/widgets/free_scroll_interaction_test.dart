// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

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
    kalenderController = freeScrollController(displayRange: displayRange, initialDateTime: start);
  });

  Future<void> pumpFreeScroll(WidgetTester tester, KalenderCallbacks callbacks) {
    return pumpAndSettleWithMaterialApp(
      tester,
      freeScrollView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        callbacks: callbacks,
        interaction: kPreciseInteraction,
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

    final controller = kalenderController.multiDayViewController.pageController;
    final pageBefore = controller.page ?? 0;

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    final headerRect = tester.getRect(find.byType(KalenderHeader));

    final gesture = await tester.holdDragAt(tile, Offset(headerRect.right - 2, tester.getCenter(tile).dy));
    await gesture.up();
    await tester.pumpAndSettle();

    final pageAfter = kalenderController.multiDayViewController.pageController.page ?? 0;
    expect(pageAfter, greaterThan(pageBefore), reason: 'holding a drag at the edge should scroll toward it');
  });
}
