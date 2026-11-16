// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart';

import '../utilities.dart';

void main() {
  setUpAll(tz.initializeTimeZones);
  final monday = FloatingDateTime(2026, 4, 13); // The callback "today"
  final tuesday = FloatingDateTime(2026, 4, 14);
  final wednesday = FloatingDateTime(2026, 4, 15);

  final withCallback = MultiDayViewConfiguration.week(nowCallback: () => DateTime(2026, 4, 13, 14, 30));

  Future<void> pump(
    WidgetTester tester, {
    required Widget child,
    required MultiDayViewConfiguration viewConfiguration,
    Location? location,
  }) {
    final kalenderController = KalenderController(viewConfiguration: viewConfiguration, location: location);
    final eventsController = DefaultEventsController();

    return pumpAndSettleWithMaterialApp(
      tester,
      TestProvider(
        kalenderController: kalenderController,
        eventsController: eventsController,
        tileComponents: TileComponents.defaultComponents(),
        location: location,
        child: child,
      ),
    );
  }

  final widgets = [
    (
      name: 'DayHeader',
      build: (FloatingDateTime date) => DayHeader(date: date),
      todayKey: DayHeader.todayKey,
      otherDay: tuesday,
      overridesLocation: true,
    ),
    (
      name: 'MonthDayHeader',
      build: (FloatingDateTime date) => MonthDayHeader(date: date),
      todayKey: MonthDayHeader.todayKey,
      otherDay: wednesday,
      overridesLocation: false,
    ),
    (
      name: 'ScheduleDate',
      build: (FloatingDateTime date) => ScheduleDate(date: date),
      todayKey: ScheduleDate.todayKey,
      otherDay: tuesday,
      overridesLocation: true,
    ),
  ];

  for (final w in widgets) {
    group('${w.name} uses nowCallback for today highlighting', () {
      testWidgets('highlights the day matching the callback', (tester) async {
        await pump(tester, viewConfiguration: withCallback, child: w.build(monday));

        expect(find.byKey(w.todayKey), findsOneWidget);
      });

      testWidgets('does not highlight a day that does not match the callback', (tester) async {
        await pump(tester, viewConfiguration: withCallback, child: w.build(w.otherDay));

        expect(find.byKey(w.todayKey), findsNothing);
      });

      testWidgets('reads the clock when the callback is null', (tester) async {
        await withClock(Clock.fixed(DateTime(2026, 4, 13, 12)), () async {
          final viewConfiguration = MultiDayViewConfiguration.week();

          await pump(tester, viewConfiguration: viewConfiguration, child: w.build(monday));
          expect(find.byKey(w.todayKey), findsOneWidget);

          await pump(tester, viewConfiguration: viewConfiguration, child: w.build(w.otherDay));
          expect(find.byKey(w.todayKey), findsNothing);
        });
      });

      if (w.overridesLocation) {
        testWidgets('callback overrides location (UTC location, local callback)', (tester) async {
          await pump(tester, viewConfiguration: withCallback, location: getLocation('Etc/UTC'), child: w.build(monday));

          expect(find.byKey(w.todayKey), findsOneWidget);
        });
      }
    });
  }
}
