import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';

import 'utilities.dart';

final datesToTest = [
  // America/New_York
  DateTime(2020, 3, 8, 2), // 2020	Sunday, 8 March, 02:00	Sunday, 1 November, 02:00
  DateTime(2020, 11, 1, 2),
  DateTime(2021, 3, 14, 2), // 2021	Sunday, 14 March, 02:00	Sunday, 7 November, 02:00
  DateTime(2021, 11, 7, 2),
  DateTime(2022, 3, 13, 2), // 2022	Sunday, 13 March, 02:00	Sunday, 6 November, 02:00
  DateTime(2022, 11, 6, 2),
  DateTime(2023, 3, 12, 2), // 2023	Sunday, 12 March, 02:00	Sunday, 5 November, 02:00
  DateTime(2023, 11, 5, 2),
  DateTime(2024, 3, 10, 2), // 2024	Sunday, 10 March, 02:00	Sunday, 3 November, 02:00
  DateTime(2024, 11, 3, 2),
  DateTime(2025, 3, 9, 2), // 2025	Sunday, 9 March, 02:00	Sunday, 2 November, 02:00
  DateTime(2025, 11, 2, 2),

  // Europe/London
  DateTime(2020, 3, 29, 1), // 2020	Sunday, 29 March, 01:00	Sunday, 25 October, 02:00
  DateTime(2020, 10, 25, 2),
  DateTime(2021, 3, 28, 1), // 2021	Sunday, 28 March, 01:00	Sunday, 31 October, 02:00
  DateTime(2021, 10, 31, 2),
  DateTime(2022, 3, 27, 1), // 2022	Sunday, 27 March, 01:00	Sunday, 30 October, 02:00
  DateTime(2022, 10, 30, 2),
  DateTime(2023, 3, 26, 1), // 2023	Sunday, 26 March, 01:00	Sunday, 29 October, 02:00
  DateTime(2023, 10, 29, 2),
  DateTime(2024, 3, 31, 1), // 2024	Sunday, 31 March, 01:00	Sunday, 27 October, 02:00
  DateTime(2024, 10, 27, 2),
  DateTime(2025, 3, 30, 1), // 2025	Sunday, 30 March, 01:00	Sunday, 26 October, 02:00
  DateTime(2025, 10, 26, 2),

  // Australia/Sydney
  DateTime(2020, 4, 5, 3), // 2020 Sunday, 5 April, 03:00	Sunday, 4 October, 02:00
  DateTime(2020, 10, 4, 2),
  DateTime(2021, 4, 4, 3), // 2021 Sunday, 4 April, 03:00	Sunday, 3 October, 02:00
  DateTime(2021, 10, 3, 2),
  DateTime(2022, 4, 3, 3), // 2022 Sunday, 3 April, 03:00	Sunday, 2 October, 02:00
  DateTime(2022, 10, 2, 2),
  DateTime(2023, 4, 2, 3), // 2023 Sunday, 2 April, 03:00	Sunday, 1 October, 02:00
  DateTime(2023, 10, 1, 2),
  DateTime(2024, 4, 7, 3), // 2024 Sunday, 7 April, 03:00	Sunday, 6 October, 02:00
  DateTime(2024, 10, 6, 2),
  DateTime(2025, 4, 6, 3), // 2025 Sunday, 6 April, 03:00	Sunday, 5 October, 02:00
  DateTime(2025, 10, 5, 2),
];

void main() {
  testWithTimeZones(
    dates: datesToTest,
    body: (timezone, testDates) {
      final testRange = DateTimeRange(start: DateTime(2020), end: DateTime(2026));

      group('PageNavigationFunctions', () {
        group('singleDay', () {
          final navigation = PageNavigationFunctions.singleDay(testRange);
          const numberOfPages = 2192;

          test('numberOfPages', () {
            expect(navigation.numberOfPages, numberOfPages);
          });

          test('indexFromDate', () {
            expect(navigation.indexFromDate(DateTime(2020, 1, 1)), 0);
            expect(navigation.indexFromDate(DateTime(2026, 1, 1)), numberOfPages);
          });

          test('dateTimeRangeFromIndex', () {
            expect(
              navigation.dateTimeRangeFromIndex(0),
              DateTimeRange(start: DateTime.utc(2020, 1, 1), end: DateTime.utc(2020, 1, 2)),
            );

            expect(
              navigation.dateTimeRangeFromIndex(numberOfPages),
              DateTimeRange(start: DateTime.utc(2026, 1, 1), end: DateTime.utc(2026, 1, 2)),
            );
          });

          group('Test Dates', () {
            for (final testDate in testDates.indexed) {
              test('indexFromDate - $testDate', () {
                final index = navigation.indexFromDate(testDate.$2);
                expect(index, singleDayDatePageIndexes[testDate.$1]);
              });

              test('dateTimeRangeFromIndex - ', () {
                final range = navigation.dateTimeRangeFromIndex(singleDayDatePageIndexes[testDate.$1]);
                expect(range, testDate.$2.asUtc.dayRange);
              });
            }
          });
        });
        group('week', () {
          final startOfWeeks = [1, 2, 3, 4, 5, 6, 7];
          for (final firstDayOfWeek in startOfWeeks) {
            final navigation = PageNavigationFunctions.week(testRange, firstDayOfWeek);
            const numberOfPages = 313;

            test('numberOfPages', () {
              expect(navigation.numberOfPages, numberOfPages);
            });

            test('dateTimeRangeFromIndex', () {
              expect(
                navigation.dateTimeRangeFromIndex(0),
                testRange.start.asUtc.weekRange.shiftByDays(firstDayOfWeek - 1),
              );
              expect(
                navigation.dateTimeRangeFromIndex(numberOfPages),
                testRange.end.asUtc.weekRange.shiftByDays(firstDayOfWeek - 1),
              );
            });

            test('indexFromDate', () {
              expect(navigation.indexFromDate(DateTime(2020, 1, 1)), 0);
              expect(navigation.indexFromDate(DateTime(2020, 1, 7)), 1);
              expect(navigation.indexFromDate(DateTime(2026, 1, 1)), numberOfPages);
            });

            group('Test Dates', () {
              for (final testDate in testDates.indexed) {
                test('indexFromDate $testDate', () {
                  final index = navigation.indexFromDate(testDate.$2);
                  expect(index, weekDatePageIndex[testDate.$1]);
                });

                test('dateTimeRangeFromIndex ', () {
                  final range = navigation.dateTimeRangeFromIndex(weekDatePageIndex[testDate.$1]);
                  expect(range, testDate.$2.asUtc.weekRange.shiftByDays(firstDayOfWeek - 1));
                });
              }
            });
          }
        });
        group('workWeek', () {
          final navigation = PageNavigationFunctions.workWeek(testRange);
          const numberOfPages = 313;

          test('numberOfPages', () {
            expect(navigation.numberOfPages, numberOfPages);
          });

          test('dateTimeRangeFromIndex', () {
            expect(
              navigation.dateTimeRangeFromIndex(0),
              testRange.start.asUtc.workWeekRange,
            );
            expect(
              navigation.dateTimeRangeFromIndex(numberOfPages),
              testRange.end.asUtc.workWeekRange,
            );
          });

          test('indexFromDate', () {
            expect(navigation.indexFromDate(DateTime(2020, 1, 1)), 0);
            expect(navigation.indexFromDate(DateTime(2020, 1, 7)), 1);
            expect(navigation.indexFromDate(DateTime(2026, 1, 1)), numberOfPages);
          });

          group('Test Dates', () {
            for (final testDate in testDates.indexed) {
              test('indexFromDate $testDate', () {
                final index = navigation.indexFromDate(testDate.$2);
                expect(index, weekDatePageIndex[testDate.$1]);
              });

              test('dateTimeRangeFromIndex ', () {
                final range = navigation.dateTimeRangeFromIndex(weekDatePageIndex[testDate.$1]);
                expect(range, testDate.$2.asUtc.workWeekRange);
              });
            }
          });
        });

        group('custom', () {
          const numberOfPages = 730;
          const numberOfDays = 3;
          final navigation = PageNavigationFunctions.custom(testRange, numberOfDays);

          test('numberOfPages', () {
            expect(navigation.numberOfPages, numberOfPages);
          });

          test('dateTimeRangeFromIndex', () {
            expect(
              navigation.dateTimeRangeFromIndex(0),
              testRange.start.asUtc.customDateTimeRange(numberOfDays),
            );

            expect(
              navigation.dateTimeRangeFromIndex(numberOfPages),
              DateTimeRange(start: DateTime.utc(2025, 12, 30), end: DateTime.utc(2026, 01, 02)),
            );
          });

          test('indexFromDate', () {
            expect(navigation.indexFromDate(DateTime(2020, 1, 1)), 0);
            expect(navigation.indexFromDate(DateTime(2026, 1, 1)), numberOfPages);
          });

          group('Test Dates', () {
            for (final testDate in testDates.indexed) {
              test('indexFromDate $testDate', () {
                final index = navigation.indexFromDate(testDate.$2);
                expect(index, customDatePageIndex[testDate.$1]);
              });
            }
          });
        });

        group('freeScroll', () {
          final navigation = PageNavigationFunctions.freeScroll(testRange);
          const numberOfPages = 2192;

          test('numberOfPages', () {
            expect(navigation.numberOfPages, numberOfPages);
          });

          test('indexFromDate', () {
            expect(navigation.indexFromDate(DateTime(2020, 1, 1)), 0);
            expect(navigation.indexFromDate(DateTime(2026, 1, 1)), numberOfPages);
          });

          test('dateTimeRangeFromIndex', () {
            expect(
              navigation.dateTimeRangeFromIndex(0),
              DateTimeRange(start: DateTime.utc(2020, 1, 1), end: DateTime.utc(2020, 1, 2)),
            );

            expect(
              navigation.dateTimeRangeFromIndex(numberOfPages),
              DateTimeRange(start: DateTime.utc(2026, 1, 1), end: DateTime.utc(2026, 1, 2)),
            );
          });

          group('Test Dates', () {
            for (final testDate in testDates.indexed) {
              test('indexFromDate - $testDate', () {
                final index = navigation.indexFromDate(testDate.$2);
                expect(index, singleDayDatePageIndexes[testDate.$1]);
              });

              test('dateTimeRangeFromIndex - ', () {
                final range = navigation.dateTimeRangeFromIndex(singleDayDatePageIndexes[testDate.$1]);
                expect(range, testDate.$2.asUtc.dayRange);
              });
            }
          });
        });
        group('month', () {
          final navigation = MonthPageFunctions(dateTimeRange: testRange, shift: 1);
          const numberOfPages = 72;

          test('numberOfPages', () {
            expect(navigation.numberOfPages, numberOfPages);
          });

          test('indexFromDate', () {
            expect(navigation.indexFromDate(DateTime(2020, 1, 1)), 0);
            expect(navigation.indexFromDate(DateTime(2026, 1, 1)), numberOfPages);
          });

          test('dateTimeRangeFromIndex', () {
            expect(
              navigation.dateTimeRangeFromIndex(0),
              DateTimeRange(
                start: DateTime.utc(2019, 12, 30),
                end: DateTime.utc(2020, 2, 3),
              ),
            );

            expect(
              navigation.dateTimeRangeFromIndex(numberOfPages),
              DateTimeRange(
                start: DateTime.utc(2025, 12, 29),
                end: DateTime.utc(2026, 2, 2),
              ),
            );

            expect(
              navigation.dateTimeRangeFromIndex(62),
              DateTimeRange(start: DateTime.utc(2025, 2, 24), end: DateTime.utc(2025, 4, 7)),
            );

            expect(
              navigation.dateTimeRangeFromIndex(65),
              DateTimeRange(start: DateTime.utc(2025, 5, 26), end: DateTime.utc(2025, 7, 7)),
            );
          });

          group('Test Dates', () {
            for (final testDate in testDates.indexed) {
              test('indexFromDate - $testDate', () {
                final index = navigation.indexFromDate(testDate.$2);

                expect(index, monthDatePageIndex[testDate.$1]);
              });
            }
          });
        });
      });
    },
  );
}

final singleDayDatePageIndexes = [
  67,
  305,
  438,
  676,
  802,
  1040,
  1166,
  1404,
  1530,
  1768,
  1894,
  2132,
  88,
  298,
  452,
  669,
  816,
  1033,
  1180,
  1397,
  1551,
  1761,
  1915,
  2125,
  95,
  277,
  459,
  641,
  823,
  1005,
  1187,
  1369,
  1558,
  1740,
  1922,
  2104,
];

final weekDatePageIndex = [
  9,
  43,
  62,
  96,
  114,
  148,
  166,
  200,
  218,
  252,
  270,
  304,
  12,
  42,
  64,
  95,
  116,
  147,
  168,
  199,
  221,
  251,
  273,
  303,
  13,
  39,
  65,
  91,
  117,
  143,
  169,
  195,
  222,
  248,
  274,
  300,
];

final customDatePageIndex = [
  22,
  101,
  146,
  225,
  267,
  346,
  388,
  468,
  510,
  589,
  631,
  710,
  29,
  99,
  150,
  223,
  272,
  344,
  393,
  465,
  517,
  587,
  638,
  708,
  31,
  92,
  153,
  213,
  274,
  335,
  395,
  456,
  519,
  580,
  640,
  701,
];

final monthDatePageIndex = [
  2,
  10,
  14,
  22,
  26,
  34,
  38,
  46,
  50,
  58,
  62,
  70,
  2,
  9,
  14,
  21,
  26,
  33,
  38,
  45,
  50,
  57,
  62,
  69,
  3,
  9,
  15,
  21,
  27,
  33,
  39,
  45,
  51,
  57,
  63,
  69,
];
