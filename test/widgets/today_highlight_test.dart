// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart';

import '../utilities.dart';

/// Today highlighting in a full [KalenderView] (#248, #251, #254).
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
  });

  Finder todayNumber(Key todayKey, int day) => find.descendant(of: find.byKey(todayKey), matching: find.text('$day'));

  group('Today highlighting in KalenderView (#254 #248 #251)', () {
    group('MonthView', () {
      Future<void> pumpMonth(
        WidgetTester tester,
        DateTime month, {
        NowCallback? nowCallback,
        KalenderComponents? components,
        Location? location,
      }) => pumpAndSettleWithMaterialApp(
        tester,
        KalenderView(
          eventsController: eventsController,
          kalenderController: kalenderController,
          location: location,
          components: components,
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: KalenderDateTimeRange(
              start: DateTime(month.year, month.month - 1),
              end: DateTime(month.year, month.month + 2),
            ),
            initialDateTime: month,
            nowCallback: nowCallback,
          ),
          body: const KalenderBody(),
        ),
      );

      testWidgets('highlights exactly the real today (default location path)', (tester) async {
        final now = DateTime.now();
        await pumpMonth(tester, DateTime(now.year, now.month));

        expect(find.byKey(MonthDayHeader.todayKey), findsOneWidget);
        expect(todayNumber(MonthDayHeader.todayKey, now.day), findsOneWidget);
      });

      testWidgets('highlights the callback day, not its neighbour (#251)', (tester) async {
        await pumpMonth(tester, DateTime(2025, 12), nowCallback: () => DateTime(2025, 12, 24, 10));

        expect(find.byKey(MonthDayHeader.todayKey), findsOneWidget);
        expect(todayNumber(MonthDayHeader.todayKey, 24), findsOneWidget);
        expect(todayNumber(MonthDayHeader.todayKey, 23), findsNothing);
      });

      testWidgets('highlights correctly on a month boundary', (tester) async {
        await pumpMonth(tester, DateTime(2025, 12), nowCallback: () => DateTime(2025, 12, 31, 23));

        expect(find.byKey(MonthDayHeader.todayKey), findsOneWidget);
        expect(todayNumber(MonthDayHeader.todayKey, 31), findsOneWidget);
      });

      tz.initializeTimeZones();
      final newYork = getLocation('America/New_York');
      final builderCases = <({String name, Location? location, Matcher date})>[
        (
          name: 'custom builder receives localized (non-UTC) dates (#248)',
          location: null,
          date: isA<DateTime>().having((date) => date.isUtc, 'isUtc', isFalse),
        ),
        (
          name: 'custom builder receives TZDateTime for a configured location (#248)',
          location: newYork,
          date: isA<TZDateTime>().having((date) => date.location, 'location', newYork),
        ),
      ];

      for (final c in builderCases) {
        testWidgets(c.name, (tester) async {
          final received = <DateTime>[];
          await pumpMonth(
            tester,
            DateTime(2025, 12),
            location: c.location,
            components: KalenderComponents(
              monthComponents: MonthComponents(
                bodyComponents: MonthBodyComponents(
                  monthDayHeaderBuilder: (context, date) {
                    received.add(date);
                    return MonthDayHeader(date: date);
                  },
                ),
              ),
            ),
          );

          expect(received, isNotEmpty);
          expect(received, everyElement(c.date));
        });
      }
    });

    group('MultiDayView header', () {
      final monday = DateTime(2026, 4, 13);
      final weekRange = KalenderDateTimeRange(start: monday, end: monday.add(const Duration(days: 7)));

      Future<void> pumpWeek(WidgetTester tester, {NowCallback? nowCallback}) => pumpAndSettleWithMaterialApp(
        tester,
        KalenderView(
          eventsController: eventsController,
          kalenderController: kalenderController,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: weekRange,
            initialDateTime: monday,
            nowCallback: nowCallback,
          ),
          header: const KalenderHeader(),
          body: const KalenderBody(),
        ),
      );

      testWidgets('highlights exactly the callback day', (tester) async {
        await pumpWeek(tester, nowCallback: () => DateTime(2026, 4, 15, 12));

        expect(find.byKey(DayHeader.todayKey), findsOneWidget);
        expect(todayNumber(DayHeader.todayKey, 15), findsOneWidget);
      });

      testWidgets('does not highlight any day when today is outside the visible range', (tester) async {
        await pumpWeek(tester, nowCallback: () => DateTime(2026, 4, 22, 12));

        expect(find.byKey(DayHeader.todayKey), findsNothing);
      });
    });
  });
}
