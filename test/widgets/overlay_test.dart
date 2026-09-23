// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';

import '../utilities.dart';

void main() {
  final eventsController = DefaultEventsController();
  final kalenderController = KalenderController(viewConfiguration: MultiDayViewConfiguration.week());
  final preciseInteraction = KalenderInteraction(
    inputMode: InputMode.precise,
    createEventGesture: EventInteractionGesture.tap,
    modifyEventGesture: EventInteractionGesture.tap,
  );
  const headerConfiguration = MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1);

  setUpAll(() {
    final now = FloatingDateTime.fromDateTime(DateTime.now()).startOfWeek();
    final startOfWeek = DateTime(now.year, now.month, now.day);

    eventsController.addEvents([
      KalenderEvent(
        start: startOfWeek,
        end: startOfWeek.copyWith(day: startOfWeek.day + 2),
      ),
      KalenderEvent(
        start: startOfWeek,
        end: startOfWeek.copyWith(day: startOfWeek.day + 2),
      ),
    ]);
  });

  final sizesToTest = [const Size(300, 500), const Size(400, 600), const Size(800, 600), const Size(1200, 600)];

  Future<void> pumpWeek(WidgetTester tester, {Size? size}) async {
    if (size != null) tester.setViewSize(size);

    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        interaction: preciseInteraction,
        views: const [MultiDayViewParts(header: MultiDayHeader(configuration: headerConfiguration))],
      ),
    );
  }

  group('Overlay', () {
    for (final size in sizesToTest) {
      testWidgets('Overlay $size test', (tester) async {
        await pumpWeek(tester, size: size);

        expect(find.byType(MultiDayEventTile), findsOne);
        expect(find.byType(MultiDayOverlayPortal), findsNWidgets(2));
        expect(find.byType(MultiDayPortalOverlayButton), findsNWidgets(2));

        final visibleDates = kalenderController.floatingVisibleRange.value!.dates();
        for (final date in visibleDates.take(2)) {
          await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(date)));
          await tester.pumpAndSettle();

          expect(find.byType(MultiDayOverlay), findsOne);

          final card = tester.getRect(find.byKey(MultiDayOverlay.getOverlayCardKey(date)));
          final view = tester.getRect(find.byType(KalenderView));
          expect(card.left, greaterThanOrEqualTo(view.left));
          expect(card.top, greaterThanOrEqualTo(view.top));
          expect(card.right, lessThanOrEqualTo(view.right));
          expect(card.bottom, lessThanOrEqualTo(view.bottom));

          await tester.tap(find.byKey(MultiDayOverlay.getCloseButtonKey(date)));
          await tester.pumpAndSettle();
        }

        expect(find.byType(MultiDayOverlay), findsNothing);
      });
    }

    testWidgets('Overlay dismisses when one of its events is dragged', (tester) async {
      await pumpWeek(tester);

      final overlay = find.byType(MultiDayOverlay);
      final date = kalenderController.floatingVisibleRange.value!.dates().first;
      await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(date)));
      await tester.pumpAndSettle();
      expect(overlay, findsOne);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(MultiDayEventOverlayTile).first),
        pointer: 1,
        kind: PointerDeviceKind.mouse,
      );
      await gesture.moveBy(const Offset(20, 0));
      await tester.pumpAndSettle();

      expect(overlay, findsNothing);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(overlay, findsNothing);
    });
  });

  // Month view cards can anchor near the bottom edge, which the week header above never does.
  group('Month overlay bounds', () {
    Future<({Rect card, Rect view})> openOverlay(
      WidgetTester tester, {
      required DateTime day,
      required int eventCount,
    }) async {
      await pumpOverflowingMonth(tester, day: day, eventCount: eventCount);
      final card = await tester.openOverflowOverlay(day);
      return (card: tester.getRect(card), view: tester.getRect(find.byType(KalenderView)));
    }

    // January 2025 lays out as 5 rows (Mon 30 Dec - Sun 2 Feb), so the 29th
    // sits in the last row, closest to the bottom edge.
    final lastRowDay = DateTime.utc(2025, 1, 29);
    final firstRowDay = DateTime.utc(2025, 1, 2);

    testWidgets('a day in the last week row stays inside the view', (tester) async {
      final rects = await openOverlay(tester, day: lastRowDay, eventCount: 8);

      expect(rects.card.bottom, lessThanOrEqualTo(rects.view.bottom));
      expect(rects.card.top, greaterThanOrEqualTo(rects.view.top));
    });

    testWidgets('a day in the first week row stays inside the view', (tester) async {
      final rects = await openOverlay(tester, day: firstRowDay, eventCount: 8);

      expect(rects.card.top, greaterThanOrEqualTo(rects.view.top));
      expect(rects.card.bottom, lessThanOrEqualTo(rects.view.bottom));
    });

    testWidgets('a card taller than the view is capped and scrolls', (tester) async {
      final rects = await openOverlay(tester, day: lastRowDay, eventCount: 40);

      expect(rects.card.height, lessThanOrEqualTo(rects.view.height));
      expect(rects.card.top, greaterThanOrEqualTo(rects.view.top));
      expect(rects.card.bottom, lessThanOrEqualTo(rects.view.bottom));

      final scrollable = find.descendant(
        of: find.byKey(MultiDayOverlay.getOverlayCardKey(lastRowDay)),
        matching: find.byType(Scrollable),
      );
      expect(scrollable, findsOne, reason: 'the event list should be scrollable');

      final position = tester.state<ScrollableState>(scrollable).position;
      expect(position.maxScrollExtent, greaterThan(0), reason: 'the events should overflow the capped card');

      await tester.drag(scrollable, const Offset(0, -80));
      await tester.pumpAndSettle();
      expect(position.pixels, greaterThan(0), reason: 'the event list should scroll');
    });

    testWidgets('a card shorter than the view is not scrollable', (tester) async {
      await openOverlay(tester, day: lastRowDay, eventCount: 8);

      final position = tester
          .state<ScrollableState>(
            find.descendant(
              of: find.byKey(MultiDayOverlay.getOverlayCardKey(lastRowDay)),
              matching: find.byType(Scrollable),
            ),
          )
          .position;

      expect(position.maxScrollExtent, 0, reason: 'a card that fits should have nothing to scroll');
    });
  });
}
