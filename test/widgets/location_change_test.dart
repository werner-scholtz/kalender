// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart';

import '../utilities.dart';

/// Changing [KalenderView.location] keeps the page on screen. `initialDateTime` only applies when the calendar is
/// first built.
void main() {
  tz.initializeTimeZones();
  final newYork = getLocation('America/New_York');
  final tokyo = getLocation('Asia/Tokyo');
  final displayRange = KalenderDateTimeRange(start: DateTime.utc(2026), end: DateTime.utc(2027));

  // Monday in Tokyo, Sunday in New York, so the two locations open on different weeks.
  final initialDateTime = DateTime.utc(2026, 4, 19, 20);
  final june = DateTime.utc(2026, 6, 10, 12);

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
  });

  Future<void> pumpView(WidgetTester tester, ViewConfiguration config, Location location) {
    return pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      location: location,
      viewConfiguration: config,
      body: const KalenderBody(),
    );
  }

  FloatingDateTime visibleStart() => kalenderController.floatingVisibleRange.value!.start;

  testWithTimeZones(
    body: (timezone, _) {
      group('Changing the location', () {
        testWidgets('keeps the page on screen when initialDateTime is set', (tester) async {
          final config = MultiDayViewConfiguration.week(displayRange: displayRange, initialDateTime: initialDateTime);
          await pumpView(tester, config, tokyo);
          final beforeSwitch = visibleStart();

          await pumpView(tester, config, newYork);

          expect(visibleStart(), beforeSwitch);
        });

        final navigatedCases = <({String name, ViewConfiguration config})>[
          (
            name: 'rather than returning to initialDateTime',
            config: MultiDayViewConfiguration.week(displayRange: displayRange, initialDateTime: initialDateTime),
          ),
          (name: 'when initialDateTime is not set', config: MultiDayViewConfiguration.week(displayRange: displayRange)),
          (
            name: 'in the month view',
            config: MonthViewConfiguration.singleMonth(displayRange: displayRange, initialDateTime: initialDateTime),
          ),
        ];

        for (final c in navigatedCases) {
          testWidgets('keeps a navigated page ${c.name}', (tester) async {
            await pumpView(tester, c.config, newYork);
            kalenderController.jumpToDate(june);
            await tester.pumpAndSettle();
            final beforeSwitch = visibleStart();

            await pumpView(tester, c.config, tokyo);

            expect(visibleStart(), beforeSwitch);
          });
        }

        testWidgets('tells a dateResolver whether the location changed', (tester) async {
          final locationChanged = <bool>[];
          FloatingDateTime record(ViewTransitionContext transition) {
            locationChanged.add(transition.locationChanged);
            return kCarryFocusDate(transition);
          }

          final week = MultiDayViewConfiguration.week(displayRange: displayRange, dateResolver: record);
          final day = MultiDayViewConfiguration.singleDay(displayRange: displayRange, dateResolver: record);
          await pumpView(tester, week, newYork);
          await pumpView(tester, week, tokyo);
          await pumpView(tester, day, tokyo);

          expect(locationChanged, [true, false]);
        });

        testWidgets('the schedule files each event under its day in the new location', (tester) async {
          // 14 January in New York, 15 January in Tokyo.
          eventsController.addEvent(
            KalenderEvent(start: DateTime.utc(2025, 1, 14, 20), end: DateTime.utc(2025, 1, 14, 21)),
          );

          final emptyDays = <int>{};
          final config = ScheduleViewConfiguration.continuous(
            displayRange: KalenderDateTimeRange(start: DateTime.utc(2025, 1, 12), end: DateTime.utc(2025, 1, 18)),
            initialDateTime: DateTime.utc(2025, 1, 14, 12),
          );
          final components = KalenderComponents(
            scheduleComponents: ScheduleComponents(
              emptyItemBuilder: (context, tileRange) {
                emptyDays.add(tileRange.start.day);
                return const SizedBox(height: 24);
              },
            ),
          );

          Future<void> pumpSchedule(Location location) {
            return pumpKalender(
              tester,
              eventsController: eventsController,
              kalenderController: kalenderController,
              location: location,
              components: components,
              viewConfiguration: config,
              body: KalenderBody(scheduleBodyConfiguration: ScheduleBodyConfiguration(emptyDay: EmptyDayBehavior.show)),
            );
          }

          await pumpSchedule(newYork);
          expect(emptyDays, isNot(contains(14)));
          expect(emptyDays, contains(15));

          emptyDays.clear();
          await pumpSchedule(tokyo);
          expect(emptyDays, isNot(contains(15)));
          expect(emptyDays, contains(14));
        });
      });
    },
  );
}
