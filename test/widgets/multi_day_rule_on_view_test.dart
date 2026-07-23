import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

/// The rule lives on the view configuration, so switching it has to move events
/// between the header and the body without the events themselves changing.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  late String eventId;

  final start = DateTime(2025, 1, 6); // A Monday.

  final interaction = CalendarInteraction(
    inputMode: InputMode.precise,
    createEventGesture: CreateEventGesture.tap,
    modifyEventGesture: CreateEventGesture.tap,
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    // 23:00 to 01:00. Two calendar days, two hours long, so the two rules
    // disagree about it and nothing else does.
    eventId = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: start.add(const Duration(days: 1, hours: 23)),
          end: start.add(const Duration(days: 2, hours: 1)),
        ),
      ),
    );
  });

  Future<void> pumpWeek(WidgetTester tester, MultiDayRule rule) {
    return pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.week(
          displayRange: year2025DisplayRange,
          initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
          initialDateTime: start,
          multiDayRule: rule,
        ),
        header: CalendarHeader(interaction: interaction),
        body: CalendarBody(interaction: interaction),
      ),
    );
  }

  testWidgets('the default rule keeps a cross-midnight event in the body', (tester) async {
    await pumpWeek(tester, const MultiDayRule.minimumDuration(Duration(hours: 24)));

    expect(find.byKey(DayEventTile.tileKey(eventId)), findsWidgets, reason: 'two hours long, so it is a day event');
    expect(find.byKey(MultiDayEventTile.tileKey(eventId)), findsNothing);
  });

  testWidgets('calendarDays moves the same event into the header', (tester) async {
    await pumpWeek(tester, const MultiDayRule.calendarDays());

    expect(find.byKey(MultiDayEventTile.tileKey(eventId)), findsOneWidget, reason: 'it covers two calendar days');
    expect(find.byKey(DayEventTile.tileKey(eventId)), findsNothing);
  });

  testWidgets('switching the rule needs no change to the events', (tester) async {
    await pumpWeek(tester, const MultiDayRule.minimumDuration(Duration(hours: 24)));
    expect(find.byKey(DayEventTile.tileKey(eventId)), findsWidgets);

    final before = eventsController.byId(eventId)!;

    // Only the view configuration changes. The controller is never touched.
    await pumpWeek(tester, const MultiDayRule.calendarDays());

    expect(find.byKey(MultiDayEventTile.tileKey(eventId)), findsOneWidget);
    expect(
      identical(eventsController.byId(eventId), before),
      isTrue,
      reason: 'the stored event must be the very same instance, not a rebuilt copy',
    );
  });

  testWidgets('an event override survives a change of view rule', (tester) async {
    eventsController.clearEvents();
    final pinned = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: start.add(const Duration(days: 1, hours: 23)),
          end: start.add(const Duration(days: 2, hours: 1)),
        ),
        multiDayRule: const MultiDayRule.calendarDays(),
      ),
    );

    // The view says duration, the event says calendar days. The event wins.
    await pumpWeek(tester, const MultiDayRule.minimumDuration(Duration(hours: 24)));
    expect(find.byKey(MultiDayEventTile.tileKey(pinned)), findsOneWidget);
    expect(find.byKey(DayEventTile.tileKey(pinned)), findsNothing);
  });
}
