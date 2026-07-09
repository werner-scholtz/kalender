import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

// The free-scroll header draws multi-day events as one continuous band. A
// multi-day event should render as ONE tile spanning several day columns, and
// stay a single tile that moves as the view scrolls, rather than being split
// into one tile per day.
void main() {
  final start = DateTime(2025, 3, 24); // Monday
  final displayRange = DateTimeRange(start: start, end: start.add(const Duration(days: 21)));

  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  final components = TileComponents(
    tileBuilder: (event, tileRange) => Container(key: ValueKey('inner-${event.id}')),
  );

  Future<void> pumpFreeScroll(WidgetTester tester) {
    return pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.freeScroll(
          numberOfDays: 7,
          displayRange: displayRange,
          initialDateTime: start,
          initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
        ),
        header: CalendarHeader(multiDayTileComponents: components),
        body: CalendarBody(multiDayTileComponents: components),
      ),
    );
  }

  MultiDayViewController viewController() => calendarController.viewController as MultiDayViewController;

  testWidgets('a multi-day event renders as one continuous spanning tile', (tester) async {
    // Monday 00:00 -> Friday 00:00, a 4-day span inside the first visible week.
    final id = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: start, end: start.add(const Duration(days: 4))),
      ),
    );

    await pumpFreeScroll(tester);

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    final calWidth = tester.getSize(find.byType(CalendarView)).width;

    expect(tile, findsOneWidget, reason: 'the multi-day event should be a single continuous tile');
    final tileWidth = tester.getSize(tile).width;
    // A single day column is ~calWidth/7. A spanning tile is clearly wider.
    expect(tileWidth, greaterThan(calWidth * 0.22), reason: 'the tile should span more than one day column');
    expect(tileWidth, lessThan(calWidth), reason: 'the tile should not fill the whole strip');
  });

  testWidgets('the spanning tile stays one tile and moves as the view scrolls', (tester) async {
    final id = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: start.add(const Duration(days: 1)), end: start.add(const Duration(days: 4))),
      ),
    );

    await pumpFreeScroll(tester);

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    expect(tile, findsOneWidget);
    final leftBefore = tester.getTopLeft(tile).dx;

    // Scroll the body forward by one day.
    final pageController = viewController().pageController;
    pageController.jumpToPage((pageController.page ?? 0).round() + 1);
    await tester.pumpAndSettle();

    expect(tile, findsOneWidget, reason: 'still a single tile after scrolling');
    final leftAfter = tester.getTopLeft(tile).dx;
    expect(leftAfter, lessThan(leftBefore), reason: 'the tile should move left as the view scrolls forward');
  });

  testWidgets('renders without blowing up on a multi-year display range', (tester) async {
    // A large range would make a whole-range strip millions of pixels wide, so
    // the band must window the days it renders.
    final bigRange = DateTimeRange(start: DateTime(2018), end: DateTime(2036));
    final id = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: DateTime(2026, 7, 6), end: DateTime(2026, 7, 9)),
      ),
    );

    await pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.freeScroll(
          numberOfDays: 3,
          displayRange: bigRange,
          initialDateTime: DateTime(2026, 7, 6),
          initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
        ),
        header: CalendarHeader(multiDayTileComponents: components),
        body: CalendarBody(multiDayTileComponents: components),
      ),
    );

    // No exception during layout, and the event near the initial date is built.
    expect(tester.takeException(), isNull);
    expect(find.byKey(MultiDayEventTile.tileKey(id)), findsOneWidget);
  });
}
