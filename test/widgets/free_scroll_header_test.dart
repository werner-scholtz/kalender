// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// Free-scroll header height: stable on rebuild (#282), fits the tallest visible day (#283).
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;
  late KalenderCallbacks callbacks;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
    callbacks = KalenderCallbacks(
      onEventCreated: eventsController.addEvent,
      onEventChanged: (event, updatedEvent) => eventsController.updateEvent(event: event, updatedEvent: updatedEvent),
    );
  });

  final base = DateTime(2025, 3, 24); // Monday

  // Two overlapping multi-day events: 26 Mar is a two-row day, its neighbours
  // are single-row.
  void addTwoRowDay() {
    eventsController.addEvents([
      KalenderEvent(start: base.add(const Duration(days: 1)), end: base.add(const Duration(days: 3))),
      KalenderEvent(start: base.add(const Duration(days: 2)), end: base.add(const Duration(days: 4))),
    ]);
  }

  Widget buildView({DateTime? initialDate}) => freeScrollView(
    eventsController: eventsController,
    kalenderController: kalenderController,
    displayRange: KalenderDateTimeRange(start: base, end: base.add(const Duration(days: 21))),
    initialDateTime: initialDate,
    numberOfDays: 3,
    callbacks: callbacks,
  );

  group('FreeScroll header', () {
    // #282
    testWidgets('does not change height when it rebuilds', (tester) async {
      addTwoRowDay();
      final rebuild = ValueNotifier(0);
      addTearDown(rebuild.dispose);

      await pumpAndSettleWithMaterialApp(
        tester,
        ValueListenableBuilder(
          valueListenable: rebuild,
          builder: (context, _, __) => buildView(initialDate: base.add(const Duration(days: 2))),
        ),
      );

      final heightBefore = tester.getSize(find.byType(KalenderHeader)).height;

      rebuild.value++;
      await tester.pumpAndSettle();

      final heightAfter = tester.getSize(find.byType(KalenderHeader)).height;
      expect(heightAfter, closeTo(heightBefore, 0.5), reason: 'the header must not wobble on rebuild');
    });

    Future<double> pumpAndMeasureHeader(WidgetTester tester, DateTime initialDate) async {
      await tester.pumpWidget(const SizedBox());
      eventsController = DefaultEventsController();
      kalenderController = KalenderController();
      addTwoRowDay();
      await pumpAndSettleWithMaterialApp(tester, buildView(initialDate: initialDate));
      return tester.getSize(find.byType(KalenderHeader)).height;
    }

    // #283
    testWidgets('fits the tallest visible day, not just the leading day', (tester) async {
      final heightAsLeading = await pumpAndMeasureHeader(tester, base.add(const Duration(days: 2)));
      final heightAsTrailing = await pumpAndMeasureHeader(tester, base.add(const Duration(days: 1)));
      final heightEmpty = await pumpAndMeasureHeader(tester, base.add(const Duration(days: 12)));

      expect(
        heightAsTrailing,
        greaterThan(heightEmpty),
        reason: 'the header should grow to fit the two-row day while it is in view',
      );
      expect(
        heightAsTrailing,
        closeTo(heightAsLeading, 0.5),
        reason: 'header height must not depend on whether the tallest visible day is the leading day',
      );
    });
  });
}
