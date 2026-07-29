import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';

import '../utilities.dart';

/// The rule decides whether an event renders in the multi-day header or the day
/// timeline, so a configuration that drops it on `copyWith` silently resets how
/// every event is classified.
void main() {
  final displayRange = DateTimeRange(start: DateTime(2024), end: DateTime(2026));
  const calendarDays = MultiDayRule.calendarDays();

  group('copyWith keeps the rule', () {
    test('MultiDayViewConfiguration, for every view type', () {
      final configurations = [
        MultiDayViewConfiguration.singleDay(displayRange: displayRange, multiDayRule: calendarDays),
        MultiDayViewConfiguration.week(displayRange: displayRange, multiDayRule: calendarDays),
        MultiDayViewConfiguration.workWeek(displayRange: displayRange, multiDayRule: calendarDays),
        MultiDayViewConfiguration.custom(numberOfDays: 3, displayRange: displayRange, multiDayRule: calendarDays),
        MultiDayViewConfiguration.freeScroll(numberOfDays: 3, displayRange: displayRange, multiDayRule: calendarDays),
      ];

      for (final configuration in configurations) {
        expect(
          configuration.copyWith(firstDayOfWeek: 3).multiDayRule,
          calendarDays,
          reason: '${configuration.type} lost the rule',
        );
      }
    });

    test('MonthViewConfiguration', () {
      final configuration = MonthViewConfiguration.singleMonth(
        displayRange: displayRange,
        multiDayRule: calendarDays,
      );
      expect(configuration.copyWith(showWeekNumbers: true).multiDayRule, calendarDays);
    });

    test('a new rule replaces the old one', () {
      final configuration = MultiDayViewConfiguration.week(displayRange: displayRange, multiDayRule: calendarDays);
      const replacement = MultiDayRule.minimumDuration(Duration(hours: 12));
      expect(configuration.copyWith(multiDayRule: replacement).multiDayRule, replacement);
    });
  });

  testWidgets('a rule swapped in through copyWith re-sorts the events', (tester) async {
    final calendarController = CalendarController();
    final eventsController = DefaultEventsController();

    // Crosses midnight but lasts under 24 hours, the only shape the two rules
    // classify differently.
    final id = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 15, 22), end: DateTime(2025, 1, 16, 2)),
      ),
    );
    final base = MultiDayViewConfiguration.week(
      displayRange: displayRange,
      initialDateTime: DateTime(2025, 1, 15),
    );

    Widget build(MultiDayViewConfiguration configuration) {
      return CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: configuration,
        header: const CalendarHeader(),
        body: const CalendarBody(),
      );
    }

    await pumpAndSettleWithMaterialApp(tester, build(base));
    expect(find.byKey(DayEventTile.tileKey(id)), findsOneWidget, reason: 'the default rule keeps it in the timeline');
    expect(find.byKey(MultiDayEventTile.tileKey(id)), findsNothing);

    await pumpAndSettleWithMaterialApp(tester, build(base.copyWith(multiDayRule: calendarDays)));
    expect(find.byKey(MultiDayEventTile.tileKey(id)), findsOneWidget, reason: 'calendarDays moves it to the header');
  });
}
