import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/view_configurations/page_index_calculator.dart';
import 'package:timezone/data/latest_10y.dart';

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
    final range = DateTimeRange(start: TZDateTime(location, 2020), end: TZDateTime(location, 2021));
    group('DayIndexCalculator for $location', () {
      late DayIndexCalculator calculator;
      setUpAll(() {
        calculator = DayIndexCalculator(dateTimeRange: range);
      });

      test('test dateTimeRangeFromIndex', () {
        var internalRange = calculator.dateTimeRangeFromIndex(0, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020), end: InternalDateTime(2020, 1, 2)),
        );
        internalRange = calculator.dateTimeRangeFromIndex(1, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 1, 2), end: InternalDateTime(2020, 1, 3)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(166, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 6, 15), end: InternalDateTime(2020, 6, 16)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(365, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 12, 31), end: InternalDateTime(2021, 1, 1)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(366, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2021), end: InternalDateTime(2021, 1, 2)),
        );
      });

      test('test indexFromDate', () {
        var index = calculator.indexFromDate(range.start, location);
        expect(index, 0);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 1, 2), location);
        expect(index, 1);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 6, 15), location);
        expect(index, 166);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 12, 31), location);
        expect(index, 365);

        index = calculator.indexFromDate(range.end, location);
        expect(index, 366);
      });

      test('test numberOfPages', () {
        final endIndex = calculator.numberOfPages(location);
        expect(endIndex, 366);
      });

      test('test internalRange', () {
        final internalRange = calculator.internalRange(location);
        expect(internalRange, InternalDateTimeRange.fromDateTimeRange(range));
      });
    });

    group('WeekIndexCalculator for $location', () {
      late WeekIndexCalculator calculator;
      setUpAll(() {
        calculator = WeekIndexCalculator.week(dateTimeRange: range, firstDayOfWeek: DateTime.monday);
      });

      test('test dateTimeRangeFromIndex', () {
        var internalRange = calculator.dateTimeRangeFromIndex(0, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2019, 12, 30), end: InternalDateTime(2020, 1, 6)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(1, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 1, 6), end: InternalDateTime(2020, 1, 13)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(9, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 3, 2), end: InternalDateTime(2020, 3, 9)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(51, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 12, 21), end: InternalDateTime(2020, 12, 28)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(52, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 12, 28), end: InternalDateTime(2021, 1, 4)),
        );
      });

      test('test indexFromDate', () {
        var index = calculator.indexFromDate(TZDateTime(location, 2019, 12, 30), location);
        expect(index, 0);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 1, 6), location);
        expect(index, 1);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 3, 2), location);
        expect(index, 9);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 12, 21), location);
        expect(index, 51);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 12, 28), location);
        expect(index, 52);
      });

      test('test numberOfPages', () {
        final endIndex = calculator.numberOfPages(location);
        expect(endIndex, 52);
      });

      test('test internalRange', () {
        final internalRange = calculator.internalRange(location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2019, 12, 30), end: InternalDateTime(2021, 1, 4)),
        );
      });
    });

    group('CustomIndexCalculator for $location', () {
      late CustomIndexCalculator calculator;
      setUpAll(() {
        calculator = CustomIndexCalculator(dateTimeRange: range, numberOfDays: 3);
      });

      test('test dateTimeRangeFromIndex', () {
        var internalRange = calculator.dateTimeRangeFromIndex(0, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020), end: InternalDateTime(2020, 1, 4)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(1, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 1, 4), end: InternalDateTime(2020, 1, 7)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(9, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 1, 28), end: InternalDateTime(2020, 1, 31)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(120, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 12, 26), end: InternalDateTime(2020, 12, 29)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(121, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 12, 29), end: InternalDateTime(2021)),
        );
      });

      test('test indexFromDate', () {
        var index = calculator.indexFromDate(TZDateTime(location, 2020), location);
        expect(index, 0);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 1, 4), location);
        expect(index, 1);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 1, 28), location);
        expect(index, 9);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 12, 26), location);
        expect(index, 120);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 12, 29), location);
        expect(index, 121);
      });

      test('test numberOfPages', () {
        final endIndex = calculator.numberOfPages(location);
        expect(endIndex, 121);
      });

      test('test internalRange', () {
        final internalRange = calculator.internalRange(location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020), end: InternalDateTime(2021)),
        );
        expect(true, true);
      });
    });

    group('MonthIndexCalculator for $location', () {
      late MonthIndexCalculator calculator;
      setUpAll(() {
        calculator = MonthIndexCalculator(dateTimeRange: range, firstDayOfWeek: DateTime.monday);
      });

      test('test dateTimeRangeFromIndex', () {
        var internalRange = calculator.dateTimeRangeFromIndex(0, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2019, 12, 30), end: InternalDateTime(2020, 2, 3)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(1, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 1, 27), end: InternalDateTime(2020, 3, 2)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(9, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 9, 28), end: InternalDateTime(2020, 11, 2)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(10, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 10, 26), end: InternalDateTime(2020, 12, 07)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(11, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 11, 30), end: InternalDateTime(2021, 1, 4)),
        );
      });

      test('test indexFromDate', () {
        var index = calculator.indexFromDate(TZDateTime(location, 2020), location);
        expect(index, 0);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 2, 3), location);
        expect(index, 1);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 6, 2), location);
        expect(index, 5);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 11, 26), location);
        expect(index, 10);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 12, 31), location);
        expect(index, 11);
      });

      test('test numberOfPages', () {
        final endIndex = calculator.numberOfPages(location);
        expect(endIndex, 11);
      });

      test('test internalRange', () {
        final internalRange = calculator.internalRange(location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020), end: InternalDateTime(2021)),
        );
      });
    });

    group('ContinuousScheduleIndexCalculator for $location', () {
      late ContinuousScheduleIndexCalculator calculator;
      setUpAll(() {
        calculator = ContinuousScheduleIndexCalculator(dateTimeRange: range);
      });

      test('test dateTimeRangeFromIndex', () {
        final internalRange = calculator.dateTimeRangeFromIndex(0, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020), end: InternalDateTime(2021)),
        );
      });

      test('test indexFromDate', () {
        final index = calculator.indexFromDate(TZDateTime(location, 2020), location);
        expect(index, 0);
      });

      test('test numberOfPages', () {
        final endIndex = calculator.numberOfPages(location);
        expect(endIndex, 1);
      });

      test('test internalRange', () {
        final internalRange = calculator.internalRange(location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020), end: InternalDateTime(2021)),
        );
      });
    });

    group('PaginatedScheduleIndexCalculator for $location', () {
      late PaginatedScheduleIndexCalculator calculator;
      setUpAll(() {
        calculator = PaginatedScheduleIndexCalculator(dateTimeRange: range);
      });

      test('test dateTimeRangeFromIndex', () {
        var internalRange = calculator.dateTimeRangeFromIndex(0, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020), end: InternalDateTime(2020, 2)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(1, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 2), end: InternalDateTime(2020, 3)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(9, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 10), end: InternalDateTime(2020, 11)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(10, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 11), end: InternalDateTime(2020, 12)),
        );

        internalRange = calculator.dateTimeRangeFromIndex(11, location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020, 12), end: InternalDateTime(2021)),
        );
      });

      test('test indexFromDate', () {
        var index = calculator.indexFromDate(TZDateTime(location, 2020), location);
        expect(index, 0);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 2, 3), location);
        expect(index, 1);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 6, 2), location);
        expect(index, 5);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 11, 26), location);
        expect(index, 10);

        index = calculator.indexFromDate(TZDateTime(location, 2020, 12, 31), location);
        expect(index, 11);
      });

      test('test numberOfPages', () {
        final endIndex = calculator.numberOfPages(location);
        expect(endIndex, 11);
      });

      test('test internalRange', () {
        final internalRange = calculator.internalRange(location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020), end: InternalDateTime(2021)),
        );
      });
    });
  }
}
