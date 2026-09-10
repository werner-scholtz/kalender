import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/view_configurations/page_index_calculator.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart';

final locationsToTest = [
  'Etc/UTC',
  'Africa/Johannesburg',
  'America/New_York',
  'Europe/London',
  'Australia/Sydney',
];

void main() {
  initializeTimeZones();
  final locations = locationsToTest.map(getLocation).toList();

  for (final location in locations) {
    final range = KalenderDateTimeRange(start: TZDateTime(location, 2020), end: TZDateTime(location, 2021));
    group('DayIndexCalculator for $location', () {
      late DayIndexCalculator calculator;
      setUpAll(() {
        calculator = DayIndexCalculator(start: range.start, end: range.end);
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

        // range.end is the exclusive end of the range, so it clamps to the last page index.
        index = calculator.indexFromDate(range.end, location);
        expect(index, 365);
      });

      test('test numberOfPages', () {
        // 366 days in the 2020 range (leap year) → 366 pages.
        final numberOfPages = calculator.numberOfPages(location);
        expect(numberOfPages, 366);
      });

      test('test internalRange', () {
        final internalRange = calculator.internalRange(location);
        expect(internalRange, InternalDateTimeRange.fromDateTimeRange(range));
      });

      // An empty range (start == end) has 0 pages; indexFromDate must not throw
      // on the negative clamp bound, and should fall back to index 0.
      test('test indexFromDate for an empty range', () {
        final emptyRange = KalenderDateTimeRange(
          start: TZDateTime(location, 2020),
          end: TZDateTime(location, 2020),
        );
        final emptyCalculator = DayIndexCalculator(start: emptyRange.start, end: emptyRange.end);
        expect(emptyCalculator.numberOfPages(location), 0);
        expect(() => emptyCalculator.indexFromDate(TZDateTime(location, 2020), location), returnsNormally);
        expect(emptyCalculator.indexFromDate(TZDateTime(location, 2020), location), 0);
      });
    });

    group('freeScroll for $location', () {
      test('the band maps a day per index, the same as a single day view', () {
        expect(PageIndexCalculator.freeScroll(range), isA<DayIndexCalculator>());
      });

      // The band used to round the end of the range up to the next midnight
      // whatever it was, so a range already ending at midnight gained a day and
      // the last column fell outside it.
      test('a range ending at midnight is not extended by a day', () {
        final calculator = PageIndexCalculator.freeScroll(range);
        expect(calculator.numberOfPages(location), 366);

        final last = calculator.dateTimeRangeFromIndex(calculator.numberOfPages(location) - 1, location);
        expect(last.start, InternalDateTime(2020, 12, 31));
        expect(last.end, InternalDateTime(2021));
      });

      test('a range ending mid-day still covers the part day', () {
        final partDay =
            KalenderDateTimeRange(start: TZDateTime(location, 2020), end: TZDateTime(location, 2020, 1, 8, 13, 30));
        final calculator = PageIndexCalculator.freeScroll(partDay);
        expect(calculator.numberOfPages(location), 8);
      });
    });

    group('WeekIndexCalculator for $location', () {
      late WeekIndexCalculator calculator;
      setUpAll(() {
        calculator = WeekIndexCalculator.week(start: range.start, end: range.end, firstDayOfWeek: DateTime.monday);
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
        // 53 whole weeks span the adjusted range → 53 pages.
        final numberOfPages = calculator.numberOfPages(location);
        expect(numberOfPages, 53);
      });

      test('test internalRange', () {
        final internalRange = calculator.internalRange(location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2019, 12, 30), end: InternalDateTime(2021, 1, 4)),
        );
      });
    });

    group('WeekIndexCalculator with six days for $location', () {
      late WeekIndexCalculator calculator;
      setUpAll(() {
        calculator = WeekIndexCalculator(
          start: range.start,
          end: range.end,
          firstDayOfWeek: DateTime.monday,
          daysToDisplay: 6,
        );
      });

      test('a page ends after six days', () {
        expect(
          calculator.dateTimeRangeFromIndex(0, location),
          InternalDateTimeRange(start: InternalDateTime(2019, 12, 30), end: InternalDateTime(2020, 1, 5)),
        );
        expect(
          calculator.dateTimeRangeFromIndex(1, location),
          InternalDateTimeRange(start: InternalDateTime(2020, 1, 6), end: InternalDateTime(2020, 1, 12)),
        );
      });

      test('pagination is unchanged', () {
        expect(calculator.indexFromDate(TZDateTime(location, 2020, 1, 6), location), 1);
        expect(calculator.indexFromDate(TZDateTime(location, 2020, 3, 2), location), 9);
        expect(calculator.numberOfPages(location), 53);
        expect(
          calculator.internalRange(location),
          InternalDateTimeRange(start: InternalDateTime(2019, 12, 30), end: InternalDateTime(2021, 1, 4)),
        );
      });

      test('the day the page drops is still reachable', () {
        // Sunday 5 January 2020 is not displayed, but asking for it must land on
        // the page that starts the week it belongs to.
        expect(calculator.indexFromDate(TZDateTime(location, 2020, 1, 5), location), 0);
      });
    });

    group('CustomIndexCalculator for $location', () {
      late CustomIndexCalculator calculator;
      setUpAll(() {
        calculator = CustomIndexCalculator(start: range.start, end: range.end, numberOfDays: 3);
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
        // 366 days / 3 days per page → 122 pages.
        final numberOfPages = calculator.numberOfPages(location);
        expect(numberOfPages, 122);
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
        calculator = MonthIndexCalculator.fromRange(range, DateTime.monday);
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
        // The range spans 12 calendar months (Jan–Dec 2020), so there are 12 pages.
        final numberOfPages = calculator.numberOfPages(location);
        expect(numberOfPages, 12);
      });

      test('test internalRange', () {
        final internalRange = calculator.internalRange(location);
        expect(
          internalRange,
          InternalDateTimeRange(start: InternalDateTime(2020), end: InternalDateTime(2021)),
        );
      });

      // Regression: https://github.com/werner-scholtz/kalender/issues/266
      // A range spanning exactly one calendar month must report a single page,
      // otherwise the month view renders nothing.
      test('test numberOfPages for a single-month range', () {
        final singleMonth = MonthIndexCalculator(
          start: TZDateTime(location, 2020, 5),
          end: TZDateTime(location, 2020, 5, 31),
          firstDayOfWeek: DateTime.monday,
        );
        expect(singleMonth.numberOfPages(location), 1);
        expect(singleMonth.indexFromDate(TZDateTime(location, 2020, 5, 15), location), 0);
      });
    });

    group('ContinuousScheduleIndexCalculator for $location', () {
      late ContinuousScheduleIndexCalculator calculator;
      setUpAll(() {
        calculator = ContinuousScheduleIndexCalculator(start: range.start, end: range.end);
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
        calculator = PaginatedScheduleIndexCalculator(start: range.start, end: range.end);
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
        // 12 calendar months (Jan–Dec 2020) → 12 pages.
        final numberOfPages = calculator.numberOfPages(location);
        expect(numberOfPages, 12);
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
