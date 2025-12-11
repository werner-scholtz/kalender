import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart';

final locationsToTest = [
  'UTC',
  'Africa/Johannesburg',
  'America/New_York',
  'Europe/London',
  'Australia/Sydney',
];

void main() {
  initializeTimeZones();
  final locations = locationsToTest.map(getLocation).toList();
  for (final location in locations) {
    final range = DateTimeRange(start: TZDateTime(location, 2025), end: TZDateTime(location, 2026));
    final visibleRange = InternalDateTimeRange(start: InternalDateTime(2025), end: InternalDateTime(2025, 2));
    final visibleEvents = ValueNotifier(<CalendarEvent>{});

    group('ViewConfiguration from Month for $location', () {
      final viewController = MonthViewController(
        viewConfiguration: MonthViewConfiguration.singleMonth(displayRange: range),
        visibleDateTimeRange: ValueNotifier(visibleRange),
        visibleEvents: visibleEvents,
        initialDate: InternalDateTime(2025, 1, 1),
      );

      test('kDefaultToMonthly', () {
        final initialDate = kDefaultToMonthly(
          oldViewController: viewController,
          newViewConfiguration: MonthViewConfiguration.singleMonth(displayRange: range),
        );
        final expected = InternalDateTime(2025, 1, 1);
        expect(
          initialDate,
          expected,
          reason: 'Monthly to Monthly expected $expected but got $initialDate\n',
        );
      });

      test('kDefaultToWeekly', () {
        final initialDate = kDefaultToWeekly(
          oldViewController: viewController,
          newViewConfiguration: MultiDayViewConfiguration.week(displayRange: range),
        );
        final expected = InternalDateTime(2024, 12, 30);
        expect(initialDate, expected, reason: 'Monthly to Weekly expected $expected but got $initialDate\n');
      });

      test('kDefaultToDaily', () {
        final initialDate = kDefaultToDaily(
          oldViewController: viewController,
          newViewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: range),
        );
        final expected = InternalDateTime(2025, 1, 1);
        expect(initialDate, expected, reason: 'Monthly to Daily expected $expected but got $initialDate\n');
      });
    });

    group('ViewConfiguration from week for $location', () {
      final viewController = MultiDayViewController(
        viewConfiguration: MultiDayViewConfiguration.week(displayRange: range),
        visibleDateTimeRange: ValueNotifier(visibleRange),
        visibleEvents: visibleEvents,
        initialDate: InternalDateTime(2025, 1, 1),
      );

      test('kDefaultToMonthly', () {
        final initialDate = kDefaultToMonthly(
          oldViewController: viewController,
          newViewConfiguration: MonthViewConfiguration.singleMonth(displayRange: range),
        );

        final expected = InternalDateTime(2024, 12, 30);
        expect(initialDate, expected, reason: 'Weekly to Monthly expected $expected but got $initialDate\n');
      });
      test('kDefaultToWeekly', () {
        final initialDate = kDefaultToWeekly(
          oldViewController: viewController,
          newViewConfiguration: MultiDayViewConfiguration.week(displayRange: range),
        );

        final expected = InternalDateTime(2024, 12, 30);
        expect(initialDate, expected, reason: 'Weekly to Weekly expected $expected but got $initialDate\n');
      });

      test('kDefaultToDaily', () {
        final initialDate = kDefaultToDaily(
          oldViewController: viewController,
          newViewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: range),
        );
        final expected = InternalDateTime(2024, 12, 30);
        expect(initialDate, expected, reason: 'Weekly to Daily expected $expected but got $initialDate\n');
      });
    });

    group('ViewConfiguration from day for $location', () {
      final viewController = MultiDayViewController(
        viewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: range),
        visibleDateTimeRange: ValueNotifier(visibleRange),
        visibleEvents: visibleEvents,
        initialDate: InternalDateTime(2025, 1, 1),
      );

      test('kDefaultToMonthly', () {
        final initialDate = kDefaultToMonthly(
          oldViewController: viewController,
          newViewConfiguration: MonthViewConfiguration.singleMonth(displayRange: range),
        );

        final expected = InternalDateTime(2025, 1, 1);
        expect(initialDate, expected, reason: 'Daily to Monthly expected $expected but got $initialDate\n');
      });
      test('kDefaultToWeekly', () {
        final initialDate = kDefaultToWeekly(
          oldViewController: viewController,
          newViewConfiguration: MultiDayViewConfiguration.week(displayRange: range),
        );
        final expected = InternalDateTime(2025, 1, 1);
        expect(initialDate, expected, reason: 'Daily to Weekly expected $expected but got $initialDate\n');
      });

      test('kDefaultToDaily', () {
        final initialDate = kDefaultToDaily(
          oldViewController: viewController,
          newViewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: range),
        );

        final expected = InternalDateTime(2025, 1, 1);
        expect(initialDate, expected, reason: 'Daily to Daily expected $expected but got $initialDate\n');
      });
    });
  }
}
