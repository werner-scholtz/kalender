// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';

import '../utilities.dart';

/// Tests that `copyWith` on view configurations keeps or replaces the multi-day rule.
void main() {
  final displayRange = KalenderDateTimeRange(start: DateTime(2024), end: DateTime(2026));
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
      final configuration = MonthViewConfiguration.singleMonth(displayRange: displayRange, multiDayRule: calendarDays);
      expect(configuration.copyWith(showWeekNumbers: true).multiDayRule, calendarDays);
    });

    test('a new rule replaces the old one', () {
      final configuration = MultiDayViewConfiguration.week(displayRange: displayRange, multiDayRule: calendarDays);
      const replacement = MultiDayRule.minimumDuration(Duration(hours: 12));
      expect(configuration.copyWith(multiDayRule: replacement).multiDayRule, replacement);
    });
  });

  testWidgets('a rule swapped in through copyWith re-sorts the events', (tester) async {
    final eventsController = DefaultEventsController();

    // Crosses midnight but lasts under 24 hours, the only shape the two rules
    // classify differently.
    final id = eventsController.addEvent(
      KalenderEvent(start: DateTime(2025, 1, 15, 22), end: DateTime(2025, 1, 16, 2)),
    );
    final base = MultiDayViewConfiguration.week(displayRange: displayRange, initialDateTime: DateTime(2025, 1, 15));
    final kalenderController = KalenderController(viewConfiguration: base);
    addTearDown(kalenderController.dispose);

    await pumpKalender(tester, eventsController: eventsController, kalenderController: kalenderController);
    expect(find.byKey(DayEventTile.tileKey(id)), findsOneWidget, reason: 'the default rule keeps it in the timeline');
    expect(find.byKey(MultiDayEventTile.tileKey(id)), findsNothing);

    kalenderController.viewConfiguration = base.copyWith(multiDayRule: calendarDays);
    await tester.pumpAndSettle();
    expect(find.byKey(MultiDayEventTile.tileKey(id)), findsOneWidget, reason: 'calendarDays moves it to the header');
  });
}
