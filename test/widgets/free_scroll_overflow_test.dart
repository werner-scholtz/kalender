import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// The "+N more" overflow portal must work inside the free-scroll band, which is
// translated and clipped, not just in the paged headers.
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
    tileBuilder: (event, tileRange) => Container(key: ValueKey('inner-${event.id}'), color: Colors.red),
  );

  const headerConfiguration = MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1);

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
        header: CalendarHeader(multiDayTileComponents: components, multiDayHeaderConfiguration: headerConfiguration),
        body: CalendarBody(multiDayTileComponents: components),
      ),
    );
  }

  testWidgets('overflowing days show the "+N more" portal, which opens on tap', (tester) async {
    // Two overlapping 2-day events. With a one-row limit the second overflows,
    // so Mon and Tue each get a "+N more" portal.
    eventsController.addEvents([
      CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: start.add(const Duration(days: 2)))),
      CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: start.add(const Duration(days: 2)))),
    ]);

    await pumpFreeScroll(tester);

    // One row of events is shown, and the overflow portal/button render.
    expect(find.byType(MultiDayOverlayPortal), findsWidgets, reason: 'overflow portals should render in the band');
    expect(find.byType(MultiDayPortalOverlayButton), findsWidgets);

    // Tapping the button for Monday opens the overlay.
    final monday = InternalDateTime.fromDateTime(start);
    final button = find.byKey(MultiDayPortalOverlayButton.getKey(monday));
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byType(MultiDayOverlay), findsOneWidget, reason: 'tapping the button should open the overlay');
  });
}
