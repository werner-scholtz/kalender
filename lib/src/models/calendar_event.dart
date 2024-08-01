import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';

class CalendarEvent<T extends Object?> {
  /// The data of the [CalendarEvent].
  T? data;

  /// The [DateTimeRange] of the [CalendarEvent].
  final DateTimeRange _dateTimeRange;
  DateTimeRange get dateTimeRange => _dateTimeRange;

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

  /// The start [DateTime] of the [CalendarEvent].
  DateTime get start => dateTimeRange.start;

  /// The end [DateTime] of the [CalendarEvent].
  DateTime get end => dateTimeRange.end;

  /// Whether the [CalendarEvent] is a multi day event.
  bool get isMultiDayEvent => dateTimeRange.dayDifference >= 1;

  /// The [DateTime]s that the [CalendarEvent] spans.
  List<DateTime> get datesSpanned => dateTimeRange.days;

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

  /// Whether the [CalendarEvent] continues before the given [DateTime].
  bool continuesBefore(DateTime date) => start.isBefore(date.startOfDay);

  /// Whether the [CalendarEvent] continues after the given [DateTime].
  ///
  /// TODO: check that this works for multiday events.
  bool continuesAfter(DateTime date) => end.isAfter(date.endOfDay);

  /// The [DateTimeRange] of the [CalendarEvent] on a specific date.
  DateTimeRange dateTimeRangeOnDate(DateTime date) {
    return dateTimeRange.dateTimeRangeOnDate(date);
  }

  /// Copy the [CalendarEvent] with the new values.
  CalendarEvent<T> copyWith({
    DateTimeRange? dateTimeRange,
    T? data,
  }) {
    return CalendarEvent<T>(
      data: data ?? this.data,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
    );
  }

  @override
  String toString() {
    return 'id: $id, data: $data, start: $start, end: $end';
  }
}
