// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';

import '../../utilities.dart';

/// The paginated schedule page on screen keeps its own rows, scrolling and visible range while a neighbouring page is
/// built and removed (#591).
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    // January has more rows than the list builds ahead of the viewport. February has one event, on the 3rd.
    eventsController = DefaultEventsController()
      ..addEvents([
        for (var day = 1; day <= 31; day++)
          for (var hour = 8; hour < 13; hour++)
            KalenderEvent(start: DateTime(2025, 1, day, hour), end: DateTime(2025, 1, day, hour + 1)),
        KalenderEvent(start: DateTime(2025, 2, 3, 9), end: DateTime(2025, 2, 3, 10)),
      ]);
  });

  Future<void> pumpSchedule(WidgetTester tester) {
    kalenderController = KalenderController(
      viewConfiguration: ScheduleViewConfiguration.paginated(
        displayRange: KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 3)),
        initialDateTime: DateTime(2025),
      ),
    );
    return pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      views: [
        ScheduleViewParts(
          body: ScheduleBody(configuration: ScheduleBodyConfiguration(emptyDay: EmptyDayBehavior.hide)),
        ),
      ],
    );
  }

  // Drags January less than half a page towards February, so the page view settles back on January.
  Future<void> cancelledSwipe(WidgetTester tester) async {
    await tester.drag(find.byType(PageView), const Offset(-100, 0));
    await tester.pumpAndSettle();
  }

  KalenderDateTimeRange? visibleRange() => kalenderController.visibleDateTimeRange.value;

  testWidgets('a cancelled swipe keeps the visible range of the page on screen', (tester) async {
    await pumpSchedule(tester);
    final before = visibleRange();

    await cancelledSwipe(tester);
    expect(visibleRange(), before);
  });

  testWidgets('a completed swipe publishes the visible range of the new page', (tester) async {
    await pumpSchedule(tester);

    await tester.drag(find.byType(PageView), const Offset(-600, 0));
    await tester.pumpAndSettle();
    // February's rows are its month header on the 1st and the event on the 3rd.
    expect(visibleRange(), KalenderDateTimeRange(start: DateTime(2025, 2), end: DateTime(2025, 2, 4)));
  });

  testWidgets('scrolling after a cancelled swipe builds the rows of the page on screen', (tester) async {
    await pumpSchedule(tester);
    await cancelledSwipe(tester);

    await tester.drag(find.byType(PageView), const Offset(0, -20000));
    await tester.pumpAndSettle();
    expect(find.text('31'), findsOneWidget);
  });

  testWidgets('animateToDate after a cancelled swipe scrolls the page on screen', (tester) async {
    await pumpSchedule(tester);
    await cancelledSwipe(tester);

    final animation = kalenderController.animateToDate(DateTime(2025, 1, 20));
    await tester.pumpAndSettle();
    await animation;
    expect(visibleRange(), KalenderDateTimeRange(start: DateTime(2025, 1, 20), end: DateTime(2025, 1, 23)));
  });

  testWidgets('an event added during a swipe shows on its own page', (tester) async {
    await pumpSchedule(tester);

    final gesture = await tester.startGesture(tester.getCenter(find.byType(PageView)));
    // The first move starts the drag without moving the page.
    await gesture.moveBy(const Offset(-50, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-50, 0));
    await tester.pump();

    final id = eventsController.addEvent(KalenderEvent(start: DateTime(2025, 1, 1, 7), end: DateTime(2025, 1, 1, 8)));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.byKey(ScheduleEventTile.tileKey(id)), findsOneWidget);
  });
}
