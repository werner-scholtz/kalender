import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/schedule_group.dart';

/// A [ChangeNotifier] that manages [CalendarEvent]s.
class CalendarEventsController<T> with ChangeNotifier {
  CalendarEventsController();

  /// The list of [CalendarEvent]s.
  final List<CalendarEvent<T>> _events = <CalendarEvent<T>>[];
  List<CalendarEvent<T>> get events => _events;

  /// The [CalendarEvent] that is selected.
  /// TODO: Make this a list of events for multi selection. ?
  CalendarEvent<T>? _selectedEvent;
  CalendarEvent<T>? get selectedEvent => _selectedEvent;

  // List<CalendarEvent<T>>? _selectedEvents = [];
  // List<CalendarEvent<T>>? get selectedEvents => _selectedEvents;

  /// Whether the [CalendarController] has a [_selectedEvent].
  bool get hasChangingEvent => _selectedEvent != null;

  /// Is resizing selectedEvent top.
  /// If true the selectedEvent will not allow resizing bottom and rescheduling.
  bool _isResizingTop = false;
  bool get isResizingTop => _isResizingTop;
  set isResizingTop(bool value) {
    _isResizingTop = value;
    notifyListeners();
  }

  // Is resizing selectedEvent bottom.
  /// If true the selectedEvent will not allow resizing top and rescheduling.
  bool _isResizingBottom = false;
  bool get isResizingBottom => _isResizingBottom;
  set isResizingBottom(bool value) {
    _isResizingBottom = value;
    notifyListeners();
  }

  // Is rescheduling selectedEvent.
  // If true the selectedEvent will not allow resizing top and bottom.
  bool _isRescheduling = false;
  bool get isRescheduling => _isRescheduling;
  set isRescheduling(bool value) {
    _isRescheduling = value;
    notifyListeners();
  }

  /// Deselects the [_selectedEvent].
  void deselectEvent() {
    _selectedEvent = null;
    notifyListeners();
  }

  /// Sets the [_selectedEvent].
  void selectEvent(
    CalendarEvent<T> event,
  ) {
    _selectedEvent = event;
    notifyListeners();
  }

  /// Forces an update of the calendar.
  void forceUpdate() {
    notifyListeners();
  }

  /// Adds an [CalendarEvent] to the list of [CalendarEvent]s.
  void addEvent(CalendarEvent<T> event) {
    _events.add(event);
    _events.sort((a, b) => a.start.compareTo(b.start));
    notifyListeners();
  }

  /// Adds a list of [CalendarEvent]s to the list of [CalendarEvent]s.
  void addEvents(List<CalendarEvent<T>> events) {
    _events.addAll(events);
    _events.sort((a, b) => a.start.compareTo(b.start));
    notifyListeners();
  }

  /// Removes an [CalendarEvent] from the list of [CalendarEvent]s.
  void removeEvent(CalendarEvent<T> event) {
    if (selectedEvent == event) {
      _selectedEvent = null;
    }
    _events.remove(event);
    _events.sort((a, b) => a.start.compareTo(b.start));
    notifyListeners();
  }

  /// Removes a list of [CalendarEvent]s from the list of [CalendarEvent]s.
  ///
  /// The events will be removed where [test] returns true.
  ///
  void removeWhere(bool Function(CalendarEvent<T> element) test) {
    _events.removeWhere(test);
    _events.sort((a, b) => a.start.compareTo(b.start));
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
  ///
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

  /// Reschedules the [_selectedEvent] by the given [duration].
  ///
  /// * The [start] and [end] are the start and end hours of the day.
  void rescheduleSelectedEvent(
    Duration duration,
  ) {
    if (selectedEvent == null) return;
    final newDateTimeRange = DateTimeRange(
      start: selectedEvent!.start.add(duration),
      end: selectedEvent!.end.add(duration),
    );

    selectedEvent!.dateTimeRange = newDateTimeRange;
  }

  /// Reschedules the [_selectedEvent]'s start by the given [duration].
  ///
  /// * The [start] and [end] are the start and end hours of the day.
  void rescheduleSelectedEventStart(
    Duration duration,
  ) {
    if (selectedEvent == null) return;

    final newDateTimeRange = DateTimeRange(
      start: selectedEvent!.start.add(duration),
      end: selectedEvent!.end,
    );

    selectedEvent!.dateTimeRange = newDateTimeRange;
  }

  /// Reschedules the [_selectedEvent]'s end by the given [duration].
  ///
  /// * The [start] and [end] are the start and end hours of the day.
  void rescheduleSelectedEventEnd(
    Duration duration,
  ) {
    if (selectedEvent == null) return;

    final newDateTimeRange = DateTimeRange(
      start: selectedEvent!.start,
      end: selectedEvent!.end.add(duration),
    );
    selectedEvent!.dateTimeRange = newDateTimeRange;
  }

  /// Returns a iterable of [CalendarEvent]s that will be visible on the given date range.
  ///
  /// * This excludes [CalendarEvent]s that are displayed on single days.
  ///
  List<CalendarEvent<T>> getMultiDayEventsFromDateRange(
    DateTimeRange dateRange,
  ) {
    final events = _events.where((event) {
      final isMultiDay = event.isMultiDayEvent;
      if (!isMultiDay) return false;
      return event.occursDuringDateTimeRange(dateRange);
    }).toList();

    return events;
  }

  /// Returns a iterable of [CalendarEvent]s for that will be visible on the given date range.
  ///
  /// * This excludes [CalendarEvent]s that are displayed on multiple days.
  ///
  Iterable<CalendarEvent<T>> getDayEventsFromDateRange(
    DateTimeRange dateRange,
  ) {
    return _events.where(
      (element) =>
          (element.start.isWithin(dateRange) ||
              element.end.isWithin(dateRange)) &&
          !element.isMultiDayEvent,
    );
  }

  /// Returns a iterable of [CalendarEvent]s that will be visible on the given date range.
  ///
  /// * This does not exclude any [CalendarEvent]s.
  ///
  Iterable<CalendarEvent<T>> getEventsFromDateRange(
    DateTimeRange dateRange,
  ) {
    return _events.where((event) {
      return event.occursDuringDateTimeRange(dateRange);
    });
  }

  /// Returns a iterable of [DateTime]s which is the [CalendarEvent.start] and [CalendarEvent.end]
  /// of the [CalendarEvent]s that are visible on the given date range.
  Iterable<DateTime> getSnapPointsFromDateTimeRange(DateTimeRange dateRange) {
    final eventsInDateTimeRange = getEventsFromDateRange(dateRange);
    final snapPoints = <DateTime>[];
    for (var event in eventsInDateTimeRange) {
      snapPoints.add(event.start);
      snapPoints.add(event.end);
    }
    return snapPoints;
  }

  /// Returns a iterable of [ScheduleGroup]s.
  /// * A [ScheduleGroup] is a group of [CalendarEvent]s that are on the same date.
  Iterable<ScheduleGroup<T>> getScheduleGroups() {
    final scheduleGroups = <ScheduleGroup<T>>[];

    for (final event in _events) {
      for (final date in event.datesSpanned) {
        final index = scheduleGroups.indexWhere(
          (element) => element.date == date,
        );

        if (index == -1) {
          final isFirstOfMonth = !scheduleGroups.any(
            (group) => group.date.startOfMonth == date.startOfMonth,
          );

          scheduleGroups.add(
            ScheduleGroup(
              date: date,
              events: [event],
              isFirstOfMonth: isFirstOfMonth,
            ),
          );
        } else {
          scheduleGroups[index].addEvent(event);
        }
      }
    }
    return scheduleGroups;
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarEventsController &&
        listEquals(other._events, _events);
  }

  @override
  int get hashCode => _events.hashCode;
}
