import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';

import '../utilities.dart';

/// A create or resize drag stops at the end of `timeOfDayRange`.
void main() {
  // 08:00 to 17:40 is 580 minutes, not a whole number of 15-minute intervals.
  final timeOfDayRange = KalenderTimeRange(
    start: const KalenderTime(hour: 8, minute: 0),
    end: const KalenderTime(hour: 17, minute: 40),
  );
  final monday = DateTime(2025, 6, 2);

  late DefaultEventsController eventsController;

  setUp(() => eventsController = DefaultEventsController());

  Future<Rect> pumpWeek(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: KalenderController(),
        viewConfiguration: MultiDayViewConfiguration.week(
          displayRange: KalenderDateTimeRange(start: monday, end: monday.add(const Duration(days: 7))),
          initialDateTime: monday,
          timeOfDayRange: timeOfDayRange,
          initialTimeOfDay: const KalenderTime(hour: 8, minute: 0),
          initialHeightPerMinute: 1,
        ),
        callbacks: KalenderCallbacks(
          onEventCreated: eventsController.addEvent,
          onEventChanged: (event, updated) => eventsController.updateEvent(event: event, updatedEvent: updated),
        ),
        body: KalenderBody(
          interaction: KalenderInteraction(
            inputMode: InputMode.precise,
            createEventGesture: EventInteractionGesture.tap,
            modifyEventGesture: EventInteractionGesture.tap,
          ),
          snapping:
              const KalenderSnapping(snapIntervalMinutes: 15, snapToTimeIndicator: false, snapToOtherEvents: false),
          multiDayTileComponents: TileComponents(tileBuilder: (context, event, range) => Container(color: Colors.red)),
        ),
      ),
    );
    return tester.getRect(find.byType(MultiDayBody));
  }

  // One pixel per minute from 08:00, so 579 is the last pixel before 17:40.
  double lastPixel(Rect body) => body.top + 579;

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

  testWidgets('a create drag to the last pixel ends at the end of the day', (tester) async {
    final body = await pumpWeek(tester);
    final x = body.left + body.width * 0.6;

    await dragTo(tester, Offset(x, body.top + 300), Offset(x, lastPixel(body)));

    final end = eventsController.events.single.floatingEnd();
    expect((end.hour, end.minute), (17, 40));
  });

  testWidgets('a resize drag to the last pixel ends at the end of the day', (tester) async {
    final wednesday = monday.add(const Duration(days: 2));
    final id = eventsController.addEvent(
      KalenderEvent(start: wednesday.copyWith(hour: 16), end: wednesday.copyWith(hour: 17)),
    );
    final body = await pumpWeek(tester);

    final tile = find.byKey(DayEventTile.tileKey(id));
    await tester.hoverOn(tile, await tester.createMouseGesture());
    final bottomHandle = find.descendant(of: tile, matching: find.byKey(ResizeDetector.endResizeDraggableKey(id)));
    expect(bottomHandle, findsOneWidget);

    final handle = tester.getCenter(bottomHandle);
    await dragTo(tester, handle, Offset(handle.dx, lastPixel(body)));

    final end = eventsController.events.single.floatingEnd();
    expect((end.hour, end.minute), (17, 40));
  });
}
