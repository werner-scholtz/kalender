import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

// The free-scroll header's continuous multi-day band must support the same
// interactions as the paged headers: creating a multi-day event by dragging
// across days.
void main() {
  final start = DateTime(2025, 3, 24); // Monday
  final displayRange = KalenderDateTimeRange(start: start, end: start.add(const Duration(days: 21)));

  late DefaultEventsController eventsController;
  late KalenderController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = KalenderController();
  });

  final components = TileComponents(
    tileBuilder: (context, event, tileRange) => Container(key: ValueKey('inner-${event.id}'), color: Colors.red),
  );

  final precise = KalenderInteraction(
    inputMode: InputMode.precise,
    createEventGesture: EventInteractionGesture.tap,
    modifyEventGesture: EventInteractionGesture.tap,
  );

  MultiDayViewController viewController() => calendarController.viewController as MultiDayViewController;

  Future<void> pumpFreeScroll(WidgetTester tester, KalenderCallbacks callbacks) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.freeScroll(
          numberOfDays: 7,
          displayRange: displayRange,
          initialDateTime: start,
          initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
        ),
        callbacks: callbacks,
        header: KalenderHeader(multiDayTileComponents: components, interaction: precise),
        body: KalenderBody(multiDayTileComponents: components, interaction: precise),
      ),
    );
  }

  testWidgets('dragging across the header creates a multi-day event', (tester) async {
    KalenderEvent? created;
    KalenderEvent? confirmed;

    await pumpFreeScroll(
      tester,
      KalenderCallbacks(
        onEventCreate: (event) {
          created = event;
          return event;
        },
        onEventCreated: (event) => confirmed = event,
      ),
    );

    expect(created, isNull);
    expect(confirmed, isNull);

    // Drag horizontally across the multi-day band (the lower part of the
    // header, empty since there are no events yet) to span several days.
    final headerRect = tester.getRect(find.byType(KalenderHeader));
    final startPoint = Offset(headerRect.left + headerRect.width * 0.25, headerRect.bottom - 4);
    await tester.dragFrom(startPoint, Offset(headerRect.width * 0.4, 0));
    await tester.pumpAndSettle();

    expect(created, isNotNull, reason: 'a drag across the header should create an event');
    expect(confirmed, isNotNull, reason: 'the created event should be confirmed');
    expect(
      created!.spansMultipleDays(location: null, defaultRule: kDefaultMultiDayRule),
      isTrue,
      reason: 'dragging across days should create a multi-day event',
    );
  });

  testWidgets('dragging an existing multi-day tile reschedules it', (tester) async {
    KalenderEvent? changedBefore;
    KalenderEvent? changedAfter;

    // A 3-day event inside the first visible week.
    final id = eventsController.addEvent(
      KalenderEvent(
        start: start.add(const Duration(days: 1)),
        end: start.add(const Duration(days: 4)),
      ),
    );

    await pumpFreeScroll(
      tester,
      KalenderCallbacks(
        onEventChange: (event) => changedBefore = event,
        onEventChanged: (_, updated) => changedAfter = updated,
      ),
    );

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    expect(tile, findsOneWidget);
    expect(changedBefore, isNull);
    expect(changedAfter, isNull);

    // Drag the tile one day to the right.
    final dayWidth = tester.getSize(find.byType(KalenderView)).width / 7;
    await tester.drag(tile, Offset(dayWidth, 0));
    await tester.pumpAndSettle();

    expect(changedBefore, isNotNull, reason: 'dragging a multi-day tile should reschedule it');
    expect(changedAfter, isNotNull, reason: 'the reschedule should be confirmed');
  });

  testWidgets('dragging an event to the viewport edge scrolls to adjacent days', (tester) async {
    final id = eventsController.addEvent(
      KalenderEvent(
        start: start.add(const Duration(days: 1)),
        end: start.add(const Duration(days: 3)),
      ),
    );

    await pumpFreeScroll(
      tester,
      KalenderCallbacks(
        onEventChange: (event) => event,
        onEventChanged: (_, __) {},
      ),
    );

    final controller = viewController().pageController;
    final pageBefore = controller.page ?? 0;

    final tile = find.byKey(MultiDayEventTile.tileKey(id));
    expect(tile, findsOneWidget);
    final headerRect = tester.getRect(find.byType(KalenderHeader));
    final tileCenter = tester.getCenter(tile);

    // Start a reschedule drag and hold it over the right viewport edge.
    final gesture = await tester.startGesture(tileCenter);
    await tester.pump();
    await gesture.moveTo(Offset(headerRect.right - 2, tileCenter.dy));
    await tester.pump(); // the edge trigger's drag target starts its timer
    // The trigger fires after its 750ms delay, then the page animates (300ms).
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 350));
    await gesture.up();
    await tester.pumpAndSettle();

    final pageAfter = viewController().pageController.page ?? 0;
    expect(pageAfter, greaterThan(pageBefore), reason: 'holding a drag at the edge should scroll toward it');
  });
}
