import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

// The paged week view builds its page-edge triggers through
// CursorNavigationTrigger.page (the shared helper for the multi-day header and
// body). Holding a drag at the viewport edge must still advance the page, the
// same as before the helper existed.
void main() {
  final start = DateTime(2025, 3, 24); // Monday
  final displayRange = DateTimeRange(start: start, end: start.add(const Duration(days: 28)));

  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  final components = TileComponents(
    tileBuilder: (event, tileRange) => Container(key: ValueKey('inner-${event.id}'), color: Colors.red),
  );

  final precise = CalendarInteraction(
    inputMode: InputMode.precise,
    createEventGesture: CreateEventGesture.tap,
    modifyEventGesture: CreateEventGesture.tap,
  );

  MultiDayViewController viewController() => calendarController.viewController as MultiDayViewController;

  Future<void> pumpWeek(WidgetTester tester) {
    return pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.week(
          displayRange: displayRange,
          initialDateTime: start,
          initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
        ),
        header: CalendarHeader(multiDayTileComponents: components, interaction: precise),
        body: CalendarBody(multiDayTileComponents: components, interaction: precise),
      ),
    );
  }

  testWidgets('dragging a header tile to the viewport edge advances the page', (tester) async {
    // A 2-day event in the first visible week, shown in the multi-day header.
    final id = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: start.add(const Duration(days: 1)), end: start.add(const Duration(days: 3))),
      ),
    );

    await pumpWeek(tester);

    final pageBefore = viewController().pageController.page ?? 0;

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    expect(tile, findsOneWidget);
    final headerRect = tester.getRect(find.byType(CalendarHeader));
    final tileCenter = tester.getCenter(tile);

    // Start a reschedule drag and hold it over the right viewport edge. Move in
    // steps so the edge trigger registers a drag-enter (a single jump past it
    // does not) and starts its timer.
    final gesture = await tester.startGesture(tileCenter);
    await tester.pump();
    await gesture.moveTo(Offset(headerRect.right - 30, tileCenter.dy));
    await tester.pump();
    await gesture.moveTo(Offset(headerRect.right - 4, tileCenter.dy));
    await tester.pump();
    // The trigger fires after its delay, then the page animates.
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 350));
    await gesture.up();
    await tester.pumpAndSettle();

    final pageAfter = viewController().pageController.page ?? 0;
    expect(pageAfter, greaterThan(pageBefore), reason: 'holding a drag at the header edge should advance the page');
  });

  testWidgets('dragging a body tile to the viewport edge advances the page', (tester) async {
    // A one-hour timed event, shown in the body.
    final eventStart = start.add(const Duration(days: 1, hours: 9));
    final id = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: eventStart, end: eventStart.add(const Duration(hours: 1)))),
    );

    await pumpWeek(tester);

    final pageBefore = viewController().pageController.page ?? 0;

    final tile = find.byKey(DayEventTile.tileKey(id));
    expect(tile, findsOneWidget);
    final bodyRect = tester.getRect(find.byType(CalendarBody));
    final tileCenter = tester.getCenter(tile);

    // Start a reschedule drag and hold it over the right viewport edge. Move in
    // steps so the edge trigger registers a drag-enter (a single jump past it
    // does not) and starts its timer.
    final gesture = await tester.startGesture(tileCenter);
    await tester.pump();
    await gesture.moveTo(Offset(bodyRect.right - 30, tileCenter.dy));
    await tester.pump();
    await gesture.moveTo(Offset(bodyRect.right - 4, tileCenter.dy));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 350));
    await gesture.up();
    await tester.pumpAndSettle();

    final pageAfter = viewController().pageController.page ?? 0;
    expect(pageAfter, greaterThan(pageBefore), reason: 'holding a drag at the body edge should advance the page');
  });
}
