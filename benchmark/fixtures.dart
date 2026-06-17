import 'package:flutter/material.dart' show DateTimeRange;
import 'package:kalender/kalender.dart';

/// Deterministic fixture data for the micro-benchmarks.
///
/// Everything here is fully deterministic (no randomness) so that benchmark
/// results only reflect the algorithm under test, not fixture variation
/// between runs.

/// Fixed anchor date used by every generator so ranges line up.
final DateTime benchmarkStart = DateTime.utc(2024, 1, 1);

/// Generates [eventsPerDay] single-day events for each of [days] consecutive
/// days starting at [start].
///
/// Events are spread across the working day (06:00–18:00) with varying
/// durations so that overlap logic has something to chew on.
List<CalendarEvent> generateDayEvents({
  required DateTime start,
  required int days,
  required int eventsPerDay,
}) {
  final events = <CalendarEvent>[];
  for (var d = 0; d < days; d++) {
    final date = DateTime.utc(start.year, start.month, start.day + d);
    for (var e = 0; e < eventsPerDay; e++) {
      final hour = 6 + (e % 12);
      final startTime = DateTime.utc(date.year, date.month, date.day, hour);
      final endTime = startTime.add(Duration(minutes: 30 + (e % 4) * 30));
      events.add(CalendarEvent(dateTimeRange: DateTimeRange(start: startTime, end: endTime)));
    }
  }
  return events;
}

/// Generates [count] multi-day events distributed across a [days]-day window
/// starting at [start], each spanning between 1 and 5 days.
List<CalendarEvent> generateMultiDayEvents({
  required DateTime start,
  required int days,
  required int count,
}) {
  final events = <CalendarEvent>[];
  for (var i = 0; i < count; i++) {
    final offset = i % days;
    final span = 1 + (i % 5);
    final startTime = DateTime.utc(start.year, start.month, start.day + offset);
    final endTime = DateTime.utc(start.year, start.month, start.day + offset + span);
    events.add(CalendarEvent(dateTimeRange: DateTimeRange(start: startTime, end: endTime)));
  }
  return events;
}
