import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/extensions.dart';
import 'package:timezone/standalone.dart';

import 'utils.dart';

void main() {
  timezoneTest(
    (zone, now) {
      group(zone.name, () {
        dayDifferenceTest(zone, now);
        monthDifferenceTest(zone, now);
        rescheduleDateTimeTest(zone, now);
        datesSpannedTest(zone, now);
      });
    },
  );
}

void dayDifferenceTest(Location zone, TZDateTime now) {
  for (var day = 0; day < 365; day++) {
    for (var numberOfDays = 1; numberOfDays <= 2; numberOfDays++) {
      test('dayDifference', () {
        final today = now.add(Duration(days: day));
        final tomorrow = today.add(Duration(days: numberOfDays));
        final range = DateTimeRange(start: today, end: tomorrow);
        final difference = range.dayDifference;

        expect(difference, numberOfDays);
      });
    }
  }

  final edgeCases = {
    DateTimeRange(
      start: now,
      end: now,
    ): 0,
    DateTimeRange(
      start: now,
      end: now.add(const Duration(days: 1)),
    ): 1,
    DateTimeRange(
      start: now,
      end: now.add(const Duration(days: 1, hours: 5)),
    ): 1,
  };

  for (final edgeCase in edgeCases.entries) {
    test('dayDifference', () {
      expect(edgeCase.key.dayDifference, edgeCase.value);
    });
  }
}

void monthDifferenceTest(Location zone, TZDateTime now) {
  for (var i = 1; i < 13; i++) {
    test('monthDifference', () {
      final start = now;
      final end = TZDateTime(zone, now.year, now.month + i);
      final range = DateTimeRange(start: start, end: end);
      final difference = range.monthDifference;

      expect(difference, i);
    });
  }
}

void rescheduleDateTimeTest(Location zone, TZDateTime now) {
  for (var i = -7; i <= 7; i++) {
    test('rescheduleDateTime', () {
      final start = now;
      final end = TZDateTime(zone, now.year, now.month, now.day + 1);
      final range = DateTimeRange(start: start, end: end);
      final duration = Duration(days: i);
      final rescheduledRange = range.rescheduleDateTime(duration);
      expect(rescheduledRange.start, start.add(duration));
      expect(rescheduledRange.end, end.add(duration));
    });
  }
}

void datesSpannedTest(Location zone, TZDateTime now) {
  final rangesToTest = {
    DateTimeRange(
      start: now,
      end: now,
    ): 1,
    DateTimeRange(
      start: now,
      end: now.add(const Duration(days: 1)),
    ): 1,
    DateTimeRange(
      start: now,
      end: now.add(const Duration(days: 2, hours: 3)),
    ): 3,
  };

  for (final entry in rangesToTest.entries) {
    final range = entry.key;

    test('datesSpanned', () {
      final dates = range.datesSpanned;
      expect(dates.length, entry.value);
    });
  }
}
