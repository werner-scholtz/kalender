import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/expandable_page_view.dart' show ExpandablePageView;

import '../utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  late CalendarCallbacks callbacks;

  final tileComponents = TileComponents(
    tileBuilder: (event, tileRange) => Container(key: ValueKey(event.id), color: Colors.red),
  );
  final scheduleTileComponents = ScheduleTileComponents(
    tileBuilder: (event, tileRange) => Container(key: ValueKey(event.id), color: Colors.blue),
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    callbacks = CalendarCallbacks(
      onEventCreated: eventsController.addEvent,
      onEventChanged: (event, updatedEvent) => eventsController.updateEvent(event: event, updatedEvent: updatedEvent),
    );
  });

  group('FreeScroll header', () {
    /// Rebuilds the [CalendarView] whenever [rebuild] changes so the test can
    /// force the FreeScroll header to build again, mirroring what happens in a
    /// real app whenever a calendar item changes.
    Future<ValueNotifier<int>> pumpFreeScrollView(WidgetTester tester) async {
      final rebuild = ValueNotifier(0);
      addTearDown(rebuild.dispose);

      // Kept stable across rebuilds (as a real app would cache it) so the view
      // controller — and therefore the header controller — is not recreated;
      // this isolates the header's own key handling as the only variable.
      final viewConfiguration = MultiDayViewConfiguration.freeScroll(numberOfDays: 3);

      await pumpAndSettleWithMaterialApp(
        tester,
        ValueListenableBuilder(
          valueListenable: rebuild,
          builder: (context, _, __) => CalendarView(
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: viewConfiguration,
            callbacks: callbacks,
            header: CalendarHeader(multiDayTileComponents: tileComponents),
            body: CalendarBody(
              multiDayTileComponents: tileComponents,
              monthTileComponents: tileComponents,
              scheduleTileComponents: scheduleTileComponents,
            ),
          ),
        ),
      );

      return rebuild;
    }

    // Regression for #282: the FreeScroll header used `key: UniqueKey()` on its
    // `ExpandablePageView`, so every rebuild minted a new key and Flutter
    // destroyed and recreated the page view's State — resetting its measured
    // per-page heights and making the header visibly "wobble" whenever an item
    // on the calendar changed. Keying on the stable header controller keeps the
    // State alive across rebuilds.
    testWidgets('preserves ExpandablePageView state across rebuilds', (tester) async {
      final rebuild = await pumpFreeScrollView(tester);

      final pageView = find.byType(ExpandablePageView);
      expect(pageView, findsOneWidget, reason: 'FreeScroll header should render an ExpandablePageView');

      final stateBefore = tester.state(pageView);

      // Force the header to build again, as a calendar item change would.
      rebuild.value++;
      await tester.pumpAndSettle();

      final stateAfter = tester.state(find.byType(ExpandablePageView));
      expect(
        identical(stateBefore, stateAfter),
        isTrue,
        reason: 'ExpandablePageView State must survive a header rebuild; a fresh '
            'UniqueKey() each build would recreate it and reset measured heights.',
      );
    });

    // Regression for the FreeScroll header clipping busier days: each day is its
    // own page (viewportFraction 1/numberOfDays) and several are visible at once,
    // but the header used to size itself to the *current* page only. A day with
    // two stacked multi-day events was clipped whenever it was not the leading
    // page. The header must instead fit the tallest day currently in view.
    Future<double> pumpAndMeasureHeader(WidgetTester tester, DateTime initialDate) async {
      // Fresh controllers per pump so each starts at its own initial date.
      eventsController = DefaultEventsController();
      calendarController = CalendarController();

      final base = DateTime(2025, 3, 24); // Monday
      // Two overlapping multi-day events give 25 Mar a single row, 26 Mar two
      // rows (both events), and 27 Mar a single row.
      eventsController.addEvents([
        CalendarEvent(
            dateTimeRange:
                DateTimeRange(start: base.add(const Duration(days: 1)), end: base.add(const Duration(days: 3)))),
        CalendarEvent(
            dateTimeRange:
                DateTimeRange(start: base.add(const Duration(days: 2)), end: base.add(const Duration(days: 4)))),
      ]);

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.freeScroll(
            numberOfDays: 3,
            initialDateTime: initialDate,
            displayRange: DateTimeRange(start: base, end: base.add(const Duration(days: 21))),
          ),
          callbacks: callbacks,
          header: CalendarHeader(multiDayTileComponents: tileComponents),
          body: CalendarBody(
            multiDayTileComponents: tileComponents,
            monthTileComponents: tileComponents,
            scheduleTileComponents: scheduleTileComponents,
          ),
        ),
      );

      return tester.getSize(find.byType(ExpandablePageView)).height;
    }

    testWidgets('fits the tallest visible day, not just the leading page', (tester) async {
      final base = DateTime(2025, 3, 24);
      // 26 Mar (two rows) as the leading page.
      final heightAsLeading = await pumpAndMeasureHeader(tester, base.add(const Duration(days: 2)));
      // 26 Mar visible as a trailing page (leading is 25 Mar, a single row).
      final heightAsTrailing = await pumpAndMeasureHeader(tester, base.add(const Duration(days: 1)));
      // A window of empty days for a single-row baseline.
      final heightEmpty = await pumpAndMeasureHeader(tester, base.add(const Duration(days: 12)));

      expect(
        heightAsTrailing,
        greaterThan(heightEmpty),
        reason: 'The header should grow to fit the two-row day while it is in view.',
      );
      expect(
        heightAsTrailing,
        closeTo(heightAsLeading, 0.5),
        reason: 'Header height must not depend on whether the tallest visible day '
            'is the leading page; sizing to the current page only clips trailing days.',
      );
    });
  });
}
