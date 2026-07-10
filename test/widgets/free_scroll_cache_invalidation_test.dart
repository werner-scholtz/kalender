import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

// The free-scroll header renders multi-day events as one continuous band whose
// range moves as it scrolls, sharing a single layout-frame cache across every
// window it visits. The cache is keyed only by date range, so when the events
// change it must be cleared for every window, not just the one on screen.
//
// Regression: a window rendered (and cached) before an event existed used to
// keep returning its event-less frame. Scrolling back to that window after
// creating the event made the event vanish, even though it clearly covered the
// visible days.
void main() {
  final displayRange = DateTimeRange(start: DateTime(2018), end: DateTime(2036));
  final initial = DateTime(2026, 7, 10);

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
          numberOfDays: 3,
          displayRange: displayRange,
          initialDateTime: initial,
          initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
        ),
        header: CalendarHeader(multiDayTileComponents: components),
        body: CalendarBody(multiDayTileComponents: components),
      ),
    );
  }

  MultiDayViewController viewController() => calendarController.viewController as MultiDayViewController;

  testWidgets('multi-day event stays visible when scrolling back to windows cached before it existed', (tester) async {
    await pumpFreeScroll(tester);

    // Scroll back then forward so the earlier windows get rendered and cached
    // while no event exists yet, mirroring creating the event after opening the
    // view.
    final pageController = viewController().pageController;
    final base = (pageController.page ?? 0).round();
    pageController.jumpToPage(base - 2);
    await tester.pumpAndSettle();
    pageController.jumpToPage(base);
    await tester.pumpAndSettle();

    // A three-day event starting on the initial leading day.
    final id = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: initial, end: initial.add(const Duration(days: 3)))),
    );
    await tester.pumpAndSettle();

    final tile = MultiDayEventTile.tileKey(id);
    expect(find.byKey(tile), findsOneWidget, reason: 'visible at the initial position');

    // Scroll back through the previously-cached windows. The event still covers
    // the visible days, so its tile must stay on screen.
    pageController.jumpToPage(base - 1);
    await tester.pumpAndSettle();
    expect(find.byKey(tile), findsOneWidget, reason: 'still visible one day back');

    pageController.jumpToPage(base - 2);
    await tester.pumpAndSettle();
    expect(find.byKey(tile), findsOneWidget, reason: 'still visible two days back');
  });
}
