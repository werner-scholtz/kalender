import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  group('ViewConfiguration from Month', () {
    final calendarRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));
    final dateTimeRange = ValueNotifier(DateTimeRange(start: DateTime(2025), end: DateTime(2025, 2)));
    final visibleEvents = ValueNotifier(<CalendarEvent>{});
    final monthViewConfiguration = MonthViewConfiguration.singleMonth(displayRange: calendarRange);
    final viewController = MonthViewController(
      viewConfiguration: monthViewConfiguration,
      visibleDateTimeRange: dateTimeRange,
      visibleEvents: visibleEvents,
      initialDate: DateTime(2025, 1, 1),
    );

    test('kDefaultToMonthly', () {
      final initialDate = kDefaultToMonthly(
        oldViewController: viewController,
        newViewConfiguration: MonthViewConfiguration.singleMonth(displayRange: calendarRange),
      );

      expect(initialDate, DateTime.utc(2025, 1, 1));
    });
    test('kDefaultToWeekly', () {
      final initialDate = kDefaultToWeekly(
        oldViewController: viewController,
        newViewConfiguration: MonthViewConfiguration.singleMonth(displayRange: calendarRange),
      );

      expect(initialDate, DateTime.utc(2024, 12, 30));
    });
    test('kDefaultToDaily', () {
      final initialDate = kDefaultToDaily(
        oldViewController: viewController,
        newViewConfiguration: MonthViewConfiguration.singleMonth(displayRange: calendarRange),
      );

      expect(initialDate, DateTime.utc(2025, 1, 1));
    });
  });

  group('ViewConfiguration from week', () {
    final calendarRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));
    final dateTimeRange = ValueNotifier(DateTimeRange(start: DateTime(2025), end: DateTime(2025, 2)));
    final visibleEvents = ValueNotifier(<CalendarEvent>{});
    final weekViewConfiguration = MultiDayViewConfiguration.week(displayRange: calendarRange);
    final viewController = MultiDayViewController(
      viewConfiguration: weekViewConfiguration,
      visibleDateTimeRange: dateTimeRange,
      visibleEvents: visibleEvents,
      initialDate: DateTime(2025, 1, 1),
    );

    test('kDefaultToMonthly', () {
      final initialDate = kDefaultToMonthly(
        oldViewController: viewController,
        newViewConfiguration: MonthViewConfiguration.singleMonth(displayRange: calendarRange),
      );

      expect(initialDate, DateTime.utc(2024, 12, 30));
    });
    test('kDefaultToWeekly', () {
      final initialDate = kDefaultToWeekly(
        oldViewController: viewController,
        newViewConfiguration: MultiDayViewConfiguration.week(displayRange: calendarRange),
      );

      expect(initialDate, DateTime.utc(2024, 12, 30));
    });
    test('kDefaultToDaily', () {
      final initialDate = kDefaultToDaily(
        oldViewController: viewController,
        newViewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: calendarRange),
      );

      expect(initialDate, DateTime.utc(2024, 12, 30));
    });
  });

  group('ViewConfiguration from day', () {
    final calendarRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));
    final dateTimeRange = ValueNotifier(DateTimeRange(start: DateTime(2025), end: DateTime(2025, 2)));
    final visibleEvents = ValueNotifier(<CalendarEvent>{});
    final weekViewConfiguration = MultiDayViewConfiguration.singleDay(displayRange: calendarRange);
    final viewController = MultiDayViewController(
      viewConfiguration: weekViewConfiguration,
      visibleDateTimeRange: dateTimeRange,
      visibleEvents: visibleEvents,
      initialDate: DateTime(2025, 1, 1),
    );

    test('kDefaultToMonthly', () {
      final initialDate = kDefaultToMonthly(
        oldViewController: viewController,
        newViewConfiguration: MonthViewConfiguration.singleMonth(displayRange: calendarRange),
      );

      expect(initialDate, DateTime.utc(2025, 1, 1));
    });

    test('kDefaultToWeekly', () {
      final initialDate = kDefaultToWeekly(
        oldViewController: viewController,
        newViewConfiguration: MultiDayViewConfiguration.week(displayRange: calendarRange),
      );

      expect(initialDate, DateTime.utc(2025, 1, 1));
    });

    test('kDefaultToDaily', () {
      final initialDate = kDefaultToDaily(
        oldViewController: viewController,
        newViewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: calendarRange),
      );

      expect(initialDate, DateTime.utc(2025, 1, 1));
    });
  });
}
