import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';

/// A [ChangeNotifier] that manages [CalendarEvent]s.
class CalendarEventsController<T> with ChangeNotifier {
  CalendarEventsController();

  /// The list of [CalendarEvent]s.
  final List<CalendarEvent<T>> _events = <CalendarEvent<T>>[];
  List<CalendarEvent<T>> get events => _events;

  /// The moving [CalendarEvent].
  CalendarEvent<T>? _selectedEvent;
  CalendarEvent<T>? get selectedEvent => _selectedEvent;

  /// Whether the [CalendarController] has a [_selectedEvent].
  bool get hasChangingEvent => _selectedEvent != null;

  bool _isSelectedEventMultiday = false;
  bool get isSelectedEventMultiDay => _isSelectedEventMultiday;

  bool _isResizing = false;
  bool get isResizing => _isResizing;
  set isResizing(bool value) {
    _isResizing = value;
    notifyListeners();
  }

  bool _isMoving = false;
  bool get isMoving => _isMoving;
  set isMoving(bool value) {
    _isMoving = value;
    notifyListeners();
  }

  /// Deselects the [_selectedEvent].
  void deselectEvent() {
    _selectedEvent = null;
    _isSelectedEventMultiday = false;
    _isResizing = false;
    _isMoving = false;
    notifyListeners();
  }

  /// Sets the [_selectedEvent].
  void selectEvent(
    CalendarEvent<T> event,
  ) {
    _selectedEvent = event;
    _isSelectedEventMultiday = event.isMultidayEvent;
    notifyListeners();
  }

  /// Forces an update of the calendar.
  void forceUpdate() {
    notifyListeners();
  }

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
    _selectedEvent = null;
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

  /// Updates an [CalendarEvent] in the list of [CalendarEvent]s.
  ///
  /// The event where [test] returns true will be updated.
  void updateEvent({
    T? newEventData,
    DateTimeRange? newDateTimeRange,
    bool? modifiable,
    required bool Function(CalendarEvent<T> calendarEvent) test,
  }) {
    final index = _events.indexWhere((element) => test(element));
    if (index == -1) return;
    if (newEventData != null) {
      _events[index].eventData = newEventData;
    }
    if (newDateTimeRange != null) {
      _events[index].dateTimeRange = newDateTimeRange;
    }
    if (modifiable != null) {
      _events[index].canModify = modifiable;
    }

    notifyListeners();
  }

  /// Returns a iterable of [CalendarEvent]s for that will be visible on the given date range.
  /// * This excludes [CalendarEvent]s that are displayed on single days.
  Iterable<CalendarEvent<T>> getMultidayEventsFromDateRange(
    DateTimeRange dateRange,
  ) {
    return _events.where(
      (element) =>
          ((element.start.isBefore(dateRange.start) &&
                  element.end.isAfter(dateRange.end)) ||
              element.start.isWithin(dateRange) ||
              element.end.isWithin(dateRange) ||
              element.start == dateRange.start ||
              element.end == dateRange.end) &&
          element.isMultidayEvent,
    );
  }

  /// Returns a iterable of [CalendarEvent]s for that will be visible on the given date range.
  /// * This excludes [CalendarEvent]s that are displayed on multiple days.
  Iterable<CalendarEvent<T>> getMonthEventsFromDateRange(
    DateTimeRange dateRange,
  ) {
    return _events.where(
      (element) => (element.start.isWithin(dateRange) ||
          element.end.isWithin(dateRange)),
    );
  }

  /// Returns a iterable of [CalendarEvent]s for that will be visible on the given date range.
  Iterable<CalendarEvent<T>> getDayEventsFromDateRange(
    DateTimeRange dateRange,
  ) {
    return _events.where(
      (element) =>
          (element.start.isWithin(dateRange) ||
              element.end.isWithin(dateRange)) &&
          !element.isMultidayEvent,
    );
  }

  /// Returns a iterable of [DateTime]s which is the [CalendarEvent.start] and [CalendarEvent.end]
  /// of the [CalendarEvent]s that are visible on the given date range.
  Iterable<DateTime> getSnapPointsFromDateTimeRange(DateTimeRange dateRange) {
    final eventsInDateTimeRange = getMonthEventsFromDateRange(dateRange);
    final snapPoints = <DateTime>[];
    for (var event in eventsInDateTimeRange) {
      snapPoints.add(event.start);
      snapPoints.add(event.end);
    }
    return snapPoints;
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarEventsController &&
        listEquals(other._events, _events);
  }

  @override
  int get hashCode => _events.hashCode;
}
