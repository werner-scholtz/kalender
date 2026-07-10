import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;

import '../utilities.dart';

// The body's top/bottom scroll triggers are built through
// CursorNavigationTrigger.scroll (the shared helper for the body and schedule
// scroll triggers). Holding a drag at the top or bottom edge must still scroll
// the body vertically, the same as before the helper existed.
void main() {
  final start = DateTime(2025, 3, 24); // Monday

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

  // Align the top of the viewport with [hour] so each test starts with room to
  // scroll in the direction it drags.
  Future<void> pumpWeek(WidgetTester tester, int hour) {
    return pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.week(
          displayRange: DateTimeRange(start: start, end: start.add(const Duration(days: 7))),
          initialDateTime: start,
          initialTimeOfDay: TimeOfDay(hour: hour, minute: 0),
        ),
        body: CalendarBody(multiDayTileComponents: components, interaction: precise),
      ),
    );
  }

  // Drag [tile] from its center to [target] in steps so the edge trigger
  // registers a drag-enter (a single jump past it does not) and starts its
  // timer, hold long enough for the scroll to run, then release.
  Future<void> dragTo(WidgetTester tester, Finder tile, Offset target) async {
    final tileCenter = tester.getCenter(tile);
    final gesture = await tester.startGesture(tileCenter);
    await tester.pump();
    await gesture.moveTo(Offset(tileCenter.dx, (tileCenter.dy + target.dy) / 2));
    await tester.pump();
    await gesture.moveTo(target);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 250));
    await gesture.up();
    await tester.pumpAndSettle();
  }

  testWidgets('holding a drag at the bottom edge scrolls the body down', (tester) async {
    // Start at the top of the day so the whole day is below and there is room
    // to scroll down. The event sits just below the top edge, so it is visible.
    final eventStart = start.add(const Duration(hours: 1));
    final id = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: eventStart, end: eventStart.add(const Duration(hours: 1)))),
    );

    await pumpWeek(tester, 0);
    final offsetBefore = viewController().scrollController.offset;

    final tile = find.byKey(DayEventTile.tileKey(id));
    expect(tile, findsOneWidget);
    final bodyRect = tester.getRect(find.byType(CalendarBody));
    await dragTo(tester, tile, Offset(tester.getCenter(tile).dx, bodyRect.bottom - 2));

    expect(
      viewController().scrollController.offset,
      greaterThan(offsetBefore),
      reason: 'holding a drag at the bottom edge should scroll the body down',
    );
  });

  testWidgets('holding a drag at the top edge scrolls the body up', (tester) async {
    // Start at midday so the morning is above and there is room to scroll up.
    final eventStart = start.add(const Duration(hours: 12));
    final id = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: eventStart, end: eventStart.add(const Duration(hours: 1)))),
    );

    await pumpWeek(tester, 12);
    final offsetBefore = viewController().scrollController.offset;
    expect(offsetBefore, greaterThan(0), reason: 'midday start should leave room to scroll up');

    final tile = find.byKey(DayEventTile.tileKey(id));
    expect(tile, findsOneWidget);
    final bodyRect = tester.getRect(find.byType(CalendarBody));
    await dragTo(tester, tile, Offset(tester.getCenter(tile).dx, bodyRect.top + 2));

    expect(
      viewController().scrollController.offset,
      lessThan(offsetBefore),
      reason: 'holding a drag at the top edge should scroll the body up',
    );
  });
}
