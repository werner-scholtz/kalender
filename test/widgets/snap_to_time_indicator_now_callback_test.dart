// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' show getLocation;

import '../utilities.dart';

/// Rescheduling and resizing snap to the time indicator, which sits where `nowCallback` or else the clock says.
/// Covers #663.
void main() {
  final day = DateTime(2025, 3, 24);
  final clockTime = DateTime(2025, 3, 24, 9);

  // Not on the 10-minute snap grid, so only the time indicator can produce it.
  const indicator = (14, 7);

  late DefaultEventsController eventsController;
  late String eventId;

  setUpAll(tz.initializeTimeZones);

  setUp(() {
    eventsController = DefaultEventsController();
    eventId = eventsController.addEvent(KalenderEvent(start: day.copyWith(hour: 6), end: day.copyWith(hour: 8)));
  });

  Future<Rect> pumpDay(WidgetTester tester, NowCallback? nowCallback) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: KalenderController(
          viewConfiguration: MultiDayViewConfiguration.singleDay(
            displayRange: KalenderDateTimeRange(start: day, end: day.add(const Duration(days: 7))),
            initialDateTime: day,
            initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
            initialHeightPerMinute: 1,
            nowCallback: nowCallback,
          ),
        ),
        callbacks: KalenderCallbacks(
          onEventChanged: (event, updated) => eventsController.updateEvent(event: event, updatedEvent: updated),
        ),
        views: [
          MultiDayViewParts(
            header: const SizedBox.shrink(),
            body: MultiDayBody(
              interaction: KalenderInteraction(
                inputMode: InputMode.precise,
                createEventGesture: EventInteractionGesture.tap,
                modifyEventGesture: EventInteractionGesture.tap,
              ),
              snapping: const KalenderSnapping(snapToTimeIndicator: true, snapToOtherEvents: false),
              tileComponents: TileComponents(tileBuilder: (context, event, range) => Container(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
    return tester.getRect(find.byType(MultiDayBody));
  }

  Future<void> dragTo(WidgetTester tester, Offset from, Offset to) async {
    final gesture = await tester.startGesture(from);
    await tester.pump(const Duration(milliseconds: 100));
    await gesture.moveTo(Offset.lerp(from, to, 0.5)!);
    await tester.pump();
    await gesture.moveTo(to);
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
  }

  (int, int) hourMinute(DateTime dateTime) => (dateTime.hour, dateTime.minute);

  // The wall-clock time decides, whatever the zone of the returned value.
  final callbacks = <String, NowCallback?>{
    'a local DateTime': () => DateTime(2025, 3, 24, 14, 7),
    'a UTC DateTime': () => DateTime.utc(2025, 3, 24, 14, 7),
    'a TZDateTime in Tokyo': () => TZDateTime(getLocation('Asia/Tokyo'), 2025, 3, 24, 14, 7),
    'a FloatingDateTime': () => FloatingDateTime(2025, 3, 24, 14, 7),
    'no callback, the clock': null,
  };

  for (final MapEntry(key: name, value: callback) in callbacks.entries) {
    group('with $name', () {
      // Without a callback the clock must be the one at 14:07.
      final fixed = callback == null ? DateTime(2025, 3, 24, 14, 7) : clockTime;

      testWidgets('rescheduling snaps the start to the time indicator', (tester) async {
        await withClock(Clock.fixed(fixed), () async {
          await pumpDay(tester, callback);

          // The start is at 06:00, so the tile's centre is at 07:00. A pixel is a minute, 14:05 is 485 minutes later.
          final tile = find.byKey(DayEventTile.tileKey(eventId));
          final from = tester.getCenter(tile);
          await dragTo(tester, from, from.translate(0, 485));

          expect(hourMinute(eventsController.events.single.floatingStart()), indicator);
        });
      });

      testWidgets('resizing snaps the end to the time indicator', (tester) async {
        await withClock(Clock.fixed(fixed), () async {
          await pumpDay(tester, callback);

          final tile = find.byKey(DayEventTile.tileKey(eventId));
          await tester.hoverOn(tile, await tester.createMouseGesture());
          final handle = tester.getCenter(
            find.descendant(of: tile, matching: find.byKey(ResizeDetector.endResizeDraggableKey(eventId))),
          );
          // The end is at 08:00, 14:05 is 365 minutes later.
          await dragTo(tester, handle, handle.translate(0, 365));

          expect(hourMinute(eventsController.events.single.floatingEnd()), indicator);
        });
      });
    });
  }
}
