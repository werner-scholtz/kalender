import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';

class CalendarEvent<T extends Object?> {
  /// The data of the [CalendarEvent].
  T? data;

  /// The [DateTimeRange] of the [CalendarEvent].
  final DateTimeRange _dateTimeRange;
  DateTimeRange get dateTimeRange => _dateTimeRange;

  /// The start [DateTime] of the [CalendarEvent].
  DateTime get start => dateTimeRange.start;

  /// The end [DateTime] of the [CalendarEvent].
  DateTime get end => dateTimeRange.end;

  /// Whether this [CalendarEvent] can be modified.
  bool canModify;

  /// The id of the [CalendarEvent].
  /// Do not set this value manually as this is set by the [EventsController].
  int _id = -1;
  int get id => _id;
  set id(int value) {
    if (_id != -1) return;
    _id = value;
  }

  CalendarEvent({
    required DateTimeRange dateTimeRange,
    this.data,
    this.canModify = true,
  }) : _dateTimeRange = dateTimeRange;

  /// Whether the [CalendarEvent] is a multi day event.
  bool get isMultiDayEvent => dateTimeRange.dayDifference >= 1;

  /// The [DateTime]s that the [CalendarEvent] spans.
  List<DateTime> get datesSpanned => dateTimeRange.datesSpanned;

  /// The total duration of the [CalendarEvent].
  Duration get duration => dateTimeRange.duration;

  /// Whether the [CalendarEvent] is during the given [DateTimeRange].
  bool occursDuringDateTimeRange(DateTimeRange dateTimeRange) {
    final rangeStart = dateTimeRange.start;
    final rangeEnd = dateTimeRange.end;

    // Check if the event starts before the range and ends after the range.
    final startsBeforeEndsAfter = (start.isBefore(rangeStart) && end.isAfter(rangeEnd));

    // Check if the event is within the range.
    final isWithin = start.isWithin(dateTimeRange) || end.isWithin(dateTimeRange);

    // Check if the start or end of the event is equal to the start or end of the range.
    final startOrEndEquals = start == rangeStart || end == rangeEnd;

    return startsBeforeEndsAfter || isWithin || startOrEndEquals;
  }

  /// The [DateTimeRange] of the [CalendarEvent] on a specific date.
  DateTimeRange dateTimeRangeOnDate(DateTime date) {
    return dateTimeRange.dateTimeRangeOnDate(date);
  }

  /// Copy the [CalendarEvent] with the new values.
  CalendarEvent<T> copyWith({
    DateTimeRange? dateTimeRange,
    T? eventData,
  }) {
    return CalendarEvent<T>(
      data: eventData ?? this.data,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
    );
  }

  @override
  String toString() {
    return 'data: $data, start: $start, end: $end';
  }
}
