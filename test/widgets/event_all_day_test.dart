import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

/// `isAllDay` decides the lane on its own, so an event carrying it renders in
/// the header whatever the view's rule says and whatever its duration is.
void main() {
  late DefaultEventsController eventsController;
  late KalenderController calendarController;

  final start = DateTime(2025, 1, 6); // A Monday.

  // One hour, inside a single calendar day. Neither built-in rule calls this
  // multi-day, so only the flag can put it in the header.
  final shortRange = KalenderDateTimeRange(
    start: start.add(const Duration(days: 1, hours: 9)),
    end: start.add(const Duration(days: 1, hours: 10)),
  );

  final interaction = KalenderInteraction(
    inputMode: InputMode.precise,
    createEventGesture: EventInteractionGesture.tap,
    modifyEventGesture: EventInteractionGesture.tap,
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = KalenderController();
  });

  Future<void> pumpWeek(WidgetTester tester, MultiDayRule rule, {KalenderCallbacks? callbacks}) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        calendarController: calendarController,
        callbacks: callbacks,
        viewConfiguration: MultiDayViewConfiguration.week(
          displayRange: year2025DisplayRange,
          initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
          initialDateTime: start,
          multiDayRule: rule,
        ),
        header: KalenderHeader(interaction: interaction),
        body: KalenderBody(interaction: interaction),
      ),
    );
  }

  testWidgets('an hour-long all-day event renders in the header', (tester) async {
    final id = eventsController.addEvent(KalenderEvent(start: shortRange.start, end: shortRange.end, isAllDay: true));

    await pumpWeek(tester, const MultiDayRule.minimumDuration(Duration(hours: 24)));

    expect(find.byKey(MultiDayEventTile.tileKey(id)), findsOneWidget);
    expect(find.byKey(DayEventTile.tileKey(id)), findsNothing);
  });

  testWidgets('the same event without the flag stays in the body', (tester) async {
    final id = eventsController.addEvent(KalenderEvent(start: shortRange.start, end: shortRange.end));

    await pumpWeek(tester, const MultiDayRule.minimumDuration(Duration(hours: 24)));

    expect(find.byKey(DayEventTile.tileKey(id)), findsWidgets);
    expect(find.byKey(MultiDayEventTile.tileKey(id)), findsNothing);
  });

  testWidgets('the view rule cannot pull it back into the body', (tester) async {
    // A rule nothing satisfies. The flag still decides.
    final id = eventsController.addEvent(KalenderEvent(start: shortRange.start, end: shortRange.end, isAllDay: true));

    await pumpWeek(tester, const MultiDayRule.minimumDuration(Duration(days: 365)));

    expect(find.byKey(MultiDayEventTile.tileKey(id)), findsOneWidget);
    expect(find.byKey(DayEventTile.tileKey(id)), findsNothing);
  });

  testWidgets('rescheduling it in the header keeps it all-day', (tester) async {
    final id = eventsController.addEvent(KalenderEvent(start: shortRange.start, end: shortRange.end, isAllDay: true));

    KalenderEvent? changed;
    await pumpWeek(
      tester,
      const MultiDayRule.minimumDuration(Duration(hours: 24)),
      callbacks: KalenderCallbacks(onEventChanged: (_, updated) => changed = updated),
    );

    final original = eventsController.byId(id)!;
    final dayWidth = tester.getSize(find.byType(KalenderView)).width / 7;

    final gesture = await tester.startGesture(tester.getCenter(find.byKey(MultiDayEventTile.tileKey(id))));
    await tester.pump(const Duration(milliseconds: 100));
    await gesture.moveBy(Offset(dayWidth * 2, 0));
    await tester.pumpAndSettle();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(changed, isNotNull, reason: 'a short all-day event has to be draggable in the header at all');
    expect(changed!.start.day, isNot(equals(original.start.day)), reason: 'the drag has to have moved it');
    expect(changed!.isAllDay, isTrue);
    expect(changed!.duration, equals(original.duration), reason: 'the range is the app\'s, not the calendar\'s');
  });
}
