import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';

/// It is used to represent an event.
///
/// [CalendarEvent] is a [ChangeNotifier] so it can be used to update the UI on changes.
///
/// The [CalendarEvent] is generic and can be used to store any type of custom object.
class CalendarEvent<T> with ChangeNotifier {
  CalendarEvent({
    required DateTimeRange dateTimeRange,
    T? eventData,
    bool? modifiable,
  }) {
    _dateTimeRange = dateTimeRange;
    _eventData = eventData;
    _canModify = modifiable ?? true;
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
    assert(
      newStart.isBefore(_dateTimeRange.end),
      'CalendarEvent start must be before end',
    );
    _dateTimeRange = DateTimeRange(
      start: newStart,
      end: _dateTimeRange.end,
    );
    notifyListeners();
  }

  /// The end [DateTime] of the [CalendarEvent].
  DateTime get end => _dateTimeRange.end;
  set end(DateTime newEnd) {
    assert(
      newEnd.isAfter(_dateTimeRange.start),
      'CalendarEvent end must be after start',
    );
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

  /// Whether the [CalendarEvent] can be modified.
  late bool _canModify;
  bool get canModify => _canModify;
  set canModify(bool newModifiable) {
    _canModify = newModifiable;
    notifyListeners();
  }

  /// Whether the [CalendarEvent] is a multi day event.
  bool get isMultiDayEvent => dateTimeRange.dayDifference >= 1;

  /// Whether the [CalendarEvent] is split across days.
  bool get isSplitAcrossDays {
    if (start.isSameDay(end) || start.endOfDay == end) {
      return false;
    } else {
      return true;
    }
  }

  /// Whether the [CalendarEvent] has a date counter.
  bool get hasDateCounter {
    // Check if the start and end are the same day.
    if (start.isSameDay(end)) return false;

    // Check if the event's end is the is the start's endOfDay.
    if (end == start.endOfDay) return false;

    return true;
  }

  /// The number of days since the start of the [CalendarEvent].
  int dayNumber(DateTime date) {
    return date.difference(start.startOfDay).inDays + 1;
  }

  /// The number of days spanned in the [CalendarEvent].
  int get daySpan => dateTimeRange.dayDifference;

  /// The total duration of the [CalendarEvent].
  Duration get duration => _dateTimeRange.duration;

  /// The [DateTimeRange] of the [CalendarEvent] on a specific date.
  DateTimeRange dateTimeRangeOnDate(DateTime date) {
    if (start.isSameDay(end)) {
      // The start and end are on same day.
      return dateTimeRange;
    } else {
      if (date.isSameDay(start)) {
        // The date is the same as the start.
        return DateTimeRange(start: start, end: start.endOfDay);
      } else if (date.isSameDay(end)) {
        // The date is the same as the end.
        return DateTimeRange(start: end.startOfDay, end: end);
      } else {
        // The date is between the start and end.
        return DateTimeRange(
          start: date.startOfDay,
          end: date.endOfDay,
        );
      }
    }
  }

  /// The duration of the [CalendarEvent] on a specific date.
  Duration durationOnDate(DateTime date) {
    return dateTimeRangeOnDate(date).duration;
  }

  /// Whether the [CalendarEvent] continues after the given date.
  bool continuesAfter(DateTime date) {
    assert(
      date.isWithin(dateTimeRange) ||
          date == start.startOfDay ||
          date == end.endOfDay,
      'The date must be within the dateTimeRange of the event',
    );
    if (isSplitAcrossDays) {
      if (date.endOfDay == end) {
        return false;
      }
      return !date.isSameDay(end);
    } else {
      return false;
    }
  }

  /// The [DateTime]s that the [CalendarEvent] spans.
  List<DateTime> get datesSpanned => dateTimeRange.datesSpanned;

  /// Whether the [CalendarEvent] is during the given [DateTimeRange].
  bool occursDuringDateTimeRange(DateTimeRange dateRange) {
    final startsBeforeEndsAfter =
        (start.isBefore(dateRange.start) && end.isAfter(dateRange.end));

    final isWithin = start.isWithin(dateRange) || end.isWithin(dateRange);

    final startOrEndEquals = start == dateRange.start || end == dateRange.end;

    return startsBeforeEndsAfter || isWithin || startOrEndEquals;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'Start': start,
        'End': end,
        'Event': eventData.toString(),
        'canModify': canModify,
      };

  CalendarEvent<T> copyWith({
    DateTimeRange? dateTimeRange,
    T? eventData,
    String? title,
    String? description,
    Color? color,
  }) {
    return CalendarEvent<T>(
      dateTimeRange: dateTimeRange ?? _dateTimeRange,
      eventData: eventData ?? _eventData,
    );
  }

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) {
    return other is CalendarEvent<T> &&
        other._dateTimeRange == _dateTimeRange &&
        other.eventData == _eventData &&
        other.canModify == _canModify &&
        other.hashCode == hashCode;
  }

  @override
  int get hashCode => Object.hash(
        _dateTimeRange,
        _eventData,
        _canModify,
      );
}
