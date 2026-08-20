import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';

import '../utilities.dart';

/// [ResizeDetector] is findable without a key.
///
/// It is exported and carries [ResizeDetector.event] and [ResizeDetector.direction],
/// so a predicate picks out one handle where the type alone matches several.
/// Making either field private, or dropping the export, breaks these tests.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  late String eventId;
  late String otherId;

  final interaction = CalendarInteraction(
    allowResizing: true,
    allowRescheduling: true,
    inputMode: InputMode.precise,
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    eventId = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 4))),
    );
    otherId = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1, 10), end: DateTime(2025, 1, 1, 14))),
    );
  });

  tearDown(() {
    eventsController.dispose();
    calendarController.dispose();
  });

  Future<void> pumpDay(WidgetTester tester) {
    return pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.singleDay(
          displayRange: year2025DisplayRange,
          initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
          initialHeightPerMinute: 1,
          initialDateTime: DateTime(2025, 1, 1),
        ),
        body: CalendarBody(
          interaction: interaction,
          multiDayTileComponents: TileComponents(
            tileBuilder: (context, event, tileRange) => const SizedBox.expand(),
            verticalResizeHandle: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  /// The handle for [eventId] facing [direction].
  Finder handleFor(String eventId, ResizeDirection direction) {
    return find.byWidgetPredicate(
      (widget) => widget is ResizeDetector && widget.event.id == eventId && widget.direction == direction,
    );
  }

  testWidgets('the type alone matches more than one handle', (tester) async {
    await pumpDay(tester);
    await tester.hoverOn(find.byKey(DayEventTile.tileKey(eventId)), await tester.createMouseGesture());

    // A start and an end handle for the hovered tile.
    expect(find.byType(ResizeDetector), findsNWidgets(2));
  });

  testWidgets('the event and the direction narrow it to one', (tester) async {
    await pumpDay(tester);
    await tester.hoverOn(find.byKey(DayEventTile.tileKey(eventId)), await tester.createMouseGesture());

    expect(handleFor(eventId, ResizeDirection.top), findsOneWidget);
    expect(handleFor(eventId, ResizeDirection.bottom), findsOneWidget);

    // The tile that is not hovered contributes no handles.
    expect(handleFor(otherId, ResizeDirection.top), findsNothing);
    expect(handleFor(otherId, ResizeDirection.bottom), findsNothing);
  });

  testWidgets('scoping to a tile finds only that tile\'s handles', (tester) async {
    await pumpDay(tester);
    await tester.hoverOn(find.byKey(DayEventTile.tileKey(eventId)), await tester.createMouseGesture());

    // The recipe for a tree where the same event could be built more than once,
    // which a page kept alive or an overlay can do.
    final tile = find.byKey(DayEventTile.tileKey(eventId));
    final other = find.byKey(DayEventTile.tileKey(otherId));

    expect(find.descendant(of: tile, matching: find.byType(ResizeDetector)), findsNWidgets(2));
    expect(find.descendant(of: other, matching: find.byType(ResizeDetector)), findsNothing);
  });
}
