import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';

import '../utilities.dart';

/// A widget that mixes in [DayEventTileUtils], used to exercise the public
/// day-tile helper API from a real [BuildContext].
class _DayTileHarness extends StatelessWidget with DayEventTileUtils {
  _DayTileHarness({required this.event, required this.tileRange});

  @override
  final CalendarEvent event;

  @override
  final DateTimeRange tileRange;

  @override
  Widget build(BuildContext context) => const SizedBox(width: 100, height: 600);
}

/// A widget that mixes in [MultiDayEventTileUtils], used to exercise the public
/// multi-day-tile helper API from a real [BuildContext].
class _MultiDayTileHarness extends StatelessWidget with MultiDayEventTileUtils {
  _MultiDayTileHarness({required this.event, required this.tileRange});

  @override
  final CalendarEvent event;

  @override
  final DateTimeRange tileRange;

  @override
  Widget build(BuildContext context) => const SizedBox(width: 300, height: 50);
}

void main() {
  initializeTimeZones();

  // A UTC location keeps wall-clock arithmetic equal to the UTC inputs so these
  // tests are deterministic regardless of the `TZ` the suite runs under.
  final utcLocation = getLocation('Etc/UTC');

  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController(locations: [utcLocation]);
    calendarController = CalendarController();
  });

  tearDown(() {
    eventsController.dispose();
    calendarController.dispose();
  });

  Future<BuildContext> pumpHarness(WidgetTester tester, Widget harness) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      wrapWithMaterialApp(
        TestProvider(
          calendarController: calendarController,
          eventsController: eventsController,
          tileComponents: TileComponents(tileBuilder: (event, range) => const SizedBox()),
          location: utcLocation,
          heightPerMinute: ValueNotifier(1.0),
          child: KeyedSubtree(key: key, child: harness),
        ),
      ),
    );
    await tester.pump();
    return key.currentContext!;
  }

  // ─── DayEventTileUtils ───────────────────────────────────────────────────────

  group('DayEventTileUtils', () {
    final event = CalendarEvent(
      dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 1, 15, 9), end: DateTime.utc(2024, 1, 15, 10)),
    );
    final tileRange = DateTimeRange(start: DateTime.utc(2024, 1, 15), end: DateTime.utc(2024, 1, 16));

    testWidgets('internalTileRange converts the tile range using the location', (tester) async {
      final harness = _DayTileHarness(event: event, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      final range = harness.internalTileRange(context);
      expect(range.start, equals(InternalDateTime(2024, 1, 15)));
      expect(range.end, equals(InternalDateTime(2024, 1, 16)));
    });

    testWidgets('eventRangeOnDate clips the event to the tile date', (tester) async {
      final harness = _DayTileHarness(event: event, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      final range = harness.eventRangeOnDate(context);
      expect(range.start.hour, equals(9));
      expect(range.end.hour, equals(10));
    });

    testWidgets('dateTimeFromPosition maps a vertical offset to a time', (tester) async {
      final harness = _DayTileHarness(event: event, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      // heightPerMinute is 1.0, so dy of 30 == 30 minutes past the event start (09:00).
      final time = harness.dateTimeFromPosition(context, const Offset(0, 30));
      expect(time.hour, equals(9));
      expect(time.minute, equals(30));
    });

    testWidgets('nearbyEvents returns overlapping events within the window and excludes self', (tester) async {
      // Self event 09:00-10:00.
      final selfId = eventsController.addEvent(event);
      // Within a +/-30min window of 09:00-10:00 (08:30-10:30).
      final nearbyId = eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 1, 15, 8), end: DateTime.utc(2024, 1, 15, 8, 45)),
        ),
      );
      // Outside the window.
      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 1, 15, 11), end: DateTime.utc(2024, 1, 15, 12)),
        ),
      );

      final harness = _DayTileHarness(event: eventsController.byId(selfId)!, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      final nearby = harness.nearbyEvents(
        context,
        before: const Duration(minutes: 30),
        after: const Duration(minutes: 30),
      );

      final ids = nearby.map((e) => e.id).toSet();
      expect(ids, contains(nearbyId));
      expect(ids, isNot(contains(selfId)), reason: 'includeSelf defaults to false');
      expect(ids, hasLength(1), reason: 'the 11:00 event is outside the +/-30min window');
    });

    testWidgets('nearbyEvents can include self', (tester) async {
      final selfId = eventsController.addEvent(event);
      final harness = _DayTileHarness(event: eventsController.byId(selfId)!, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      final nearby = harness.nearbyEvents(context, includeSelf: true);
      expect(nearby.map((e) => e.id), contains(selfId));
    });
  });

  // ─── MultiDayEventTileUtils ──────────────────────────────────────────────────

  group('MultiDayEventTileUtils', () {
    final event = CalendarEvent(
      dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 1, 15, 9), end: DateTime.utc(2024, 1, 17, 18)),
    );
    final tileRange = DateTimeRange(start: DateTime.utc(2024, 1, 15), end: DateTime.utc(2024, 1, 18));

    testWidgets('dateFromPosition maps a horizontal offset to the right day', (tester) async {
      final harness = _MultiDayTileHarness(event: event, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      // 3-day span across a 300px-wide tile → 100px per day. dx 150 → day index 1 → Jan 16.
      final date = harness.dateFromPosition(context, const Offset(150, 0));
      expect(date.year, equals(2024));
      expect(date.month, equals(1));
      expect(date.day, equals(16));
    });

    testWidgets('dateFromPosition first column resolves to the start day', (tester) async {
      final harness = _MultiDayTileHarness(event: event, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      final date = harness.dateFromPosition(context, const Offset(10, 0));
      expect(date.day, equals(15));
    });

    testWidgets('nearbyEvents includes multi-day events by default', (tester) async {
      final selfId = eventsController.addEvent(event);
      final otherMultiDayId = eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 1, 16), end: DateTime.utc(2024, 1, 18)),
        ),
      );

      final harness = _MultiDayTileHarness(event: eventsController.byId(selfId)!, tileRange: tileRange);
      final context = await pumpHarness(tester, harness);
      final nearby = harness.nearbyEvents(context);

      final ids = nearby.map((e) => e.id).toSet();
      expect(ids, contains(otherMultiDayId));
      expect(ids, isNot(contains(selfId)), reason: 'includeSelf defaults to false');
    });
  });
}
