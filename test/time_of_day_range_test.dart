import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/models/time_of_day_range.dart';

void main() {
  group('TimeOfDayRange Tests', () {
    testTimeOfDayRange();
    testTimeOfDayRangeConstructors();
  });
}

void testTimeOfDayRange() {
  const start = TimeOfDay(hour: 10, minute: 20);
  const end = TimeOfDay(hour: 12, minute: 30);
  final timeOfDayRange = TimeOfDayRange(start: start, end: end);

  test('TimeOfDayRange', () {
    expect(timeOfDayRange.start, start);
    expect(timeOfDayRange.end, end);
  });

  test('TimeOfDayRange.duration', () {
    expect(timeOfDayRange.duration, const Duration(hours: 2, minutes: 11));
  });

  test('TimeOfDayRange.hourRanges', () {
    final ranges = timeOfDayRange.hourRanges;
    expect(ranges.length, 3);
    expect(ranges[0].start, start);
    expect(ranges[0].end, const TimeOfDay(hour: 10, minute: 59));
    expect(ranges[1].start, const TimeOfDay(hour: 11, minute: 0));
    expect(ranges[1].end, const TimeOfDay(hour: 11, minute: 59));
    expect(ranges[2].start, const TimeOfDay(hour: 12, minute: 0));
    expect(ranges[2].end, end);
  });

  final edgeCase = TimeOfDayRange(
    start: const TimeOfDay(hour: 5, minute: 59),
    end: const TimeOfDay(hour: 13, minute: 0),
  );

  test('TimeOfDayRange.hourRanges edge case', () {
    final ranges = edgeCase.hourRanges;
    expect(ranges.length, 9);
    expect(ranges[0].start, const TimeOfDay(hour: 5, minute: 59));
    expect(ranges[0].end, const TimeOfDay(hour: 5, minute: 59));
    expect(ranges[1].start, const TimeOfDay(hour: 6, minute: 0));
    expect(ranges[1].end, const TimeOfDay(hour: 6, minute: 59));
    expect(ranges[7].start, const TimeOfDay(hour: 12, minute: 0));
    expect(ranges[7].end, const TimeOfDay(hour: 12, minute: 59));
    expect(ranges[8].start, const TimeOfDay(hour: 13, minute: 0));
    expect(ranges[8].end, const TimeOfDay(hour: 13, minute: 0));
  });
}

void testTimeOfDayRangeConstructors() {
  test('TimeOfDayRange.allDay', () {
    final allDay = TimeOfDayRange.allDay();
    expect(allDay.start, const TimeOfDay(hour: 0, minute: 0));
    expect(allDay.end, const TimeOfDay(hour: 23, minute: 59));
  });

  test('TimeOfDayRange.forHour', () {
    final hour = TimeOfDayRange.forHour(10);
    expect(hour.start, const TimeOfDay(hour: 10, minute: 0));
    expect(hour.end, const TimeOfDay(hour: 10, minute: 59));
  });
}
