import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;

import '../utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  final components = TileComponents(
    tileBuilder: (event, range) => Container(key: ValueKey(event.id), color: Colors.red),
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  /// Adds [count] one-hour timed events on 2025-01-01 starting at 00:00.
  void addEvents(int count) {
    for (var i = 0; i < count; i++) {
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 1, 0).add(Duration(minutes: i * 5)),
            end: DateTime(2025, 1, 1, 0).add(Duration(minutes: i * 5 + 30)),
          ),
        ),
      );
    }
  }

  Widget buildView({int? deferTileRenderingAbove}) {
    return CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: MultiDayViewConfiguration.singleDay(
        displayRange: year2025DisplayRange,
        initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
        initialDateTime: DateTime(2025, 1, 1),
        initialHeightPerMinute: 2,
      ),
      body: CalendarBody(
        multiDayTileComponents: components,
        multiDayBodyConfiguration: MultiDayBodyConfiguration(deferTileRenderingAbove: deferTileRenderingAbove),
      ),
    );
  }

  group('Deferred tile rendering', () {
    testWidgets('default config (null) renders all tiles immediately — no behaviour change', (tester) async {
      addEvents(30);
      await pumpAndSettleWithMaterialApp(tester, buildView());
      expect(find.byType(DayEventTile), findsNWidgets(30));
    });

    testWidgets('enabled + dense column defers tiles one frame, then renders them', (tester) async {
      addEvents(30);
      // First frame: dense column (> threshold) mounts deferred — no tiles yet.
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: buildView(deferTileRenderingAbove: 10))));
      expect(find.byType(DayEventTile), findsNothing, reason: 'tiles should be deferred on the first frame');

      // Subsequent frames: the post-frame flip renders the tiles.
      await tester.pumpAndSettle();
      expect(find.byType(DayEventTile), findsNWidgets(30), reason: 'tiles should appear after deferral');
    });

    testWidgets('enabled + sparse column (<= threshold) renders immediately, no deferral', (tester) async {
      addEvents(5);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: buildView(deferTileRenderingAbove: 10))));
      expect(find.byType(DayEventTile), findsNWidgets(5), reason: 'sparse column should not defer');
    });

    testWidgets('after ready, event updates render synchronously (no re-defer)', (tester) async {
      addEvents(30);
      await pumpAndSettleWithMaterialApp(tester, buildView(deferTileRenderingAbove: 10));
      expect(find.byType(DayEventTile), findsNWidgets(30));

      // Adding more events to an already-ready column must not re-trigger deferral.
      addEvents(5); // ids differ → 35 distinct events
      await tester.pump();
      expect(find.byType(DayEventTile), findsNWidgets(35), reason: 'updates to a ready column render immediately');
    });
  });
}
