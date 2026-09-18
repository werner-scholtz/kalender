// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart';

import '../utilities.dart';

class _DayTileHarness extends StatelessWidget with DayEventTileUtils {
  _DayTileHarness({required this.event, required this.tileRange});

  @override
  final KalenderEvent event;

  @override
  final KalenderDateTimeRange tileRange;

  @override
  Widget build(BuildContext context) => const SizedBox(width: 100, height: 600);
}

class _MultiDayTileHarness extends StatelessWidget with MultiDayEventTileUtils {
  _MultiDayTileHarness({required this.event, required this.tileRange});

  @override
  final KalenderEvent event;

  @override
  final KalenderDateTimeRange tileRange;

  @override
  Widget build(BuildContext context) => const SizedBox(width: 300, height: 50);
}

void main() {
  initializeTimeZones();

  // A UTC location keeps wall-clock arithmetic equal to the UTC inputs so these
  // tests are deterministic regardless of the `TZ` the suite runs under.
  final utcLocation = getLocation('Etc/UTC');

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController(locations: [utcLocation]);
    kalenderController = KalenderController();
  });

  tearDown(() {
    eventsController.dispose();
    kalenderController.dispose();
  });

  Future<BuildContext> pumpHarness(WidgetTester tester, Widget harness) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      wrapWithMaterialApp(
        TestProvider(
          kalenderController: kalenderController,
          eventsController: eventsController,
          tileComponents: TileComponents(tileBuilder: (context, event, range) => const SizedBox()),
          location: utcLocation,
          heightPerMinute: ValueNotifier(1.0),
          child: KeyedSubtree(key: key, child: harness),
        ),
      ),
    );
    await tester.pump();
    return key.currentContext!;
  }

  group('DayEventTileUtils', () {
    final event = KalenderEvent(start: DateTime.utc(2024, 1, 15, 9), end: DateTime.utc(2024, 1, 15, 10));
    final tileRange = KalenderDateTimeRange(start: DateTime.utc(2024, 1, 15), end: DateTime.utc(2024, 1, 16));

    testWidgets('floatingTileRange converts the tile range using the location', (tester) async {
      final harness = _DayTileHarness(event: event, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      final range = harness.floatingTileRange(context);
      expect(range.start, equals(FloatingDateTime(2024, 1, 15)));
      expect(range.end, equals(FloatingDateTime(2024, 1, 16)));
    });

    testWidgets('eventRangeOnDate clips the event to the tile date', (tester) async {
      final harness = _DayTileHarness(event: event, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      final range = harness.eventRangeOnDate(context);
      expect(range.start.hour, equals(9));
      expect(range.end.hour, equals(10));
    });

    testWidgets('dateTimeFromPosition maps a vertical offset to a time', (tester) async {
      final harness = _DayTileHarness(event: event, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      // heightPerMinute is 1.0, so dy of 30 == 30 minutes past the event start (09:00).
      final time = harness.dateTimeFromPosition(context, const Offset(0, 30));
      expect(time.hour, equals(9));
      expect(time.minute, equals(30));
    });

    testWidgets('nearbyEvents returns overlapping events within the window and excludes self', (tester) async {
      final selfId = eventsController.addEvent(event);
      final nearbyId = eventsController.addEvent(
        KalenderEvent(start: DateTime.utc(2024, 1, 15, 8), end: DateTime.utc(2024, 1, 15, 8, 45)),
      );
      eventsController.addEvent(
        KalenderEvent(start: DateTime.utc(2024, 1, 15, 11), end: DateTime.utc(2024, 1, 15, 12)),
      );

      final harness = _DayTileHarness(event: eventsController.byId(selfId)!, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      final nearby = harness.nearbyEvents(
        context,
        before: const Duration(minutes: 30),
        after: const Duration(minutes: 30),
      );

      final ids = nearby.map((e) => e.id).toSet();
      expect(ids, contains(nearbyId));
      expect(ids, isNot(contains(selfId)), reason: 'includeSelf defaults to false');
      expect(ids, hasLength(1), reason: 'the 11:00 event is outside the +/-30min window');
    });

    testWidgets('nearbyEvents can include self', (tester) async {
      final selfId = eventsController.addEvent(event);
      final harness = _DayTileHarness(event: eventsController.byId(selfId)!, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      final nearby = harness.nearbyEvents(context, includeSelf: true);
      expect(nearby.map((e) => e.id), contains(selfId));
    });
  });

  group('MultiDayEventTileUtils', () {
    final event = KalenderEvent(start: DateTime.utc(2024, 1, 15, 9), end: DateTime.utc(2024, 1, 17, 18));
    final tileRange = KalenderDateTimeRange(start: DateTime.utc(2024, 1, 15), end: DateTime.utc(2024, 1, 18));

    Future<(_MultiDayTileHarness, BuildContext)> pumpMultiDayHarness(WidgetTester tester, KalenderEvent event) async {
      final harness = _MultiDayTileHarness(event: event, tileRange: tileRange);
      return (harness, await pumpHarness(tester, harness));
    }

    // Runs Jan 13 to Jan 20, but the tile only shows Jan 15 to Jan 18.
    final overflowing = KalenderEvent(start: DateTime.utc(2024, 1, 13, 9), end: DateTime.utc(2024, 1, 20, 18));

    // 3 days across the 300px tile, so each day is 100px wide.
    final dateFromPositionCases = [
      ('maps a horizontal offset to the right day', event, 150.0, TZDateTime(utcLocation, 2024, 1, 16)),
      ('resolves the first column to the start day', event, 10.0, TZDateTime(utcLocation, 2024, 1, 15)),
      ('resolves the last column to the end day', event, 250.0, TZDateTime(utcLocation, 2024, 1, 17)),
      ('clamps a tap on the trailing edge to the last day', event, 300.0, TZDateTime(utcLocation, 2024, 1, 17)),
      ('clips an overflowing event', overflowing, 10.0, TZDateTime(utcLocation, 2024, 1, 15)),
      ('clips an overflowing event', overflowing, 150.0, TZDateTime(utcLocation, 2024, 1, 16)),
      ('clips an overflowing event', overflowing, 250.0, TZDateTime(utcLocation, 2024, 1, 17)),
    ];

    for (final (description, tileEvent, dx, expected) in dateFromPositionCases) {
      testWidgets('dateFromPosition $description, dx $dx', (tester) async {
        final (harness, context) = await pumpMultiDayHarness(tester, tileEvent);
        expect(harness.dateFromPosition(context, Offset(dx, 0)), expected);
      });
    }

    testWidgets('nearbyEvents includes multi-day events by default', (tester) async {
      final selfId = eventsController.addEvent(event);
      final otherMultiDayId = eventsController.addEvent(
        KalenderEvent(start: DateTime.utc(2024, 1, 16), end: DateTime.utc(2024, 1, 18)),
      );

      final (harness, context) = await pumpMultiDayHarness(tester, eventsController.byId(selfId)!);
      final nearby = harness.nearbyEvents(context);

      final ids = nearby.map((e) => e.id).toSet();
      expect(ids, contains(otherMultiDayId));
      expect(ids, isNot(contains(selfId)), reason: 'includeSelf defaults to false');
    });
  });
}
