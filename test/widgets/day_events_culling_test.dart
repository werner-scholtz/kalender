import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// Tests for the off-screen tile culling in the day event column. Only events
// whose time band is within the visible scroll window (plus an overscan margin)
// are built.
//
// These use a real CalendarView so the vertical scroll view is attached and the
// culling actually runs. Without an attached scroll view the column falls back
// to building every event, and neither behaviour below could be observed.
void main() {
  final day = DateTime(2025, 3, 24);

  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  // Adds one event on [day], starting at [hour] for [durationHours]. The view
  // uses 1 pixel per minute and starts the day at 00:00, so the tile's top
  // pixel is hour * 60.
  String addEvent(int hour, {int durationHours = 1}) {
    return eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: day.copyWith(hour: hour),
          end: day.copyWith(hour: hour + durationHours),
        ),
      ),
    );
  }

  Future<void> pumpSingleDay(WidgetTester tester) {
    final components = TileComponents(
      tileBuilder: (event, tileRange) => Container(key: ValueKey(event.id)),
    );
    return pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.singleDay(
          initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: DateTimeRange(start: day, end: day.add(const Duration(days: 1))),
          initialDateTime: day,
        ),
        body: CalendarBody(multiDayTileComponents: components),
      ),
    );
  }

  ScrollPosition bodyScrollPosition() {
    final viewController = calendarController.viewController as MultiDayViewController;
    return viewController.scrollController.position;
  }

  testWidgets('an event partially inside the viewport is still built', (tester) async {
    // Midday event (top at 720px) so there is room to scroll it under the edge.
    final id = addEvent(12, durationHours: 2);
    await pumpSingleDay(tester);

    final position = bodyScrollPosition();
    // Scroll so the event's top sits just above the viewport's bottom edge: the
    // top slice is visible and the rest hangs off the bottom. A partially
    // visible tile must still be built.
    position.jumpTo(720 - (position.viewportDimension - 20));
    await tester.pumpAndSettle();

    expect(find.byKey(ValueKey(id)), findsOneWidget);
  });

  testWidgets('scrolling reveals a tile that was culled off-screen', (tester) async {
    // Late-evening event (top at 1320px), far below the initial window.
    final id = addEvent(22);
    await pumpSingleDay(tester);

    // At the top of the day it sits outside the window and overscan, so its
    // tile is not built.
    expect(find.byKey(ValueKey(id)), findsNothing);

    // Scroll to the bottom of the day. The event now enters the window and its
    // tile is built.
    final position = bodyScrollPosition();
    position.jumpTo(position.maxScrollExtent);
    await tester.pumpAndSettle();

    expect(find.byKey(ValueKey(id)), findsOneWidget);
  });
}
