// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';

import '../utilities.dart';

/// Creating, resizing and rescheduling stop at the bottom of the day, which is the start of `timeOfDayRange` plus
/// its `duration`.
void main() {
  final monday = DateTime(2025, 6, 2);
  final wednesday = monday.add(const Duration(days: 2));

  // Draws 581 minutes, not a whole number of 15-minute intervals.
  final to1740 = KalenderTimeRange(
    start: const KalenderTime(hour: 8, minute: 0),
    end: const KalenderTime(hour: 17, minute: 40),
  );

  // Draws 600 minutes, so the bottom of the day is 18:00.
  final to1759 = KalenderTimeRange(
    start: const KalenderTime(hour: 8, minute: 0),
    end: const KalenderTime(hour: 17, minute: 59),
  );

  late DefaultEventsController eventsController;

  setUp(() => eventsController = DefaultEventsController());

  Future<Rect> pumpWeek(WidgetTester tester, KalenderTimeRange timeOfDayRange) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: KalenderController(
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: KalenderDateTimeRange(start: monday, end: monday.add(const Duration(days: 7))),
            initialDateTime: monday,
            timeOfDayRange: timeOfDayRange,
            initialTimeOfDay: const KalenderTime(hour: 8, minute: 0),
            initialHeightPerMinute: 1,
          ),
        ),
        callbacks: KalenderCallbacks(
          onEventCreated: eventsController.addEvent,
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
              snapping: const KalenderSnapping(
                snapIntervalMinutes: 15,
                snapToTimeIndicator: false,
                snapToOtherEvents: false,
              ),
              tileComponents: TileComponents(tileBuilder: (context, event, range) => Container(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
    return tester.getRect(find.byType(MultiDayBody));
  }

  // One pixel per minute from 08:00.
  double lastPixel(Rect body, KalenderTimeRange range) => body.top + range.duration.inMinutes - 1;

  (int, int) hourMinute(DateTime dateTime) => (dateTime.hour, dateTime.minute);

  Future<void> dragTo(WidgetTester tester, Offset from, Offset to) async {
    final gesture = await tester.startGesture(from);
    await tester.pump();
    await gesture.moveTo(Offset.lerp(from, to, 0.5)!);
    await tester.pump();
    await gesture.moveTo(to);
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
  }

  for (final (range, bottom) in [(to1740, (17, 41)), (to1759, (18, 0))]) {
    final name = '${range.end.hour}:${range.end.minute}';

    testWidgets('a create drag to the last pixel of a day ending $name ends at $bottom', (tester) async {
      final body = await pumpWeek(tester, range);
      final x = body.left + body.width * 0.6;

      await dragTo(tester, Offset(x, body.top + 300), Offset(x, lastPixel(body, range)));

      expect(hourMinute(eventsController.events.single.floatingEnd()), bottom);
    });

    testWidgets('a resize drag to the last pixel of a day ending $name ends at $bottom', (tester) async {
      final id = eventsController.addEvent(
        KalenderEvent(start: wednesday.copyWith(hour: 16), end: wednesday.copyWith(hour: 17)),
      );
      final body = await pumpWeek(tester, range);

      final tile = find.byKey(DayEventTile.tileKey(id));
      await tester.hoverOn(tile, await tester.createMouseGesture());
      final bottomHandle = find.descendant(of: tile, matching: find.byKey(ResizeDetector.endResizeDraggableKey(id)));

      final handle = tester.getCenter(bottomHandle);
      await dragTo(tester, handle, Offset(handle.dx, lastPixel(body, range)));

      expect(hourMinute(eventsController.events.single.floatingEnd()), bottom);
    });
  }

  testWidgets('a create drag picked up at the last pixel stays within the day', (tester) async {
    final body = await pumpWeek(tester, to1740);
    final bottom = Offset(body.left + body.width * 0.6, lastPixel(body, to1740));

    // Sideways, so the drag starts while the pointer stays on the last pixel.
    final gesture = await tester.startGesture(bottom);
    await tester.pump();
    await gesture.moveTo(bottom.translate(20, 0));
    await tester.pump();
    await gesture.moveTo(bottom);
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    final event = eventsController.events.single;
    expect(hourMinute(event.floatingEnd()), (17, 41));
    expect(event.floatingStart().isBefore(event.floatingEnd()), isTrue);
  });

  testWidgets('rescheduling an event as long as the day keeps it within the day', (tester) async {
    final id = eventsController.addEvent(
      KalenderEvent(start: wednesday.copyWith(hour: 8), end: wednesday.copyWith(hour: 18)),
    );
    await pumpWeek(tester, to1759);

    final tile = tester.getCenter(find.byKey(DayEventTile.tileKey(id)));
    await dragTo(tester, tile, tile.translate(0, 100));

    final event = eventsController.events.single;
    expect(hourMinute(event.floatingStart()), (8, 0));
    expect(hourMinute(event.floatingEnd()), (18, 0));
  });
}
