import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/extentions.dart';
import 'date_time_test_object.dart';

void main() {
  testDateTimeRangeExtentions();

  testDateTimeExtentions();
}

void testDateTimeRangeExtentions() {
  group('DateTimeRangeExtensions Tests', () {
    final yearRange = DateTimeRange(
      start: DateTime(2023, 1, 1),
      end: DateTime(2023, 12, 31),
    );

    final leapYearRange = DateTimeRange(
      start: DateTime(2020, 1, 1),
      end: DateTime(2020, 12, 31),
    );

    final y2Range = DateTimeRange(
      start: DateTime(2021, 1, 1),
      end: DateTime(2023, 12, 31),
    );

    final y3Range = DateTimeRange(
      start: DateTime(2021, 1, 1),
      end: DateTime(2024, 12, 31),
    );

    final monthRange = DateTimeRange(
      start: DateTime(2021, 1, 1),
      end: DateTime(2021, 1, 31),
    );

    final m2Range = DateTimeRange(
      start: DateTime(2021, 1),
      end: DateTime(2021, 2),
    );

    final m3Range = DateTimeRange(
      start: DateTime(2021, 1, 15),
      end: DateTime(2021, 1, 16),
    );

    final d2Range = DateTimeRange(
      start: DateTime(2021, 1, 1),
      end: DateTime(2021, 1, 3),
    );

    final d7Range = DateTimeRange(
      start: DateTime(2021, 1, 1),
      end: DateTime(2021, 1, 8),
    );

    final d7Range2 = DateTimeRange(
      start: DateTime(2021, 1, 1),
      end: DateTime(2021, 1, 7, 23, 59, 59),
    );

    final d8Range = DateTimeRange(
      start: DateTime(2021, 1, 1),
      end: DateTime(2021, 1, 9),
    );

    final d14Range = DateTimeRange(
      start: DateTime(2021, 1, 1),
      end: DateTime(2021, 1, 15),
    );

    test('dayDifference', () {
      expect(yearRange.dayDifference, 364);
      expect(leapYearRange.dayDifference, 365);
      expect(y2Range.dayDifference, 1094);
      expect(y3Range.dayDifference, 1460);
      expect(monthRange.dayDifference, 30);
      expect(m2Range.dayDifference, 31);
      expect(m3Range.dayDifference, 1);
      expect(d7Range.dayDifference, 7);
      expect(d7Range2.dayDifference, 7);
      expect(d8Range.dayDifference, 8);
      expect(d14Range.dayDifference, 14);
    });

    test('monthDifference', () {
      expect(yearRange.monthDifference, 11);
      expect(leapYearRange.monthDifference, 11);
      expect(y2Range.monthDifference, 35);
      expect(m2Range.monthDifference, 1);
    });

    test('datesSpanned', () {
      expect(d2Range.datesSpanned, <DateTime>[
        DateTime(2021, 1, 1),
        DateTime(2021, 1, 2),
      ]);
      expect(d7Range.datesSpanned, <DateTime>[
        DateTime(2021, 1, 1),
        DateTime(2021, 1, 2),
        DateTime(2021, 1, 3),
        DateTime(2021, 1, 4),
        DateTime(2021, 1, 5),
        DateTime(2021, 1, 6),
        DateTime(2021, 1, 7),
      ]);
      expect(d8Range.datesSpanned, <DateTime>[
        DateTime(2021, 1, 1),
        DateTime(2021, 1, 2),
        DateTime(2021, 1, 3),
        DateTime(2021, 1, 4),
        DateTime(2021, 1, 5),
        DateTime(2021, 1, 6),
        DateTime(2021, 1, 7),
        DateTime(2021, 1, 8),
      ]);
    });

    test('numberOfyears', () {
      expect(yearRange.numberOfyears, 0);
      expect(leapYearRange.numberOfyears, 0);
      expect(y2Range.numberOfyears, 2);
      expect(y3Range.numberOfyears, 3);
    });

    test('rescheduleDateTime', () {
      expect(
        d2Range.rescheduleDateTime(const Duration(days: 1)),
        DateTimeRange(
          start: d2Range.start.add(const Duration(days: 1)),
          end: d2Range.end.add(const Duration(days: 1)),
        ),
      );
      expect(
        d2Range.rescheduleDateTime(const Duration(days: 2)),
        DateTimeRange(
          start: d2Range.start.add(const Duration(days: 2)),
          end: d2Range.end.add(const Duration(days: 2)),
        ),
      );
      expect(
        d2Range.rescheduleDateTime(const Duration(days: -1)),
        DateTimeRange(
          start: d2Range.start.add(const Duration(days: -1)),
          end: d2Range.end.add(const Duration(days: -1)),
        ),
      );
      expect(
        d2Range.rescheduleDateTime(const Duration(days: -2)),
        DateTimeRange(
          start: d2Range.start.add(const Duration(days: -2)),
          end: d2Range.end.add(const Duration(days: -2)),
        ),
      );
    });

    test('centerDateTime', () {
      expect(monthRange.centerDateTime, DateTime(2021, 1, 16));
      expect(m2Range.centerDateTime, DateTime(2021, 1, 16));
      expect(m3Range.centerDateTime, DateTime(2021, 1, 15));
      expect(d7Range.centerDateTime, DateTime(2021, 1, 4));
      expect(d8Range.centerDateTime, DateTime(2021, 1, 5));
      expect(d14Range.centerDateTime, DateTime(2021, 1, 8));
    });
  });
}

void testDateTimeExtentions() {
  group('DateTimeExtentions Tests', () {
    for (var object in dateTimeTestObjects) {
      test('weekNumber $object', () {
        expect(object.date.weekOfYear, object.weekNumber);
      });

      test('startOfDay', () {
        expect(object.date.startOfDay, object.startOfDay);
      });

      test('endOfDay', () {
        expect(object.date.endOfDay, object.endOfDay);
      });

      test('startOfWeekWithOffset', () {
        expect(object.date.startOfWeekWithOffset(1), object.startOfWeek);
        expect(
          object.date.startOfWeekWithOffset(7),
          object.startOfWeekSundayOffset,
        );
      });

      test('endOfWeek', () {
        expect(object.date.startOfWeekWithOffset(1), object.startOfWeek);
      });

      test('startOfMonth', () {
        expect(object.date.startOfMonth, object.startOfMonth);
      });

      test('endOfMonth', () {
        expect(object.date.endOfMonth, object.endOfMonth);
      });

      test('startOfYear', () {
        expect(object.date.startOfYear, object.startOfYear);
      });

      test('endOfYear', () {
        expect(object.date.endOfYear, object.endOfYear);
      });

      test('dayRange', () {
        expect(object.date.dayRange, object.dayRange);
      });

      test('threeDayRange', () {
        expect(object.date.threeDayRange, object.threeDayRange);
      });

      test('fourDayRange', () {
        expect(object.date.fourDayRange, object.fourDayRange);
      });

      test('weekRangeWithOffset', () {
        expect(
          object.date.weekRangeWithOffset(1),
          object.weekRangeWithMondayOffset,
        );
      });

      test('weekRange', () {
        expect(object.date.weekRange, object.weekRange);
      });

      test('monthRange', () {
        expect(object.date.monthRange, object.monthRange);
      });

      test('yearRange', () {
        expect(object.date.yearRange, object.yearRange);
      });

      test('isSameDay', () {
        expect(object.date.isSameDay(object.date), true);
        expect(
          object.date.isSameDay(object.date.add(const Duration(days: 1))),
          false,
        );
      });
    }
  });
}
