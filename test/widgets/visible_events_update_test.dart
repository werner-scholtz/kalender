// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';

import '../utilities.dart';

/// [KalenderController.visibleEvents] follows the events controller and the body configuration.
void main() {
  final day = DateTime(2025, 6, 18);
  KalenderEvent oneHour() => KalenderEvent(start: day.copyWith(hour: 10), end: day.copyWith(hour: 11));
  KalenderEvent threeDays() => KalenderEvent(start: day.copyWith(hour: 10), end: DateTime(2025, 6, 21, 10));
  final week = MultiDayViewConfiguration.week(displayRange: year2025DisplayRange, initialDateTime: day);
  final month = MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange, initialDateTime: day);

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() => eventsController = DefaultEventsController());
  tearDown(() {
    kalenderController.dispose();
    eventsController.dispose();
  });

  Future<void> pump(WidgetTester tester, ViewConfiguration configuration, {List<ViewParts>? views}) {
    kalenderController = KalenderController(viewConfiguration: configuration);
    return pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      views: views,
    );
  }

  for (final configuration in [week, month]) {
    for (final (name, create) in [('one hour', oneHour), ('three day', threeDays)]) {
      testWidgets('${configuration.name}: a removed $name event leaves', (tester) async {
        final event = create();
        await pump(tester, configuration);
        eventsController.addEvent(event);
        await tester.pumpAndSettle();
        final added = kalenderController.visibleEvents.value;

        eventsController.removeEvent(event);
        await tester.pumpAndSettle();

        expect(
          [added, kalenderController.visibleEvents.value],
          [
            {event},
            <KalenderEvent>{},
          ],
        );
      });
    }

    testWidgets('${configuration.name}: an event moved off the page leaves', (tester) async {
      final event = oneHour();
      await pump(tester, configuration);
      eventsController.addEvent(event);
      await tester.pumpAndSettle();

      final moved = event.withDateTimeRange(
        KalenderDateTimeRange(start: DateTime(2025, 9, 1, 10), end: DateTime(2025, 9, 1, 11)),
      );
      eventsController.updateEvent(event: event, updatedEvent: moved);
      await tester.pumpAndSettle();

      expect(kalenderController.visibleEvents.value, isEmpty);
    });
  }

  testWidgets('week: a header event stays when a body event is added', (tester) async {
    final events = [threeDays(), oneHour()];
    await pump(tester, week);
    eventsController.addEvent(events.first);
    await tester.pumpAndSettle();

    eventsController.addEvent(events.last);
    await tester.pumpAndSettle();

    expect(kalenderController.visibleEvents.value, events.toSet());
  });

  testWidgets('week: a change of showMultiDayEvents updates the visible events', (tester) async {
    List<ViewParts> views({required bool showMultiDayEvents}) => [
      MultiDayViewParts(
        header: const SizedBox.shrink(),
        body: MultiDayBody(configuration: MultiDayBodyConfiguration(showMultiDayEvents: showMultiDayEvents)),
      ),
    ];
    final timed = oneHour();
    final long = threeDays();
    eventsController.addEvents([timed, long]);
    await pump(tester, week, views: views(showMultiDayEvents: false));
    final hidden = kalenderController.visibleEvents.value;

    await pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      views: views(showMultiDayEvents: true),
    );

    expect(
      [hidden, kalenderController.visibleEvents.value],
      [
        {timed},
        {timed, long},
      ],
    );
  });

  for (final configuration in [week, month]) {
    testWidgets('${configuration.name}: a new events controller replaces the events', (tester) async {
      final first = oneHour();
      eventsController.addEvent(first);
      await pump(tester, configuration);
      final second = DefaultEventsController();
      addTearDown(second.dispose);
      final other = KalenderEvent(start: day.copyWith(hour: 13), end: day.copyWith(hour: 14));

      await pumpKalender(tester, eventsController: second, kalenderController: kalenderController);
      second.addEvent(other);
      await tester.pumpAndSettle();

      expect(kalenderController.visibleEvents.value, {other});
      expect(
        find.byWidgetPredicate(
          (widget) => widget.key == DayEventTile.tileKey(first.id) || widget.key == MultiDayEventTile.tileKey(first.id),
        ),
        findsNothing,
      );

      await pumpAndSettleWithMaterialApp(tester, const SizedBox());
      expect(eventsController.hasListeners, isFalse);
    });
  }
}
