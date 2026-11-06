// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart';

import '../utilities.dart';

/// The month and multi-day headers show one column per calendar day on pages that start on the day DST ends.
///
/// DST ended on Sunday 2026-11-01 in America/New_York, and on Sunday 2025-10-26 and 2026-10-25 in Europe/London. A
/// null location uses the device timezone. Covers issue #645.
void main() {
  tz.initializeTimeZones();
  final displayRange = KalenderDateTimeRange(start: DateTime.utc(2025), end: DateTime.utc(2027));
  const locations = [null, 'America/New_York', 'Europe/London'];

  late DefaultEventsController eventsController;
  setUp(() => eventsController = DefaultEventsController());
  tearDown(() => eventsController.dispose());

  Future<void> pump(WidgetTester tester, ViewConfiguration configuration, Location? location) {
    final kalenderController = KalenderController(viewConfiguration: configuration, location: location);
    addTearDown(kalenderController.dispose);
    return pumpKalender(tester, eventsController: eventsController, kalenderController: kalenderController);
  }

  List<FloatingDateTime> days(FloatingDateTime start, int count) => [
    for (var i = 0; i < count; i++) FloatingDateTime(start.year, start.month, start.day + i),
  ];

  testWithTimeZones(
    body: (timezone, _) {
      group('the month header', () {
        // Pages that start on 2026-11-01 and 2025-10-26.
        final months = [DateTime.utc(2026, 11, 15, 12), DateTime.utc(2025, 11, 15, 12)];

        for (final name in locations) {
          for (final initialDateTime in months) {
            testWidgets('reads Sunday to Saturday for ${initialDateTime.year}-11 in ${name ?? 'the device timezone'}', (
              tester,
            ) async {
              final location = name == null ? null : getLocation(name);
              final configuration = MonthViewConfiguration.singleMonth(
                displayRange: displayRange,
                initialDateTime: initialDateTime,
                firstDayOfWeek: DateTime.sunday,
              );
              await pump(tester, configuration, location);

              final labels = tester
                  .widgetList<WeekDayHeader>(find.byType(WeekDayHeader))
                  .map((header) => header.date.dayNameLocalized())
                  .toList();
              expect(labels, ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']);
            });
          }
        }
      });

      group('the multi-day header', () {
        final cases = [
          (description: 'a week starting 2026-11-01', start: FloatingDateTime(2026, 11, 1), numberOfDays: 7),
          (description: 'a week starting 2026-10-25', start: FloatingDateTime(2026, 10, 25), numberOfDays: 7),
          (description: 'a 3 day page starting 2026-11-01', start: FloatingDateTime(2026, 11, 1), numberOfDays: 3),
          (description: 'a 3 day page starting 2026-10-25', start: FloatingDateTime(2026, 10, 25), numberOfDays: 3),
        ];

        for (final name in locations) {
          for (final c in cases) {
            testWidgets('shows one column per day for ${c.description} in ${name ?? 'the device timezone'}', (
              tester,
            ) async {
              final location = name == null ? null : getLocation(name);
              final initialDateTime = c.start.add(const Duration(days: 1, hours: 12)).forLocation(location: location);
              final configuration = c.numberOfDays == 7
                  ? MultiDayViewConfiguration.week(
                      displayRange: displayRange,
                      initialDateTime: initialDateTime,
                      firstDayOfWeek: DateTime.sunday,
                    )
                  : MultiDayViewConfiguration.custom(
                      displayRange: KalenderDateTimeRange(
                        start: c.start.forLocation(location: location),
                        end: displayRange.end,
                      ),
                      initialDateTime: initialDateTime,
                      numberOfDays: c.numberOfDays,
                    );
              await pump(tester, configuration, location);

              final dates = tester
                  .widgetList<DayHeader>(find.byType(DayHeader))
                  .map((header) => FloatingDateTime.fromDateTime(header.date))
                  .toList();
              expect(dates, days(c.start, c.numberOfDays));
            });
          }
        }
      });
    },
  );
}
