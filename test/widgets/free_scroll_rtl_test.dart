import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

// The free-scroll multi-day band must work in right-to-left too: spanning tiles
// render, sit on the mirrored side, and scroll the right way.
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

  Future<void> pump(WidgetTester tester, TextDirection direction) {
    return pumpAndSettleWithMaterialApp(
      tester,
      Directionality(
        textDirection: direction,
        child: CalendarView(
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
      ),
    );
  }

  MultiDayViewController viewController() => calendarController.viewController as MultiDayViewController;

  testWidgets('RTL: a multi-day event renders as one spanning tile', (tester) async {
    final id = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: start.add(const Duration(days: 4)))),
    );

    await pump(tester, TextDirection.rtl);

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    expect(tile, findsOneWidget, reason: 'the multi-day event should be a single continuous tile in RTL');
    final calWidth = tester.getSize(find.byType(CalendarView)).width;
    expect(tester.getSize(tile).width, greaterThan(calWidth * 0.22));
  });

  testWidgets('RTL mirrors the tile position relative to LTR', (tester) async {
    // A 2-day event on the first two visible days.
    final event = CalendarEvent(
      dateTimeRange: DateTimeRange(start: start, end: start.add(const Duration(days: 2))),
    );
    final id = eventsController.addEvent(event);

    await pump(tester, TextDirection.ltr);
    final calRect = tester.getRect(find.byType(CalendarView));
    final ltrCenter = tester.getCenter(find.byKey(MultiDayEventTile.tileKey(id)));

    // Rebuild fresh in RTL.
    eventsController = DefaultEventsController()..addEvent(event);
    calendarController = CalendarController();
    await pump(tester, TextDirection.rtl);
    final rtlCenter = tester.getCenter(find.byKey(MultiDayEventTile.tileKey(id)));

    // The event sits near the left in LTR and should sit near the right in RTL:
    // its center should be mirrored across the view's horizontal midline.
    final mirroredLtr = calRect.left + (calRect.right - ltrCenter.dx);
    expect(rtlCenter.dx, closeTo(mirroredLtr, 2.0), reason: 'the tile should be mirrored in RTL');
  });

  testWidgets('RTL: scrolling forward moves the tile toward the start side (right)', (tester) async {
    final id = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: start.add(const Duration(days: 1)), end: start.add(const Duration(days: 4)))),
    );

    await pump(tester, TextDirection.rtl);

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    expect(tile, findsOneWidget);
    final leftBefore = tester.getTopLeft(tile).dx;

    final controller = viewController().pageController;
    controller.jumpToPage((controller.page ?? 0).round() + 1);
    await tester.pumpAndSettle();

    expect(tile, findsOneWidget, reason: 'still a single tile after scrolling in RTL');
    // Scrolling forward in time in RTL moves earlier days toward the right edge,
    // so the tile's left edge should increase (move right).
    final leftAfter = tester.getTopLeft(tile).dx;
    expect(leftAfter, greaterThan(leftBefore), reason: 'in RTL the tile should move right as the view scrolls forward');
  });
}
