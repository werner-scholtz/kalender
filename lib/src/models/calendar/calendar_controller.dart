import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

class CalendarController<T extends Object?> with ChangeNotifier {
  CalendarController();

  /// The list of [CalendarEvent]s.
  final List<CalendarEvent<T>> _events = <CalendarEvent<T>>[];
  List<CalendarEvent<T>> get events => _events;

  /// The moving [CalendarEvent].
  CalendarEvent<T>? _chaningEvent;
  CalendarEvent<T>? get chaningEvent => _chaningEvent;
  set chaningEvent(CalendarEvent<T>? value) {
    _chaningEvent = value;
    notifyListeners();
  }

  bool isMoving = false;
  bool isResizing = false;
  bool isNewEvent = false;
  bool isMultidayEvent = false;

  /// Whether the [CalendarController] has a [_chaningEvent].
  bool get hasChaningEvent => _chaningEvent != null;

  /// Adds an [CalendarEvent] to the list of [CalendarEvent]s.
  void addEvent(CalendarEvent<T> event) {
    _events.add(event);
    notifyListeners();
  }

  /// Adds a list of [CalendarEvent]s to the list of [CalendarEvent]s.
  void addEvents(List<CalendarEvent<T>> events) {
    _events.addAll(events);
    notifyListeners();
  }

  /// Removes an [CalendarEvent] from the list of [CalendarEvent]s.
  void removeEvent(CalendarEvent<T> event) {
    _events.remove(event);
    notifyListeners();
  }

  /// Removes a list of [CalendarEvent]s from the list of [CalendarEvent]s.
  ///
  /// The events will be removed where [test] returns true.
  void removeWhere(bool Function(CalendarEvent<T> element) test) {
    _events.removeWhere(test);
    notifyListeners();
  }

  /// Removes all [CalendarEvent]s from [_events].
  void clearEvents() {
    _events.clear();
    notifyListeners();
  }

  /// Returns a iterable of [CalendarEvent]s for that will be visible on the given date range.
  /// * This exludes [CalendarEvent]s that are displayed on single days.
  Iterable<CalendarEvent<T>> getMultidayEventsFromDateRange(DateTimeRange dateRange) {
    return _events.where(
      (CalendarEvent<T> element) =>
          ((element.start.isBefore(dateRange.start) && element.end.isAfter(dateRange.end)) ||
              element.start.isWithin(dateRange) ||
              element.end.isWithin(dateRange) ||
              element.start == dateRange.start ||
              element.end == dateRange.end) &&
          element.isMultidayEvent,
    );
  }

  /// Returns a iterable of [CalendarEvent]s for that will be visible on the given date range.
  /// * This excludes [CalendarEvent]s that are displayed on multiple days.
  Iterable<CalendarEvent<T>> getDayEventsFromDateRange(DateTimeRange dateRange) {
    return _events.where(
      (CalendarEvent<T> element) =>
          (element.start.isWithin(dateRange) || element.end.isWithin(dateRange)) &&
          !element.isMultidayEvent,
    );
  }

  /// Returns a iterable of [DateTime]s which is the [CalendarEvent.start] and [CalendarEvent.end]
  /// of the [CalendarEvent]s that are visible on the given date range.
  Iterable<DateTime> getSnapPointsFromDateTimeRange(DateTimeRange dateRange) {
    Iterable<CalendarEvent<T>> eventsInDateTimeRange = getDayEventsFromDateRange(dateRange);
    List<DateTime> snapPoints = <DateTime>[];
    for (CalendarEvent<T> event in eventsInDateTimeRange) {
      snapPoints.add(event.start);
      snapPoints.add(event.end);
    }
    return snapPoints;
  }

  Iterable<CalendarEvent<T>> getEventsFromDate(DateTime date) {
    return _events.where((CalendarEvent<T> element) => (element.isOnDate(date)));
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarController && listEquals(other._events, _events);
  }

  @override
  int get hashCode => _events.hashCode;
}
