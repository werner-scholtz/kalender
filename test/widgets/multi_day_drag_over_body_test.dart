import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

/// A multi-day event is laid out in the header, but a drag can wander down over
/// the body. The header's drop target should keep following the cursor's day.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  late String eventId;

  final start = DateTime(2025, 1, 6); // A Monday.

  final interaction = CalendarInteraction(
    inputMode: InputMode.precise,
    createEventGesture: CreateEventGesture.tap,
    modifyEventGesture: CreateEventGesture.tap,
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    // A two-day event starting on the Tuesday.
    eventId = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: start.add(const Duration(days: 1, hours: 9)),
          end: start.add(const Duration(days: 3, hours: 9)),
        ),
      ),
    );
  });

  Future<void> pumpWeek(WidgetTester tester, {CalendarCallbacks? callbacks}) {
    return pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        callbacks: callbacks,
        viewConfiguration: MultiDayViewConfiguration.week(
          displayRange: year2025DisplayRange,
          initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
          initialDateTime: start,
        ),
        header: CalendarHeader(interaction: interaction),
        body: CalendarBody(interaction: interaction),
      ),
    );
  }

  testWidgets('dragging a multi-day tile down into the body still moves the header preview', (tester) async {
    await pumpWeek(tester);

    final tile = find.byKey(MultiDayEventTile.tileKey(eventId));
    expect(tile, findsOneWidget, reason: 'the multi-day tile should render in the header');

    final originalStart = eventsController.byId(eventId)!.start;
    final dayWidth = tester.getSize(find.byType(CalendarView)).width / 7;

    // Pick the tile up, then move well below the header, into the body.
    final gesture = await tester.startGesture(tester.getCenter(tile));
    await tester.pump(const Duration(milliseconds: 100));
    await gesture.moveBy(const Offset(0, 200));
    await tester.pumpAndSettle();

    // Now move sideways by two day columns while still over the body.
    await gesture.moveBy(Offset(dayWidth * 2, 0));
    await tester.pumpAndSettle();

    final preview = calendarController.selectedEvent.value;
    expect(preview, isNotNull, reason: 'the body should keep previewing a multi-day drag');
    expect(
      preview!.start.day,
      isNot(equals(originalStart.day)),
      reason: 'the preview should follow the cursor across day columns while over the body',
    );

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('the time of day and duration survive a drag across the body', (tester) async {
    await pumpWeek(tester);

    final original = eventsController.byId(eventId)!;
    final dayWidth = tester.getSize(find.byType(CalendarView)).width / 7;

    final gesture = await tester.startGesture(tester.getCenter(find.byKey(MultiDayEventTile.tileKey(eventId))));
    await tester.pump(const Duration(milliseconds: 100));
    await gesture.moveBy(Offset(dayWidth, 250));
    await tester.pumpAndSettle();

    final preview = calendarController.selectedEvent.value!;
    expect(
      preview.start.day,
      isNot(equals(original.start.day)),
      reason: 'the date must actually have moved, or the rest of this test proves nothing',
    );
    expect(preview.duration, equals(original.duration), reason: 'a vertical drag must not resize a multi-day event');
    expect(
      preview.start.difference(preview.start.copyWith(hour: 0, minute: 0)),
      equals(original.start.difference(original.start.copyWith(hour: 0, minute: 0))),
      reason: 'the time of day should be preserved, only the date changes',
    );

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('dropping over the body commits the new date', (tester) async {
    CalendarEvent? changed;
    await pumpWeek(tester, callbacks: CalendarCallbacks(onEventChanged: (_, updated) => changed = updated));

    final originalStart = eventsController.byId(eventId)!.start;
    final dayWidth = tester.getSize(find.byType(CalendarView)).width / 7;

    final gesture = await tester.startGesture(tester.getCenter(find.byKey(MultiDayEventTile.tileKey(eventId))));
    await tester.pump(const Duration(milliseconds: 100));
    await gesture.moveBy(Offset(dayWidth, 220));
    await tester.pumpAndSettle();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(changed, isNotNull, reason: 'releasing over the body should commit, not snap back');
    expect(changed!.start.day, isNot(equals(originalStart.day)));
  });
}
