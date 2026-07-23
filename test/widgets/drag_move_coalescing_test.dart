import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;

import '../utilities.dart';

/// Pointer moves arrive faster than the display refreshes, so [DragTargetUtilities.onMove]
/// keeps only the newest and processes it once per frame.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  late String eventId;

  final start = DateTime(2025, 3, 24);
  final viewConfiguration = MultiDayViewConfiguration.singleDay(
    initialTimeOfDay: const TimeOfDay(hour: 5, minute: 0),
    initialHeightPerMinute: 1,
    displayRange: DateTimeRange(start: start, end: DateTime(2025, 3, 31)),
    initialDateTime: start,
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    eventId = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: start.copyWith(hour: 6), end: start.copyWith(hour: 8)),
      ),
    );
  });

  Future<void> pumpCalendar(WidgetTester tester) {
    return pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: viewConfiguration,
        callbacks: CalendarCallbacks(
          onEventChanged: (event, updatedEvent) => eventsController.updateEvent(
            event: event,
            updatedEvent: updatedEvent,
          ),
        ),
        body: CalendarBody(
          interaction: CalendarInteraction(
            inputMode: InputMode.precise,
            createEventGesture: CreateEventGesture.tap,
            modifyEventGesture: CreateEventGesture.tap,
          ),
          multiDayTileComponents: TileComponents(
            tileBuilder: (event, tileRange) => Container(key: ValueKey(event.id), color: Colors.red),
          ),
        ),
      ),
    );
  }

  /// Starts a reschedule drag and returns the gesture, past the point where the
  /// draggable has been picked up.
  Future<TestGesture> beginDrag(WidgetTester tester) async {
    final tile = find.byKey(DayEventTile.tileKey(eventId));
    expect(tile, findsOneWidget);

    final gesture = await tester.startGesture(tester.getCenter(tile));
    await tester.pump(const Duration(milliseconds: 100));
    await gesture.moveBy(const Offset(0, 40));
    await tester.pumpAndSettle();
    return gesture;
  }

  testWidgets('moves within one frame coalesce into a single update', (tester) async {
    await pumpCalendar(tester);
    final gesture = await beginDrag(tester);

    var updates = 0;
    calendarController.selectedEvent.addListener(() => updates++);

    // Three moves with no frame between them.
    await gesture.moveBy(const Offset(0, 20));
    await gesture.moveBy(const Offset(0, 20));
    await gesture.moveBy(const Offset(0, 20));
    expect(updates, 0, reason: 'nothing is processed until the frame ends');

    await tester.pump();
    expect(updates, 1, reason: 'the three moves collapse into one update');

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('the update uses the newest move, not the first', (tester) async {
    await pumpCalendar(tester);
    final gesture = await beginDrag(tester);

    final afterFirstMove = calendarController.selectedEvent.value!.start;

    await gesture.moveBy(const Offset(0, 30));
    await gesture.moveBy(const Offset(0, 30));
    await tester.pump();

    final coalesced = calendarController.selectedEvent.value!.start;
    final movedBy = coalesced.difference(afterFirstMove);

    // 60 logical pixels at 1 minute per pixel. Had the first move won, this
    // would be half as much.
    expect(movedBy.inMinutes, greaterThan(45), reason: 'the last move should win, not the first');

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('a move queued at the moment of the drop does not survive it', (tester) async {
    await pumpCalendar(tester);
    final gesture = await beginDrag(tester);

    // Queue a move and drop before the frame that would process it.
    await gesture.moveBy(const Offset(0, 20));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(
      calendarController.selectedEvent.value,
      isNull,
      reason: 'a pending move must not reselect the event after the drop deselected it',
    );
    expect(find.byKey(DayEventTile.tileKey(eventId)), findsOneWidget, reason: 'the preview must not be left behind');
  });
}
