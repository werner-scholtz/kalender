import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// The free-scroll header renders its multi-day events as one continuous band
// (not a per-day page view). These regressions cover the two behaviours the old
// paged header had to fight for and the band should get for free:
//  - the header does not wobble (change height) when it rebuilds (#282), and
//  - the header fits the tallest day currently in view, not just the leading
//    day (#283).
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  late CalendarCallbacks callbacks;

  final tileComponents = TileComponents(
    tileBuilder: (event, tileRange) => Container(key: ValueKey(event.id), color: Colors.red),
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    callbacks = CalendarCallbacks(
      onEventCreated: eventsController.addEvent,
      onEventChanged: (event, updatedEvent) => eventsController.updateEvent(event: event, updatedEvent: updatedEvent),
    );
  });

  final base = DateTime(2025, 3, 24); // Monday

  // Two overlapping multi-day events: 26 Mar is a two-row day, its neighbours
  // are single-row.
  void addTwoRowDay() {
    eventsController.addEvents([
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: base.add(const Duration(days: 1)), end: base.add(const Duration(days: 3))),
      ),
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: base.add(const Duration(days: 2)), end: base.add(const Duration(days: 4))),
      ),
    ]);
  }

  Widget freeScrollView({DateTime? initialDate}) => CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.freeScroll(
          numberOfDays: 3,
          initialDateTime: initialDate,
          displayRange: DateTimeRange(start: base, end: base.add(const Duration(days: 21))),
        ),
        callbacks: callbacks,
        header: CalendarHeader(multiDayTileComponents: tileComponents),
        body: CalendarBody(multiDayTileComponents: tileComponents),
      );

  group('FreeScroll header', () {
    // Regression for #282: the old header reset its measured per-page heights on
    // rebuild and visibly wobbled. The band's height is deterministic, so a
    // rebuild must not change it.
    testWidgets('does not change height when it rebuilds', (tester) async {
      addTwoRowDay();
      final rebuild = ValueNotifier(0);
      addTearDown(rebuild.dispose);

      await pumpAndSettleWithMaterialApp(
        tester,
        ValueListenableBuilder(
          valueListenable: rebuild,
          builder: (context, _, __) => freeScrollView(initialDate: base.add(const Duration(days: 2))),
        ),
      );

      final heightBefore = tester.getSize(find.byType(CalendarHeader)).height;

      // Force the header to build again, as a calendar item change would.
      rebuild.value++;
      await tester.pumpAndSettle();

      final heightAfter = tester.getSize(find.byType(CalendarHeader)).height;
      expect(heightAfter, closeTo(heightBefore, 0.5), reason: 'the header must not wobble on rebuild');
    });

    // Regression for #283: the header must fit the tallest day currently in
    // view, regardless of whether it is the leading day.
    Future<double> pumpAndMeasureHeader(WidgetTester tester, DateTime initialDate) async {
      eventsController = DefaultEventsController();
      calendarController = CalendarController();
      addTwoRowDay();
      await pumpAndSettleWithMaterialApp(tester, freeScrollView(initialDate: initialDate));
      return tester.getSize(find.byType(CalendarHeader)).height;
    }

    testWidgets('fits the tallest visible day, not just the leading day', (tester) async {
      // 26 Mar (two rows) as the leading day.
      final heightAsLeading = await pumpAndMeasureHeader(tester, base.add(const Duration(days: 2)));
      // 26 Mar visible as a trailing day (leading is 25 Mar, a single row).
      final heightAsTrailing = await pumpAndMeasureHeader(tester, base.add(const Duration(days: 1)));
      // A window of empty days for a single-row baseline.
      final heightEmpty = await pumpAndMeasureHeader(tester, base.add(const Duration(days: 12)));

      expect(
        heightAsTrailing,
        greaterThan(heightEmpty),
        reason: 'the header should grow to fit the two-row day while it is in view',
      );
      expect(
        heightAsTrailing,
        closeTo(heightAsLeading, 0.5),
        reason: 'header height must not depend on whether the tallest visible day is the leading day',
      );
    });
  });
}
