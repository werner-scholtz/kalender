import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Covers the regression where [TileComponents.overlayTileBuilder] was ignored,
/// and overlay tiles rendered with [TileComponents.tileBuilder] instead.
void main() {
  const headerConfiguration = MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1);

  /// Builds a week view whose header overflows, then opens the overlay.
  Future<CalendarController> pumpAndOpenOverlay(WidgetTester tester, TileComponents tileComponents) async {
    final eventsController = DefaultEventsController();
    final calendarController = CalendarController();

    final now = InternalDateTime.fromDateTime(DateTime.now()).startOfWeek();
    final startOfWeek = DateTime(now.year, now.month, now.day);
    final range = DateTimeRange(start: startOfWeek, end: startOfWeek.copyWith(day: startOfWeek.day + 2));
    eventsController.addEvents([
      CalendarEvent(dateTimeRange: range),
      CalendarEvent(dateTimeRange: range),
    ]);

    final dpi = tester.view.devicePixelRatio;
    tester.view.physicalSize = Size(800 * dpi, 600 * dpi);
    addTearDown(tester.view.reset);

    await pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.week(),
        header: CalendarHeader(
          multiDayHeaderConfiguration: headerConfiguration,
          multiDayTileComponents: tileComponents,
        ),
        body: CalendarBody(multiDayTileComponents: tileComponents),
      ),
    );

    final date = calendarController.internalDateTimeRange.value!.dates().first;
    await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(date)));
    await tester.pumpAndSettle();
    expect(find.byType(MultiDayOverlay), findsOne);

    return calendarController;
  }

  group('overlayTileBuilder', () {
    testWidgets('renders the overlay tiles when provided', (tester) async {
      await pumpAndOpenOverlay(
        tester,
        TileComponents(
          tileBuilder: (context, event, tileRange) => const Text('normal'),
          overlayTileBuilder: (context, event, tileRange) => const Text('overlay'),
        ),
      );

      // Both events are hidden behind the overflow button, so both render in the overlay.
      expect(find.text('overlay'), findsNWidgets(2));
    });

    testWidgets('falls back to tileBuilder when omitted', (tester) async {
      await pumpAndOpenOverlay(
        tester,
        TileComponents(tileBuilder: (context, event, tileRange) => const Text('normal')),
      );

      expect(find.text('normal'), findsWidgets);
    });
  });
}
