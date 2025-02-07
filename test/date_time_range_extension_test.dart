// ignore_for_file: unnecessary_lambdas

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kalender/src/extensions.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart' show ListEquality;

Future<void> main() async {
  final systemTimezone = (await Process.run('cat', ['/etc/timezone'])).stdout as String;
  final timezones = [
    'America/New_York',
    'Europe/London',
    'Asia/Tokyo',
    'Australia/Sydney',
    'Africa/Johannesburg',
    'UTC',
  ];
  final currentTimezone = timezones.firstWhere((zone) => zone.contains(systemTimezone.trim()));
  group('DateTimeRangeExtensions.dates', () {
    group(
      'UTC',
      testBasic,
      skip: currentTimezone != 'UTC',
    );

    group(
      'America/New_York',
      () {
        // TODO: add test for DST switching
        // Sunday, March 10, 2024 — 1 hour forward
        // Sunday, November 3, 2024 — 1 hour backward

        testBasic();
      },
      skip: currentTimezone != 'America/New_York',
    );

    group(
      'Europe/London',
      () {
        // TODO: add test for DST switching
        // Sunday, March 31, 2024 — 1 hour forward
        // Sunday, October 27, 2024 — 1 hour backward

        testBasic();
      },
      skip: currentTimezone != 'Europe/London',
    );

    group(
      'Asia/Tokyo',
      testBasic,
      skip: currentTimezone != 'Asia/Tokyo',
    );

    group(
      'Australia/Sydney',
      () {
        // TODO: add test for DST switching
        testBasic();
      },
      skip: currentTimezone != 'Australia/Sydney',
    );

    group(
      'Africa/Johannesburg',
      testBasic,
      skip: currentTimezone != 'Africa/Johannesburg',
    );
  });
}

void testBasic() {
  test('Same start and end date (inclusive)', () {
    final date = DateTime.now();
    final range = DateTimeRange(start: date, end: date);
    final dates = range.dates(inclusive: true);
    expect(dates, [date.startOfDay]);
  });

  test('Same start and end date (exclusive)', () {
    final date = DateTime.now();
    final range = DateTimeRange(start: date, end: date);
    final dates = range.dates(inclusive: false);
    expect(dates, [date.startOfDay]);
  });

  test('Start date before end date', () {
    final startDate = DateTime.now().startOfDay;
    final endDate = startDate.copyWith(day: startDate.day + 3);
    final range = DateTimeRange(start: startDate, end: endDate);
    final expectedDates = [
      startDate,
      startDate.copyWith(day: startDate.day + 1),
      startDate.copyWith(day: startDate.day + 2),
      startDate.copyWith(day: startDate.day + 3),
    ];
    final dates = range.dates(inclusive: true);
    expect(const ListEquality<DateTime>().equals(dates, expectedDates), isTrue);
  });

  test('Start date before end date (exclusive)', () {
    final startDate = DateTime.now().startOfDay;
    final endDate = startDate.copyWith(day: startDate.day + 3);
    final range = DateTimeRange(start: startDate, end: endDate);
    final expectedDates = [
      startDate,
      startDate.copyWith(day: startDate.day + 1),
      startDate.copyWith(day: startDate.day + 2),
    ];
    final dates = range.dates(inclusive: false);
    expect(const ListEquality<DateTime>().equals(dates, expectedDates), isTrue);
  });
}
