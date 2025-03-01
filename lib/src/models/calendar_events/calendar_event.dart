import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';

/// TODO: consider a abstract class for CalendarEvent that needs to be implemented by users.
///
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
  ///
  /// TODO: split this into canResize (start/end), canDrag, canCreate, etc.
  final bool canModify;

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
  }) : _dateTimeRange = dateTimeRange.isUtc ? dateTimeRange : dateTimeRange.toUtc();

  /// The [DateTimeRange] of the [CalendarEvent] in the local timezone.
  DateTimeRange get dateTimeRange => _dateTimeRangeLocal;

  /// The start [DateTime] of the [CalendarEvent] in the local timezone.
  DateTime get start => _dateTimeRangeLocal.start;

  /// The end [DateTime] of the [CalendarEvent] in the local timezone.
  DateTime get end => _dateTimeRangeLocal.end;

  /// The [DateTimeRange] of the [CalendarEvent] in utc time.
  DateTimeRange get dateTimeRangeAsUtc => _dateTimeRange;

  /// The start [DateTime] of the [CalendarEvent] in utc time.
  DateTime get startAsUtc => dateTimeRangeAsUtc.start;

  /// The end [DateTime] of the [CalendarEvent] in utc time.
  DateTime get endAsUtc => dateTimeRangeAsUtc.end;

  /// The [DateTimeRange] of the [CalendarEvent] in local time.
  DateTimeRange get dateTimeRangeLocal => _dateTimeRangeLocal;

  /// The total duration of the [CalendarEvent] this uses utc time for the calculation.
  Duration get duration => dateTimeRangeAsUtc.duration;

  /// Whether the [CalendarEvent] is longer than a day.
  bool get isMultiDayEvent => duration.inDays > 0;

  /// The [DateTime]s that the [CalendarEvent] spans. This uses utc time.
  List<DateTime> get datesSpanned => dateTimeRangeAsUtc.dates();

  /// Copy the [CalendarEvent] with the new values.
  CalendarEvent<T> copyWith({
    DateTimeRange? dateTimeRange,
    T? data,
    bool? canModify,
  }) {
    return CalendarEvent<T>(
      data: data ?? this.data,
      dateTimeRange: dateTimeRange ?? this.dateTimeRangeAsUtc,
      canModify: canModify ?? this.canModify,
    );
  }

  @override
  String toString() {
    return 'CalendarEvent<$T> ($id):'
        '\nstart:  $startAsUtc'
        '\nend: $endAsUtc'
        '\ndata: ${data.toString()}';
  }
}
