// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/gestures.dart' show kLongPressTimeout;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

/// #259: a drag starting on an event that can't be rescheduled, resized or tapped creates an event.
void main() {
  final start = DateTime(2025, 3, 24);
  final range = KalenderDateTimeRange(start: start, end: DateTime(2025, 4, 30));

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;
  late List<KalenderEvent> created;
  late List<KalenderEvent> tapped;
  late List<DateTime> emptySpaceTaps;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
    created = [];
    tapped = [];
    emptySpaceTaps = [];
  });

  KalenderInteraction interaction(EventInteractionGesture gesture) =>
      KalenderInteraction(inputMode: InputMode.precise, createEventGesture: gesture, modifyEventGesture: gesture);

  Future<void> pump(
    WidgetTester tester,
    ViewConfiguration configuration, {
    EventInteractionGesture gesture = EventInteractionGesture.tap,
    bool tapCallback = false,
    TileBuilder? tileBuilder,
  }) {
    final components = TileComponents(
      tileBuilder: tileBuilder ?? (context, event, tileRange) => Container(color: Colors.red),
    );
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: configuration,
        callbacks: KalenderCallbacks(
          onEventCreated: created.add,
          onEventChanged: (event, updatedEvent) =>
              eventsController.updateEvent(event: event, updatedEvent: updatedEvent),
          onEventTapped: tapCallback ? tapped.add : null,
          onTapped: emptySpaceTaps.add,
        ),
        header: KalenderHeader(interaction: interaction(gesture), multiDayTileComponents: components),
        body: KalenderBody(
          interaction: interaction(gesture),
          multiDayTileComponents: components,
          monthTileComponents: components,
        ),
      ),
    );
  }

  final week = MultiDayViewConfiguration.week(
    displayRange: range,
    initialDateTime: start,
    initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
    initialHeightPerMinute: 1,
  );
  final month = MonthViewConfiguration.singleMonth(displayRange: range, initialDateTime: start);

  String addEvent({EventInteraction? interaction}) => eventsController.addEvent(
    KalenderEvent(
      start: start.copyWith(day: 26, hour: 8),
      end: start.copyWith(day: 26, hour: 10),
      interaction: interaction ?? EventInteraction.allowNone(),
    ),
  );

  group('A locked event', () {
    testWidgets('creates an event when dragged in the multi-day body', (tester) async {
      final id = addEvent();
      await pump(tester, week);

      await tester.drag(find.byKey(DayEventTile.tileKey(id)), const Offset(0, 100));
      await tester.pumpAndSettle();

      expect(created, hasLength(1));
    });

    testWidgets('creates an event when long pressed and dragged', (tester) async {
      final id = addEvent();
      await pump(tester, week, gesture: EventInteractionGesture.longPress);

      final gesture = await tester.startGesture(tester.getCenter(find.byKey(DayEventTile.tileKey(id))));
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
      await gesture.moveBy(const Offset(0, 50));
      await tester.pump();
      await gesture.moveBy(const Offset(0, 50));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(created, hasLength(1));
    });

    testWidgets('creates an event when dragged over a movable event', (tester) async {
      final movable = eventsController.addEvent(
        KalenderEvent(
          start: start.copyWith(day: 26, hour: 7),
          end: start.copyWith(day: 26, hour: 11),
          interaction: EventInteraction.allowAll(),
        ),
      );
      final id = addEvent();
      await pump(tester, week);

      // The locked tile starts later, so the overlap layout draws it over the movable one.
      final movableTile = find.byKey(DayEventTile.tileKey(movable));
      final before = tester.getCenter(movableTile);
      await tester.drag(find.byKey(DayEventTile.tileKey(id)), const Offset(0, 100));
      await tester.pumpAndSettle();

      expect(created, hasLength(1));
      expect(tester.getCenter(movableTile), before);
    });

    testWidgets('creates an event when dragged in the week header', (tester) async {
      final id = eventsController.addEvent(
        KalenderEvent(
          start: start.copyWith(day: 26),
          end: start.copyWith(day: 28),
          interaction: EventInteraction.allowNone(),
        ),
      );
      await pump(tester, week);

      final tile = find.byKey(MultiDayEventTile.tileKey(id));
      await tester.drag(tile, Offset(tester.getSize(tile).width, 0));
      await tester.pumpAndSettle();

      expect(created, hasLength(1));
    });

    testWidgets('creates an event when every resize handle is hidden', (tester) async {
      final id = eventsController.addEvent(
        KalenderEvent(
          start: start.copyWith(day: 20),
          end: start.copyWith(day: 40),
          interaction: EventInteraction(allowRescheduling: false),
        ),
      );
      await pump(tester, week);

      final tile = find.byKey(MultiDayEventTile.tileKey(id));
      await tester.drag(tile, Offset(tester.getSize(tile).width / 7, 0));
      await tester.pumpAndSettle();

      expect(created, hasLength(1));
    });

    testWidgets('creates an event when dragged in the month view', (tester) async {
      final id = addEvent();
      await pump(tester, month);

      final tile = find.byKey(MultiDayEventTile.tileKey(id));
      await tester.drag(tile, Offset(tester.getSize(tile).width * 2, 0));
      await tester.pumpAndSettle();

      expect(created, hasLength(1));
    });

    testWidgets('passes a tap to onTapped', (tester) async {
      final id = addEvent();
      await pump(tester, week);

      await tester.tap(find.byKey(DayEventTile.tileKey(id)));
      await tester.pumpAndSettle();

      expect(emptySpaceTaps.map((date) => (date.day, date.hour)), [(26, 9)]);
    });

    testWidgets('keeps the taps of its own tile content', (tester) async {
      var tileTaps = 0;
      final id = addEvent();
      await pump(
        tester,
        week,
        tileBuilder: (context, event, tileRange) => GestureDetector(
          onTap: () => tileTaps++,
          child: Container(color: Colors.red),
        ),
      );

      await tester.tap(find.byKey(DayEventTile.tileKey(id)));
      await tester.pumpAndSettle();

      expect(tileTaps, 1);
      expect(emptySpaceTaps, isEmpty);
    });
  });

  group('An event that does something', () {
    testWidgets('does not create an event when it can be tapped', (tester) async {
      final id = addEvent();
      await pump(tester, week, tapCallback: true);

      final tile = find.byKey(DayEventTile.tileKey(id));
      await tester.drag(tile, const Offset(0, 100));
      await tester.pumpAndSettle();
      expect(created, isEmpty);

      await tester.tap(tile);
      await tester.pumpAndSettle();
      expect(tapped.map((event) => event.id), [id]);
      expect(emptySpaceTaps, isEmpty);
    });

    testWidgets('is rescheduled rather than creating an event', (tester) async {
      final id = addEvent(interaction: EventInteraction.allowAll());
      await pump(tester, week);

      final tile = find.byKey(DayEventTile.tileKey(id));
      final before = tester.getCenter(tile);
      await tester.drag(tile, const Offset(0, 100));
      await tester.pumpAndSettle();

      expect(created, isEmpty);
      expect(tester.getCenter(tile), isNot(before));
    });

    testWidgets('does not create an event when it can be resized', (tester) async {
      final id = addEvent(interaction: EventInteraction(allowRescheduling: false));
      await pump(tester, week);

      await tester.drag(find.byKey(DayEventTile.tileKey(id)), const Offset(0, 100));
      await tester.pumpAndSettle();

      expect(created, isEmpty);
    });
  });
}
