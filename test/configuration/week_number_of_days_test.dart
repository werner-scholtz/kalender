import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/week_day_headers.dart' show WeekDayHeaders;

import '../utilities.dart';

/// A week view shortened with [MultiDayViewConfiguration.week]'s `numberOfDays`.
///
/// The body divides its width by `numberOfDays` while the header renders the
/// dates of the page, so the two only line up if the page is that many days
/// long. Covers issue #444.
void main() {
  final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

  // Monday 14 April 2025.
  final monday = DateTime(2025, 4, 14);

  group('MultiDayViewConfiguration.week', () {
    test('a page is numberOfDays long and still turns a week at a time', () {
      final configuration = MultiDayViewConfiguration.week(
        displayRange: displayRange,
        firstDayOfWeek: DateTime.monday,
        numberOfDays: 6,
      );

      final calculator = configuration.pageIndexCalculator;
      final index = calculator.indexFromDate(monday, null);
      final page = calculator.dateTimeRangeFromIndex(index, null);
      final next = calculator.dateTimeRangeFromIndex(index + 1, null);

      expect(page.dates().length, 6, reason: 'Monday to Saturday');
      expect(page.start.weekday, DateTime.monday);
      expect(page.end.difference(page.start), const Duration(days: 6));
      expect(next.start.difference(page.start), const Duration(days: 7), reason: 'pagination stays weekly');
    });

    test('the default is still a full week', () {
      final configuration = MultiDayViewConfiguration.week(displayRange: displayRange);
      final calculator = configuration.pageIndexCalculator;
      final page = calculator.dateTimeRangeFromIndex(calculator.indexFromDate(monday, null), null);
      expect(configuration.numberOfDays, DateTime.daysPerWeek);
      expect(page.dates().length, DateTime.daysPerWeek);
    });

    test('copyWith keeps numberOfDays and replaces it', () {
      final configuration = MultiDayViewConfiguration.week(displayRange: displayRange, numberOfDays: 6);

      expect(configuration.copyWith(name: 'Renamed').numberOfDays, 6);

      final replaced = configuration.copyWith(numberOfDays: 4);
      expect(replaced.numberOfDays, 4);
      final page = replaced.pageIndexCalculator.dateTimeRangeFromIndex(
        replaced.pageIndexCalculator.indexFromDate(monday, null),
        null,
      );
      expect(page.dates().length, 4);
    });

    test('numberOfDays outside 1 to 7 is rejected', () {
      expect(
        () => MultiDayViewConfiguration.week(displayRange: displayRange, numberOfDays: 8),
        throwsAssertionError,
        reason: 'pages would overlap',
      );
      expect(
        () => MultiDayViewConfiguration.week(displayRange: displayRange, numberOfDays: 0),
        throwsAssertionError,
      );
    });
  });

  group('MultiDayViewConfiguration.workWeek', () {
    test('a page is numberOfDays long', () {
      final configuration = MultiDayViewConfiguration.workWeek(displayRange: displayRange, numberOfDays: 4);
      final calculator = configuration.pageIndexCalculator;
      final page = calculator.dateTimeRangeFromIndex(calculator.indexFromDate(monday, null), null);

      expect(page.dates().length, 4);
      expect(page.start.weekday, DateTime.monday);
    });

    test('the default is still five days', () {
      final configuration = MultiDayViewConfiguration.workWeek(displayRange: displayRange);
      final calculator = configuration.pageIndexCalculator;
      final page = calculator.dateTimeRangeFromIndex(calculator.indexFromDate(monday, null), null);
      expect(page.dates().length, 5);
    });

    test('copyWith keeps numberOfDays', () {
      final configuration = MultiDayViewConfiguration.workWeek(displayRange: displayRange, numberOfDays: 4);
      expect(configuration.copyWith(name: 'Renamed').numberOfDays, 4);
    });
  });

  group('WeekIndexCalculator', () {
    test('daysToDisplay outside 1 to 7 is rejected', () {
      expect(
        () => WeekIndexCalculator(
          dateTimeRange: displayRange,
          firstDayOfWeek: DateTime.monday,
          daysToDisplay: 8,
        ),
        throwsAssertionError,
      );
    });
  });

  group('the header follows numberOfDays', () {
    Future<void> pumpWeek(WidgetTester tester, int numberOfDays) {
      return pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: DefaultEventsController(),
          calendarController: CalendarController(),
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: displayRange,
            initialDateTime: monday,
            firstDayOfWeek: DateTime.monday,
            numberOfDays: numberOfDays,
          ),
          header: const CalendarHeader(),
          body: const CalendarBody(),
        ),
      );
    }

    testWidgets('six days render six day headers', (tester) async {
      await pumpWeek(tester, 6);

      final headers = tester.widgetList<WeekDayHeaders>(find.byType(WeekDayHeaders));
      expect(headers, isNotEmpty);
      for (final header in headers) {
        expect(header.dates.length, 6);
        expect(header.dates.first.weekday, DateTime.monday);
        expect(header.dates.last.weekday, DateTime.saturday);
      }
    });

    testWidgets('the default renders seven', (tester) async {
      await pumpWeek(tester, 7);

      final headers = tester.widgetList<WeekDayHeaders>(find.byType(WeekDayHeaders));
      expect(headers, isNotEmpty);
      for (final header in headers) {
        expect(header.dates.length, DateTime.daysPerWeek);
      }
    });
  });
}
