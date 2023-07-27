import 'package:flutter/material.dart';

/// [CalendarEvent] is a [ChangeNotifier] that contains a [DateTimeRange] and an optional [eventData].
class CalendarEvent<T extends Object?> with ChangeNotifier {
  CalendarEvent({
    required DateTimeRange dateTimeRange,
    T? eventData,
  }) {
    _dateTimeRange = dateTimeRange;
    _eventData = eventData;
  }

  /// The [DateTimeRange] of the [CalendarEvent].
  late DateTimeRange _dateTimeRange;
  DateTimeRange get dateTimeRange => _dateTimeRange;
  set dateTimeRange(DateTimeRange newDateTimeRange) {
    _dateTimeRange = newDateTimeRange;
    notifyListeners();
  }

  /// The start [DateTime] of the [CalendarEvent].
  DateTime get start => _dateTimeRange.start;
  set start(DateTime newStart) {
    assert(newStart.isBefore(_dateTimeRange.end), 'CalendarEvent start must be before end');
    _dateTimeRange = DateTimeRange(
      start: newStart,
      end: _dateTimeRange.end,
    );
    notifyListeners();
  }

  /// The end [DateTime] of the [CalendarEvent].
  DateTime get end => _dateTimeRange.end;
  set end(DateTime newEnd) {
    assert(newEnd.isAfter(_dateTimeRange.start), 'CalendarEvent end must be after start');
    _dateTimeRange = DateTimeRange(
      start: _dateTimeRange.start,
      end: newEnd,
    );
    notifyListeners();
  }

  /// EventData of the [CalendarEvent].
  late T? _eventData;
  T? get eventData => _eventData;
  set eventData(T? newEvent) {
    _eventData = newEvent;
    notifyListeners();
  }
}
