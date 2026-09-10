import 'package:kalender/kalender.dart';

mixin NewEvent {
  /// The event that is being created by the controller.
  KalenderEvent? _newEvent;
  KalenderEvent? get newEvent => _newEvent;

  void setNewEvent(KalenderEvent event) {
    if (_newEvent == event) return;
    _newEvent = event;
  }

  void clearNewEvent() {
    _newEvent = null;
  }
}
