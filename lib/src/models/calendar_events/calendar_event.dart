import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';

/// A class representing a object that can be displayed by the calendar.
///
/// A calendar event requires a [DateTimeRange] this is used by the [CalendarView] to render the event.
///
/// Any calculations done with the [_dateTimeRange] should be done in utc time and then converted back to local time.
class CalendarEvent<T extends Object?> {
  /// The data of the [CalendarEvent].
  T? data;

  /// The [DateTimeRange] of the [CalendarEvent] stored in utc time.
  final DateTimeRange _dateTimeRange;

  /// The [DateTimeRange] of the [CalendarEvent] stored in local time.
  late final DateTimeRange _dateTimeRangeLocal = _dateTimeRange.toLocal();

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
  }) : _dateTimeRange = dateTimeRange.toUtc();

  /// The [DateTimeRange] of the [CalendarEvent] in utc time.
  DateTimeRange get dateTimeRange => _dateTimeRange;

  /// The start [DateTime] of the [CalendarEvent] in utc time.
  DateTime get start => dateTimeRange.start;

  /// The end [DateTime] of the [CalendarEvent] in utc time.
  DateTime get end => dateTimeRange.end;

  /// The [DateTimeRange] of the [CalendarEvent] in local time.
  DateTimeRange get dateTimeRangeLocal => _dateTimeRangeLocal;
  
  /// The start [DateTime] of the [CalendarEvent] in local time.
  DateTime get startLocal => dateTimeRangeLocal.start;

  /// The end [DateTime] of the [CalendarEvent] in local time.
  DateTime get endLocal => dateTimeRangeLocal.end;

  /// The total duration of the [CalendarEvent] this uses utc time for the calculation.
  Duration get duration => dateTimeRange.duration;

  /// Whether the [CalendarEvent] spans multiple days in the local timezone.
  bool get isMultiDayEvent => datesSpanned.length > 1;

  /// The [DateTime]s that the [CalendarEvent] spans in the local timezone.
  List<DateTime> get datesSpanned => dateTimeRangeLocal.dates();

  /// The [DateTimeRange] of the [CalendarEvent] on a specific date.
  ///
  /// This expects the [DateTime] to be constructed with [DateTime.utc].
  ///
  /// TODO: Check that all usages of this still works as expected.
  DateTimeRange? dateTimeRangeOnDate(DateTime date) {
    assert(date.isUtc, 'The $date should be in utc time.');
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
