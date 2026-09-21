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

  Future<void> pump(WidgetTester tester, TextDirection direction) {
    return pumpAndSettleWithMaterialApp(
      tester,
      Directionality(
        textDirection: direction,
        child: freeScrollView(
          eventsController: eventsController,
          kalenderController: kalenderController,
          displayRange: displayRange,
          initialDateTime: start,
        ),
      ),
    );
  }

  testWidgets('RTL: a multi-day event renders as one spanning tile', (tester) async {
    final id = eventsController.addEvent(KalenderEvent(start: start, end: start.add(const Duration(days: 4))));

    await pump(tester, TextDirection.rtl);

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    final calWidth = tester.getSize(find.byType(KalenderView)).width;
    expect(tester.getSize(tile).width, greaterThan(calWidth * 0.22));
  });

  testWidgets('RTL mirrors the tile position relative to LTR', (tester) async {
    final event = KalenderEvent(start: start, end: start.add(const Duration(days: 2)));
    final id = eventsController.addEvent(event);

    await pump(tester, TextDirection.ltr);
    final calRect = tester.getRect(find.byType(KalenderView));
    final ltrCenter = tester.getCenter(find.byKey(MultiDayEventTile.tileKey(id)));

    eventsController = DefaultEventsController()..addEvent(event);
    kalenderController = KalenderController();
    await pump(tester, TextDirection.rtl);
    final rtlCenter = tester.getCenter(find.byKey(MultiDayEventTile.tileKey(id)));

    final mirroredLtr = calRect.left + (calRect.right - ltrCenter.dx);
    expect(rtlCenter.dx, closeTo(mirroredLtr, 2.0), reason: 'the tile should be mirrored in RTL');
  });

  testWidgets('RTL: scrolling forward moves the tile toward the start side (right)', (tester) async {
    final id = eventsController.addEvent(
      KalenderEvent(start: start.add(const Duration(days: 1)), end: start.add(const Duration(days: 4))),
    );

    await pump(tester, TextDirection.rtl);

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    final leftBefore = tester.getTopLeft(tile).dx;

    final controller = kalenderController.multiDayViewController.pageController;
    controller.jumpToPage((controller.page ?? 0).round() + 1);
    await tester.pumpAndSettle();

    final leftAfter = tester.getTopLeft(tile).dx;
    expect(leftAfter, greaterThan(leftBefore), reason: 'in RTL the tile should move right as the view scrolls forward');
  });
}
