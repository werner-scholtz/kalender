import 'package:flutter/foundation.dart';
import 'package:kalender/src/models/calendar_event.dart';

class CalendarController<T extends Object?> with ChangeNotifier {
  CalendarController();

  /// The list of [CalendarEvent]s.
  final List<CalendarEvent<T>> _events = <CalendarEvent<T>>[];
  // List<CalendarEvent<T>> get events => _events;

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

  @override
  bool operator ==(Object other) {
    return other is CalendarController && listEquals(other._events, _events);
  }

  @override
  int get hashCode => _events.hashCode;
}
