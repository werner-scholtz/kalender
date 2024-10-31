import 'package:kalender/kalender.dart';

mixin NewEvent<T extends Object?> {
  /// The event that is being created by the controller.
  CalendarEvent<T>? _newEvent;
  CalendarEvent<T>? get newEvent => _newEvent;

  void setNewEvent(CalendarEvent<T> event) {
    if (_newEvent == event) return;
    _newEvent = event;
  }

  void clearNewEvent() {
    _newEvent = null;
  }
}
